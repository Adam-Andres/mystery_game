// Writes every spoken line to build/voice_lines.json for tool/make_voices.py.
// The game's data imports Flutter, so run it through the test runner:
//
//   flutter test tool/voice_lines.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystery/audio/lines.dart';

void main() {
  test('write voice lines', () {
    final lines = [
      for (final l in allVoiceLines())
        {'file': clipName(l.voice, l.text), 'voice': l.voice, 'text': l.text},
    ];
    File('build/voice_lines.json')
      ..createSync(recursive: true)
      ..writeAsStringSync(const JsonEncoder.withIndent(' ').convert(lines));
    // ignore: avoid_print
    print('${lines.length} lines');
  });
}
