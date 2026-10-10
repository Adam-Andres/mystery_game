/// Evidence and testimony shared between mysteries: the household's routines,
/// and the red herrings that have an innocent explanation in every case that
/// uses them.
library;

import 'package:flutter/material.dart';

import 'models.dart';

const briefing =
    "The Donut County Police rang at dawn: Mrs. Éclaire Senclair has been found "
    "dead in the cellar of her own house. Five residents were home, and every door "
    "was latched from the inside. One of them did it — or two of them, together.\n\n"
    "Everybody here has a motive and nobody will confess, so I must cross-check "
    "every story. Arrows to move, click anything suspicious, and put what one "
    "dessert says to another. When I am certain, I return to the Entrance Hall "
    "and press “I solved the case”.";

const gold = Color(0xFFFFD54F);
const paper = Color(0xFFFFF59D);
const _white = Colors.white;
const _dull = Color(0xFFBCAAA4);

const whereQ = 'Where were you around 11 last night?';
const aboutQ = 'Tell me about Mrs. Senclair.';
const suspectQ = 'Who do you suspect?';

const phoneHint =
    "That is the operator's word, not the caller's. An alibi that somebody "
    "else wrote down is worth ten that are merely spoken.";

const souffleHint =
    "If that log is honest, Penny never left her oven. I should ask to see "
    "the log itself.";

const bootsHint =
    "Locked out until midnight, by the look of it. Who latches the doors in "
    "this house, and when?";

const _fivePast =
    "Five past eleven, then. Never mind who had a reason, Churlock. Who can "
    "prove where they stood at five past eleven? And I mean prove, not say.";

/// What he makes of the stopped watch or clock, when it can be trusted.
const timeHints = <String, String>{'watch': _fivePast, 'clock': _fivePast};

/// Watsonut's thoughts on evidence that turns up in every mystery. He says
/// the same of a document whether it is genuine or forged.
const commonHints = <String, String>{
  'chart': "Splendid. Now all we want is the weapon.",
  'cellarbook': "Useful for knowing who had honest business in the cellar, "
      "and when. Compare it with whatever you find down there.",
  'ovenlog': "Read it line by line against the clock, Churlock. Every entry "
      "ought to be possible.",
  'extension': "Read it again, slowly, as she would have written it. Every "
      "word.",
};

// Time of death

const watch = Evidence(
  'watch', 'Stopped Pocket Watch', 'cellar', 0,
  "Mrs. Senclair's pocket watch, lying inside the outline and ruined along "
  "with her. The hands stopped at 11:05 PM.",
  icon: Icons.watch_later, color: gold,
);

const clock = Evidence(
  'clock', 'Fallen Cellar Clock', 'cellar', 3,
  "The old cellar clock lies face-up among the barrels, knocked off its nail "
  "in a struggle. The pendulum has snapped and the hands are frozen at "
  "11:05 PM.",
  icon: Icons.access_time_filled, color: gold,
);

const timeOfDeath = [watch, clock];

// Alibi evidence

const souffle = Evidence(
  'souffle', 'Perfect Soufflé', 'kitchen', 1,
  "Penny's notorious Needy Soufflé, which must be basted every two minutes or "
  "it collapses. The oven log beside it reads IN 10:30 PM, OUT 11:30 PM — and "
  "it stands tall and flawless.",
  icon: Icons.cake, color: Color(0xFFFFCC80),
);

const boots = Evidence(
  'boots', 'Muddy Boots', 'entrance', 0,
  "Barry's gardening boots on the doormat, caked in fresh greenhouse mud and "
  "still damp. The night-latch book beside the door, in Penny's handwriting: "
  "“Let Barry in from the greenhouse — midnight.”",
  icon: Icons.hiking, color: _dull,
);

const phoneTira = Evidence(
  'phone', 'Telephone Log', 'landing', 0,
  "The operator's slip beside the attic telephone: “Outgoing call, 10:50 PM – "
  "11:30 PM. Caller: Miss T. Misu. To: Madame Leine's Hat Boutique, "
  "after-hours line. Line never dropped.”",
  icon: Icons.phone_in_talk, color: Color(0xFFB2EBF2),
);

