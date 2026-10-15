/// Evidence and testimony shared between the farm's mysteries: the farm's
/// routines, and the red herrings that have an innocent explanation in
/// every case that uses them.
library;

import 'package:flutter/material.dart';

import 'common.dart' show gold, paper, whereQ;
import 'models.dart';

/// Watsonut on the farm's routine evidence, when it can be trusted.
const farmTimeHint =
    "Five past eleven, then. Never mind who had a reason, Churlock. Who can "
    "prove where they stood at five past eleven? And I mean prove, not say.";

const farmHints = <String, String>{
  'fwatch': farmTimeHint,
  'fclock': farmTimeHint,
  'fchart': "Splendid. Now all we want is the weapon.",
  'creamslip': "A slip written by somebody with no reason to lie. That is "
      "worth ten sworn statements. If it says what it seems to.",
};

/// Watsonut on the telephone slip, where it is what it seems.
const farmPhoneHints = <String, String>{
  'partyline': "That is the exchange's word, not the caller's. An alibi "
      "that somebody else wrote down is worth ten that are merely spoken.",
};

/// Watsonut on Marsha's pie and her card, where they are what they seem.
const farmPieHints = <String, String>{
  'bakecard': "Read it line by line against the clock, Churlock. Every "
      "entry ought to be possible.",
  'harvestpie': "If that card is honest, Marsha never left her oven. I "
      "should ask to see the card itself.",
};

// Time of death

const fwatch = Evidence(
  'fwatch', 'Stopped Pocket Watch', 'rootcellar', 0,
  "Farmer Kernel's brass pocket watch, lying in the scattered candy corn "
  "beside the outline. The glass is cracked across, and the hands stopped "
  "at 11:05 PM.",
  icon: Icons.watch_later, color: gold,
);

const fclock = Evidence(
  'fclock', 'Fallen Cellar Clock', 'rootcellar', 3,
  "The root cellar's old wall clock, knocked down among the potato racks "
  "in a struggle. The pendulum has snapped and the hands are frozen at "
  "11:05 PM.",
  icon: Icons.access_time_filled, color: gold,
);

const farmTimeOfDeath = [fwatch, fclock];

// The farm's routines, which give four or five of them an alibi.

const harvestPie = Evidence(
  'harvestpie', 'Harvest Pie', 'fkitchen', 1,
  "Marsha's Harvest Moon Pie, which must be turned in the oven every three "
  "minutes or it scorches on one side. It sits on the sill, golden all "
  "round, with a lattice as even as a chessboard.",
  icon: Icons.cake, color: Color(0xFFFFCC80),
);

const creamSlip = Evidence(
  'creamslip', 'Creamery Slip', 'barn', 2,
  "A slip from the Candy Land Creamery, tucked under the milk pail: "
  "“Collected 11:00 PM, four churns of chocolate milk, from G. Gumdrop in "
  "person at the barn door. — Fudge, driver.”",
  icon: Icons.receipt, color: paper,
);

const partyLine = Evidence(
  'partyline', 'Party-Line Slip', 'frontroom', 3,
  "The exchange's slip beside the telephone in the front room: “Kernel Farm "
  "line. Call placed 10:50 PM by Miss L. Popwell to the Candy City "
  "Talent Bureau. Cleared 11:30 PM. Line never dropped.”",
  icon: Icons.phone_in_talk, color: Color(0xFFB2EBF2),
);

const ticketGood = Evidence(
  'ticket', 'Railway Ticket', 'greenhouse', 1,
  "On the Professor's potting bench, a railway ticket: “Candy Line Railway. Candy "
  "City to Kernel Halt. Last train, 11:20 PM. Wednesday the 13th.” It has "
  "been punched by the guard.",
  icon: Icons.train, color: paper,
);

const calendar = Evidence(
  'calendar', 'Kitchen Calendar', 'fkitchen', 0,
  "The calendar from the feed merchant, by the kitchen door. Yesterday, "
  "Wednesday the 13th, is ringed in red: “HARVEST MOON. Pie for the "
  "Professor when he gets in off the last train.”",
  icon: Icons.calendar_month, color: paper,
);

