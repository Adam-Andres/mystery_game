import 'dart:math';

import 'package:flutter/foundation.dart';

import 'data/cases.dart';
import 'data/hints.dart';
import 'data/house.dart';
import 'data/models.dart';

/// The intro and outro are the narrated scenes outside the mansion.
enum Phase { title, intro, playing, outro, ended }

enum Panel { none, notebook, accuse, nook, puzzle }

/// The hands-on task currently on screen.
enum Task { none, rubbing, torn, prints }

/// What the dialogue box at the bottom of the screen is showing.
class Dialogue {
  const Dialogue({
    required this.speaker,
    required this.title,
    required this.text,
    this.talk = false,
    this.note,
    this.evidence,
  });

  final Person speaker;
  final String title;
  final String text;

  /// True when [speaker] can be asked questions.
  final bool talk;

  /// A line shown beneath the text, such as what was just handed over.
  final String? note;

  /// The evidence being examined, about which Watsonut can be asked.
  final Evidence? evidence;
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

  /// The piece of furniture being searched while [panel] is [Panel.nook].
  Nook? nook;

  /// The evidence being worked on while [panel] is [Panel.puzzle].
  Evidence? puzzle;
  Task task = Task.none;

  /// Every piece of evidence in this game: a random draw of what is hidden
  /// in the house, plus whatever can be handed over or raised by dusting.
  List<Evidence> evidence = const [];

  final found = <String>{};
  final visited = <String>{};

  /// Locked furniture that has been opened.
  final unlocked = <String>{};

  /// Statements already heard, as `person/topicId`.
  final asked = <String>{};

  /// How many hints Watsonut has given this game, of either kind.
  int hintsUsed = 0;

  /// How many of his nudges on the accusation screen have been heard.
  int accuseHintsGiven = 0;

  /// True while the game is checking that the first hint was meant.
  bool hintPrompt = false;
  Evidence? _hintAbout;

  /// Suspects ticked in the accusation panel; the final verdict once ended.
  final accused = <String>{};

  Room get room => roomById(roomId);

  /// Evidence lying out in the open in the current room.
  Iterable<Evidence> get evidenceHere => evidence.where(
    (e) => e.room == roomId && e.inside == null && e.from == null,
  );

  Iterable<Nook> get nooksHere => nooks.where((n) => n.room == roomId);