// Red herrings

const will = Evidence(
  'will', "Mrs. Senclair's Will", 'bedroom', 0,
  "A copy of Aunt Éclaire's will on Tira's nightstand. “Everything to my "
  "niece, Tira Misu” is circled in lipstick.",
  icon: Icons.description, color: _white,
);

const bills = Evidence(
  'bills', 'Unpaid Hat Bills', 'bedroom', 3,
  "A drawer of Tira's dresser stuffed with bills from Madame Leine's Hat "
  "Boutique. The newest is stamped FINAL DEMAND in red. The total would buy "
  "a small bakery.",
  icon: Icons.receipt_long, color: paper, inside: 'dresser',
);

const dismissal = Evidence(
  'dismissal', 'Dismissal Notice', 'study', 4,
  "Tucked into a gardening manual on the shelf: “B. Tart — to be let go at "
  "month end. The strawberries are a disgrace. — É.S.”",
  icon: Icons.mail, color: paper,
);

const spade = Evidence(
  'spade', 'Stained Spade', 'boiler', 4,
  "Barry's spade, propped against the wall. The blade is smeared with "
  "something dark red and sticky.",
  icon: Icons.construction, color: Color(0xFFEF9A9A),
);

const jobAd = Evidence(
  'jobad', 'Crumpled Advertisement', 'dining', 4,
  "Under the dining table, screwed into a ball: “BUTLER WANTED at Lady "
  "Finger's residence. References essential.” Across it, in Graham's neat "
  "hand: “She REFUSED. Thirty years!”",
  icon: Icons.newspaper, color: paper,
);

const recipe = Evidence(
  'recipe', 'Old Recipe Book', 'kitchen', 3,
  "A battered notebook at the back of the cupboard. Inside: the famous Senclair Cream "
  "Puff recipe — dated thirty years ago, in Penny's handwriting, long before "
  "Senclair Confections existed. Scrawled beneath: “MINE. She never paid a "
  "cube.”",
  icon: Icons.menu_book, color: Color(0xFFD7CCC8), inside: 'cupboard',
);

const threat = Evidence(
  'threat', 'Anonymous Letter', 'entrance', 2,
  "In the pocket of a coat at the back of the closet, a letter made of cut-out "
  "newspaper type: “YOU WILL GET YOUR JUST DESSERTS.” No signature.",
  icon: Icons.markunread_mailbox, color: Color(0xFFEF9A9A), inside: 'closet',
);

const berryStain = Evidence(
  'berrystain', 'Purple Stain', 'pantry', 4,
  "A wide purple-red stain soaked into the pantry flagstones, with a few "
  "seeds stuck in it. Berry juice, and plenty of it.",
  icon: Icons.water_drop, color: Color(0xFF9C27B0),
);

const crumbs = Evidence(
  'crumbs', 'Honey-Brown Crumbs', 'pantry', 2,
  "A scatter of honey-brown cracker crumbs along the pantry shelf, with a "
  "sharp, square corner printed in the dust beside them.",
  icon: Icons.grain, color: Color(0xFFD8A55C),
);

const cocoa = Evidence(
  'cocoa', 'Cocoa Dusting', 'cellar', 4,
  "A fine dusting of cocoa powder on the wine rack, with dainty fingermarks "
  "in it. One slot in the rack is empty.",
  icon: Icons.blur_on, color: Color(0xFF8D6E63),
);

const sauceDrip = Evidence(
  'saucedrip', 'Red Sauce Drips', 'entrance', 4,
  "Three drops of red berry sauce on the floor at the top of the cellar "
  "steps, still glossy.",
  icon: Icons.water_drop, color: Color(0xFFE53935),
);

const iou = Evidence(
  'iou', 'Crumpled IOU', 'parlor', 1,
  "Wedged down the side of the armchair: “I, Col. Cannoli, owe Mrs. É. "
  "Senclair 50,000 sugar cubes.”",
  icon: Icons.request_quote, color: paper,
);

