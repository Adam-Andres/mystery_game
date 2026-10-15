import 'package:flutter/material.dart';

import 'farm_cases.dart';
import 'house.dart';
import 'models.dart';

// The Candy Corn Caper: the Kernel family's candy corn farm, in Candy Land.

const _plankFloor = Color(0xFF8A6238);
const _earth = Color(0xFF5E5145);
const _earthFloor = Color(0xFF433A30);
const _loft = Color(0xFFB98D5A);

const farmRooms = <Room>[
  // Buildings, each entered through a door from the lane below it
  Room(
    id: 'greenhouse',
    name: 'Greenhouse',
    level: 2,
    col: -2,
    wall: Color(0xFF7FA88A),
    floor: Color(0xFF5E4A36),
  ),
  Room(
    id: 'fkitchen',
    name: 'Farmhouse Kitchen',
    level: 2,
    col: -1,
    wall: Color(0xFFF0D9A0),
    floor: _plankFloor,
  ),
  Room(
    id: 'frontroom',
    name: 'Front Room',
    level: 2,
    col: 0,
    wall: Color(0xFFB5603A),
    floor: _plankFloor,
  ),
  Room(
    id: 'office',
    name: 'Farm Office',
    level: 2,
    col: 1,
    wall: Color(0xFF6F7F5C),
    floor: _plankFloor,
  ),
  Room(
    id: 'barn',
    name: 'The Barn',
    level: 2,
    col: 2,
    wall: Color(0xFF9E3A2E),
    floor: Color(0xFF7A5A34),
  ),
  Room(
    id: 'pressroom',
    name: 'Press Shed',
    level: 2,
    col: 3,
    wall: _loft,
    floor: Color(0xFF6B4E2A),
  ),
  // The farm lane, out of doors
  Room(
    id: 'orchard',
    name: 'Orchard',
    level: 1,
    col: -2,
    wall: Color(0xFF2B2A3A),
    floor: Color(0xFF4F6A3C),
  ),
  Room(
    id: 'cornfield',
    name: 'Candy Corn Field',
    level: 1,
    col: -1,
    wall: Color(0xFF2B2A3A),
    floor: Color(0xFF6B4E2A),
  ),
  Room(
    id: 'porch',
    name: 'Front Porch',
    level: 1,
    col: 0,
    wall: Color(0xFF2B2A3A),
    floor: _plankFloor,
  ),
  Room(
    id: 'farmyard',
    name: 'Farmyard',
    level: 1,
    col: 1,
    wall: Color(0xFF2B2A3A),
    floor: Color(0xFF7A5E3A),
  ),
  Room(
    id: 'pasture',
    name: 'Pasture',
    level: 1,
    col: 2,
    wall: Color(0xFF2B2A3A),
    floor: Color(0xFF4F6A3C),
  ),
  // Below the farmyard
  Room(
    id: 'rootcellar',
    name: 'Root Cellar',
    level: 0,
    col: 1,
    wall: _earth,
    floor: _earthFloor,
  ),
];

/// Where each place leads. The lane runs left and right; the buildings
/// are up through their doors, and the root cellar down through the storm
/// doors in the farmyard.
const farmLinks = <(String, Dir), String>{
  ('orchard', Dir.right): 'cornfield',
  ('cornfield', Dir.left): 'orchard',
  ('cornfield', Dir.right): 'porch',
  ('porch', Dir.left): 'cornfield',
  ('porch', Dir.right): 'farmyard',
  ('farmyard', Dir.left): 'porch',
  ('farmyard', Dir.right): 'pasture',
  ('pasture', Dir.left): 'farmyard',
  ('orchard', Dir.up): 'greenhouse',
  ('greenhouse', Dir.down): 'orchard',
  ('porch', Dir.up): 'frontroom',
  ('frontroom', Dir.down): 'porch',
  ('frontroom', Dir.left): 'fkitchen',
  ('fkitchen', Dir.right): 'frontroom',
  ('frontroom', Dir.right): 'office',
  ('office', Dir.left): 'frontroom',
  ('farmyard', Dir.down): 'rootcellar',
  ('rootcellar', Dir.up): 'farmyard',
  ('pasture', Dir.up): 'barn',
  ('barn', Dir.down): 'pasture',
  ('barn', Dir.right): 'pressroom',
  ('pressroom', Dir.left): 'barn',
};