const timetable = Evidence(
  'timetable', 'Railway Timetable', 'porch', 1,
  "The Candy Line timetable, pinned by the front door. The last train leaves "
  "Candy City at 11:20 PM, and reaches Kernel Halt at 11:48 PM. It is a "
  "twenty-minute walk from the halt to the farm.",
  icon: Icons.train, color: paper,
);

// Red herrings

const bigSugar = Evidence(
  'bigsugar', 'Letter from Big Sugar', 'frontroom', 1,
  "Pushed down the side of the settee, a letter on thick cream paper: "
  "“Dear Miss Popwell. Big Sugar & Co. renews its offer for the Kernel "
  "farm, should it ever be yours to sell.”",
  icon: Icons.mail, color: paper,
);

const oldWill = Evidence(
  'oldwill', "Farmer Kernel's Will", 'office', 2,
  "On the farmer's desk, a copy of his will, dog-eared: “The farm, "
  "the corn and the cows to my daughter, Lolly.” The cows are underlined.",
  icon: Icons.description, color: Colors.white,
);

const contest = Evidence(
  'contest', 'Talent Contest Entry', 'frontroom', 7,
  "Tucked in the frame of Lolly's looking glass, an entry form for the Candy City Talent Contest, "
  "stamped FEE OVERDUE in red. The fee would buy a cow.",
  icon: Icons.mic, color: Color(0xFFF8BBD0),
);

const cinnamonFork = Evidence(
  'cinnamonfork', 'Red Pitchfork', 'barn', 0,
  "Gus's pitchfork, leaning on a stall. The tines are smeared with "
  "something dark red and sticky.",
  icon: Icons.agriculture, color: Color(0xFFEF9A9A),
);

const honeyJar = Evidence(
  'honeyjar', 'Broken Honey Jar', 'fkitchen', 5,
  "A jar of honey smashed on the kitchen floor, and a trail of sticky "
  "footprints leading away from it toward the front room.",
  icon: Icons.water_drop, color: Color(0xFFFFB74D),
);

const licoriceLace = Evidence(
  'licoricelace', 'Liquorice Strands', 'office', 4,
  "Black liquorice strands caught in the farmer's leather chair, and a "
  "faint smell of aniseed.",
  icon: Icons.gesture, color: Color(0xFF424242),
);

const wagesDocked = Evidence(
  'wagesdocked', 'Wages Book', 'office', 1,
  "The farm wages book, open on the shelf. “T. Pulman. Docked one week, "
  "for breaking the puller handle. Again.”",
  icon: Icons.menu_book, color: Color(0xFFD7CCC8),
);

const weedKiller = Evidence(
  'weedkiller', 'Bottle Marked POISON', 'greenhouse', 2,
  "A brown bottle on a high shelf in the greenhouse, with a skull drawn on the "
  "label and “POISON” underneath, in a very scientific hand.",
  icon: Icons.science, color: Color(0xFFA5D6A7),
);

const raffle = Evidence(
  'raffle', 'Raffle Tickets', 'barn', 3,
  "Pinned to a beam, a strip of fifty raffle tickets for the county fair. "
  "First prize: a tractor. Every ticket has Gus's name on it.",
  icon: Icons.confirmation_number, color: paper,
);

const markedCards = Evidence(
  'cards', 'Marked Cards', 'frontroom', 2,
  "A pack of playing cards on the card table. Every ace has a tiny pin "
  "prick in one corner.",
  icon: Icons.style, color: Colors.white,
);

const lollyDiary = Evidence(
  'lollydiary', "Lolly's Diary", 'frontroom', 0,
  "In the drawer of her dressing table, a diary with a heart-shaped lock, left open. "
  "Yesterday's entry: “Daddy says the city will chew me up. I said I'd "
  "rather be chewed up than stay a stalk in a field forever.”",
  icon: Icons.book, color: Color(0xFFF8BBD0), inside: 'vanity',
);

