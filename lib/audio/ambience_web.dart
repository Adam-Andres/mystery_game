import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'ambience.dart';

Ambience createPlatformAmbience() => _WebAmbience();

/// One recording of rain, looped, and passed through a filter that muffles
/// it more the further indoors and underground Churlock goes.
class _WebAmbience implements Ambience {
  web.AudioContext? _context;
  web.BiquadFilterNode? _filter;
  web.GainNode? _gain;
  web.AudioBuffer? _thunder;
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
  void wake() {
    final context = _context;
    if (context == null) {
      _start();
    } else if (context.state != 'running') {
      context.resume();
    }
  }

  Future<web.AudioBuffer> _load(web.AudioContext context, String name) async {
    final response = await web.window
        .fetch('assets/assets/sfx/$name'.toJS)
        .toDart;
    final bytes = await response.arrayBuffer().toDart;
    return context.decodeAudioData(bytes).toDart;
  }

  /// Thunder goes through the same filter and volume as the rain, so it is
  /// a crash out of doors and a far-off grumble in the cellar.
  @override
  void thunder() {
    final context = _context;
    final filter = _filter;
    final buffer = _thunder;
    if (context == null || filter == null || buffer == null) return;
    if (context.state != 'running') return;
    final source = context.createBufferSource()..buffer = buffer;
    final boost = context.createGain()..gain.value = 2.4;
    source.connect(boost);
    boost.connect(filter);
    source.start();
  }

  Future<void> _start() async {
    if (_starting) return;
    _starting = true;
    try {
      final context = web.AudioContext();
      context.resume();
      final buffer = await _load(context, 'rain.wav');
      final source = context.createBufferSource()
        ..buffer = buffer
        ..loop = true;
      final filter = context.createBiquadFilter()..type = 'lowpass';
      final gain = context.createGain()..gain.value = 0;
      source.connect(filter);
      filter.connect(gain);
      gain.connect(context.destination);
      source.start();
      _context = context;
      _filter = filter;
      _gain = gain;
      _apply();
      _thunder = await _load(context, 'thunder.wav');
    } catch (_) {
      // No rain, then. The game is none the worse for it.
      _starting = false;
    }
  }

  /// Moves toward the current weather over about a second, so that walking
  /// through a door does not cut the sound.
  void _apply() {
    final context = _context;
    final filter = _filter;
    final gain = _gain;
    if (context == null || filter == null || gain == null) return;
    final now = context.currentTime;
    filter.frequency.setTargetAtTime(_weather.cutoff, now, .35);
    gain.gain.setTargetAtTime(_muted ? 0 : _weather.volume, now, .35);
  }
}