/// The doors drawn in each place, by the way they lead.
const farmDoors = <(String, Dir), Rect>{
  ('orchard', Dir.up): Rect.fromLTWH(740, 190, 90, 180),
  ('greenhouse', Dir.down): Rect.fromLTWH(20, 130, 100, 220),
  ('porch', Dir.up): Rect.fromLTWH(420, 110, 120, 240),
  ('frontroom', Dir.down): Rect.fromLTWH(630, 120, 80, 230),
  ('farmyard', Dir.down): Rect.fromLTWH(400, 432, 160, 56),
  ('pasture', Dir.up): Rect.fromLTWH(130, 150, 140, 210),
  ('barn', Dir.down): Rect.fromLTWH(20, 130, 110, 220),
  ('barn', Dir.right): Rect.fromLTWH(892, 130, 64, 220),
  ('pressroom', Dir.left): Rect.fromLTWH(4, 120, 62, 230),
};

const farmResidents = <Person>[
  Person(
    id: 'lolly',
    name: 'Lolly Popwell',
    role: "The farmer's daughter",
    dessert: Dessert.lollipop,
    greeting:
        "Oh, a real detective! Daddy would have hated this. He hated "
        "anything from the city.",
  ),
  Person(
    id: 'taffy',
    name: 'Taffy Pulman',
    role: 'Farmhand',
    dessert: Dessert.taffy,
    greeting:
        "Evenin'. Mornin'. Whatever it is. I've been up since four "
        "pullin' taffy.",
  ),
  Person(
    id: 'gus',
    name: 'Gus Gumdrop',
    role: 'Foreman',
    dessert: Dessert.gumdrop,
    greeting:
        "Twenty-two years I've worked this farm, Detective. Ask me "
        "what you like.",
  ),
  Person(
    id: 'marsha',
    name: 'Marsha Mallow',
    role: 'Cook',
    dessert: Dessert.marshmallow,
    greeting:
        "Oh! Oh my. Sit down, have a scone. I'm all puffed up and I "
        "can't stop baking.",
  ),
  Person(
    id: 'licorice',
    name: 'Professor Rex Licorice',
    role: 'Agricultural scientist & lodger',
    dessert: Dessert.licorice,
    greeting:
        "Professor Licorice, Candy City University. I study the corn. "
        "I am told that is suspicious.",
  ),
];

const farmPolice = <Person>[
  Person(
    id: 'butterscotch',
    name: 'Sheriff Butterscotch',
    role: 'Candy Land Constabulary',
    dessert: Dessert.butterscotch,
    greeting:
        "Churlock. They told me you'd come all the way from Donut "
        "County. Mind the corn on the stairs.",
  ),
  Person(
    id: 'jellybean',
    name: 'Deputy Jellybean',
    role: 'Candy Land Constabulary',
    dessert: Dessert.jellybean,
    greeting:
        "Deputy Jellybean, sir! First murder. I've been very careful "
        "not to touch anything. Mostly.",
  ),
];

/// Who stands where: room id -> (person id, x of their centre).
const farmPlacements = <String, List<(String, double)>>{
  'fkitchen': [('marsha', 760)],
  'frontroom': [('lolly', 830)],
  'greenhouse': [('licorice', 640)],
  'barn': [('gus', 720)],
  'pressroom': [('taffy', 740)],
  'rootcellar': [('butterscotch', 690), ('jellybean', 835)],
};