const regiment = Evidence(
  'regiment', 'Letter from the Regiment', 'study', 5,
  "In the desk drawer, a reply to Mrs. Senclair from Fort Fondant: “Madam, "
  "we regret that we can find no record of any Colonel Cannoli among our "
  "fighting officers, nor of the medals you describe.”",
  icon: Icons.mail, color: paper, inside: 'desk',
);

const sabre = Evidence(
  'sabre', 'Sticky Sabre', 'storage', 3,
  "The Colonel's ceremonial sabre, missing from the parlor wall, thrust "
  "through the old dress form. The blade is tacky with something dark red.",
  icon: Icons.colorize, color: Color(0xFFCFD8DC),
);

const betting = Evidence(
  'betting', 'Betting Slips', 'parlor', 0,
  "Pressed inside a hollowed-out book: a thick wad of the Colonel's betting "
  "slips from the Gingerbread Derby. Every single horse lost.",
  icon: Icons.confirmation_number, color: paper, inside: 'bookcase',
);

const savings = Evidence(
  'savings', 'Savings Tin', 'boiler', 0,
  "At the bottom of Barry's bag, a tobacco tin of sugar cubes and the deeds "
  "to a small plot: “Tart's Nursery — deposit paid. Balance due at month "
  "end.”",
  icon: Icons.savings, color: gold, inside: 'kitbag',
);

const diary = Evidence(
  'diary', "Tira's Diary", 'landing', 0,
  "Hidden under the sheets, a diary with a tiny brass lock, left open. "
  "Yesterday's entry: “Auntie impossible again about my allowance. I could "
  "scream. Must be sweeter to her. Madame Leine telephones tonight.”",
  icon: Icons.book, color: Color(0xFFF8BBD0), inside: 'chest',
);

/// A game of chess with no gaps in it.
const steadyScoresheet = Evidence(
  'scoresheet', 'Chess Scoresheet', 'parlor', 0,
  "Graham's meticulous record of last night's game. A move is entered "
  "every two or three minutes from 10:32 until 11:58 without a break, "
  "each one initialled by both players.",
  icon: Icons.assignment, color: paper,
);

// Red herrings out in the yard, and in the places that want a tool to open.

const medal = Evidence(
  'medal', 'Chewed Medal', 'backyard', 0,
  "Buried a hand deep among the biscuit bones: one of the Colonel's medals, "
  "gnawed along one edge. Under the gilt it is solid chocolate.",
  icon: Icons.military_tech, color: gold, inside: 'dirt',
);

const slipper = Evidence(
  'slipper', 'Chewed Slipper', 'backyard', 0,
  "At the back of the kennel, under the blanket: a left slipper, monogrammed "
  "G.C. and chewed to a rag. There is cellar dust on the sole.",
  icon: Icons.ice_skating, color: _dull, inside: 'kennel',
);

const scratches = Evidence(
  'scratches', 'Scratched Back Door', 'backyard', 3,
  "Deep fresh scratches low down on the back door, and the paint gouged "
  "away in strips. Something wanted very badly to be let in last night.",
  icon: Icons.door_back_door, color: _dull,
);

const letters = Evidence(
  'letters', 'Bundle of Letters', 'cellar', 0,
  "In the strongbox, tied with a faded ribbon: thirty-year-old letters "
  "beginning “My dearest Éclaire” and ending “Your devoted G.” Every one "
  "has been opened, read, and kept.",
  icon: Icons.mail, color: Color(0xFFF8BBD0), inside: 'strongbox',
);

const cannoliMedal = Topic(
  'medal', 'One of your medals was buried in the yard.',
  "That hound, sir! He has had three of them off my dressing table. The "
  "ones he buries are the stage set, for the Fort Fondant theatricals. One "
  "doesn't leave the real ones lying about. Chocolate, yes. What of it?",
  needs: ['medal'],
);

