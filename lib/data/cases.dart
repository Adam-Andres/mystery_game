import 'package:flutter/material.dart';

import 'models.dart';

const briefing =
    "The Donut County Police rang at dawn: Mrs. Éclaire Senclair has been found "
    "dead in the cellar of her own house. Five residents were home, and every door "
    "was locked from the inside. One of them did it — or two of them, together.\n\n"
    "I shall explore with the arrows, click anything suspicious, and question "
    "everyone. When I am certain, I return here to the Entrance Hall and press "
    "“I solved the case”.";

const _gold = Color(0xFFFFD54F);

// Evidence and testimony that is the same whoever the killer is.

const _watch = Evidence(
  id: 'watch',
  name: 'Stopped Pocket Watch',
  description:
      "Mrs. Senclair's pocket watch, lying inside the outline and ruined along "
      "with her. The hands stopped at 11:05 PM.",
  room: 'cellar',
  pos: Offset(395, 452),
  icon: Icons.watch_later,
  color: _gold,
);

const _souffle = Evidence(
  id: 'souffle',
  name: 'Perfect Soufflé',
  description:
      "Penny's notorious Needy Soufflé, which must be basted every two minutes or "
      "it collapses. The oven log reads IN 10:30 PM, OUT 11:30 PM — and it stands "
      "tall and flawless. Whoever baked it never left the kitchen in that hour.",
  room: 'kitchen',
  pos: Offset(560, 222),
  icon: Icons.cake,
  color: Color(0xFFFFCC80),
);

const _boots = Evidence(
  id: 'boots',
  name: 'Muddy Boots',
  description:
      "Barry's gardening boots on the doormat, caked in fresh greenhouse mud and "
      "still damp. The night-latch book beside the door, in Penny's handwriting: "
      "“Let Barry in from the greenhouse — midnight.”",
  room: 'entrance',
  pos: Offset(300, 440),
  icon: Icons.hiking,
  color: Color(0xFFBCAAA4),
);

const _whereQ = 'Where were you around 11 last night?';
const _aboutQ = 'Tell me about Mrs. Senclair.';
const _suspectQ = 'Who do you suspect?';

const _pennyWhere = Topic(
  _whereQ,
  "In my kitchen from half ten to half eleven, basting my Needy Soufflé every two "
  "minutes — look away and it sulks flat. At midnight I let Barry in from the "
  "greenhouse, then went to bed. I didn't go down to the cellar until morning... "
  "oh, I'm all a-wobble just thinking of it.",
);

const _barryWhere = Topic(
  _whereQ,
  "Out in the greenhouse 'til midnight, coverin' the strawberries against the "
  "frost. Penny let me in — door was latched. Left me boots on the mat like she "
  "always nags me to.",
);

const _barryAbout = Topic(
  _aboutQ,
  "She had a sharp tongue, but she let me sleep by the boiler when the potting "
  "shed leaks. Can't say fairer than that.",
);

const _glazeTopics = [
  Topic(
    'When did she die?',
    "Her filling was stone cold when we got here at seven this morning. Call it "
    "around eleven last night. Find something that pins it down and I'll owe you "
    "a coffee.",
  ),
  Topic(
    'Who found her?',
    "The housekeeper, Penny Cotta, at half six when she came down for jam. She's "
    "been wobbling ever since. More than usual, I mean.",
  ),
  Topic(
    'Any advice, Officer?',
    "Search every room, talk to everyone — then talk to them again once you've got "
    "evidence to wave under their noses. People remember all sorts when you do "
    "that. When you're sure, the Chief is waiting by the front door.",
  ),
];

const _whoWasHome = Topic(
  'Who was in the house?',
  "Five residents, all home, all doors locked from inside, no sign of a break-in. "
  "One of them did this — or two of them together. Could be either. Follow the "
  "crumbs, Detective.",
);