/// Where evidence can sit in each room, in scene coordinates.
const farmSlots = <String, List<Offset>>{
  'porch': [
    Offset(300, 450),
    Offset(600, 190),
    Offset(250, 300),
    Offset(590, 320),
    Offset(640, 360),
    Offset(760, 450),
  ],
  'frontroom': [
    Offset(520, 145),
    Offset(225, 395),
    Offset(375, 352),
    Offset(780, 290),
    Offset(165, 165),
    Offset(225, 330),
    Offset(560, 445),
    Offset(420, 440),
  ],
  'fkitchen': [
    Offset(330, 150),
    Offset(560, 222),
    Offset(155, 285),
    Offset(830, 150),
    Offset(320, 300),
    Offset(660, 430),
    Offset(640, 300),
  ],
  'office': [
    Offset(470, 300),
    Offset(275, 200),
    Offset(640, 300),
    Offset(765, 165),
    Offset(250, 330),
    Offset(400, 440),
    Offset(820, 420),
  ],
  'barn': [
    Offset(350, 300),
    Offset(760, 260),
    Offset(540, 440),
    Offset(260, 240),
    Offset(840, 430),
    Offset(460, 262),
  ],
  'pressroom': [
    Offset(240, 455),
    Offset(600, 240),
    Offset(530, 440),
    Offset(665, 290),
    Offset(560, 118),
    Offset(850, 180),
  ],
  'greenhouse': [
    Offset(215, 438),
    Offset(470, 296),
    Offset(560, 160),
    Offset(330, 200),
    Offset(880, 430),
  ],
  'orchard': [
    Offset(420, 330),
    Offset(200, 470),
    Offset(560, 440),
    Offset(130, 380),
    Offset(600, 300),
  ],
  'cornfield': [
    Offset(380, 330),
    Offset(200, 470),
    Offset(130, 400),
    Offset(872, 330),
    Offset(585, 470),
  ],
  'farmyard': [
    Offset(180, 300),
    Offset(330, 400),
    Offset(620, 470),
    Offset(760, 330),
    Offset(880, 440),
  ],
  'pasture': [
    Offset(400, 330),
    Offset(600, 460),
    Offset(860, 400),
    Offset(700, 300),
    Offset(330, 470),
  ],
  'rootcellar': [
    Offset(395, 452),
    Offset(200, 480),
    Offset(565, 425),
    Offset(430, 290),
    Offset(805, 230),
    Offset(600, 300),
  ],
};

/// The deed on the hall pegs gives away the year, which is not the dial's
/// combination, but is something to read.
String farmCertificate(String year) =>
    "A framed deed behind the coats: “Kernel Family Farm. First candy corn "
    "planted $year.” The frame has been polished more than anything else "
    "in the hall.";

const farmLooseCorner = Junk(
  'Hidden keepsakes',
  "A tobacco tin, tucked in a little compartment behind the lining. A "
      "prize ribbon from the county fair, two buttons, and a lock of yellow "
      "hair. His keepsakes. Dear to him, and nothing to do with last night.",
  icon: Icons.inventory_2,
);

