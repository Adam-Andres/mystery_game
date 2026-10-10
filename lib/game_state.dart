import 'dart:math';

import 'package:flutter/foundation.dart';

import 'data/cases.dart';
import 'data/hints.dart';
import 'data/house.dart';
import 'data/house.dart' as house;
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
    this.voice,
    this.lying = false,
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

  /// The voice to speak in, where it is not simply the speaker's own.
  final String? voice;

  /// True when the speaker does not believe a word of it.
  final bool lying;
}

/// How often a new game is the rare mystery in which Watsonut did it.
/// It is every game for now, to try it out; it is meant to be one in twenty.
const twistOdds = 1.0;

/// The voice Watsonut speaks in when the evidence is too close to home.
const shakyVoice = 'watsonut-shaky';

class GameState extends ChangeNotifier {
  GameState({Random? random, this.twistChance = twistOdds})
    : _rng = random ?? Random();

  /// The chance that a game chosen at random is the rare one.
  final double twistChance;

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

  /// Ids of the tools Churlock is carrying, in the order he found them. A
  /// tool is used up by the thing it opens.
  final items = <String>[];

  /// Every tool he has ever picked up, so that a used one does not reappear
  /// where it was found.
  final taken = <String>{};

  /// The three numbers of the study desk's dial, drawn afresh each game.
  /// They are written down nowhere: each is found by its click.
  List<int> combination = const [10, 69, 36];

  /// True once the loose lining of the desk drawer has been lifted.
  bool cornerLifted = false;

  /// The order in which the strongbox's pins must be set, which changes
  /// from game to game.
  List<int> pinOrder = const [0, 1, 2, 3];

  /// Statements already heard, as `person/topicId`.
  final asked = <String>{};

  /// How many hints Watsonut has given this game, of either kind.
  int hintsUsed = 0;

  /// How many of his nudges on the accusation screen have been heard.
  int accuseHintsGiven = 0;

  /// True while the game is checking that the first hint was meant.
  bool hintPrompt = false;
  Evidence? _hintAbout;

  /// True from the end of the arrival scene until Watsonut has had his say
  /// in the entrance hall.
  bool arriving = false;

  /// True once the strip torn from the list of suspects has been put back.
  bool sheetAttached = false;

  /// True while the list of suspects has a strip torn off it: only in the
  /// mystery where somebody had a reason to tear it.
  bool get listTorn => mystery.id == twistCase.id && !sheetAttached;

  /// Whether the torn strip has been found and is waiting to be put back.
  bool get canAttachSheet => found.contains('tornsheet') && !sheetAttached;

  void attachSheet() {
    if (!canAttachSheet) return;
    sheetAttached = true;
    notifyListeners();
  }

  /// Everyone who can be accused: the residents, and whoever else turns out
  /// to have been on the sergeant's list.
  List<Person> get suspects => [...residents, if (sheetAttached) watsonut];

  /// Suspects ticked in the accusation panel; the final verdict once ended.
  final accused = <String>{};

  Room get room => roomById(roomId);

  /// Evidence lying out in the open in the current room.
  Iterable<Evidence> get evidenceHere => evidence.where(
    (e) => e.room == roomId && e.inside == null && e.from == null,
  );

  Iterable<Nook> get nooksHere => nooks.where((n) => n.room == roomId);

  /// Tools lying in the current room that have not been picked up yet.
  Iterable<Item> get itemsHere =>
      allItems.where((i) => i.room == roomId && !taken.contains(i.id));

  static const allItems = house.items;

  Iterable<Sight> get sightsHere => sights.where((s) => s.room == roomId);

  /// What is to be seen inside [n]: not what is tucked behind its lining.
  Iterable<Evidence> evidenceIn(Nook n) =>
      evidence.where((e) => e.inside == n.id && !e.hidden);

  /// What is behind the lining of [n], if anything.
  Iterable<Evidence> hiddenIn(Nook n) =>
      evidence.where((e) => e.inside == n.id && e.hidden);

  /// Lifts the loose corner of the desk drawer's lining.
  void liftCorner(Nook n) {
    cornerLifted = true;
    notifyListeners();
  }

  /// Starts a fresh investigation with a randomly chosen mystery — never the
  /// one just played — and a fresh draw of its evidence.
  void newGame({int? caseIndex, bool? twist, bool skipIntro = false}) {
    final previous = _caseIndex;
    var next = caseIndex ?? _rng.nextInt(allCases.length);
    if (caseIndex == null && next == previous) {
      next = (next + 1 + _rng.nextInt(allCases.length - 1)) % allCases.length;
    }
    if (twist ?? (caseIndex == null && _rng.nextDouble() < twistChance)) {
      mystery = twistCase;
    } else {
      _caseIndex = next;
      mystery = allCases[next];
    }
    sheetAttached = false;
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
    items.clear();
    taken.clear();
    cornerLifted = false;
    // No number twice running, or there would be no turn between them.
    combination = [_rng.nextInt(99) + 1];
    while (combination.length < 3) {
      final next = _rng.nextInt(100);
      if (next != combination.last) combination.add(next);
    }
    pinOrder = [0, 1, 2, 3]..shuffle(_rng);
    hintsUsed = 0;
    accuseHintsGiven = 0;
    hintPrompt = false;
    arriving = false;
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
    arriving = true;
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
  /// year in each mystery.
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

  /// Pockets a tool found lying about.
  void take(Item item) {
    if (taken.add(item.id)) items.add(item.id);
    showItem(item, isNew: true);
  }

  /// Churlock looks over a tool he is carrying.
  void showItem(Item item, {bool isNew = false}) {
    dialogue = Dialogue(
      speaker: churlock,
      title: isNew ? 'Picked up: ${item.name}' : item.name,
      text: item.description,
    );
    notifyListeners();
  }

  bool has(String itemId) => items.contains(itemId);

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
    final String id;
    if (about != null) {
      id = about.id;
      text = hintFor(mystery, about);
      note = 'On: ${about.name}';
    } else {
      id = 'accuse:$accuseHintsGiven';
      text = mystery.accuseHints[accuseHintsGiven++];
      note = 'Hint $accuseHintsGiven of ${mystery.accuseHints.length}';
    }
    dialogue = Dialogue(
      speaker: watsonut,
      title: watsonut.name,
      text: text,
      note: note,
      voice: mystery.shaky.contains(id) ? shakyVoice : null,
      lying: mystery.lies.contains(id),
    );
    notifyListeners();
  }

  void talkTo(Person p) {
    dialogue = Dialogue(
      speaker: p,
      title: p.name,
      text: mystery.greetings[p.id] ?? p.greeting,
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

  bool isOpen(Nook n) =>
      (!n.locked && n.needs == null) || unlocked.contains(n.id);

  /// Whether Churlock has what it takes to get into [n].
  bool canOpen(Nook n) => n.needs != null && has(n.needs!);

  /// Uses the right tool on [n]: digs it up, picks it, or bribes the dog.
  void forceOpen(Nook n) {
    if (!canOpen(n)) return;
    unlocked.add(n.id);
    // It stays open, and the tool has done its work.
    items.remove(n.needs);
    notifyListeners();
  }

  /// Tries a combination on a locked piece of furniture.
  bool tryCode(Nook n, String code) {
    if (code != combination.join('-')) return false;
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