const hotelLetter = Evidence(
  'hotelletter', 'Letter from a Hotel', 'fkitchen', 0,
  "In Marsha's recipe box: “The Grand Sugar Hotel, Candy City, is pleased "
  "to offer Miss M. Mallow the post of pastry cook, to begin at once.” "
  "There is no reply with it.",
  icon: Icons.mail, color: paper, inside: 'recipebox',
);

const lovePoem = Evidence(
  'lovepoem', 'A Poem', 'pressroom', 5,
  "Pinned over Taffy's bunk, in a painfully careful hand: “Your stripes "
  "are pink, your stick is true, I'd pull all night for a lick of you.” "
  "It is addressed to “L.”",
  icon: Icons.favorite, color: Color(0xFFF48FB1),
);

/// The red herrings of every farm mystery, but for those it needs for
/// itself.
const farmHerrings = [
  bigSugar, oldWill, contest, cinnamonFork, honeyJar, licoriceLace,
  wagesDocked, weedKiller, raffle, markedCards, lollyDiary, hotelLetter,
];

// Things handed over when asked.

const fchart = Evidence.given(
  'fchart', 'Fingerprint Card', 'butterscotch',
  "A card from the Candy Land Constabulary with the fingerprints of all "
  "five on the farm, taken this morning. With it I can dust the murder "
  "weapon and see who has handled it.",
  icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
);

const bakeCard = Evidence.given(
  'bakecard', 'Bake Card', 'marsha',
  "Marsha's bake card for last night, in pencil: “Harvest Moon Pie. IN "
  "10:30. Turned every 3 minutes. OUT 11:30. Not a scorch on her.”",
);

const sheriffChart = Topic(
  'chart', 'May I borrow your fingerprint card?',
  "Take it. We printed all five of them at breakfast and the farmhand "
  "nearly pulled my arm off shaking hands after. Find the weapon, dust "
  "it, and see whose prints come up. A print tells you who touched a "
  "thing. It doesn't tell you when.",
  gives: fchart,
);

const sheriffHome = Topic(
  'home', 'Who was on the farm last night?',
  "The five who live here, Detective, and nobody else: the gate was "
  "chained at ten and the dogs from Nougat's place would have raised the "
  "county. One of them did this — or two of them together. Mind you, "
  "they've all got a reason, and most of the mess round here is just a "
  "farm being a farm.",
);

const deputyTopics = [
  Topic(
    'when', 'When did he die?',
    "Cold as a cucumber when we got here at seven, sir. Some time round "
    "eleven last night, the Sheriff says. Find something that pins it "
    "down and you'll beat us to it.",
  ),
  Topic(
    'found', 'Who found him?',
    "Miss Mallow, the cook, at six, when she came down for potatoes. She "
    "rang the exchange from the front room and they rang us. She's been "
    "baking ever since. We've had nine scones each.",
  ),
  Topic(
    'advice', 'Any advice, Deputy?',
    "The Sheriff says never believe an alibi till something else backs it "
    "up, sir. A slip, a clock, somebody with no reason to lie. And when "
    "one of them tells you a thing, go and put it to the others.",
  ),
];

// What each of them says in every mystery, where it is true.

const marshaWhere = Topic(
  'where', whereQ,
  "In my kitchen from half past ten till half past eleven, turning my "
  "Harvest Moon Pie every three minutes, or it catches on the one side. "
  "Then I went up to bed. I didn't go down to the cellar till six.",
);

const marshaCard = Topic(
  'card', 'May I see your bake card?',
  "Of course you may, dear. I write up every bake. I've nothing to hide "
  "but a very good pastry.",
  needs: ['harvestpie'],
  gives: bakeCard,
);

const marshaCommon = [
  Topic(
    'honey', 'There is honey all over your floor.',
    "That was me, this morning, when I found him. I came in from the yard "
    "like a bolting rabbit and knocked the jar flying. I've not had the "
    "heart to mop it.",
    needs: ['honeyjar'],
  ),
  Topic(
    'hotel', 'The Grand Sugar Hotel has offered you a post.',
    "Three weeks ago, and I've been carrying that letter about like a hot "
    "coal. I wasn't going to take it. Who'd turn the Professor's pie?",
    needs: ['hotelletter'],
  ),
];

