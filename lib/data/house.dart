import 'package:flutter/material.dart';

import 'models.dart';
import 'farm.dart';
import 'senclair.dart';

export 'senclair.dart'
    show pupcake, purrfait, pupcakeGuarding, pupcakeFed, pupcakeRemark;

const double sceneW = 960;
const double sceneH = 540;

/// Where the back wall meets the floor.
const double floorY = 350;

/// Every place a mystery can be set, in the order the title screen shows
/// them.
const worlds = <World>[senclair, farm];

/// The place being played, or shown on the title screen.
World world = senclair;

/// The column that holds the staircase on every level.
int get stairCol => world.stairCol;

enum Dir { left, right, up, down }

List<Room> get rooms => world.rooms;

Room roomById(String id) => rooms.firstWhere((r) => r.id == id);

Room? _roomAt(int level, int col) {
  for (final r in rooms) {
    if (r.level == level && r.col == col) return r;
  }
  return null;
}

Room? neighbor(Room r, Dir d) {
  // A place with its own paths goes only where they lead.
  if (world.links.isNotEmpty) {
    final to = world.links[(r.id, d)];
    return to == null ? null : roomById(to);
  }
  switch (d) {
    case Dir.left:
      return _roomAt(r.level, r.col - 1);
    case Dir.right:
      return _roomAt(r.level, r.col + 1);
    case Dir.up:
      return r.col == stairCol ? _roomAt(r.level + 1, stairCol) : null;
    case Dir.down:
      return r.col == stairCol ? _roomAt(r.level - 1, stairCol) : null;
  }
}

Rect? doorOf(String room, Dir d) => world.doors[(room, d)];

const churlock = Person(
  id: 'churlock',
  name: 'Detective Churlock',
  role: 'Consulting churro',
  dessert: Dessert.churro,
);

const watsonut = Person(
  id: 'watsonut',
  name: 'Dr. Watsonut',
  role: "Churlock's partner",
  dessert: Dessert.donutChocolate,
  greeting: "If you want my opinion of anything, Churlock, examine it and "
      "ask me. I shan't volunteer. You know how you get.",
);

/// What Watsonut says as they come into the house. With a keyboard, the
/// keys are written beside the buttons they press, and he need say no more
/// than how to ask his opinion. On a touch screen he also explains the map.
String arrivalGreeting({required bool touch}) =>
    touch ? '${watsonut.greeting} $_travelByTouch' : watsonut.greeting;

const _travelByTouch =
    "And should you want to be somewhere else in a hurry, tap the little map "
    "in the corner, and choose any room we have already seen.";

/// What Watsonut says when Churlock has stood about doing nothing.
const idleRemarks = [
  "Shall we get on, Churlock? The trail isn't getting any warmer.",
  "I say, are you thinking, or have you gone stale?",
  "If you're stuck, old chap, you need only ask. Examine something, and "
      "I'll tell you what I make of it.",
  "Have we looked in all the cupboards? One never finds anything by "
      "standing about.",
  "I could murder a cup of tea. Poor choice of words. Sorry.",
  "Perhaps one of them has more to say, now that we know a little more.",
  "You have that look again. The one you get just before you say Eureka. "
      "No? Not yet?",
  "My feet hurt, and I haven't any.",
];

List<Person> get residents => world.residents;
List<Person> get police => world.police;

Person personById(String id) =>
    [churlock, watsonut, ...residents, ...police].firstWhere((p) => p.id == id);

/// Who stands where: room id -> (person id, x of their centre).
Map<String, List<(String, double)>> get placements => world.placements;

/// Where evidence can sit in each room, in scene coordinates.
Map<String, List<Offset>> get slots => world.slots;

Offset evidencePos(Evidence e) => slots[e.room]![e.slot];

/// The certificate that names the year the victim's business began.
String certificateText(String year) => world.certificate(year);

/// Furniture that can be searched.
List<Nook> get nooks => world.nooks;

Nook nookById(String id) => nooks.firstWhere((n) => n.id == id);

/// Tools that can be picked up and carried.
List<Item> get items => world.items;

Item itemById(String id) => items.firstWhere((i) => i.id == id);

/// Things worth a remark that are neither evidence nor furniture.
List<Sight> get sights => world.sights;

/// The animals about the place.
List<Pet> get pets => world.pets;

/// What is in the hidden compartment of the locked desk, in most mysteries.
Junk get looseCorner => world.looseCorner;
