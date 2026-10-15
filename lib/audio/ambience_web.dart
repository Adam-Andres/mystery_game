import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'ambience.dart';

Ambience createPlatformAmbience() => _WebAmbience();

/// The sounds of the house itself, through the Web Audio API: a loop of
/// rain passed through a filter that muffles it more the further indoors
/// Churlock goes, thunder through the same filter, and in the basement the
/// hum and sputter of the lamps instead.
class _WebAmbience implements Ambience {
  web.AudioContext? _context;
  web.BiquadFilterNode? _filter;
  web.GainNode? _master;
  web.GainNode? _rain;
  web.GainNode? _hum;
  /// A loop for each piece of title music, by asset, once it has loaded.
  final _music = <String, web.GainNode>{};
  final _loading = <String>{};
  String _track = 'title.wav';
  bool _musicOn = false;
  bool _musicMuted = false;
  web.AudioBuffer? _thunder;
  web.AudioBuffer? _buzz;
  web.HTMLAudioElement? _keepAwake;
  bool _starting = false;
  bool _muted = false;
  Weather _weather = Weather.outside;

  @override
  void set(Weather weather) {
    _weather = weather;
    _apply();
  }

  @override
  void setMuted(bool muted) {
    _muted = muted;
    _apply();
  }

  @override
  void setMusic(bool playing) {
    _musicOn = playing;
    _apply();
  }

  @override
  void setTrack(String asset) {
    _track = asset;
    _loadTrack(asset);
    _apply();
  }

  /// Starts a piece of music looping, silently, so it can be faded up.
  Future<void> _loadTrack(String asset) async {
    final context = _context;
    if (context == null || !_loading.add(asset)) return;
    try {
      // The music has its own switch, and does not pass through the
      // haptics' one.
      _music[asset] = _loop(
        context,
        await _load(context, asset),
        context.destination,
      );
      _apply();
    } catch (_) {
      _loading.remove(asset);
    }
  }

  @override
  void setMusicMuted(bool muted) {
    _musicMuted = muted;
    _apply();
  }

  @override
  void wake() {
    _holdAudioSession();
    final context = _context;
    if (context == null) {
      _start();
    } else if (context.state != 'running') {
      context.resume();
    }
  }

  /// On an iPhone, sound made this way counts as background noise, which
  /// the silent switch turns off, unless the page is also playing something
  /// through an ordinary audio element. The voices are that something, until
  /// they are muted. So a silent clip is kept looping, and these sounds stay
  /// audible whatever the voices are doing.
  void _holdAudioSession() {
    if (_keepAwake != null) return;
    final audio = web.HTMLAudioElement()
      ..src = 'assets/assets/sfx/silence.wav'
      ..loop = true;
    _keepAwake = audio;
    audio.play().toDart.then(
      (_) {},
      onError: (Object _) {
        // Not allowed yet: try again at the next touch.
        _keepAwake = null;
      },
    );
  }

  Future<web.AudioBuffer> _load(web.AudioContext context, String name) async {
    final response = await web.window
        .fetch('assets/assets/sfx/$name'.toJS)
        .toDart;
    final bytes = await response.arrayBuffer().toDart;
    return context.decodeAudioData(bytes).toDart;
  }

  web.GainNode _loop(
    web.AudioContext context,
    web.AudioBuffer buffer,
    web.AudioNode into,
  ) {
    final gain = context.createGain()..gain.value = 0;
    final source = context.createBufferSource()
      ..buffer = buffer
      ..loop = true;
    source.connect(gain);
    gain.connect(into);
    source.start();
    return gain;
  }

  void _once(web.AudioBuffer? buffer, web.AudioNode? into, double volume) {
    final context = _context;
    if (context == null || buffer == null || into == null) return;
    if (context.state != 'running') return;
    final source = context.createBufferSource()..buffer = buffer;
    final gain = context.createGain()..gain.value = volume;
    source.connect(gain);
    gain.connect(into);
    source.start();
  }

  /// Thunder goes through the same filter and volume as the rain, so it is
  /// a crash out of doors and a grumble behind a wall.
  @override
  void thunder() => _once(_thunder, _filter, 2.4);

  @override
  void flicker() => _once(_buzz, _master, .5);

  final _creatures = <String, web.AudioBuffer>{};

  /// Plays an animal's sound, fetching it the first time it is wanted.
  @override
  void creature(String sound) {
    final buffer = _creatures[sound];
    if (buffer != null) return _once(buffer, _master, .55);
    final context = _context;
    if (context == null) return;
    _load(context, '$sound.wav').then((b) {
      _creatures[sound] = b;
      _once(b, _master, .55);
    }, onError: (Object _) {});
  }

  Future<void> _start() async {
    if (_starting) return;
    _starting = true;
    try {
      final context = web.AudioContext();
      context.resume();
      final master = context.createGain()..gain.value = 0;
      master.connect(context.destination);
      final filter = context.createBiquadFilter()..type = 'lowpass';
      final rain = context.createGain()..gain.value = 0;
      filter.connect(rain);
      rain.connect(master);
      final shower = context.createBufferSource()
        ..buffer = await _load(context, 'rain.wav')
        ..loop = true;
      shower.connect(filter);
      shower.start();
      _context = context;
      _master = master;
      _filter = filter;
      _rain = rain;
      _apply();
      _hum = _loop(context, await _load(context, 'hum.wav'), master);
      _apply();
      await _loadTrack(_track);
      _thunder = await _load(context, 'thunder.wav');
      _buzz = await _load(context, 'buzz.wav');
    } catch (_) {
      // No sound, then. The game is none the worse for it.
      _starting = false;
    }
  }

  /// Moves toward the current weather over about a second, so that walking
  /// through a door does not cut the sound.
  void _apply() {
    final context = _context;
    if (context == null) return;
    final now = context.currentTime;
    _master?.gain.setTargetAtTime(_muted ? 0 : 1, now, .1);
    _filter?.frequency.setTargetAtTime(_weather.cutoff, now, .35);
    _rain?.gain.setTargetAtTime(_weather.volume, now, .35);
    _hum?.gain.setTargetAtTime(_weather.hum, now, .35);
    // The music comes up gently, and fades out over a few seconds as the
    // opening scene takes over.
    // Changing place on the title screen fades one tune into the other.
    for (final entry in _music.entries) {
      final playing = _musicOn && entry.key == _track;
      entry.value.gain.setTargetAtTime(
        playing && !_musicMuted ? .5 : 0,
        now,
        playing ? .6 : 1.3,
      );
    }
  }
}