/// Furniture that can be searched. What evidence each holds depends on the
/// mystery; the odds and ends are always there.
const farmNooks = <Nook>[
  Nook(
    id: 'coatpegs',
    name: 'Coat Pegs',
    room: 'porch',
    pos: Offset(320, 210),
    icon: Icons.checkroom,
    blurb:
        'Pegs by the front door, hung with oilskins and whatever has '
        'been hung behind them.',
    junk: [
      Junk('Framed deed', '', icon: Icons.workspace_premium),
      Junk(
        'Oilskins',
        "Six oilskins, and every one of them still dripping syrup. Every "
            "body on this farm was out in the rain at some point last night.",
        icon: Icons.umbrella,
      ),
    ],
  ),
  Nook(
    id: 'pantryshelf',
    name: 'Pantry Shelves',
    room: 'fkitchen',
    pos: Offset(830, 230),
    icon: Icons.kitchen,
    blurb: 'Jars of everything, labelled in a round, careful hand.',
    junk: [
      Junk(
        'Jam jars',
        "Sixty jars of preserves, each with a date and a little drawing of "
            "what is inside. Marsha draws a very good gooseberry.",
        icon: Icons.local_drink,
      ),
    ],
  ),
  Nook(
    id: 'rolltop',
    name: 'Rolltop Desk',
    room: 'office',
    pos: Offset(560, 360),
    icon: Icons.lock,
    blurb: "Farmer Kernel kept the farm's papers here, under a dial lock.",
    locked: true,
    junk: [
      Junk(
        'Seed catalogues',
        "Forty years of seed catalogues, with every candy corn in them "
            "crossed out and “MINE IS BETTER” written beside it.",
        icon: Icons.menu_book,
      ),
    ],
  ),
  Nook(
    id: 'feedbin',
    name: 'Feed Bin',
    room: 'barn',
    pos: Offset(250, 380),
    icon: Icons.inventory,
    blurb: 'A great wooden bin of cow cake and sugar beet.',
    junk: [
      Junk(
        'Cow cake',
        "Cow cake. Even the cows here eat dessert.",
        icon: Icons.grass,
      ),
    ],
  ),
  Nook(
    id: 'hayloft',
    name: 'Hay Loft',
    room: 'barn',
    pos: Offset(470, 150),
    icon: Icons.height,
    blurb:
        'The loft over the stalls, where Gus sleeps when he works late. '
        'The ladder has been taken down.',
    needs: 'ladder',
    barred:
        'The loft is twelve feet up and somebody has taken the ladder '
        'away. I am a churro, not a squirrel.',
    action: 'Put up the ladder',
    junk: [
      Junk(
        'Bedroll',
        "Gus's bedroll, and a candle stub in a saucer. The stub is cold "
            "and the bedroll is still rolled.",
        icon: Icons.bed,
      ),
    ],
  ),
  Nook(
    id: 'furrow',
    name: 'Turned Furrow',
    room: 'cornfield',
    pos: Offset(292, 452),
    icon: Icons.landscape,
    blurb:
        'One furrow at the edge of the field has been dug over lately, '
        'and patted flat again.',
    needs: 'trowel',
    barred:
        'Somebody has dug here and filled it in again. I am not '
        'scrabbling in the syrup with my hands. I want a trowel.',
    action: 'Dig',
    junk: [
      Junk(
        'Seed corn',
        "Seed corn, planted in a neat row a little too deep. Somebody "
            "wanted it to look as though they had been planting.",
        icon: Icons.grain,
      ),
    ],
  ),
  Nook(
    id: 'crawlspace',
    name: 'Crawlspace',
    room: 'rootcellar',
    pos: Offset(600, 318),
    icon: Icons.dark_mode,
    blurb:
        'A low black gap behind the potato racks, running under the '
        'farmyard.',
    needs: 'lantern',
    barred:
        'It is pitch dark in there, and I am not putting my hand into '
        'the dark in a house with a murderer in it. I want a light.',
    action: 'Shine the lantern in',
    junk: [
      Junk(
        'Spiders',
        "Spiders, a quantity. They are made of liquorice laces, and they "
            "are not pleased to see me.",
        icon: Icons.pest_control,
      ),
    ],
  ),
  Nook(
    id: 'footlocker',
    name: "Taffy's Footlocker",
    room: 'pressroom',
    pos: Offset(880, 400),
    icon: Icons.inventory_2,
    blurb: 'A tin footlocker at the end of the bunk in the press shed.',
    junk: [
      Junk(
        'Spare shirts',
        "Three shirts, all stretched to twice their proper length. Taffy "
            "pulls in his sleep.",
        icon: Icons.dry_cleaning,
      ),
    ],
  ),
  Nook(
    id: 'vat',
    name: 'Syrup Vat',
    room: 'pressroom',
    pos: Offset(382, 300),
    icon: Icons.water_drop,
    blurb: 'A copper vat as big as a bath, half full of cooling syrup.',
    junk: [
      Junk(
        'Syrup',
        "Syrup. A very great deal of it, and now some of it on my sleeve.",
        icon: Icons.water_drop,
      ),
    ],
  ),
  Nook(
    id: 'vanity',
    name: "Lolly's Dressing Table",
    room: 'frontroom',
    pos: Offset(900, 330),
    icon: Icons.face_retouching_natural,
    blurb:
        'A dressing table in the corner of the front room, with a '
        'looking glass ringed in light bulbs.',
    junk: [
      Junk(
        'Song sheets',
        "Sheet music for a song called “Sweet on the City”, with all the "
            "high notes underlined twice.",
        icon: Icons.music_note,
      ),
    ],
  ),
  Nook(
    id: 'recipebox',
    name: 'Recipe Box',
    room: 'fkitchen',
    pos: Offset(430, 300),
    icon: Icons.receipt_long,
    blurb: 'A tin box of recipe cards, worn smooth at the corners.',
    junk: [
      Junk(
        'Recipe cards',
        "Four hundred recipes for scones. Four hundred and one. There is "
            "a new one, still drying.",
        icon: Icons.cookie,
      ),
    ],
  ),
  Nook(
    id: 'nightstand',
    name: 'Deed Box',
    room: 'office',
    pos: Offset(160, 196),
    icon: Icons.inventory_2,
    blurb: 'A black tin deed box on the shelf, where he kept what mattered.',
    junk: [
      Junk(
        'Almanac',
        "A farmer's almanac with every frost of forty years marked in "
            "the margin. He kept count of his weather like other men keep "
            "count of their money.",
        icon: Icons.menu_book,
      ),
    ],
  ),
  Nook(
    id: 'specimens',
    name: 'Specimen Cabinet',
    room: 'greenhouse',
    pos: Offset(810, 230),
    icon: Icons.science,
    blurb: 'Rows of little drawers, each holding a different kernel.',
    junk: [
      Junk(
        'Kernels',
        "Candy corn, sorted by stripe. There is a drawer labelled "
            "“Rainbow — failed” and it is very full.",
        icon: Icons.science,
      ),
    ],
  ),
];

