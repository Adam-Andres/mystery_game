import '../data/hints.dart';
import '../data/house.dart';
import '../data/models.dart';

export '../data/models.dart' show VoiceLine, narrator;
import '../game_state.dart' show shakyVoice;

/// Churlock's cry when the player declares the case solved. Its clip is made
/// specially, with a fanfare under it: see `FANFARE` in tool/make_voices.py.
const VoiceLine eurekaLine = (voice: 'churlock', text: "Eureka!");

/// What the narrator and Churlock say in the opening and closing scenes of
/// the mystery being played.
List<VoiceLine> get introLines => world.intro;
List<VoiceLine> get winLines => world.win;
List<VoiceLine> get loseAgainLines => world.loseAgain;
List<VoiceLine> get loseHalfLines => world.loseHalf;

/// A file-safe name for a clip. Deliberately simple arithmetic, so that it
/// gives the same answer on the web (where integers are doubles) as natively.
String clipName(String voice, String text) {
  var a = 7;
  var b = 11;
  for (final c in '$voice|$text'.runes) {
    a = (a * 31 + c) % 1000000007;
    b = (b * 131 + c) % 998244353;
  }
  return '${voice}_${a.toRadixString(36)}${b.toRadixString(36)}';
}

String clipAsset(VoiceLine line) =>
    'assets/voice/${clipName(line.voice, line.text)}.mp3';

/// Every line the game can speak. `tool/voice_lines.dart` writes this out for
/// the generator, and a test checks that each one has its audio file.
List<VoiceLine> allVoiceLines() {
  final seen = <String>{};
  final lines = <VoiceLine>[];
  void add(String voice, String text) {
    if (text.isNotEmpty && seen.add(clipName(voice, text))) {
      lines.add((voice: voice, text: text));
    }
  }

  add(eurekaLine.voice, eurekaLine.text);
  add(watsonut.id, watsonut.greeting);
  for (final touch in [false, true]) {
    add(watsonut.id, arrivalGreeting(touch: touch));
  }
  for (final remark in idleRemarks) {
    add(watsonut.id, remark);
  }
  // Everything else belongs to one place or another. Each is made the
  // current one in turn, since some lines name its people.
  final playing = world;
  for (final w in worlds) {
    world = w;
    for (final l in [...w.intro, ...w.win, ...w.loseAgain, ...w.loseHalf]) {
      add(l.voice, l.text);
    }
    for (final p in [...w.residents, ...w.police]) {
      add(p.id, p.greeting);
    }
    for (final nook in w.nooks) {
      for (final junk in nook.junk) {
        add(churlock.id, junk.text);
      }
    }
    for (final item in w.items) {
      add(churlock.id, item.description);
    }
    for (final pet in w.pets) {
      add(churlock.id, pet.remark.text);
    }
    add(churlock.id, w.looseCorner.text);
    for (final sight in w.sights) {
      add(churlock.id, sight.junk.text);
    }
    for (final mystery in [...w.cases, ?w.twist]) {
      add(narrator, mystery.solution);
      for (final entry in mystery.greetings.entries) {
        add(entry.key, entry.value);
      }
      // Churlock reads out what he finds, what dusting turns up, and (from
      // the notebook) what he has been handed.
      for (final e in [...mystery.pool, ...mystery.gifts, mystery.prints]) {
        add(churlock.id, e.description);
      }
      add(churlock.id, certificateText(mystery.deskCode));
      // Watsonut has something to say about every piece of evidence.
      String voiceOf(String id) =>
          mystery.shaky.contains(id) ? shakyVoice : watsonut.id;
      for (final e in [...mystery.pool, ...mystery.gifts, mystery.prints]) {
        add(voiceOf(e.id), hintFor(mystery, e));
      }
      for (final (i, hint) in mystery.accuseHints.indexed) {
        add(voiceOf('accuse:$i'), hint);
      }
      for (final entry in mystery.topics.entries) {
        for (final t in entry.value) {
          add(entry.key, t.answer);
        }
      }
    }
  }
  world = playing;
  return lines;
}