  Iterable<Evidence> evidenceIn(Nook n) =>
      evidence.where((e) => e.inside == n.id);

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
      ...mystery.gifts,
      mystery.prints,
    ];
    roomId = 'entrance';
    found.clear();
    visited
      ..clear()
      ..add(roomId);
    unlocked.clear();
    hintsUsed = 0;
    accuseHintsGiven = 0;
    hintPrompt = false;
    asked.clear();
    accused.clear();
    panel = Panel.none;
    nook = null;
    puzzle = null;
    task = Task.none;
    dialogue = null;
    phase = skipIntro ? Phase.playing : Phase.intro;
    notifyListeners();
  }

  /// Ends the arrival scene and puts Churlock in the entrance hall.
  void beginInvestigation() {
    phase = Phase.playing;
    notifyListeners();
  }

  /// True while a dialogue or a panel has the player's attention.
  bool get busy => dialogue != null || panel != Panel.none || hintPrompt;

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

  /// The murder weapon can be dusted once it is found and Churlock has the
  /// police chart to compare prints against.
  bool canDust(Evidence e) =>
      mystery.weapons.contains(e.id) &&
      found.contains(e.id) &&
      found.contains('chart') &&
      !found.contains(mystery.prints.id);

  /// Examines [e]. Some evidence needs a hands-on step first.
  void inspect(Evidence e) {
    if (canDust(e)) {
      _startTask(e, Task.prints);
    } else if (e.puzzle != Puzzle.none && !found.contains(e.id)) {
      _startTask(e, e.puzzle == Puzzle.rubbing ? Task.rubbing : Task.torn);
    } else {
      _show(e);
    }
  }

  void _startTask(Evidence e, Task t) {
    puzzle = e;
    task = t;
    panel = Panel.puzzle;
    notifyListeners();
  }

  void _show(Evidence e) {
    final isNew = found.add(e.id);
    dialogue = Dialogue(
      speaker: churlock,
      title: isNew ? 'New evidence: ${e.name}' : e.name,
      text: e.description,
      evidence: e,
    );
    notifyListeners();
  }

  /// Brings a piece of evidence already in the notebook back up.
  void review(Evidence e) => _show(e);

  /// Plays back something [p] has already said.
  void replay(Person p, Topic topic) {
    dialogue = Dialogue(
      speaker: p,
      title: p.name,
      text: topic.answer,
      note: 'You asked: “${topic.question}”',
    );
    notifyListeners();
  }

  /// Called by a minigame when the player has finished it.
  void completeTask() {
    final e = puzzle;
    if (e == null) return;
    final done = task;
    puzzle = null;
    task = Task.none;
    // Back to the furniture being searched, if that is where this was found.
    panel = nook != null ? Panel.nook : Panel.none;
    _show(done == Task.prints ? mystery.prints : e);
  }

  /// Abandons a minigame without finishing it.
  void cancelTask() {
    puzzle = null;
    task = Task.none;
    panel = nook != null ? Panel.nook : Panel.none;
    notifyListeners();
  }

  /// What Churlock says about [junk]. The certificate names a different
  /// year in each mystery, because it is the combination of the desk.
  String junkText(Junk junk) =>
      junk.text.isEmpty ? certificateText(mystery.deskCode) : junk.text;

  /// Churlock remarks on something that is not evidence.
  void remark(Junk junk) {
    dialogue = Dialogue(
      speaker: churlock,
      title: junk.name,
      text: junkText(junk),
    );
    notifyListeners();
  }

  bool get moreAccuseHints => accuseHintsGiven < mystery.accuseHints.length;

  /// Asks Watsonut for a hint: about [about] if given, otherwise his next
  /// nudge on the accusation screen. The very first request of a game is
  /// confirmed first, in case the button was pressed by accident.
  void askHint({Evidence? about}) {
    if (about == null && !moreAccuseHints) return;
    if (hintsUsed == 0) {
      _hintAbout = about;
      hintPrompt = true;
      notifyListeners();
      return;
    }
    _giveHint(about);
  }

  void answerHintPrompt({required bool wanted}) {
    hintPrompt = false;
    if (wanted) {
      _giveHint(_hintAbout);
    } else {
      notifyListeners();
    }
  }

  void _giveHint(Evidence? about) {
    hintsUsed++;
    final String text;
    final String note;
    if (about != null) {
      text = hintFor(mystery, about);
      note = 'On: ${about.name}';
    } else {
      text = mystery.accuseHints[accuseHintsGiven++];
      note = 'Hint $accuseHintsGiven of ${mystery.accuseHints.length}';
    }
    dialogue = Dialogue(
      speaker: watsonut,
      title: watsonut.name,
      text: text,
      note: note,
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
    final gift = topic.gives;
    final received = gift != null && found.add(gift.id);
    dialogue = Dialogue(
      speaker: p,
      title: p.name,
      text: topic.answer,
      talk: true,
      note: received ? 'Received: ${gift.name} — see the notebook.' : null,
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

  void search(Nook n) {
    nook = n;
    panel = Panel.nook;
    notifyListeners();
  }

  bool isOpen(Nook n) => !n.locked || unlocked.contains(n.id);

  /// Tries a combination on a locked piece of furniture.
  bool tryCode(Nook n, String code) {
    if (code != mystery.deskCode) return false;
    unlocked.add(n.id);
    notifyListeners();
    return true;
  }

  void closePanel() {
    panel = Panel.none;
    nook = null;
    puzzle = null;
    task = Task.none;
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