/// Tools that can be picked up and carried. Each opens one place.
const farmItems = <Item>[
  Item(
    id: 'trowel',
    name: 'Garden Trowel',
    room: 'barn',
    pos: Offset(630, 300),
    icon: Icons.agriculture,
    description:
        "A trowel hanging by the barn door, its handle worn to the "
        "shape of Gus's hand. Just the thing for turning over a furrow.",
  ),
  Item(
    id: 'lantern',
    name: 'Storm Lantern',
    room: 'pressroom',
    pos: Offset(780, 150),
    icon: Icons.light,
    color: Color(0xFFFFE082),
    description:
        "Taffy's storm lantern, from the hook over his bunk. Full of "
        "oil, and the wick trimmed. I can see into any dark corner now.",
  ),
  Item(
    id: 'ladder',
    name: 'Orchard Ladder',
    room: 'orchard',
    pos: Offset(300, 300),
    icon: Icons.stairs,
    color: Color(0xFFFFCC80),
    description:
        "A tall orchard ladder, leaning in a candy apple tree "
        "where nobody would think to look for it. It belongs in the barn.",
  ),
];

const chicklet = Person(
  id: 'chicklet',
  name: 'Chicklet',
  role: 'Chick',
  dessert: Dessert.chicklet,
);

const chickletRemark = Junk(
  'Chicklet',
  "Chicklet. A sugar-coated chick, about the size of a gumball, who has "
      "decided that I am her mother. I have not the heart to tell her.",
  icon: Icons.egg,
);

const farmPets = <Pet>[
  Pet(
    person: chicklet,
    room: 'farmyard',
    feet: Offset(290, 470),
    width: 54,
    remark: chickletRemark,
    sound: 'cheep',
  ),
];

const farmSights = <Sight>[
  Sight(
    'scarecrow',
    'cornfield',
    Offset(520, 230),
    Junk(
      'Scarecrow',
      "A gingerbread scarecrow in the farmer's old hat. The crows of Candy "
          "Land are made of liquorice, and they are not afraid of him in the "
          "least.",
      icon: Icons.accessibility_new,
    ),
    size: 90,
  ),
  Sight(
    'coop',
    'farmyard',
    Offset(150, 250),
    Junk(
      'Chicken Coop',
      "A coop made of a gingerbread house with the roof left off. Chicklet "
          "is its only tenant, and she keeps it very badly.",
      icon: Icons.house,
    ),
    size: 90,
  ),
  Sight(
    'hive',
    'orchard',
    Offset(150, 330),
    Junk(
      'Beehive',
      "A beehive on a stump. The bees of Candy Land make caramel, and they "
          "are slower about it than one would like.",
      icon: Icons.hive,
    ),
  ),
  Sight(
    'windmill',
    'cornfield',
    Offset(640, 150),
    Junk(
      'Windmill',
      "The farm's windmill, turning in the syrup rain. It drives the pump, "
          "and a belt runs from it to the press shed. It never stops.",
      icon: Icons.wind_power,
    ),
  ),
];