/// Case 1: a single killer.
const flatCase = MysteryCase(
  id: 'flat',
  title: 'The Flat Truth',
  culprits: {'cannoli'},
  nextVictims: ['graham', 'barry', 'penny', 'tira'],
  solution:
      "Colonel Cannoli owed Mrs. Senclair 50,000 sugar cubes, and she had "
      "discovered that his medals were chocolate coins. At 10:45 he abandoned his "
      "chess game, lifted Penny's marble rolling pin from the kitchen, and at "
      "11:05 rolled Mrs. Senclair flat in the cellar — leaking ricotta as he went. "
      "He hid the pin behind the boiler, dropped a medal in the coal, and was back "
      "at the board by 11:20, quite out of breath.",
  evidence: [
    _watch,
    _souffle,
    _boots,
    Evidence(
      id: 'ricotta',
      name: 'White Cream Drips',
      description:
          "A trail of thick white cream leading away from the outline. You taste "
          "it (professionally). Sweet ricotta — NOT custard. Mrs. Senclair was "
          "filled with vanilla custard, so this leaked out of somebody else.",
      room: 'cellar',
      pos: Offset(200, 480),
      icon: Icons.water_drop,
      color: Colors.white,
    ),
    Evidence(
      id: 'tub',
      name: 'Empty Ricotta Tub',
      description:
          "A large tub on the pantry shelf, scraped clean. The label, in Penny's "
          "handwriting: “Col. Cannoli's PRIVATE ricotta refills. Hands off! — P.C.” "
          "Nobody else in this house is filled with ricotta.",
      room: 'pantry',
      pos: Offset(640, 300),
      icon: Icons.inventory_2,
      color: Color(0xFFE3F2FD),
    ),
    Evidence(
      id: 'pin',
      name: 'Marble Rolling Pin',
      description:
          "Shoved behind the boiler: a heavy marble rolling pin, hastily wiped. "
          "There is custard in the handle grooves, and a shard of crisp, bubbly, "
          "FRIED pastry shell stuck to one end.",
      room: 'boiler',
      pos: Offset(240, 455),
    ),
    Evidence(
      id: 'medal',
      name: 'Dropped Medal',
      description:
          "Glinting in the coal dust: a military medal, “For Valour”. The gold is "
          "peeling. It is foil. This is a chocolate coin on a ribbon.",
      room: 'boiler',
      pos: Offset(610, 440),
      icon: Icons.military_tech,
      color: _gold,
    ),
    Evidence(
      id: 'rack',
      name: 'Rolling Pin Rack',
      description:
          "Penny's rack of rolling pins. Six hooks, five pins. The big marble one "
          "is missing.",
      room: 'kitchen',
      pos: Offset(380, 150),
    ),
    Evidence(
      id: 'notepad',
      name: "Butler's Notepad",
      description:
          "Graham's household notepad, every line ruled. Last night's final "
          "entry: “10:30 — chess with the Colonel in the parlor. (He cheats.)”",
      room: 'dining',
      pos: Offset(430, 312),
      icon: Icons.sticky_note_2,
      color: Color(0xFFFFF59D),
    ),
    Evidence(
      id: 'chess',
      name: 'Chess Scoresheet',
      description:
          "Graham's meticulous record of last night's game. Between moves 14 and "
          "15 he has written: “Col. left for nightcap 10:45. Returned 11:20. Out "
          "of breath. No glass in hand.”",
      room: 'parlor',
      pos: Offset(455, 340),
      icon: Icons.assignment,
      color: Color(0xFFFFF59D),
    ),
    Evidence(
      id: 'phone',
      name: 'Telephone Log',
      description:
          "The operator's slip beside the attic telephone: “Outgoing call, "
          "10:50 PM – 11:30 PM. Caller: Miss T. Misu. To: Madame Leine's Hat "
          "Boutique, after-hours line.”",
      room: 'landing',
      pos: Offset(640, 296),
      icon: Icons.phone_in_talk,
      color: Color(0xFFB2EBF2),
    ),
    Evidence(
      id: 'will',
      name: "Mrs. Senclair's Will",
      description:
          "A copy of Aunt Éclaire's will on Tira's nightstand. “Everything to my "
          "niece, Tira Misu” is circled in lipstick. A motive, certainly. Proof "
          "of anything? No.",
      room: 'bedroom',
      pos: Offset(268, 312),
      icon: Icons.description,
      color: Colors.white,
    ),
    Evidence(
      id: 'trunk',
      name: "The Colonel's Trunk",
      description:
          "Inside the lid of his old uniform trunk, a receipt: “Sweet Victory "
          "Novelty Coins — 12 chocolate medals, assorted valour.” One medal is "
          "missing from the dress jacket. A torn thread dangles where it hung.",
      room: 'storage',
      pos: Offset(485, 395),
    ),
    Evidence(
      id: 'ledger',
      name: 'Debt Ledger',
      description:
          "Mrs. Senclair's ledger, open on her desk. “Col. Cannoli owes 50,000 "
          "sugar cubes. FINAL notice given — pay by tomorrow or leave.” In the "
          "margin: “His medals are CHOCOLATE COINS. The Regiment should know.”",
      room: 'study',
      pos: Offset(470, 300),
      icon: Icons.menu_book,
      color: Color(0xFFD7CCC8),
    ),
  ],
  topics: {
    'sprinkles': [
      Topic(
        'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "Somebody rolled her flat, Detective — squeezed the custard clean out of "
        "her. We traced where she fell in powdered sugar. Not a pretty sight. "
        "Barely a pastry.",
      ),
      Topic(
        'What was the weapon?',
        "Something long, heavy and round. A rolling pin, I'd bet a dozen on it. "
        "It's not down here — the killer carried it off and stashed it somewhere.",
      ),
      _whoWasHome,
    ],
    'glaze': _glazeTopics,
    'penny': [
      _pennyWhere,
      Topic(
        _aboutQ,
        "Strict, but fair. She paid on time and never once called me “jelly”. "
        "She'd been cross with the Colonel lately, mind — something about money.",
      ),
      Topic(
        _suspectQ,
        "I don't like to stir the pot... but Miss Tira does love her aunt's "
        "fortune a great deal more than she loved her aunt.",
      ),
      Topic(
        'One of your rolling pins is missing.',
        "My marble pin! It hung right there at supper. Anyone passing through "
        "could have lifted it — I had my head in the oven from half ten. I did "
        "hear heavy footsteps behind me around quarter to eleven, mind. "
        "Marching, they were. Left, right, left, right.",
        needs: 'rack',
      ),
      Topic(
        'Who eats the ricotta in the pantry?',
        "Eats it? Nobody eats it, Detective. That's the Colonel's filling. He "
        "springs a leak whenever he exerts himself, poor man, and I top him up "
        "on Sundays.",
        needs: 'tub',
      ),
    ],
    'graham': [
      Topic(
        _whereQ,
        "In the parlor, playing chess with the Colonel from half past ten until "
        "midnight. I keep a scoresheet of every game, sir. It is on the chess "
        "table, should you care to inspect it.",
      ),
      Topic(
        _aboutQ,
        "Thirty years I served Madam. She was exacting, as a great house "
        "requires. I shall miss ironing her newspaper.",
      ),
      Topic(
        _suspectQ,
        "It is not a butler's place to speculate, sir. Though I will say that "
        "they always blame the butler, and I find it tiresome.",
      ),
      Topic(
        'Your scoresheet says the Colonel left the game.',
        "Indeed, sir. At 10:45 he announced he needed a nightcap and marched "
        "out. He returned at 11:20, quite out of breath, with no glass — and "
        "leaking a little at one end, if I may be indelicate. I spent the "
        "interval alone with the board, but I recorded the times precisely.",
        needs: 'chess',
      ),
    ],
    'cannoli': [
      Topic(
        _whereQ,
        "In the parlor, thrashing Graham at chess! Half ten to midnight, never "
        "left my chair. A soldier holds his position, what!",
      ),
      Topic(
        _aboutQ,
        "Éclaire? Dear old friend! Generous to a fault. We had no quarrels "
        "whatsoever. None! Why, who's been saying otherwise?",
      ),
      Topic(
        _suspectQ,
        "That gardener, Tart. Shifty fellow, always lurking about in the boiler "
        "room. If I were hiding a weapon, that's where I'd — that's where HE'D "
        "put it, I mean.",
      ),
      Topic(
        'Graham says you left for 35 minutes.',
        "Ah. Yes. Well. Nightcap! Popped to the dining room for a brandy. "
        "Couldn't find the decanter. Took a while. Hardly worth mentioning, what.",
        needs: 'chess',
      ),
      Topic(
        'Is this your medal? It is made of chocolate.',
        "I — that's — a commemorative piece! Must have dropped it weeks ago. In "
        "the boiler room, you say? I have never set foot in that boiler room in "
        "my life. Er. Except then.",
        needs: 'medal',
      ),
      Topic(
        'You owed her 50,000 sugar cubes.',
        "A gentleman's debts are private, sir! And she would never have told the "
        "Regiment about the medals. She... she wouldn't have had the chance. I "
        "MEAN — the heart! She wouldn't have had the heart!",
        needs: 'ledger',
      ),
    ],
    'tira': [
      Topic(
        _whereQ,
        "On the telephone on the landing, darling, from ten to eleven until half "
        "past. Madame Leine was describing the new spring hats in exhaustive "
        "detail. Ask the operator.",
      ),
      Topic(
        _aboutQ,
        "Aunt Éclaire was a sweet old thing with a very hard glaze. Yes, I "
        "inherit. No, I didn't flatten her for it. I look dreadful in black.",
      ),
      Topic(
        _suspectQ,
        "The Colonel has been jumpy as a jelly all week. He and Auntie had a "
        "screaming row in the study on Tuesday. I heard the word “fraud”. And "
        "“foil”.",
      ),
      Topic(
        'The will leaves everything to you.',
        "And it has for ten years, darling. If I were going to do it for the "
        "money, I'd hardly have sat through a decade of her bridge parties first.",
        needs: 'will',
      ),
    ],
    'barry': [
      _barryWhere,
      _barryAbout,
      Topic(
        _suspectQ,
        "Dunno. But somethin' ain't right about that Colonel. Real soldiers "
        "don't get brown smudges on their fingers from polishin' their medals.",
      ),
      Topic(
        'I found a rolling pin behind your boiler.',
        "Not mine, guv! When I came in at midnight the boiler room door was "
        "hangin' open — thought Graham had been at the coal. Whoever stashed "
        "that did it before I got back. I'm a tart, not a fool.",
        needs: 'pin',
      ),
    ],
  },
);

