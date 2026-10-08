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
  "A drawer of Tira's vanity stuffed with bills from Madame Leine's Hat "
  "Boutique. The newest is stamped FINAL DEMAND in red. The total would buy "
  "a small bakery.",
  icon: Icons.receipt_long, color: paper,
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
  "A battered notebook behind the jars. Inside: the famous Senclair Cream "
  "Puff recipe — dated thirty years ago, in Penny's handwriting, long before "
  "Senclair Confections existed. Scrawled beneath: “MINE. She never paid a "
  "cube.”",
  icon: Icons.menu_book, color: Color(0xFFD7CCC8),
);

const threat = Evidence(
  'threat', 'Anonymous Letter', 'entrance', 2,
  "In the pocket of the coat on the stand, a letter made of cut-out "
  "newspaper type: “YOU WILL GET YOUR JUST DESSERTS.” No signature.",
  icon: Icons.markunread_mailbox, color: Color(0xFFEF9A9A),
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
  icon: Icons.mail, color: paper,
);

const sabre = Evidence(
  'sabre', 'Sticky Sabre', 'storage', 3,
  "The Colonel's ceremonial sabre, missing from the parlor wall, thrust "
  "through the old dress form. The blade is tacky with something dark red.",
  icon: Icons.colorize, color: Color(0xFFCFD8DC),
);

// Testimony about the household's routines and the herrings above.

const pennyWhere = Topic(
  'where', whereQ,
  "In my kitchen from half ten to half eleven, basting my Needy Soufflé every "
  "two minutes — look away and it sulks flat. At midnight I let Barry in from "
  "the greenhouse, then went to bed. I didn't go down to the cellar until "
  "morning... oh, I'm all a-wobble just thinking of it.",
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

const barryCommon = [
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
