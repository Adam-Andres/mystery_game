import 'dart:math';

import 'package:flutter/foundation.dart';

import 'data/cases.dart';
import 'data/house.dart';
import 'data/models.dart';

enum Phase { title, playing, ended }

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

  final found = <String>{};
  final visited = <String>{};

  /// Person id -> indexes of the topics already asked.
  final asked = <String, Set<int>>{};

  /// Suspects ticked in the accusation panel; the final verdict once ended.
  final accused = <String>{};

  Room get room => roomById(roomId);

  Iterable<Evidence> get evidenceHere =>
      mystery.evidence.where((e) => e.room == roomId);

  /// Starts a fresh investigation. The first case is random; after that the
  /// cases alternate so a replay is never the same mystery twice in a row.
  void newGame({int? caseIndex}) {
    final previous = _caseIndex;
    _caseIndex = caseIndex ??
        (previous == null
            ? _rng.nextInt(allCases.length)
            : (previous + 1) % allCases.length);
    mystery = allCases[_caseIndex!];
    roomId = 'entrance';
    found.clear();
    visited
      ..clear()
      ..add(roomId);
    asked.clear();
    accused.clear();
    panel = Panel.none;
    dialogue = const Dialogue(
      speaker: churlock,
      title: 'Detective Churlock',
      text: briefing,
    );
    phase = Phase.playing;
    notifyListeners();
  }

  bool get busy => dialogue != null || panel != Panel.none;

  void move(Dir d) {
    if (phase != Phase.playing || busy) return;
    final next = neighbor(room, d);
    if (next == null) return;
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

  /// The questions [personId] can currently be asked, with their index in the
  /// case's full topic list.
  List<(int, Topic)> topicsFor(String personId) {
    final all = mystery.topics[personId] ?? const <Topic>[];
    return [
      for (var i = 0; i < all.length; i++)
        if (all[i].needs == null || found.contains(all[i].needs)) (i, all[i]),
    ];
  }

  bool hasAsked(String personId, int index) =>
      asked[personId]?.contains(index) ?? false;

  void ask(Person p, int index) {
    final topic = mystery.topics[p.id]![index];
    asked.putIfAbsent(p.id, () => {}).add(index);
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
