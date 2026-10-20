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
    wall: Color(0xFF8D7458),
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
  // Under the ground beside the porch
  Room(
    id: 'rootcellar',
    name: 'Tornado Shelter',
    level: 0,
    col: 0,
    wall: _earth,
    floor: _earthFloor,
  ),
  // Up the farmhouse stairs
  Room(
    id: 'lollyroom',
    name: "Lolly's Room",
    level: 3,
    col: -1,
    wall: Color(0xFFE8A0BF),
    floor: _plankFloor,
  ),
  Room(
    id: 'kernelroom',
    name: "Farmer Kernel's Room",
    level: 3,
    col: 0,
    wall: Color(0xFF9C7A54),
    floor: _plankFloor,
  ),
];

/// Where each place leads. The lane runs left and right; the buildings
/// are up through their doors, the bedrooms up the farmhouse stairs, and
/// the tornado shelter down through its doors at the side of the porch.
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
  ('porch', Dir.down): 'rootcellar',
  ('rootcellar', Dir.up): 'porch',
  ('frontroom', Dir.up): 'kernelroom',
  ('kernelroom', Dir.down): 'frontroom',
  ('kernelroom', Dir.left): 'lollyroom',
  ('lollyroom', Dir.right): 'kernelroom',
  ('pasture', Dir.up): 'barn',
  ('barn', Dir.down): 'pasture',
  ('barn', Dir.right): 'pressroom',
  ('pressroom', Dir.left): 'barn',
};

/// The doors drawn in each place, by the way they lead.
const farmDoors = <(String, Dir), Rect>{
  ('orchard', Dir.up): Rect.fromLTWH(740, 190, 90, 180),
  ('greenhouse', Dir.down): Rect.fromLTWH(20, 130, 100, 220),
  ('porch', Dir.up): Rect.fromLTWH(330, 110, 120, 240),
  ('porch', Dir.down): Rect.fromLTWH(752, 400, 176, 64),
  ('frontroom', Dir.down): Rect.fromLTWH(680, 120, 80, 230),
  ('frontroom', Dir.up): Rect.fromLTWH(400, 60, 170, 290),
  ('kernelroom', Dir.down): Rect.fromLTWH(390, 410, 180, 70),
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
    Offset(200, 450),
    Offset(510, 200),
    Offset(245, 300),
    Offset(497, 312),
    Offset(300, 368),
    Offset(560, 450),
    Offset(800, 300),
    Offset(690, 470),
  ],
  'frontroom': [
    Offset(128, 130),
    Offset(250, 378),
    Offset(625, 345),
    Offset(812, 292),
    Offset(290, 215),
    Offset(140, 410),
    Offset(812, 445),
    Offset(420, 450),
  ],
  'fkitchen': [
    Offset(330, 150),
    Offset(560, 290),
    Offset(200, 192),
    Offset(810, 128),
    Offset(690, 290),
    Offset(560, 450),
    Offset(370, 392),
  ],
  'office': [
    Offset(470, 300),
    Offset(200, 252),
    Offset(585, 300),
    Offset(760, 196),
    Offset(335, 362),
    Offset(400, 450),
    Offset(820, 430),
  ],
  'lollyroom': [
    Offset(620, 236),
    Offset(340, 440),
    Offset(470, 232),
    Offset(700, 440),
    Offset(560, 452),
    Offset(190, 320),
  ],
  'kernelroom': [
    Offset(905, 262),
    Offset(110, 262),
    Offset(700, 330),
    Offset(265, 210),
    Offset(660, 462),
    Offset(200, 450),
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
    Offset(740, 460),
    Offset(585, 470),
  ],
  'farmyard': [
    Offset(120, 420),
    Offset(330, 400),
    Offset(620, 470),
    Offset(560, 330),
    Offset(860, 440),
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
    Offset(880, 470),
  ],
};

