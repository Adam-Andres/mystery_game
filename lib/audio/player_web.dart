import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'voice.dart';

ClipPlayer createClipPlayer() => _WebPlayer();

/// Plays voice clips through one audio element, used over and over. A
/// browser allows a page only so many media players, and an element is not
/// given back when it is merely paused, so a fresh one for every line
/// eventually leaves the page unable to make any sound at all.
class _WebPlayer implements ClipPlayer {
  _WebPlayer() {
    void finish(web.Event _) => _finish();
    _audio.addEventListener('ended', finish.toJS);
    _audio.addEventListener('error', finish.toJS);
  }

  final web.HTMLAudioElement _audio = web.HTMLAudioElement();
  Completer<void>? _done;

  void _finish() {
    final done = _done;
    _done = null;
    if (done != null && !done.isCompleted) done.complete();
  }

  @override
  void setMuted(bool muted) => _audio.muted = muted;

  @override
  Future<void> play(String asset) {
    stop();
    final done = Completer<void>();
    _done = done;
    // Flutter serves bundled assets from the `assets/` folder beside the page.
    _audio.src = 'assets/$asset';
    // The browser refuses playback until the player has clicked something.
    _audio.play().toDart.then(
      (_) {},
      onError: (Object _) {
        if (identical(_done, done)) _finish();
      },
    );
    return done.future;
  }

  @override
  void stop() {
    _audio.pause();
    _finish();
  }
}

ClipPlayer createEffectsPlayer(List<String> assets) => _WebEffects(assets);

/// Short sound effects, played through the Web Audio API. Each sound is
/// fetched and decoded once, up front, and then starts the instant it is
/// asked for, however short it is and however slowly they come. (An audio
/// element has to be set up afresh for every play, and swallows clips this
/// brief as often as not.)
class _WebEffects implements ClipPlayer {
  _WebEffects(List<String> assets) {
    for (final asset in assets) {
      _buffers[asset] = _load(asset);
    }
  }

  final web.AudioContext _context = web.AudioContext();
  final _buffers = <String, Future<web.AudioBuffer?>>{};
  bool _muted = false;

  Future<web.AudioBuffer?> _load(String asset) async {
    try {
      final response = await web.window.fetch('assets/$asset'.toJS).toDart;
      final bytes = await response.arrayBuffer().toDart;
      return await _context.decodeAudioData(bytes).toDart;
    } catch (_) {
      return null;
    }
  }

  @override
  void setMuted(bool muted) => _muted = muted;

  @override
  Future<void> play(String asset) async {
    if (_muted) return;
    // The browser keeps sound suspended until the player has touched the
    // page; turning the dial counts.
    if (_context.state != 'running') {
      try {
        await _context.resume().toDart;
      } catch (_) {}
    }
    final buffer = await (_buffers[asset] ??= _load(asset));
    if (buffer == null) return;
    final source = _context.createBufferSource()..buffer = buffer;
    source.connect(_context.destination);
    source.start();
  }

  @override
  void stop() {}
}
