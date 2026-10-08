import '../data/cases.dart';
import '../data/house.dart';

/// One spoken line: who says it, and what they say.
typedef VoiceLine = ({String voice, String text});

const narrator = 'narrator';

const introLines = <VoiceLine>[
  (
    voice: narrator,
    text: "It is a gloomy morning in Donut County, and the soda rain has not let "
        "up since midnight. At dawn, the police telephoned Detective Churlock. "
        "Mrs. Éclaire Senclair has been found dead, in the cellar of her own "
        "gingerbread mansion.",
  ),
  (
    voice: narrator,
    text: "Five residents were home, and every door was latched from the "
        "inside. One of them did it. Or two of them, together.",
  ),
  (
    voice: 'churlock',
    text: "Everybody here has a motive, and nobody will confess, so I must "
        "cross-check every story. I shall search every room, examine anything "
        "suspicious, and put what one dessert says to another.",
  ),
  (
    voice: 'churlock',
    text: "When I am certain, I return to the entrance hall, and declare the "
        "case solved.",
  ),
];

/// Churlock's cry when the player declares the case solved.
const VoiceLine eurekaLine = (voice: 'churlock', text: "Eureka! I know who did it!");

const winLines = <VoiceLine>[
  (
    voice: narrator,
    text: "The soda rain has stopped at last. The police wagon rolls away "
        "down the lane, and this time, the right dessert is inside it.",
  ),
  (
    voice: narrator,
    text: "The case is closed. Donut County can sleep soundly again, thanks "
        "to Detective Churlock.",
  ),
  (voice: 'churlock', text: "Elementary, my dear Watsonut."),
];

const loseAgainLines = <VoiceLine>[
  (
    voice: narrator,
    text: "The police wagon rattles away through the soda rain, with an "
        "innocent dessert behind its bars.",
  ),
  (
    voice: narrator,
    text: "And in the gingerbread mansion, a killer is still free. By "
        "morning, there will be another outline on the floor.",
  ),
  (voice: 'churlock', text: "I have made a terrible mistake."),
];

const loseHalfLines = <VoiceLine>[
  (
    voice: narrator,
    text: "The police wagon rattles away through the soda rain. The killer "
        "is inside it. But so is an innocent dessert, who will pay dearly "
        "for the detective's guesswork.",
  ),
  (voice: 'churlock', text: "Half right, I fear, is not right at all."),
];

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

  for (final l in [...introLines, eurekaLine, ...winLines, ...loseAgainLines, ...loseHalfLines]) {
    add(l.voice, l.text);
  }
  for (final p in [...residents, ...police]) {
    add(p.id, p.greeting);
  }
  for (final nook in nooks) {
    for (final junk in nook.junk) {
      add(churlock.id, junk.text);
    }
  }
  for (final mystery in allCases) {
    add(narrator, mystery.solution);
    // Churlock reads out what he finds, including what dusting turns up.
    for (final e in [...mystery.pool, mystery.prints]) {
      add(churlock.id, e.description);
    }
    add(churlock.id, certificateText(mystery.deskCode));
    for (final entry in mystery.topics.entries) {
      for (final t in entry.value) {
        add(entry.key, t.answer);
      }
    }
  }
  return lines;
}