const grahamYard = [
  Topic(
    'slipper', 'Your slipper was in the kennel, with cellar dust on it.',
    "The animal has stolen my left slipper every week since it was a pup, "
    "sir. I wear them when I do the cellar book. I have asked Madam for a "
    "taller shoe rack on four occasions.",
    needs: ['slipper'],
  ),
  Topic(
    'letters', 'Who is “Your devoted G.”?',
    "A youthful indiscretion, sir, of thirty years' standing. Madam "
    "declined. I stayed. One does not strike down a lady after thirty years "
    "for saying no in the first week.",
    needs: ['letters'],
  ),
];

const pennyYard = [
  Topic(
    'scratches', 'Something has clawed at the back door.',
    "Pupcake. He wants in every time it rains, and I won't have it. He "
    "sheds sprinkles into everything. He scratched at that door half the "
    "night, the little beast.",
    needs: ['scratches'],
  ),
];

// Things the residents and the police hand over when asked.

const chart = Evidence.given(
  'chart', 'Fingerprint Chart', 'sprinkles',
  "A reference card from the Donut County Police with the fingerprints of "
  "all five residents, taken this morning. With it I can dust the murder "
  "weapon and see who has handled it.",
  icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
);

const cellarBook = Evidence.given(
  'cellarbook', 'Cellar Book', 'graham',
  "Graham's cellar book. Yesterday's entries: “8:00 PM — Colonel Cannoli, "
  "one bottle of brandy (helped himself). 9:00 PM — Miss Tira, one bottle of "
  "the '08 port.” Nothing is entered after nine.",
  icon: Icons.menu_book, color: Color(0xFFD7CCC8),
);

const ovenLog = Evidence.given(
  'ovenlog', 'Oven Log', 'penny',
  "Penny's oven log card for last night, in pencil: “Needy Soufflé. IN "
  "10:30. Basted every 2 min. OUT 11:30. Risen four inches. Eggs: 6.”",
);

/// As [ovenLog], with one entry too many: Mrs. Senclair died at 11:05.
const ovenLogForged = Evidence.given(
  'ovenlog', 'Oven Log', 'penny',
  "Penny's oven log card for last night, in pencil: “Needy Soufflé. IN "
  "10:30. Basted every 2 min. 11:20 — Madam rang down to say it smelt "
  "divine. OUT 11:30. Risen four inches. Eggs: 6.”",
);

const extension = Evidence.given(
  'extension', "Mrs. Senclair's Note", 'cannoli',
  "A note the Colonel says Mrs. Senclair wrote him last week: “My dear "
  "Colonel, do not trouble yourself about the sugar. Take until Christmas. "
  "Your friend, Éclaire Senclair.”",
  icon: Icons.mail,
);

/// As [extension], but whoever wrote it could not spell her surname.
const extensionForged = Evidence.given(
  'extension', "Mrs. Senclair's Note", 'cannoli',
  "A note the Colonel says Mrs. Senclair wrote him last week: “My dear "
  "Colonel, do not trouble yourself about the sugar. Take until Christmas. "
  "Your friend, Éclaire Sinclair.”",
  icon: Icons.mail,
);

const sprinklesChart = Topic(
  'chart', 'May I borrow your fingerprint chart?',
  "Take it, Detective. We printed all five of them at breakfast, and they "
  "were not pleased about it. Find the weapon, dust it, and see whose prints "
  "come up. Just remember: a print tells you who touched a thing. It doesn't "
  "tell you when.",
  gives: chart,
);

const grahamRecords = Topic(
  'records', 'Do you keep a record of the household?',
  "Naturally, sir. Every bottle that leaves the cellar is entered in my "
  "cellar book. You may borrow it. I should like it back unmarked.",
  gives: cellarBook,
);

const pennyLogQ = 'May I see your oven log?';
const pennyLogA =
    "Of course. I write up every bake, same as my mother did. Take it. I've "
    "nothing to hide.";

const cannoliProofQ = 'Can you prove she gave you more time?';
const cannoliProofA =
    "As it happens, sir, I can! She wrote me this only last week. Keep it. "
    "You'll see we were on the best of terms.";

const tiraDiary = Topic(
  'diary', 'Your diary says you could scream at her.',
  "Darling, I could scream at everybody. It's a diary. If I meant to do "
  "anything about it I should hardly write it down first and leave it in "
  "the linen.",
  needs: ['diary'],
);

