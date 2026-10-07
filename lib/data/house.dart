import 'package:flutter/material.dart';

import 'models.dart';

const double sceneW = 960;
const double sceneH = 540;

/// Where the back wall meets the floor.
const double floorY = 350;

/// The column that holds the staircase on every level.
const int stairCol = 2;

enum Dir { left, right, up, down }

const _stone = Color(0xFF5B5F6B);
const _stoneFloor = Color(0xFF3F4048);
const _atticWall = Color(0xFF8B6B4A);
const _atticFloor = Color(0xFF5E432C);

const rooms = <Room>[
  // Attic
  Room(id: 'storage', name: 'Storage Nook', level: 2, col: 0, wall: _atticWall, floor: _atticFloor),
  Room(id: 'bedroom', name: "Tira's Bedroom", level: 2, col: 1, wall: Color(0xFF9A6F7A), floor: _atticFloor),
  Room(id: 'landing', name: 'Attic Landing', level: 2, col: 2, wall: _atticWall, floor: _atticFloor),
  Room(id: 'study', name: "Mrs. Senclair's Study", level: 2, col: 3, wall: Color(0xFF5E6B4A), floor: _atticFloor),
  // Ground floor
  Room(id: 'kitchen', name: 'Kitchen', level: 1, col: 0, wall: Color(0xFFD9C9A0), floor: Color(0xFF9A8468)),
  Room(id: 'dining', name: 'Dining Room', level: 1, col: 1, wall: Color(0xFF3E5C76), floor: Color(0xFF7B5536)),
  Room(id: 'entrance', name: 'Entrance Hall', level: 1, col: 2, wall: Color(0xFF2F6F73), floor: Color(0xFF8A5A3A)),
  Room(id: 'parlor', name: 'Parlor', level: 1, col: 3, wall: Color(0xFF7A3B46), floor: Color(0xFF6E4A2F)),
  // Basement
  Room(id: 'pantry', name: 'Pantry', level: 0, col: 1, wall: _stone, floor: _stoneFloor),
  Room(id: 'cellar', name: 'Cellar', level: 0, col: 2, wall: _stone, floor: _stoneFloor),
  Room(id: 'boiler', name: 'Boiler Room', level: 0, col: 3, wall: _stone, floor: _stoneFloor),
];

Room roomById(String id) => rooms.firstWhere((r) => r.id == id);

Room? _roomAt(int level, int col) {
  for (final r in rooms) {
    if (r.level == level && r.col == col) return r;
  }
  return null;
}

Room? neighbor(Room r, Dir d) {
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

const churlock = Person(
  id: 'churlock',
  name: 'Detective Churlock',
  role: 'Consulting churro',
  dessert: Dessert.churro,
);

const residents = <Person>[
  Person(
    id: 'penny',
    name: 'Penny Cotta',
    role: 'Housekeeper',
    dessert: Dessert.pannaCotta,
    greeting: "Oh! Detective! Forgive me, I'm all of a wobble this morning.",
  ),
  Person(
    id: 'graham',
    name: 'Graham Cracker',
    role: 'Butler',
    dessert: Dessert.cracker,
    greeting: 'Good morning, sir. I trust you wiped your feet.',
  ),
  Person(
    id: 'cannoli',
    name: 'Colonel Cannoli',
    role: 'Retired officer & lodger',
    dessert: Dessert.cannoli,
    greeting: 'Churlock, is it? Ghastly business, what! Ask away, ask away.',
  ),
  Person(
    id: 'tira',
    name: 'Tira Misu',
    role: "Mrs. Senclair's niece",
    dessert: Dessert.tiramisu,
    greeting: "A detective, in my bedroom, before noon. Do make it quick, darling.",
  ),
  Person(
    id: 'barry',
    name: 'Barry Tart',
    role: 'Gardener',
    dessert: Dessert.tart,
    greeting: "Mornin', guv. Mind the coal.",
  ),
];

const police = <Person>[
  Person(
    id: 'sprinkles',
    name: 'Sgt. Sprinkles',
    role: 'Donut County Police',
    dessert: Dessert.donutPink,
    greeting: "Detective Churlock. Glad you're here — this one's got us going in circles.",
  ),
  Person(
    id: 'glaze',
    name: 'Officer Glaze',
    role: 'Donut County Police',
    dessert: Dessert.donutGlazed,
    greeting: 'Morning, Detective. Watch your step around the outline.',
  ),
];

Person personById(String id) =>
    [churlock, ...residents, ...police].firstWhere((p) => p.id == id);

/// Who stands where: room id -> (person id, x of their centre).
const placements = <String, List<(String, double)>>{
  'kitchen': [('penny', 760)],
  'dining': [('graham', 740)],
  'parlor': [('cannoli', 720)],
  'bedroom': [('tira', 720)],
  'boiler': [('barry', 740)],
  'cellar': [('sprinkles', 690), ('glaze', 835)],
};