/// Case 2: two killers working together.
const brewCase = MysteryCase(
  id: 'brew',
  title: 'A Bitter Brew',
  culprits: {'tira', 'graham'},
  nextVictims: ['penny', 'cannoli', 'barry'],
  solution:
      "Mrs. Senclair was about to sign a new will, cutting off her niece Tira and "
      "dismissing Graham without a pension for helping Tira pawn her pearls. "
      "Graham wrote the plan on his own notepad. At eleven Tira lured her aunt to "
      "the cellar while Graham fetched the great espresso urn, and together they "
      "tipped it over her. They burnt the note, invented a silver inventory as "
      "their alibi, and booked two tickets to Biscotti Bay.",
  evidence: [
    _watch,
    _souffle,
    _boots,
    Evidence(
      id: 'urn',
      name: 'Overturned Espresso Urn',
      description:
          "The huge brass urn from the pantry, emptied over the victim. It has "
          "two handles, one each side, and is far too heavy for one dessert to "
          "lift. Left handle: smeared with cocoa powder. Right handle: dusted "
          "with honey-brown cracker crumbs.",
      room: 'cellar',
      pos: Offset(565, 425),
    ),
    Evidence(
      id: 'stand',
      name: 'Empty Urn Stand',
      description:
          "Where the espresso urn normally sits. Two sets of tracks cross the "
          "spilled flour toward the cellar: one a dainty trail dusted with cocoa, "
          "the other a row of neat, square-cornered footprints.",
      room: 'pantry',
      pos: Offset(330, 300),
    ),
    Evidence(
      id: 'note',
      name: 'Half-Burnt Note',
      description:
          "Fished from the furnace grate: “...she signs the new will TOMORROW. It "
          "must be tonight, at eleven. I shall fetch the urn; you bring her down "
          "to the cellar. Burn this.” Unsigned — but written on thick cream paper "
          "with a silver “S” monogram.",
      room: 'boiler',
      pos: Offset(382, 240),
      icon: Icons.local_fire_department,
      color: Color(0xFFFFAB40),
    ),
    Evidence(
      id: 'notepad',
      name: "Butler's Notepad",
      description:
          "Graham's household notepad: thick cream paper, silver “S” monogram. "
          "The top sheet has been torn off. Rubbing a pencil over the next page "
          "reveals the ghost of the words “...must be tonight, at eleven...”",
      room: 'dining',
      pos: Offset(430, 312),
      icon: Icons.sticky_note_2,
      color: Color(0xFFFFF59D),
    ),
    Evidence(
      id: 'silver',
      name: 'Silver Cabinet',
      description:
          "The family silver, gleaming. A tag in Penny's handwriting hangs on the "
          "door: “Counted & polished — yesterday, 3 PM. All 144 pieces present.” "
          "Nobody needed to count it again last night.",
      room: 'dining',
      pos: Offset(175, 210),
    ),
    Evidence(
      id: 'newwill',
      name: 'Unsigned New Will',
      description:
          "A draft on Mrs. Senclair's desk, due to be signed today: “I revoke all "
          "bequests to my niece Tira Misu, who loves only my money. My butler, "
          "G. Cracker, is dismissed without pension for helping her pawn my "
          "pearls. Everything goes to the Donut County Home for Day-Old Pastries.”",
      room: 'study',
      pos: Offset(470, 300),
      icon: Icons.description,
      color: Colors.white,
    ),
    Evidence(
      id: 'gloves',
      name: 'Coffee-Stained Gloves',
      description:
          "Stuffed under Tira's mattress: a pair of elegant evening gloves, "
          "soaked through with espresso and still damp. They smell of last night.",
      room: 'bedroom',
      pos: Offset(430, 400),
      icon: Icons.back_hand,
      color: Color(0xFFBCAAA4),
    ),
    Evidence(
      id: 'tickets',
      name: 'Packed Suitcase',
      description:
          "A suitcase hidden behind the trunks, initialled G.C. Inside: a spare "
          "butler's collar and two one-way train tickets to Biscotti Bay for "
          "tonight — “Mr. G. Cracker” and “Miss T. Misu”.",
      room: 'storage',
      pos: Offset(485, 395),
      icon: Icons.luggage,
      color: Color(0xFFBCAAA4),
    ),
    Evidence(
      id: 'phone',
      name: 'Telephone Log',
      description:
          "The operator's slip beside the attic telephone: “Outgoing call, "
          "10:50 PM – 11:30 PM. Caller: Col. Cannoli. To: Fort Fondant Officers' "
          "Club.”",
      room: 'landing',
      pos: Offset(640, 296),
      icon: Icons.phone_in_talk,
      color: Color(0xFFB2EBF2),
    ),
    Evidence(
      id: 'iou',
      name: 'Crumpled IOU',
      description:
          "Wedged in the Colonel's armchair: “I, Col. Cannoli, owe Mrs. É. "
          "Senclair 50,000 sugar cubes.” A motive, certainly — but where was he "
          "at eleven?",
      room: 'parlor',
      pos: Offset(250, 395),
      icon: Icons.request_quote,
      color: Color(0xFFFFF59D),
    ),
  ],
  topics: {
    'sprinkles': [
      Topic(
        'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "Somebody drenched her, Detective — gallons of scalding espresso, poured "
        "until she went soggy and simply fell apart. We outlined what was left "
        "in powdered sugar.",
      ),
      Topic(
        'What was the weapon?',
        "That brass espresso urn lying on its side. Thing weighs more than I do "
        "after the holidays. Take a good close look at it.",
      ),
      _whoWasHome,
    ],
    'glaze': _glazeTopics,
    'penny': [
      _pennyWhere,
      Topic(
        _aboutQ,
        "Strict, but fair. She'd been upset lately — her pearls went missing "
        "last month, and she'd been shut up with her solicitor ever since.",
      ),
      Topic(
        _suspectQ,
        "I don't like to stir the pot... but the Colonel owes Madam a fortune. "
        "Then again, I could hear him booming down the telephone upstairs half "
        "the night, so I suppose it can't be him.",
      ),
      Topic(
        'Was anyone counting the silver last night?',
        "Last night? Stuff and nonsense! I counted and polished every piece at "
        "three that afternoon — it's on the tag. And the dining room is right "
        "next to my kitchen: dark and silent as a fridge from half ten onwards. "
        "Nobody was in there.",
        needs: 'silver',
      ),
    ],
    'graham': [
      Topic(
        _whereQ,
        "In the dining room, sir, conducting the monthly silver inventory with "
        "Miss Tira's kind assistance. Half past ten until half past eleven. One "
        "hundred and forty-four pieces, all present.",
      ),
      Topic(
        _aboutQ,
        "Thirty years I served Madam. One expects a certain... recognition, "
        "after thirty years. One does not always receive it.",
      ),
      Topic(
        _suspectQ,
        "The Colonel is deeply in debt to Madam, sir. And the gardener is, well, "
        "a gardener. I should look there.",
      ),
      Topic(
        'A sheet is missing from your notepad.',
        "A shopping list, sir. Lemons. I... burnt it. One burns shopping lists. "
        "It is a perfectly normal thing for a butler to do with lemons.",
        needs: 'notepad',
      ),
      Topic(
        'She was dismissing you without a pension.',
        "Thirty years, sir! Thirty years of ironing newspapers, and she would "
        "have crumbled me over one string of pearls! ...Which is to say, I was "
        "unaware of any such document.",
        needs: 'newwill',
      ),
      Topic(
        'Two tickets to Biscotti Bay, Graham?',
        "A — a holiday, sir. Long planned. That Miss Tira's name appears on the "
        "second ticket is a clerical coincidence. I find I should like to stop "
        "answering questions now.",
        needs: 'tickets',
      ),
    ],
    'tira': [
      Topic(
        _whereQ,
        "Helping Graham count the silver in the dining room, darling. Half ten "
        "to half eleven. Frightfully dull — spoons, spoons, spoons.",
      ),
      Topic(
        _aboutQ,
        "Auntie was a sweet old thing with a very hard glaze. We adored each "
        "other. Everyone knows I am her sole heir.",
      ),
      Topic(
        _suspectQ,
        "The Colonel, obviously. He owes her mountains of sugar. Or that muddy "
        "gardener. Honestly, anyone but me, darling.",
      ),
      Topic(
        'Your gloves are soaked in espresso.',
        "I — spilled my after-dinner coffee! All of it. On both hands. I'm a "
        "tiramisu, darling, we are practically made of coffee. It proves nothing.",
        needs: 'gloves',
      ),
      Topic(
        'Your aunt was cutting you out of her will.',
        "She was WHAT? I mean — yes, I knew — I mean I did NOT know. Who told "
        "you I knew? Was it Graham? That crumbling old fool...",
        needs: 'newwill',
      ),
    ],
    'cannoli': [
      Topic(
        _whereQ,
        "On the telephone on the attic landing, sir! Ten to eleven until half "
        "past, swapping war stories with old Major Meringue at the Fort Fondant "
        "Officers' Club. The operator will have a record.",
      ),
      Topic(
        _aboutQ,
        "Éclaire? Splendid woman. Very patient with a chap's... temporary "
        "financial embarrassments.",
      ),
      Topic(
        _suspectQ,
        "Dashed odd thing — I came downstairs past the dining room at half "
        "eleven and it was pitch dark. Yet the butler tells everyone he was "
        "counting spoons in there. Counting 'em by smell, was he?",
      ),
      Topic(
        'You owed her 50,000 sugar cubes.',
        "I did, and I do, and I'm not proud of it. But she'd given me until "
        "Christmas, and a dead creditor's heirs are far less patient. Her death "
        "is the worst thing that could happen to me, what!",
        needs: 'iou',
      ),
    ],
    'barry': [
      _barryWhere,
      _barryAbout,
      Topic(
        _suspectQ,
        "Them two — Miss Tira and old Graham — been whisperin' in corners for "
        "weeks. Go quiet as custard the moment I walk by.",
      ),
      Topic(
        'I pulled this note out of your furnace.',
        "Ain't my writin', guv — I can barely spell “fertiliser”. But when I "
        "came in at midnight the furnace door was open and the fire fresh-poked. "
        "And there was cocoa powder on the handle. I don't use cocoa. Bad for "
        "the roses.",
        needs: 'note',
      ),
    ],
  },
);

const allCases = [flatCase, brewCase];