const barrySavings = Topic(
  'savings', 'You are buying a nursery.',
  "Me own plot, guv. Balance due at month end — and me last wages off the "
  "old girl was to pay it. With her gone, who's payin' me? Worst thing that "
  "could've happened.",
  needs: ['savings'],
);

const cannoliBetting = Topic(
  'betting', 'You have lost a great deal on the horses.',
  "The Gingerbread Derby, sir. A mug's game, and I am the mug. But one "
  "doesn't murder one's creditor over a slow horse. One simply backs another.",
  needs: ['betting'],
);

// Testimony about the household's routines and the herrings above.

const pennyWhere = Topic(
  'where', whereQ,
  "In my kitchen from half ten to half eleven, basting my Needy Soufflé every "
  "two minutes — look away and it sulks flat. At midnight I let Barry in from "
  "the greenhouse, then went to bed. I didn't go down to the cellar until "
  "morning... oh, I'm all a-wobble just thinking of it.",
);

const pennyLog = Topic(
  'log', pennyLogQ, pennyLogA,
  needs: ['souffle'],
  gives: ovenLog,
);

const cannoliProof = Topic(
  'proof', cannoliProofQ, cannoliProofA,
  needs: ['iou'],
  gives: extension,
);

const pennyRecipe = Topic(
  'recipe', 'The Senclair Cream Puff was your recipe.',
  "So you found it. Yes, it was mine, and no, she never paid me a cube for it. "
  "I have been cross about it for thirty years, Detective. One doesn't wait "
  "thirty years and then pick a Thursday.",
  needs: ['recipe'],
);

const pennySauce = Topic(
  'sauce', 'There is red sauce at the top of the cellar steps.',
  "Oh, that's mine, I'm afraid. When I found her this morning I went all to "
  "pieces, and my topping runs when I'm upset. I dripped the whole way back "
  "up to the telephone.",
  needs: ['saucedrip'],
);

const pennyCommon = [
  Topic(
    'letin', 'Barry says you let him in at midnight.',
    "I did, boots and all. He was blue with cold, poor crumb — he'd plainly "
    "been out there for hours.",
    heard: ['barry/where'],
  ),
  Topic(
    'jam', 'What is the purple stain in the pantry?',
    "Blackberry jam. Barry dropped a whole crate of my jars on Tuesday. I "
    "scrubbed for an hour and it's there for good. It has nothing to do with "
    "last night.",
    needs: ['berrystain'],
  ),
  Topic(
    'crumbs', 'There are cracker crumbs along the pantry shelf.',
    "Graham's. He counts the stores every evening at six, regular as the "
    "clock, and sheds while he does it. I sweep them up each morning. I hadn't "
    "got to it today, for obvious reasons.",
    needs: ['crumbs'],
  ),
];

const grahamCommon = [
  Topic(
    'latch', 'Barry says he was outside until midnight.',
    "I latch every door at ten o'clock sharp, sir, from the inside. After ten, "
    "nobody enters this house unless somebody already in it lets them in. The "
    "gardener was, I regret to say, outside.",
    heard: ['barry/where'],
  ),
  Topic(
    'port', 'There is cocoa powder on the wine rack.',
    "Miss Tira came down for a bottle of the '08 port at nine o'clock, sir. I "
    "entered it in the cellar book myself. She dusts everything she touches.",
    needs: ['cocoa'],
  ),
  Topic(
    'jobad', 'She refused you a reference.',
    "She did, sir, and the position at Lady Finger's went to another. That "
    "was a month ago. Had I wished to do something rash about it, I should "
    "have done it then — and a good deal more tidily.",
    needs: ['jobad'],
  ),
  grahamRecords,
];

