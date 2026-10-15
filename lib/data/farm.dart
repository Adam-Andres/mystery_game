import 'package:flutter/material.dart';

import 'farm_cases.dart';
import 'house.dart';
import 'models.dart';

// The Candy Corn Caper: the Kernel family's candy corn farm, in Candy Land.

const _plank = Color(0xFFC9A46A);
const _plankFloor = Color(0xFF8A6238);
const _earth = Color(0xFF5E5145);
const _earthFloor = Color(0xFF433A30);
const _loft = Color(0xFFB98D5A);

const farmRooms = <Room>[
  // Upstairs
  Room(id: 'lollyroom', name: "Lolly's Room", level: 2, col: 0, wall: Color(0xFFE7A9C4), floor: _plankFloor),
  Room(id: 'marsharoom', name: "Marsha's Room", level: 2, col: 1, wall: Color(0xFFD9CDE8), floor: _plankFloor),
  Room(id: 'upstairs', name: 'Upstairs Landing', level: 2, col: 2, wall: _loft, floor: _plankFloor),
  Room(id: 'farmerroom', name: "Farmer Kernel's Room", level: 2, col: 3, wall: Color(0xFF9AB27A), floor: _plankFloor),
  Room(id: 'profroom', name: "The Professor's Room", level: 2, col: 4, wall: Color(0xFF6E6A8A), floor: _plankFloor),
  // Ground floor, the field beyond the kitchen and the barn beyond the office
  Room(id: 'cornfield', name: 'Candy Corn Field', level: 1, col: -1, wall: Color(0xFF2B2A3A), floor: Color(0xFF6B4E2A)),
  Room(id: 'fkitchen', name: 'Farmhouse Kitchen', level: 1, col: 0, wall: Color(0xFFF0D9A0), floor: _plankFloor),
  Room(id: 'frontroom', name: 'Front Room', level: 1, col: 1, wall: Color(0xFFB5603A), floor: _plankFloor),
  Room(id: 'fhall', name: 'Front Hall', level: 1, col: 2, wall: _plank, floor: _plankFloor),
  Room(id: 'office', name: 'Farm Office', level: 1, col: 3, wall: Color(0xFF6F7F5C), floor: _plankFloor),
  Room(id: 'barn', name: 'The Barn', level: 1, col: 4, wall: Color(0xFF9E3A2E), floor: Color(0xFF7A5A34)),
  // Below
  Room(id: 'bunk', name: "Taffy's Bunkroom", level: 0, col: 1, wall: _earth, floor: _earthFloor),
  Room(id: 'rootcellar', name: 'Root Cellar', level: 0, col: 2, wall: _earth, floor: _earthFloor),
  Room(id: 'pressroom', name: 'Syrup Press Room', level: 0, col: 3, wall: _earth, floor: _earthFloor),
];

const farmDoors = <(String, Dir), Rect>{
  ('fkitchen', Dir.left): Rect.fromLTWH(4, 120, 62, 230),
  ('cornfield', Dir.right): Rect.fromLTWH(826, 176, 96, 244),
  ('office', Dir.right): Rect.fromLTWH(892, 130, 64, 220),
};

const farmResidents = <Person>[
  Person(
    id: 'lolly',
    name: 'Lolly Popwell',
    role: "The farmer's daughter",
    dessert: Dessert.lollipop,
    greeting: "Oh, a real detective! Daddy would have hated this. He hated "
        "anything from the city.",
  ),
  Person(
    id: 'taffy',
    name: 'Taffy Pulman',
    role: 'Farmhand',
    dessert: Dessert.taffy,
    greeting: "Evenin'. Mornin'. Whatever it is. I've been up since four "
        "pullin' taffy.",
  ),
  Person(
    id: 'gus',
    name: 'Gus Gumdrop',
    role: 'Foreman',
    dessert: Dessert.gumdrop,
    greeting: "Twenty-two years I've worked this farm, Detective. Ask me "
        "what you like.",
  ),
  Person(
    id: 'marsha',
    name: 'Marsha Mallow',
    role: 'Cook',
    dessert: Dessert.marshmallow,
    greeting: "Oh! Oh my. Sit down, have a scone. I'm all puffed up and I "
        "can't stop baking.",
  ),
  Person(
    id: 'licorice',
    name: 'Professor Rex Licorice',
    role: 'Agricultural scientist & lodger',
    dessert: Dessert.licorice,
    greeting: "Professor Licorice, Candy City University. I study the corn. "
        "I am told that is suspicious.",
  ),
];

