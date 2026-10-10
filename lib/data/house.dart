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
  // Ground floor, with the yard behind the kitchen
  Room(id: 'backyard', name: 'Backyard', level: 1, col: -1, wall: Color(0xFF2A2633), floor: Color(0xFF2E3B2A)),
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

const watsonut = Person(
  id: 'watsonut',
  name: 'Dr. Watsonut',
  role: "Churlock's partner",
  dessert: Dessert.donutChocolate,
  greeting: "If you want my opinion of anything, Churlock, examine it and "
      "ask me. I shan't volunteer. You know how you get.",
);

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
    [churlock, watsonut, ...residents, ...police].firstWhere((p) => p.id == id);

/// Who stands where: room id -> (person id, x of their centre).
const placements = <String, List<(String, double)>>{
  'kitchen': [('penny', 760)],
  'dining': [('graham', 740)],
  'parlor': [('cannoli', 720)],
  'bedroom': [('tira', 720)],
  'boiler': [('barry', 740)],
  'cellar': [('sprinkles', 690), ('glaze', 835)],
};

/// Where evidence can sit in each room, in scene coordinates.
const slots = <String, List<Offset>>{
  'entrance': [Offset(300, 440), Offset(170, 150), Offset(326, 215), Offset(480, 300), Offset(600, 430), Offset(372, 498)],
  'parlor': [Offset(455, 340), Offset(250, 395), Offset(480, 255), Offset(865, 200), Offset(165, 165)],
  'dining': [Offset(430, 312), Offset(175, 210), Offset(560, 312), Offset(830, 165), Offset(340, 440), Offset(480, 150)],
  'kitchen': [Offset(380, 150), Offset(560, 222), Offset(155, 285), Offset(830, 150), Offset(320, 300)],
  'pantry': [Offset(330, 300), Offset(640, 300), Offset(160, 200), Offset(480, 350), Offset(560, 450)],
  'backyard': [Offset(150, 300), Offset(275, 404), Offset(790, 395), Offset(872, 330), Offset(585, 470)],
  'cellar': [Offset(395, 452), Offset(200, 480), Offset(565, 425), Offset(430, 290), Offset(805, 230)],
  'boiler': [Offset(240, 455), Offset(382, 240), Offset(610, 440), Offset(880, 270), Offset(545, 290)],
  'landing': [Offset(640, 296), Offset(290, 200), Offset(835, 360), Offset(480, 140), Offset(220, 440)],
  'study': [Offset(470, 300), Offset(275, 200), Offset(880, 300), Offset(765, 165), Offset(160, 260), Offset(560, 360)],
  'bedroom': [Offset(268, 312), Offset(430, 400), Offset(855, 215), Offset(850, 290), Offset(185, 170)],
  'storage': [Offset(485, 395), Offset(180, 300), Offset(650, 290), Offset(800, 250), Offset(615, 410)],
};

Offset evidencePos(Evidence e) => slots[e.room]![e.slot];

/// The combination of the study desk. It is written down nowhere: the
/// dial has to be turned until each tumbler is heard to click.
const deskCombination = [10, 69, 36];

/// The founding-year certificate in the coat closet names a different year
/// in each mystery.
String certificateText(String year) =>
    "A framed certificate, put away behind the coats: “Senclair Confections. "
    "Founded $year.” She was prouder of that year than of anything.";