const gusWhere = Topic(
  'where', whereQ,
  "In the barn, milking. Eleven o'clock every night, rain or shine, and "
  "the creamery man takes the churns from me at the barn door. Then I "
  "bedded down in the loft.",
);

const gusCommon = [
  Topic(
    'fork', 'What is that on your pitchfork?',
    "Cinnamon, Detective. I mucked out the red-hot pigs yesterday. Lick it "
    "if you don't believe me. ...Wouldn't, though. Burns.",
    needs: ['cinnamonfork'],
  ),
  Topic(
    'raffle', 'Fifty raffle tickets, all in your name.',
    "A tractor, Detective. A red one. I've wanted a tractor since I was a "
    "seedling. A man's allowed one weakness.",
    needs: ['raffle'],
  ),
  Topic(
    'cards', 'Somebody has marked the aces.',
    "The Farmer did that himself. Every Sunday for twenty years he took my "
    "wages back off me at cards, and every Sunday I let him. You don't tell "
    "a man that age you know.",
    needs: ['cards'],
  ),
];

const lollyWhere = Topic(
  'where', whereQ,
  "On the telephone in the front room, from ten to eleven till half past, "
  "with the Talent Bureau in Candy City. They do auditions down the line "
  "at night. I sang the whole of “Sweet on the City”. Twice.",
);

const lollyCommon = [
  Topic(
    'bigsugar', 'Big Sugar want to buy the farm from you.',
    "They write every month. They want it for a factory. I'd sell it to "
    "them tomorrow and take the train to the city, and Daddy knew it. But "
    "it was never mine to sell.",
    needs: ['bigsugar'],
  ),
  Topic(
    'will', 'The will leaves everything to you.',
    "And the cows. Especially the cows. He changed it every time we "
    "quarrelled, and changed it back the next Sunday. Ask Gus.",
    needs: ['oldwill'],
  ),
  Topic(
    'contest', 'Your contest fee is overdue.',
    "Everything I have is overdue, darling. That's what it is to be an "
    "artist on a farm.",
    needs: ['contest'],
  ),
  Topic(
    'diary', 'Your diary says the city will chew you up.',
    "He said it, I wrote it down. That's not a motive, that's a lyric.",
    needs: ['lollydiary'],
  ),
];

const taffyWhere = Topic(
  'where', whereQ,
  "In the press shed, crankin' the puller, from twenty to eleven till "
  "twenty to twelve. Stop crankin' for two minutes and the batch sets "
  "like glass. Counter on the side'll tell you.",
);

const taffyCommon = [
  Topic(
    'wages', 'The Farmer docked your wages.',
    "Handle snapped off in my hand. Third time. I'm strong, Detective. I "
    "don't know my own strength. He docked me a week and I said fair "
    "enough. It was fair enough.",
    needs: ['wagesdocked'],
  ),
];

const taffyPoem = Topic(
  'poem', 'Who is the poem for?',
  "That's private. ...It's for Miss Lolly. She don't know. She's goin' "
  "to the city, and I'm stayin' here with the corn. That's how it is.",
  needs: ['lovepoem'],
);

const licoriceWhere = Topic(
  'where', whereQ,
  "In Candy City, at the University, until the last train. I came in at "
  "ten to twelve, soaked to the stick, and went straight to my cot in the "
  "greenhouse. Marsha had "
  "left a pie out. I didn't touch it. I was too tired.",
);

const licoriceCommon = [
  Topic(
    'lace', "Your liquorice is all over the Farmer's chair.",
    "I read in that chair every evening while he did the accounts. We "
    "argued about corn. He was wrong about everything and I shall miss "
    "him terribly.",
    needs: ['licoricelace'],
  ),
  Topic(
    'poison', 'You keep a bottle of poison.',
    "Weedkiller, for the aphids in my seed trays. If I wished to poison "
    "anyone, Detective, I should hardly label the bottle with a skull.",
    needs: ['weedkiller'],
  ),
];
