import 'package:flutter/foundation.dart';

import 'lines.dart';
import 'player_stub.dart'
    if (dart.library.js_interop) 'player_web.dart'
    if (dart.library.io) 'player_io.dart';

/// Plays one audio asset at a time.
abstract class ClipPlayer {
  /// Completes when the clip ends, fails to play, or is stopped.
  Future<void> play(String asset);

  void stop();
}

/// A player that makes no sound, for tests and unsupported platforms.
class SilentPlayer implements ClipPlayer {
  @override
  Future<void> play(String asset) async {}

  @override
  void stop() {}
}

/// The game's voices: speaks pre-recorded lines, and remembers the mute setting.
class Voice extends ChangeNotifier {
  Voice([ClipPlayer? player]) : _player = player ?? createClipPlayer();

  final ClipPlayer _player;

  bool _muted = false;
  bool get muted => _muted;

  Object? _owner;

  /// Speaks [line], cutting off whatever was being said before. [owner]
  /// identifies who asked, so that it alone can [release] the line later.
  Future<void> say(VoiceLine line, {Object? owner}) async {
    _player.stop();
    _owner = owner;
    if (_muted) return;
    await _player.play(clipAsset(line));
  }

  void stop() => _player.stop();

  /// Stops speaking, but only if [owner] started the current line. A screen
  /// calls this as it closes; by then the next screen may already be talking,
  /// and must not be cut off.
  void release(Object owner) {
    if (identical(_owner, owner)) _player.stop();
  }

  void toggleMute() {
    _muted = !_muted;
    if (_muted) _player.stop();
    notifyListeners();
  }
}
