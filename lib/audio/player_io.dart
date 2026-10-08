import 'dart:io';

import 'voice.dart';

ClipPlayer createClipPlayer() => _CommandPlayer();

/// Desktop playback without a native plugin: hands the clip to a command-line
/// audio player if the system has one, and stays silent if it does not.
class _CommandPlayer implements ClipPlayer {
  static const _linuxPlayers = <(String, List<String>)>[
    ('mpv', ['--no-video', '--really-quiet']),
    ('ffplay', ['-nodisp', '-autoexit', '-loglevel', 'quiet']),
    ('mpg123', ['-q']),
    ('gst-play-1.0', ['-q']),
    ('cvlc', ['--play-and-exit', '-q']),
  ];

  late final Future<(String, List<String>)?> _command = _findCommand();
  Process? _process;
  int _request = 0;
  bool _muted = false;

  /// A command-line player cannot be turned down once started, so here
  /// muting simply stops the clip, and nothing plays until it is unmuted.
  @override
  void setMuted(bool muted) {
    _muted = muted;
    if (muted) stop();
  }

  Future<(String, List<String>)?> _findCommand() async {
    if (Platform.isMacOS) return ('afplay', const <String>[]);
    if (!Platform.isLinux) return null;
    for (final candidate in _linuxPlayers) {
      try {
        final found = await Process.run('which', [candidate.$1]);
        if (found.exitCode == 0) return candidate;
      } on ProcessException {
        return null;
      }
    }
    return null;
  }

  String _path(String asset) {
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    return Platform.isMacOS
        ? '$exeDir/../Frameworks/App.framework/Resources/flutter_assets/$asset'
        : '$exeDir/data/flutter_assets/$asset';
  }

  @override
  Future<void> play(String asset) async {
    stop();
    if (_muted) return;
    final request = _request;
    final command = await _command;
    if (command == null || request != _request) return;
    try {
      final process = await Process.start(command.$1, [...command.$2, _path(asset)]);
      if (request != _request) {
        process.kill();
        return;
      }
      _process = process;
      await process.exitCode;
    } on ProcessException {
      // No sound is better than no game.
    }
  }

  @override
  void stop() {
    _request++;
    _process?.kill();
    _process = null;
  }
}