/// The deed on the porch pegs gives away the year, which is not the dial's
/// combination, but is something to read.
String farmCertificate(String year) =>
    "A framed deed behind the coats: “Kernel Family Farm. First candy corn "
    "planted $year.” The frame has been polished more than anything else "
    "on the porch.";

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
    pos: Offset(245, 210),
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
    name: 'Pie Safe',
    room: 'fkitchen',
    pos: Offset(810, 250),
    icon: Icons.kitchen,
    blurb:
        'A tall cupboard with punched-tin doors, to keep the flies off the '
        'pies. Jars of everything, labelled in a round, careful hand.',
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
    name: 'Escape Tunnel',
    room: 'rootcellar',
    pos: Offset(600, 318),
    icon: Icons.dark_mode,
    blurb:
        "The shelter's back way out: a low tin culvert, pitch black, "
        'running off under the yard.',
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
    room: 'lollyroom',
    pos: Offset(620, 330),
    icon: Icons.face_retouching_natural,
    blurb:
        'A dressing table in the corner of her room, with a looking glass '
        'ringed in light bulbs, like a dressing room in Candy City.',
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
    room: 'kernelroom',
    pos: Offset(905, 330),
    icon: Icons.inventory_2,
    blurb:
        'A black tin deed box on the shelf of his bedside table, where he '
        'kept what mattered.',
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
    id: 'suitcase',
    name: 'Packed Suitcase',
    room: 'lollyroom',
    pos: Offset(790, 420),
    icon: Icons.luggage,
    blurb:
        'A pink suitcase, packed to bursting, by the door. It has a little '
        'brass padlock on it.',
    needs: 'boltcutters',
    barred:
        'Padlocked. Somebody did not want anybody looking inside, and I '
        'would very much like to. Something to cut the lock would do.',
    action: 'Cut the padlock',
    junk: [
      Junk(
        'Sequins',
        "Three dresses with more sequins than dress, and a hat with a "
            "whole candy apple on it.",
        icon: Icons.checkroom,
      ),
    ],
  ),
  Nook(
    id: 'blanketchest',
    name: 'Blanket Chest',
    room: 'kernelroom',
    pos: Offset(260, 390),
    icon: Icons.inventory,
    blurb:
        'An old pine chest at the foot of the wall, with a rusted hasp '
        'hammered shut.',
    needs: 'prybar',
    barred:
        'The hasp has rusted solid. My fingers are pastry. I want '
        'something to pry it with.',
    action: 'Pry it open',
    junk: [
      Junk(
        'Quilts',
        "Patchwork quilts, each square cut from a sack of seed corn. "
            "Somebody very patient made these.",
        icon: Icons.bed,
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
    id: 'prybar',
    name: 'Pry Bar',
    room: 'farmyard',
    pos: Offset(750, 318),
    icon: Icons.hardware,
    color: Color(0xFF90A4AE),
    description:
        "A pry bar, left in the woodpile for splitting kindling. Just the "
        "thing for a hasp that does not want to open.",
  ),
  Item(
    id: 'boltcutters',
    name: 'Bolt Cutters',
    room: 'greenhouse',
    pos: Offset(660, 240),
    icon: Icons.content_cut,
    color: Color(0xFFEF9A9A),
    description:
        "The Professor's bolt cutters, for the wire on his plant frames. "
        "They would make short work of a little padlock.",
  ),
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
    feet: Offset(440, 470),
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
    Offset(285, 250),
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
  'frontroom': Rect.fromLTWH(230, 90, 120, 110),
  'fkitchen': Rect.fromLTWH(540, 60, 130, 110),
  'office': Rect.fromLTWH(820, 90, 110, 120),
  'lollyroom': Rect.fromLTWH(760, 70, 120, 110),
  'kernelroom': Rect.fromLTWH(430, 70, 110, 110),
  'barn': Rect.fromLTWH(760, 70, 120, 80),
  // The greenhouse is glass all round, down to the floor.
  'greenhouse': Rect.fromLTWH(0, 0, 960, 350),
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
        "Farmer Cornelius Kernel has been found dead in his own tornado "
        "shelter. Five others live on the farm. One of them did it. Or two "
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
        "When I am certain, I return to the front porch, and declare the "
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
      'dead in his own tornado shelter. Five desserts live on the farm. '
      'Search the fields, the farmhouse and the barn, question the farmhands '
      '— and name the killer, or killers, before the next harvest.',
  accuseQuestion: 'Who murdered Farmer Kernel?',
  place: 'Candy Land',
  rooms: farmRooms,
  start: 'porch',
  leftStairs: {'rootcellar'},
  outdoors: {'orchard', 'cornfield', 'porch', 'farmyard', 'pasture'},
  outbuildings: {'barn', 'pressroom', 'greenhouse'},
  links: farmLinks,
  atticLevel: 3,
  levelNames: ['Underground', 'Outside', 'Indoors', 'Upstairs'],
  residents: farmResidents,
  police: farmPolice,
  placements: farmPlacements,
  slots: farmSlots,
  nooks: farmNooks,
  items: farmItems,
  sights: farmSights,
  pets: farmPets,
  doors: farmDoors,
  openings: {('frontroom', Dir.up), ('kernelroom', Dir.down)},
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
  // Maple syrup: brown, and nothing but brown.
  rain: [Color(0xFF7B4A1E)],
  splash: Color(0xFF8D5A2B),
);