const tiraCommon = [
  Topic(
    'will', 'The will leaves everything to you.',
    "And it has for ten years, darling. If I were going to do it for the "
    "money, I'd hardly have sat through a decade of her bridge parties first.",
    needs: ['will'],
  ),
  Topic(
    'bills', 'You owe Madame Leine a fortune.',
    "Darling, I have owed Madame Leine since I was a ladyfinger. She is far "
    "too fond of me to press. Final demands are simply how she says hello.",
    needs: ['bills'],
  ),
  Topic(
    'cocoa', 'Your cocoa is all over the wine rack.',
    "I went down for the port at nine, darling. Graham wrote it in his little "
    "book. Auntie was alive and scolding me for it at ten.",
    needs: ['cocoa'],
  ),
  tiraDiary,
];

const cannoliIou = Topic(
  'iou', 'You owed her 50,000 sugar cubes.',
  "I did, and I do, and I'm not proud of it. But she had given me until "
  "Christmas, and a dead creditor's heirs are far less patient. Her death is "
  "the worst thing that could happen to my finances, what!",
  needs: ['iou'],
);

const cannoliRegiment = Topic(
  'regiment', 'Fort Fondant has never heard of you.',
  "Not among the FIGHTING officers, no. I was a colonel in the Catering "
  "Corps, sir. Forty years of trifle for the troops. One doesn't advertise "
  "it. Éclaire knew, and teased me rotten.",
  needs: ['regiment'],
);

const cannoliSabre = Topic(
  'sabre', 'Your sabre is in the attic, and it is sticky.',
  "Toffee apples, sir! Fearsome things to slice. I was carving one for "
  "myself on Sunday, the blade stuck fast in that dummy, and I haven't had "
  "the puff to pull it out since.",
  needs: ['sabre'],
);

const barryAbout = Topic(
  'about', aboutQ,
  "She had a sharp tongue, but she let me sleep by the boiler when the potting "
  "shed leaks. Can't say fairer than that.",
);

const barryBasics = [
  Topic(
    'lockedout', 'Graham latches the doors at ten.',
    "Too right he does. I hammered on the back door a good while before "
    "Penny came and let me in.",
    heard: ['graham/latch'],
  ),
  Topic(
    'dismissal', 'She was going to dismiss you.',
    "Aye, at month end. Told me herself on Monday. Month end, guv — that's "
    "three more weeks of wages and a warm boiler. Why'd I cut that short?",
    needs: ['dismissal'],
  ),
  Topic(
    'spade', 'What is that on your spade?',
    "Beetroot, guv. Been liftin' beets all week. Lick it if you don't "
    "believe me. ...Suit yourself.",
    needs: ['spade'],
  ),
  Topic(
    'jam', 'Did you spill something in the pantry?',
    "Dropped a crate of Penny's jam Tuesday. She ain't forgiven me, and the "
    "floor ain't neither.",
    needs: ['berrystain'],
  ),
];

const barryCommon = [...barryBasics, barrySavings];

const whoWasHome = Topic(
  'home', 'Who was in the house?',
  "Five residents, all home, every door latched from the inside, no sign of a "
  "break-in. One of them did this — or two of them together. Could be either. "
  "Mind you, they've all got a reason, and half the mess in this house has "
  "nothing to do with it. Follow the crumbs, Detective, but check where they "
  "came from.",
);

const glazeTopics = [
  Topic(
    'when', 'When did she die?',
    "She was stone cold when we got here at seven this morning. Call it around "
    "eleven last night. Find something that pins it down and I'll owe you a "
    "coffee.",
  ),
  Topic(
    'found', 'Who found her?',
    "The housekeeper, Penny Cotta, at half six when she came down for jam. She "
    "telephoned us from upstairs. She's been wobbling ever since. More than "
    "usual, I mean.",
  ),
  Topic(
    'advice', 'Any advice, Officer?',
    "Don't trust an alibi until something else backs it up — a log, a clock, "
    "somebody with no reason to lie. And when one of them tells you a thing, "
    "go and put it to the others. That's when stories come apart.",
  ),
  Topic(
    'threat', 'There was a threatening letter in a coat pocket.',
    "“Just desserts”? We know those. Every confectioner in the county got one "
    "last month, from the Sugar-Free League. Cranks. They post letters; they "
    "don't pick locks.",
    needs: ['threat'],
  ),
];