const farmWindows = <String, Rect>{
  'frontroom': Rect.fromLTWH(90, 90, 150, 150),
  'fkitchen': Rect.fromLTWH(540, 60, 130, 110),
  'office': Rect.fromLTWH(700, 100, 130, 130),
  'barn': Rect.fromLTWH(760, 70, 120, 80),
  'pressroom': Rect.fromLTWH(628, 66, 84, 58),
};

const farmIntroLines = <VoiceLine>[
  (
    voice: narrator,
    text:
        "Far from Donut County, where the candy corn grows taller than a "
        "house, a warm syrup rain has fallen all night on the Kernel "
        "family farm. At dawn, the sheriff sent for Detective Churlock.",
  ),
  (
    voice: narrator,
    text:
        "Farmer Cornelius Kernel has been found dead in his own root "
        "cellar. Five others live on the farm. One of them did it. Or two "
        "of them, together.",
  ),
  (
    voice: 'churlock',
    text:
        "A long way from home, Watsonut, and a long way from the "
        "pavement. Everybody here has a motive, and nobody will confess. "
        "I shall search every room and every stall.",
  ),
  (
    voice: 'churlock',
    text:
        "When I am certain, I return to the front hall, and declare the "
        "case solved.",
  ),
];

const farmWinLines = <VoiceLine>[
  (
    voice: narrator,
    text:
        "The syrup rain has stopped at last. The sheriff's wagon rolls "
        "away down the farm track, between the rows of corn, and this time "
        "the right dessert is inside it.",
  ),
  (
    voice: narrator,
    text:
        "The case is closed. Candy Land can sleep soundly again, thanks "
        "to Detective Churlock.",
  ),
  (voice: 'churlock', text: "Corn-gratulations are in order, Watsonut."),
];

const farmLoseAgainLines = <VoiceLine>[
  (
    voice: narrator,
    text:
        "The sheriff's wagon rattles away through the syrup rain, with an "
        "innocent dessert behind its bars.",
  ),
  (
    voice: narrator,
    text:
        "And on the Kernel farm, a killer is still free. By the next "
        "harvest, there will be another outline in the corn.",
  ),
  (voice: 'churlock', text: "I have made a terrible mistake."),
];

const farmLoseHalfLines = <VoiceLine>[
  (
    voice: narrator,
    text:
        "The sheriff's wagon rattles away through the syrup rain. The "
        "killer is inside it. But so is an innocent dessert, who will pay "
        "dearly for the detective's guesswork.",
  ),
  (voice: 'churlock', text: "Half right, I fear, is not right at all."),
];

const farm = World(
  id: 'farm',
  title: 'The Candy Corn Caper',
  blurb:
      'Farmer Kernel, the candy corn king of Candy Land, has been found '
      'dead in his own root cellar. Five desserts live on the farm. Search '
      'the farmhouse, the barn and the field, question the farmhands — and '
      'name the killer, or killers, before the next harvest. Most of it is '
      'out of doors.',
  accuseQuestion: 'Who murdered Farmer Kernel?',
  place: 'Candy Land',
  rooms: farmRooms,
  start: 'porch',
  leftStairs: {'rootcellar'},
  outdoors: {'orchard', 'cornfield', 'porch', 'farmyard', 'pasture'},
  outbuildings: {'barn', 'pressroom', 'greenhouse'},
  links: farmLinks,
  atticLevel: null,
  levelNames: ['Underground', 'Outside', 'Indoors'],
  residents: farmResidents,
  police: farmPolice,
  placements: farmPlacements,
  slots: farmSlots,
  nooks: farmNooks,
  items: farmItems,
  sights: farmSights,
  pets: farmPets,
  doors: farmDoors,
  windows: farmWindows,
  cases: farmCases,
  intro: farmIntroLines,
  win: farmWinLines,
  loseAgain: farmLoseAgainLines,
  loseHalf: farmLoseHalfLines,
  music: 'farm.wav',
  certificate: farmCertificate,
  looseCorner: farmLooseCorner,
  titleColors: [Color(0xFF7A4A12), Color(0xFF1C1206)],
);