/// Furniture that can be searched. What evidence each holds depends on the
/// mystery; the odds and ends are always there.
const nooks = <Nook>[
  Nook(
    id: 'closet',
    name: 'Coat Closet',
    room: 'entrance',
    pos: Offset(326, 215),
    icon: Icons.checkroom,
    blurb: 'Coats, umbrellas, and whatever has been pushed to the back.',
    junk: [
      Junk('Framed certificate', '', icon: Icons.workspace_premium),
      Junk(
        'Umbrellas',
        "Five umbrellas, and every one of them bone dry. Nobody took one "
            "out into the soda rain last night.",
        icon: Icons.umbrella,
      ),
    ],
  ),
  Nook(
    id: 'bookcase',
    name: 'Bookcase',
    room: 'parlor',
    pos: Offset(865, 200),
    icon: Icons.menu_book,
    blurb: 'Four shelves of books that nobody in this house appears to read.',
    junk: [
      Junk(
        'War memoirs',
        "A row of the Colonel's war memoirs. Every one of them is a cookery "
            "book in a false cover.",
        icon: Icons.auto_stories,
      ),
    ],
  ),
  Nook(
    id: 'cupboard',
    name: 'Kitchen Cupboards',
    room: 'kitchen',
    pos: Offset(440, 305),
    icon: Icons.kitchen,
    blurb: 'Everything in its place, and a label on the place.',
    junk: [
      Junk(
        'Cooking sherry',
        "Cooking sherry. The level is marked in pencil. So is the cork.",
        icon: Icons.wine_bar,
      ),
      Junk(
        'Wooden spoons',
        "Forty-one wooden spoons, graded by size. I count them. Forty-one.",
        icon: Icons.restaurant,
      ),
    ],
  ),
  Nook(
    id: 'sacks',
    name: 'Flour Sacks',
    room: 'pantry',
    pos: Offset(480, 350),
    icon: Icons.shopping_bag,
    blurb: 'Two fat sacks of flour. Something could be pushed down inside.',
    junk: [
      Junk(
        'Flour',
        "Flour. A great deal of flour. And now a great deal of it on me.",
        icon: Icons.grain,
      ),
    ],
  ),
  Nook(
    id: 'kitbag',
    name: "Barry's Kit Bag",
    room: 'boiler',
    pos: Offset(870, 410),
    icon: Icons.backpack,
    blurb: 'A canvas bag that smells of compost and strong tea.',
    junk: [
      Junk(
        'Lunch',
        "A flask, three packets of seeds, and a sandwich of some age.",
        icon: Icons.lunch_dining,
      ),
    ],
  ),
  Nook(
    id: 'chest',
    name: 'Linen Chest',
    room: 'landing',
    pos: Offset(835, 360),
    icon: Icons.inventory_2,
    blurb: 'Sheets and pillowcases, and room to hide things under them.',
    junk: [
      Junk(
        'Sheets',
        "Monogrammed sheets, ironed perfectly flat. Graham irons everything.",
        icon: Icons.bed,
      ),
    ],
  ),
  Nook(
    id: 'desk',
    name: 'Desk Drawer',
    room: 'study',
    pos: Offset(560, 360),
    icon: Icons.lock,
    blurb: "Mrs. Senclair kept her private papers here, under lock.",
    locked: true,
    junk: [
      Junk(
        'Peppermints',
        "A tin of peppermints, with a note on the lid: “Counted.”",
        icon: Icons.cookie,
      ),
    ],
  ),
  Nook(
    id: 'dresser',
    name: "Tira's Dresser",
    room: 'bedroom',
    pos: Offset(850, 290),
    icon: Icons.dry_cleaning,
    blurb: 'Three drawers, all of them too full to close.',
    junk: [
      Junk(
        'Hats',
        "Nineteen hats. I count them twice. Nineteen.",
        icon: Icons.checkroom,
      ),
    ],
  ),
  Nook(
    id: 'trunk',
    name: "The Colonel's Trunk",
    room: 'storage',
    pos: Offset(485, 395),
    icon: Icons.work,
    blurb: 'A battered campaign trunk, stencilled “COL. CANNOLI”.',
    junk: [
      Junk(
        'Dress uniform',
        "A dress uniform, smelling of mothballs and marsala.",
        icon: Icons.military_tech,
      ),
    ],
  ),
  Nook(
    id: 'crates',
    name: 'Old Crates',
    room: 'storage',
    pos: Offset(180, 300),
    icon: Icons.inventory,
    blurb: 'Thirty years of things nobody could bear to throw away.',
    junk: [
      Junk(
        'Curtains',
        "Old curtains, older curtains, and a stuffed pheasant with a "
            "disapproving look.",
        icon: Icons.curtains,
      ),
    ],
  ),
  Nook(
    id: 'strongbox',
    name: 'Iron Strongbox',
    room: 'cellar',
    pos: Offset(600, 318),
    icon: Icons.lock,
    blurb: 'A squat iron box bolted to the cellar wall. Nobody admits to '
        'having the key.',
    needs: 'lockpicks',
    barred: 'The keyhole is the old lever kind. With the right picks I could '
        'have it open in a minute. With my fingers, never.',
    action: 'Pick the lock',
    pick: true,
    junk: [
      Junk(
        'Spare keys',
        "A ring of spare keys, each with a neat brass tag. The tag marked "
            "“Strongbox” has no key on it.",
        icon: Icons.key,
      ),
    ],
  ),
  Nook(
    id: 'dirt',
    name: 'Loose Earth',
    room: 'backyard',
    pos: Offset(292, 452),
    icon: Icons.landscape,
    blurb: 'A patch of earth beside the kennel, darker and softer than the '
        'ground around it.',
    needs: 'shovel',
    barred: 'It has been turned over lately, and patted flat again. I am '
        'not digging with my hands in this rain. I want a shovel.',
    action: 'Dig',
    junk: [
      Junk(
        'Old bones',
        "Biscuit bones, a great many, buried at careful intervals. Somebody "
            "small has been saving for his retirement.",
        icon: Icons.pets,
      ),
    ],
  ),
  Nook(
    id: 'kennel',
    name: 'Dog House',
    room: 'backyard',
    pos: Offset(508, 262),
    icon: Icons.cottage,
    blurb: 'A gingerbread kennel with an iced roof. The plate over the door '
        'reads “PUPCAKE”.',
    needs: 'biscuit',
    barred: 'Pupcake has wedged himself in the doorway, and growls like a '
        'small kettle when I reach past him. He wants bribing.',
    action: 'Offer the biscuit',
    junk: [
      Junk(
        'Blanket',
        "A tartan blanket, thick with sprinkles. He sheds.",
        icon: Icons.bed,
      ),
    ],
  ),
];