const farmPolice = <Person>[
  Person(
    id: 'butterscotch',
    name: 'Sheriff Butterscotch',
    role: 'Candy Land Constabulary',
    dessert: Dessert.butterscotch,
    greeting: "Churlock. They told me you'd come all the way from Donut "
        "County. Mind the corn on the stairs.",
  ),
  Person(
    id: 'jellybean',
    name: 'Deputy Jellybean',
    role: 'Candy Land Constabulary',
    dessert: Dessert.jellybean,
    greeting: "Deputy Jellybean, sir! First murder. I've been very careful "
        "not to touch anything. Mostly.",
  ),
];

/// Who stands where: room id -> (person id, x of their centre).
const farmPlacements = <String, List<(String, double)>>{
  'fkitchen': [('marsha', 760)],
  'frontroom': [('lolly', 720)],
  'office': [('licorice', 700)],
  'barn': [('gus', 720)],
  'pressroom': [('taffy', 740)],
  'rootcellar': [('butterscotch', 690), ('jellybean', 835)],
};

/// Where evidence can sit in each room, in scene coordinates.
const farmSlots = <String, List<Offset>>{
  'fhall': [Offset(440, 426), Offset(170, 150), Offset(326, 215), Offset(480, 300), Offset(600, 430), Offset(372, 498)],
  'frontroom': [Offset(550, 145), Offset(225, 395), Offset(375, 352), Offset(760, 170), Offset(165, 165), Offset(225, 330)],
  'fkitchen': [Offset(330, 150), Offset(560, 222), Offset(155, 285), Offset(830, 150), Offset(320, 300), Offset(660, 430)],
  'office': [Offset(470, 300), Offset(275, 200), Offset(640, 300), Offset(765, 165), Offset(250, 330), Offset(400, 440)],
  'barn': [Offset(350, 300), Offset(760, 260), Offset(540, 440), Offset(260, 240), Offset(880, 240)],
  'cornfield': [Offset(380, 330), Offset(200, 470), Offset(130, 400), Offset(872, 330), Offset(585, 470)],
  'rootcellar': [Offset(395, 452), Offset(200, 480), Offset(565, 425), Offset(430, 290), Offset(805, 230), Offset(600, 300)],
  'bunk': [Offset(330, 300), Offset(640, 300), Offset(160, 200), Offset(480, 350), Offset(560, 450)],
  'pressroom': [Offset(240, 455), Offset(600, 240), Offset(530, 440), Offset(880, 270), Offset(670, 110)],
  'upstairs': [Offset(640, 296), Offset(290, 200), Offset(835, 360), Offset(480, 222), Offset(220, 440), Offset(560, 392)],
  'lollyroom': [Offset(430, 372), Offset(268, 312), Offset(855, 215), Offset(700, 330), Offset(185, 170)],
  'marsharoom': [Offset(250, 215), Offset(560, 392), Offset(450, 300), Offset(160, 440), Offset(640, 300)],
  'farmerroom': [Offset(280, 286), Offset(730, 282), Offset(500, 250), Offset(165, 300), Offset(560, 440)],
  'profroom': [Offset(215, 438), Offset(470, 296), Offset(645, 228), Offset(330, 200), Offset(880, 430)],
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
    room: 'fhall',
    pos: Offset(326, 215),
    icon: Icons.checkroom,
    blurb: 'Oilskins, a sou\'wester, and whatever has been hung behind them.',
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
    id: 'sideboard',
    name: 'Sideboard',
    room: 'frontroom',
    pos: Offset(860, 290),
    icon: Icons.table_bar,
    blurb: 'A long sideboard covered in county fair trophies.',
    junk: [
      Junk(
        'Trophies',
        "First prize for candy corn, nineteen years running. One year is "
            "missing. A small card in its place reads: “Hail.”",
        icon: Icons.emoji_events,
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
    blurb: 'The loft over the stalls, where Gus sleeps when he works late. '
        'The ladder has been taken down.',
    needs: 'ladder',
    barred: 'The loft is twelve feet up and somebody has taken the ladder '
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
    blurb: 'One furrow at the edge of the field has been dug over lately, '
        'and patted flat again.',
    needs: 'trowel',
    barred: 'Somebody has dug here and filled it in again. I am not '
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
    blurb: 'A low black gap behind the potato racks, running under the '
        'front room.',
    needs: 'lantern',
    barred: 'It is pitch dark in there, and I am not putting my hand into '
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
    room: 'bunk',
    pos: Offset(480, 350),
    icon: Icons.inventory_2,
    blurb: 'A tin footlocker at the end of the lower bunk.',
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
    name: "Lolly's Vanity",
    room: 'lollyroom',
    pos: Offset(850, 290),
    icon: Icons.face_retouching_natural,
    blurb: 'A vanity table with a looking glass ringed in light bulbs.',
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
    room: 'marsharoom',
    pos: Offset(560, 392),
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
    name: "Farmer's Nightstand",
    room: 'farmerroom',
    pos: Offset(280, 372),
    icon: Icons.nightlight,
    blurb: 'A plain pine nightstand, with a candle and a Bible on top.',
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
    room: 'profroom',
    pos: Offset(790, 230),
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
    description: "A trowel hanging by the barn door, its handle worn to the "
        "shape of Gus's hand. Just the thing for turning over a furrow.",
  ),
  Item(
    id: 'lantern',
    name: 'Storm Lantern',
    room: 'bunk',
    pos: Offset(760, 200),
    icon: Icons.light,
    color: Color(0xFFFFE082),
    description: "Taffy's storm lantern, from the hook by his bunk. Full of "
        "oil, and the wick trimmed. I can see into any dark corner now.",
  ),
  Item(
    id: 'ladder',
    name: 'Orchard Ladder',
    room: 'cornfield',
    pos: Offset(700, 300),
    icon: Icons.stairs,
    color: Color(0xFFFFCC80),
    description: "A tall orchard ladder, left lying in the corn where "
        "nobody would think to look. It belongs in the barn.",
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
    room: 'cornfield',
    feet: Offset(470, 470),
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
    'windmill',
    'cornfield',
    Offset(640, 150),
    Junk(
      'Windmill',
      "The farm's windmill, turning in the syrup rain. It drives the pump, "
          "and a belt runs from it to the press room. It never stops.",
      icon: Icons.wind_power,
    ),
  ),
];

const farmWindows = <String, Rect>{
  'frontroom': Rect.fromLTWH(90, 90, 150, 150),
  'fkitchen': Rect.fromLTWH(540, 60, 130, 110),
  'office': Rect.fromLTWH(700, 100, 130, 130),
  'upstairs': Rect.fromLTWH(422, 82, 116, 116),
  'lollyroom': Rect.fromLTWH(130, 110, 110, 120),
  'marsharoom': Rect.fromLTWH(420, 90, 110, 110),
  'farmerroom': Rect.fromLTWH(105, 100, 120, 130),
  'profroom': Rect.fromLTWH(600, 95, 90, 120),
  'barn': Rect.fromLTWH(110, 90, 120, 90),
};

const farmIntroLines = <VoiceLine>[
  (
    voice: narrator,
    text: "Far from Donut County, where the candy corn grows taller than a "
        "house, a warm syrup rain has fallen all night on the Kernel "
        "family farm. At dawn, the sheriff sent for Detective Churlock.",
  ),
  (
    voice: narrator,
    text: "Farmer Cornelius Kernel has been found dead in his own root "
        "cellar. Five others live on the farm. One of them did it. Or two "
        "of them, together.",
  ),
  (
    voice: 'churlock',
    text: "A long way from home, Watsonut, and a long way from the "
        "pavement. Everybody here has a motive, and nobody will confess. "
        "I shall search every room and every stall.",
  ),
  (
    voice: 'churlock',
    text: "When I am certain, I return to the front hall, and declare the "
        "case solved.",
  ),
];

const farmWinLines = <VoiceLine>[
  (
    voice: narrator,
    text: "The syrup rain has stopped at last. The sheriff's wagon rolls "
        "away down the farm track, between the rows of corn, and this time "
        "the right dessert is inside it.",
  ),
  (
    voice: narrator,
    text: "The case is closed. Candy Land can sleep soundly again, thanks "
        "to Detective Churlock.",
  ),
  (voice: 'churlock', text: "Corn-gratulations are in order, Watsonut."),
];

const farmLoseAgainLines = <VoiceLine>[
  (
    voice: narrator,
    text: "The sheriff's wagon rattles away through the syrup rain, with an "
        "innocent dessert behind its bars.",
  ),
  (
    voice: narrator,
    text: "And on the Kernel farm, a killer is still free. By the next "
        "harvest, there will be another outline in the corn.",
  ),
  (voice: 'churlock', text: "I have made a terrible mistake."),
];

const farmLoseHalfLines = <VoiceLine>[
  (
    voice: narrator,
    text: "The sheriff's wagon rattles away through the syrup rain. The "
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
      'name the killer, or killers, before the next harvest.',
  accuseQuestion: 'Who murdered Farmer Kernel?',
  place: 'Candy Land',
  rooms: farmRooms,
  start: 'fhall',
  leftStairs: {'rootcellar'},
  outdoors: {'cornfield'},
  outbuildings: {'barn'},
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
