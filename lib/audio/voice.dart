import 'package:flutter/widgets.dart';

import 'lines.dart';
import 'player_stub.dart'
    if (dart.library.js_interop) 'player_web.dart'
    if (dart.library.io) 'player_io.dart';

/// Plays one audio asset at a time.
abstract class ClipPlayer {
  /// Completes when the clip ends, fails to play, or is stopped.
  Future<void> play(String asset);

  void stop();

  /// Silences or restores the sound. Where the platform allows, a clip keeps
  /// running while muted, so unmuting picks it up at the point it has reached.
  void setMuted(bool muted);
}

/// A player that makes no sound, for tests and unsupported platforms.
class SilentPlayer implements ClipPlayer {
  @override
  Future<void> play(String asset) async {}

  @override
  void stop() {}

  @override
  void setMuted(bool muted) {}
}

/// The game's voices: speaks pre-recorded lines, and remembers the mute setting.
class Voice extends ChangeNotifier {
  Voice([ClipPlayer? player, ClipPlayer? effects])
    : _player = player ?? createClipPlayer(),
      // A voice that was given a player is under test, and stays quiet.
      _effects =
          effects ?? (player == null ? createClipPlayer() : SilentPlayer());

  final ClipPlayer _player;

  /// A second player, so that a sound effect does not cut off a voice.
  final ClipPlayer _effects;

  /// The loud click of a lock's tumbler falling into place.
  void click() => _effects.play('assets/sfx/click.mp3');

  /// The faint tick of a dial passing a notch.
  void tick() => _effects.play('assets/sfx/tick.mp3');

  bool _muted = false;
  bool get muted => _muted;

  Object? _owner;

  // Who is talking, for the sake of their mouth.
  String? _speaker;
  bool _playing = false;
  bool _guessing = false;
  int _turn = 0;
  final _clock = Stopwatch();
  Duration _length = Duration.zero;

  /// True while the character whose voice is [id] is saying something,
  /// whether or not the sound is muted.
  bool isSpeaking(String id) =>
      _speaker?.split('-').first == id && (_playing || (_guessing && _clock.elapsed < _length));

  /// Speaks [line], cutting off whatever was being said before. [owner]
  /// identifies who asked, so that it alone can [release] the line later.
  Future<void> say(VoiceLine line, {Object? owner}) async {
    _player.stop();
    _owner = owner;
    final turn = ++_turn;
    _speaker = line.voice;
    _playing = true;
    _guessing = false;
    _length = Duration(milliseconds: 500 + line.text.length * 62);
    _clock
      ..reset()
      ..start();
    // Lines are played even when muted, only silently, so that narration
    // keeps its place and its timing.
    await _player.play(clipAsset(line));
    if (turn != _turn) return;
    _playing = false;
    // A clip that ends at once never played: the browser refused it, or
    // there is no sound here at all. Go by the length of the line instead.
    _guessing = _clock.elapsed < const Duration(milliseconds: 400);
  }

  void stop() {
    _turn++;
    _speaker = null;
    _player.stop();
  }

  /// Stops speaking, but only if [owner] started the current line. A screen
  /// calls this as it closes; by then the next screen may already be talking,
  /// and must not be cut off.
  void release(Object owner) {
    if (identical(_owner, owner)) stop();
  }

  void toggleMute() {
    _muted = !_muted;
    _player.setMuted(_muted);
    _effects.setMuted(_muted);
    notifyListeners();
  }
}

/// Makes the game's [Voice] available to the characters drawn beneath it, so
/// that they can move their mouths while they speak.
class VoiceScope extends InheritedWidget {
  const VoiceScope({super.key, required this.voice, required super.child});

  final Voice voice;

  static Voice? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VoiceScope>()?.voice;

  @override
  bool updateShouldNotify(VoiceScope old) => old.voice != voice;
}
