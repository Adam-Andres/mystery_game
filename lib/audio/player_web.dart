import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'voice.dart';

ClipPlayer createClipPlayer() => _WebPlayer();

class _WebPlayer implements ClipPlayer {
  web.HTMLAudioElement? _audio;
  Completer<void>? _done;

  @override
  Future<void> play(String asset) {
    stop();
    final done = Completer<void>();
    void finish([web.Event? _]) {
      if (!done.isCompleted) done.complete();
    }

    // Flutter serves bundled assets from the `assets/` folder beside the page.
    final audio = web.HTMLAudioElement()..src = 'assets/$asset';
    audio.addEventListener('ended', finish.toJS);
    audio.addEventListener('error', finish.toJS);
    _audio = audio;
    _done = done;
    // The browser refuses playback until the player has clicked something.
    audio.play().toDart.then((_) {}, onError: (Object _) => finish());
    return done.future;
  }

  @override
  void stop() {
    _audio?.pause();
    _audio = null;
    final done = _done;
    if (done != null && !done.isCompleted) done.complete();
    _done = null;
  }
}