Nook nookById(String id) => nooks.firstWhere((n) => n.id == id);

/// Tools that can be picked up and carried. Each opens one place in [nooks].
const items = <Item>[
  Item(
    id: 'shovel',
    name: 'Coal Shovel',
    room: 'boiler',
    pos: Offset(655, 285),
    icon: Icons.construction,
    description: "Barry's coal shovel, propped by the bunker. A broad blade "
        "and a long handle: just the thing for turning over loose earth. "
        "Barry watches me take it and says nothing.",
  ),
  Item(
    id: 'lockpicks',
    name: 'Lock Pick Box',
    room: 'storage',
    pos: Offset(720, 418),
    icon: Icons.vpn_key,
    description: "A flat tin behind the dress form, stencilled “Catering "
        "Corps — Larder Entry Kit”. Inside, a tidy row of picks and "
        "tension wrenches. Nothing with a keyhole is safe from me now.",
  ),
  Item(
    id: 'biscuit',
    name: 'Dog Biscuit',
    room: 'pantry',
    pos: Offset(770, 196),
    icon: Icons.cookie,
    color: Color(0xFFFFCC80),
    description: "A bone-shaped shortbread from a jar on the pantry shelf, "
        "labelled “PUPCAKE'S. One a day, however he looks at you.” I know a "
        "bribe when I see one.",
  ),
];

Item itemById(String id) => items.firstWhere((i) => i.id == id);

/// The dog. Half pup, half cupcake.
const pupcake = Person(
  id: 'pupcake',
  name: 'Pupcake',
  role: 'Dog',
  dessert: Dessert.pupcake,
);

/// Where Pupcake's paws are: in his doorway until he has been bribed out of
/// it.
const pupcakeGuarding = Offset(508, 420);
const pupcakeFed = Offset(680, 446);

/// What Churlock makes of the dog.
const pupcakeRemark = Junk(
  'Pupcake',
  "Pupcake. Half pup, half cupcake, and all appetite. He wags his cherry "
      "at me. I suspect he would wag it at a burglar.",
  icon: Icons.pets,
);

/// Things worth a remark that are neither evidence nor furniture.
/// The house cat, who lives in the entrance hall. Half purr, half parfait.
const purrfait = Person(
  id: 'purrfait',
  name: 'Purrfait',
  role: 'Cat',
  dessert: Dessert.purrfait,
);

/// Where Purrfait's paws are.
const purrfaitSpot = Offset(722, 470);

const sights = <Sight>[
  Sight(
    'purrfait',
    'entrance',
    Offset(722, 432),
    Junk(
      'Purrfait',
      "Purrfait, the house cat. Layers of cream and berries, and a look of "
          "perfect contempt. She saw everything last night, and she will "
          "tell me nothing.",
      icon: Icons.pets,
    ),
    size: 84,
  ),
  Sight(
    'catbowl',
    'kitchen',
    Offset(620, 430),
    Junk(
      'Cat Bowl',
      "A glass dish under a card that reads PURRFAIT, filled with tuna "
          "tartlets and a swirl of cream. Untouched. She is making a point.",
      icon: Icons.ramen_dining,
    ),
  ),
  Sight(
    'bowl',
    'backyard',
    Offset(396, 418),
    Junk(
      'Dog Bowl',
      "A sugar bowl with DOG painted on the side, heaped with Kibbles and "
          "Sprinkles. Somebody in this house spoils him.",
      icon: Icons.ramen_dining,
    ),
  ),
];
