import 'package:flutter/material.dart';

import 'house.dart' show Dir, world;

enum Dessert {
  churro,
  donutPink,
  donutGlazed,
  donutChocolate,
  pannaCotta,
  tart,
  tiramisu,
  cannoli,
  cracker,
  pupcake,
  purrfait,
}

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.role,
    required this.dessert,
    this.greeting = '',
  });

  final String id;
  final String name;
  final String role;
  final Dessert dessert;
  final String greeting;
}

/// A question Churlock can ask.
///
/// It appears once any of the [needs] evidence has been found (if there is
/// any) and every statement in [heard] — written `person/topicId` — has been
/// listened to. Asking it may also make the speaker hand over [gives].
class Topic {
  const Topic(
    this.id,
    this.question,
    this.answer, {
    this.needs = const [],
    this.heard = const [],
    this.gives,
  });

  final String id;
  final String question;
  final String answer;
  final List<String> needs;
  final List<String> heard;
  final Evidence? gives;

  bool get isFollowUp => needs.isNotEmpty || heard.isNotEmpty;
}

/// A hands-on step needed before a piece of evidence gives up its secret.
enum Puzzle {
  none,

  /// Shade a notepad with a pencil to raise what was written on the sheet above.
  rubbing,

  /// Put the strips of a torn-up letter back in order.
  torn,
}

class Evidence {
  const Evidence(
    this.id,
    this.name,
    this.room,
    this.slot,
    this.description, {
    this.icon = Icons.auto_awesome,
    this.color = const Color(0xFFFFE082),
    this.inside,
    this.puzzle = Puzzle.none,
    this.pieces = const [],
    this.hidden = false,
  }) : from = null;

  /// Evidence that is not lying about the house but handed over by [from].
  const Evidence.given(
    this.id,
    this.name,
    this.from,
    this.description, {
    this.icon = Icons.description,
    this.color = const Color(0xFFFFF59D),
  })  : room = '',
        slot = 0,
        inside = null,
        puzzle = Puzzle.none,
        pieces = const [],
        hidden = false;

  final String id;
  final String name;
  final String room;

  /// Index into the room's list of evidence positions.
  final int slot;
  final String description;
  final IconData icon;
  final Color color;

  /// The piece of furniture this is hidden in, if it is not out in the room.
  final String? inside;
  final Puzzle puzzle;

  /// The hidden text for a [Puzzle.rubbing], or the strips, in order, of a
  /// [Puzzle.torn] letter.
  final List<String> pieces;

  /// Whether it is tucked behind the loose lining of the furniture it is
  /// [inside], and so not seen until the lining is lifted.
  final bool hidden;

  /// Who handed this over, for evidence obtained by asking.
  final String? from;
}

/// Something in a room that can be searched: a closet, a trunk, a drawer.
class Nook {
  const Nook({
    required this.id,
    required this.name,
    required this.room,
    required this.pos,
    required this.blurb,
    this.icon = Icons.door_sliding,
    this.junk = const [],
    this.locked = false,
    this.needs,
    this.barred = '',
    this.action = '',
    this.pick = false,
  });

  final String id;
  final String name;
  final String room;
  final Offset pos;
  final String blurb;
  final IconData icon;

  /// Things inside that are not evidence, but worth a remark.
  final List<Junk> junk;

  /// Whether a combination is needed to open it.
  final bool locked;

  /// The id of the [Item] needed to get into it, if any.
  final String? needs;

  /// What Churlock thinks of it while he lacks that item.
  final String barred;

  /// The label of the button that uses the item on it.
  final String action;

  /// Whether using the item means picking a lock.
  final bool pick;
}

/// A tool lying about the house, which Churlock can pocket and use to get
/// at something he otherwise could not.
class Item {
  const Item({
    required this.id,
    required this.name,
    required this.room,
    required this.pos,
    required this.description,
    required this.icon,
    this.color = const Color(0xFF80DEEA),
  });

  final String id;
  final String name;
  final String room;
  final Offset pos;
  final String description;
  final IconData icon;
  final Color color;
}

/// Something in a room that is worth a remark and nothing more.
class Sight {
  const Sight(this.id, this.room, this.pos, this.junk, {this.size = 60});

  final String id;
  final String room;
  final Offset pos;
  final Junk junk;

  /// The side of the square that can be clicked.
  final double size;
}

class Junk {
  const Junk(this.name, this.text, {this.icon = Icons.category});

  final String name;
  final String text;
  final IconData icon;
}

/// A mystery. Each playthrough shows all of [core], one clue from each list
/// in [variants], and [herringCount] of the [herrings] chosen at random.
class MysteryCase {
  const MysteryCase({
    required this.id,
    required this.title,
    required this.culprits,
    required this.core,
    required this.variants,
    required this.herrings,
    this.herringCount = 8,
    required this.weapons,
    required this.prints,
    required this.printsOn,
    required this.deskCode,
    required this.hints,
    required this.accuseHints,
    this.lies = const {},
    this.greetings = const {},
    this.shaky = const {},
    required this.topics,
    required this.solution,
    required this.nextVictims,
  });

  final String id;
  final String title;
  final Set<String> culprits;
  final List<Evidence> core;
  final List<List<Evidence>> variants;
  final List<Evidence> herrings;
  final int herringCount;

  /// Ids of the evidence that is the murder weapon (one per playthrough),
  /// which can be dusted once Churlock has the police fingerprint chart.
  final Set<String> weapons;

