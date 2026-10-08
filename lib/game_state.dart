import 'dart:math';

import 'package:flutter/foundation.dart';

import 'data/cases.dart';
import 'data/house.dart';
import 'data/models.dart';

/// The intro and outro are the narrated scenes outside the mansion.
enum Phase { title, intro, playing, outro, ended }

enum Panel { none, notebook, accuse }

/// What the dialogue box at the bottom of the screen is showing.
class Dialogue {
  const Dialogue({
    required this.speaker,
    required this.title,
    required this.text,
    this.talk = false,
  });

  final Person speaker;
  final String title;
  final String text;

  /// True when [speaker] can be asked questions.
  final bool talk;
}

class GameState extends ChangeNotifier {
  GameState({Random? random}) : _rng = random ?? Random();

  final Random _rng;
  int? _caseIndex;

  Phase phase = Phase.title;
  MysteryCase mystery = allCases.first;
  String roomId = 'entrance';
  Panel panel = Panel.none;
  Dialogue? dialogue;

  /// The evidence hidden in the house this game: a random draw from the
  /// case, so two playthroughs of one mystery do not offer the same clues.
  List<Evidence> evidence = const [];

  final found = <String>{};
  final visited = <String>{};

  /// Statements already heard, as `person/topicId`.
  final asked = <String>{};

  /// Suspects ticked in the accusation panel; the final verdict once ended.
  final accused = <String>{};

  Room get room => roomById(roomId);

  Iterable<Evidence> get evidenceHere =>
      evidence.where((e) => e.room == roomId);

  /// Starts a fresh investigation with a randomly chosen mystery — never the
  /// one just played — and a fresh draw of its evidence.
  void newGame({int? caseIndex, bool skipIntro = false}) {
    final previous = _caseIndex;
    var next = caseIndex ?? _rng.nextInt(allCases.length);
    if (caseIndex == null && next == previous) {
      next = (next + 1 + _rng.nextInt(allCases.length - 1)) % allCases.length;
    }
    _caseIndex = next;
    mystery = allCases[next];
    evidence = [
      ...mystery.core,
      for (final group in mystery.variants) group[_rng.nextInt(group.length)],
      ...(List.of(mystery.herrings)..shuffle(_rng)).take(mystery.herringCount),
    ];
    roomId = 'entrance';
    found.clear();
    visited
      ..clear()
      ..add(roomId);
    asked.clear();
    accused.clear();
    panel = Panel.none;
    dialogue = null;
    phase = skipIntro ? Phase.playing : Phase.intro;
    notifyListeners();
  }

  /// Ends the arrival scene and puts Churlock in the entrance hall.
  void beginInvestigation() {
    phase = Phase.playing;
    notifyListeners();
  }

  bool get busy => dialogue != null || panel != Panel.none;

  /// Where [d] leads from here, or null if Churlock cannot go that way now.
  Room? destination(Dir d) {
    if (phase != Phase.playing || busy) return null;
    return neighbor(room, d);
  }

  void enter(Room next) {
    roomId = next.id;
    visited.add(roomId);
    notifyListeners();
  }

  void inspect(Evidence e) {
    final isNew = found.add(e.id);
    dialogue = Dialogue(
      speaker: churlock,
      title: isNew ? 'New evidence: ${e.name}' : e.name,
      text: e.description,
    );
    notifyListeners();
  }

  void talkTo(Person p) {
    dialogue = Dialogue(
      speaker: p,
      title: p.name,
      text: p.greeting,
      talk: true,
    );
    notifyListeners();
  }

  static String keyOf(String personId, Topic t) => '$personId/${t.id}';

  /// The questions [personId] can currently be asked. Follow-ups appear only
  /// once the evidence or the statements they rest on are known.
  List<Topic> topicsFor(String personId) {
    final all = mystery.topics[personId] ?? const <Topic>[];
    return [
      for (final t in all)
        if ((t.needs.isEmpty || t.needs.any(found.contains)) &&
            t.heard.every(asked.contains))
          t,
    ];
  }

  bool hasAsked(String personId, Topic t) => asked.contains(keyOf(personId, t));

  /// Everything [personId] has told Churlock so far.
  List<Topic> statementsOf(String personId) => [
        for (final t in mystery.topics[personId] ?? const <Topic>[])
          if (hasAsked(personId, t)) t,
      ];

  void ask(Person p, Topic topic) {
    asked.add(keyOf(p.id, topic));
    dialogue = Dialogue(
      speaker: p,
      title: p.name,
      text: topic.answer,
      talk: true,
    );
    notifyListeners();
  }

  void closeDialogue() {
    dialogue = null;
    notifyListeners();
  }

  void openPanel(Panel p) {
    if (p == Panel.accuse) accused.clear();
    panel = p;
    notifyListeners();
  }

  void closePanel() {
    panel = Panel.none;
    notifyListeners();
  }

  void toggleAccused(String id) {
    if (!accused.remove(id) && accused.length < 2) accused.add(id);
    notifyListeners();
  }

  bool get canAccuse => accused.isNotEmpty && accused.length <= 2;

  void makeArrest() {
    if (!canAccuse) return;
    panel = Panel.none;
    dialogue = null;
    phase = Phase.outro;
    notifyListeners();
  }

  /// Ends the closing scene and shows the verdict.
  void showVerdict() {
    phase = Phase.ended;
    notifyListeners();
  }

  // Verdict

  bool get won => setEquals(accused, mystery.culprits);

  Set<String> get jailedInnocents => accused.difference(mystery.culprits);

  Set<String> get freeKillers => mystery.culprits.difference(accused);

  /// The resident a killer who is still at large silences next.
  Person? get nextVictim {
    if (freeKillers.isEmpty) return null;
    for (final id in mystery.nextVictims) {
      if (!accused.contains(id)) return personById(id);
    }
    return null;
  }
}