  /// What dusting the weapon reveals, and whose prints are on it.
  final Evidence prints;
  final List<String> printsOn;

  /// The year Senclair Confections was founded, in this mystery.
  final String deskCode;

  /// Evidence id -> what Watsonut makes of it, when asked.
  final Map<String, String> hints;

  /// Watsonut's nudges on the accusation screen, gentlest first.
  final List<String> accuseHints;

  /// The hints in which Watsonut is lying: evidence ids, and `accuse:n` for
  /// the nth nudge on the accusation screen. His moustache keeps still.
  final Set<String> lies;

  /// Person id -> what they say on being approached, where it differs from
  /// their usual greeting.
  final Map<String, String> greetings;

  /// The hints he cannot give without his voice shaking, named likewise.
  final Set<String> shaky;

  /// Person id -> everything they can be asked in this case.
  final Map<String, List<Topic>> topics;
  final String solution;

  /// Innocent residents, in the order the killer would silence them.
  final List<String> nextVictims;

  /// Everything that can be found lying about the house.
  Iterable<Evidence> get pool => [
        ...core,
        for (final group in variants) ...group,
        ...herrings,
      ];

  /// Everything the residents and the police can hand over.
  Iterable<Evidence> get gifts sync* {
    final seen = <String>{};
    for (final list in topics.values) {
      for (final t in list) {
        final gift = t.gives;
        if (gift != null && seen.add(gift.id)) yield gift;
      }
    }
  }

  /// How many pieces of evidence one playthrough holds.
  int get evidenceCount =>
      core.length + variants.length + herringCount + gifts.length + 1;
}

class Room {
  const Room({
    required this.id,
    required this.name,
    required this.level,
    required this.col,
    required this.wall,
    required this.floor,
  });

  final String id;
  final String name;

  /// 0 = basement, 1 = ground floor, 2 = attic.
  final int level;
  final int col;
  final Color wall;
  final Color floor;

  String get levelName => world.outdoors.contains(id) || world.outbuildings.contains(id)
      ? 'Outside'
      : const ['Basement', 'Ground Floor', 'Attic'][level];
}

/// One spoken line: who says it, and what they say.
typedef VoiceLine = ({String voice, String text});

/// The voice that tells the story in the opening and closing scenes.
const narrator = 'narrator';

/// An animal about the place, who can be clicked on and speaks up now and
/// then. One may sit somewhere else once [bribedBy] has been opened.
class Pet {
  const Pet({
    required this.person,
    required this.room,
    required this.feet,
    required this.remark,
    required this.sound,
    this.width = 80,
    this.bribedBy,
    this.bribedFeet,
  });

  final Person person;
  final String room;

  /// Where its paws are, in scene coordinates.
  final Offset feet;
  final double width;

  /// What Churlock says of it.
  final Junk remark;

  /// The name of its sound effect.
  final String sound;

  /// The furniture whose opening moves it to [bribedFeet].
  final String? bribedBy;
  final Offset? bribedFeet;
}

/// A place where mysteries happen: its rooms and people, its furniture and
/// tools, its mysteries, and how its story is told.
class World {
  const World({
    required this.id,
    required this.title,
    required this.blurb,
    required this.accuseQuestion,
    required this.place,
    required this.rooms,
    this.stairCol = 2,
    required this.start,
    this.leftStairs = const {},
    this.outdoors = const {},
    this.outbuildings = const {},
    required this.residents,
    required this.police,
    required this.placements,
    required this.slots,
    required this.nooks,
    required this.items,
    this.sights = const [],
    this.pets = const [],
    this.doors = const {},
    this.windows = const {},
    required this.cases,
    this.twist,
    required this.intro,
    required this.win,
    required this.loseAgain,
    required this.loseHalf,
    required this.music,
    required this.certificate,
    required this.looseCorner,
  });

  final String id;
  final String title;

  /// The paragraph on the title screen.
  final String blurb;
  final String accuseQuestion;

  /// Where it is, for the closing words: "… can sleep soundly again".
  final String place;
  final List<Room> rooms;

  /// The column that holds the staircase on every level.
  final int stairCol;

  /// The room the investigation begins in, and the case is solved from.
  final String start;

  /// Rooms whose stairs climb to the left rather than the right.
  final Set<String> leftStairs;

  /// Rooms out of doors, under the open sky.
  final Set<String> outdoors;

  /// Rooms in buildings of their own, with a tin roof to drum on.
  final Set<String> outbuildings;
  final List<Person> residents;
  final List<Person> police;
  final Map<String, List<(String, double)>> placements;
  final Map<String, List<Offset>> slots;
  final List<Nook> nooks;
  final List<Item> items;
  final List<Sight> sights;
  final List<Pet> pets;

  /// Doors drawn in a room, by room and the direction they lead.
  final Map<(String, Dir), Rect> doors;

  /// The glass of each room's window, in scene coordinates.
  final Map<String, Rect> windows;
  final List<MysteryCase> cases;

  /// The rare mystery that breaks the rules of the others, if there is one.
  final MysteryCase? twist;
  final List<VoiceLine> intro;
  final List<VoiceLine> win;
  final List<VoiceLine> loseAgain;
  final List<VoiceLine> loseHalf;

  /// The title screen's music.
  final String music;

  /// The certificate that gives the year the victim's business began.
  final String Function(String year) certificate;

  /// What is in the hidden compartment of the locked desk, in most mysteries.
  final Junk looseCorner;
}
