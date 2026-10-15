import 'package:flutter/material.dart';

import 'common.dart' show paper, aboutQ, suspectQ;
import 'farm_common.dart';
import 'models.dart';

/// A single killer, who says he was not even on the farm.
const moonCase = MysteryCase(
  id: 'fmoon',
  title: 'Under the Harvest Moon',
  culprits: {'licorice'},
  nextVictims: ['marsha', 'gus', 'lolly', 'taffy'],
  herringCount: 10,
  solution:
      "Farmer Kernel had found out that Professor Licorice's famous rainbow "
      "corn was grown from seed stolen out of the Kernel seed chest, and he "
      "meant to go to the University on Friday and say so. The Professor "
      "said he spent the evening in Candy City and came home on the last "
      "train. In fact he came home at six, kept to his room, and at eleven "
      "crept down the back stairs with the Giant Gobstopper from the "
      "trophy shelf. At 11:05 he struck the farmer with it in the root "
      "cellar, and hid it. The ticket he showed was for the next day's "
      "train, and the guard had never punched it. His umbrella had stood "
      "dry in the hall since nine, and Lolly, on the landing telephone, "
      "heard his door at eleven. Marsha was at her pie, Taffy at the "
      "puller, and Gus at the barn door with the creamery man.",
  core: [
    Evidence(
      'trophygap', 'Gap on the Trophy Shelf', 'frontroom', 0,
      "The trophy shelf over the hearth. Between two silver cups, a round "
      "ring in the dust where the Giant Gobstopper sat: Best in Show, "
      "1902, and heavy as a cannonball. It is gone.",
      icon: Icons.emoji_events, color: gold2,
    ),
    harvestPie,
    creamSlip,
    partyLine,
    Evidence(
      'puller', 'Taffy Puller', 'pressroom', 1,
      "The taffy puller. Its counter reads 1,190 pulls since the batch went "
      "in at 10:40, and the batch came out at 11:40 as soft as a pillow. A "
      "brass plate on the side: “Hand-cranked. Twenty pulls a minute. Do "
      "not force.”",
      icon: Icons.settings, color: Color(0xFFF48FB1),
    ),
    calendar,
    Evidence(
      'fplanner', "Farmer's Daybook", 'office', 0,
      "Farmer Kernel's daybook, locked in the rolltop. Friday's page: "
      "“Candy City. The University. Take the seed tags, and say it to "
      "their faces.”",
      icon: Icons.event_note, color: paper, inside: 'rolltop',
    ),
  ],
  variants: [
    farmTimeOfDeath,
    [
      Evidence(
        'umbrella', 'Dry Umbrella', 'fhall', 3,
        "In the stand by the front door, an umbrella with a black liquorice "
        "handle, labelled R.L. It is furled tight and bone dry. It has not "
        "been out in the rain at all.",
        icon: Icons.umbrella, color: Color(0xFF424242),
      ),
      Evidence(
        'spats', 'Clean Spats', 'profroom', 0,
        "Under the Professor's bed, his spats: pressed, white, and "
        "spotless. There is not a speck of syrup or mud on them.",
        icon: Icons.hiking, color: Colors.white,
      ),
    ],
    [
      Evidence(
        'aniseed', 'Liquorice on a Nail', 'rootcellar', 1,
        "A strand of black liquorice snagged on a nail at the foot of the "
        "cellar steps. It lies on top of the spilled candy corn, so it came "
        "after the struggle.",
        icon: Icons.gesture, color: Color(0xFF424242),
      ),
      Evidence(
        'stilts', 'Thin Footprints', 'rootcellar', 2,
        "Footprints in the spilled sugar, long and thin and very close "
        "together, as though made by somebody walking on two sticks. They "
        "are on top of the scattered corn.",
        icon: Icons.directions_walk, color: Color(0xFFBCAAA4),
      ),
    ],
    [
      Evidence(
        'gobcrawl', 'Giant Gobstopper', 'rootcellar', 0,
        "Pushed to the back of the crawlspace: the Giant Gobstopper, its "
        "rainbow rings dulled, and a crust of candy corn on one side. It "
        "wants dusting for fingerprints.",
        inside: 'crawlspace',
      ),
      Evidence(
        'gobfurrow', 'Giant Gobstopper', 'cornfield', 0,
        "Buried in the turned furrow: the Giant Gobstopper, its rainbow "
        "rings dulled, and a crust of candy corn on one side. It wants "
        "dusting for fingerprints.",
        inside: 'furrow',
      ),
    ],
    [
      Evidence(
        'uniletter', 'Letter to the University', 'office', 0,
        "In the rolltop, in the farmer's hand: “Sirs. Your Professor "
        "Licorice's rainbow corn is my own seed, taken out of my seed "
        "chest. I shall come on Friday and prove it.”",
        icon: Icons.mail, color: paper, inside: 'rolltop',
      ),
      Evidence(
        'seedtags', 'Seed Packets', 'profroom', 0,
        "In the specimen cabinet, packets marked “R. Licorice. Rainbow "
        "Hybrid.” Under each new label, the old one shows through: "
        "“KERNEL FARM. NOT FOR SALE.”",
        icon: Icons.grain, color: Color(0xFFFFCC80), inside: 'specimens',
      ),
    ],
  ],
  herrings: [...farmHerrings, lovePoem],
  weapons: {'gobcrawl', 'gobfurrow'},
  printsOn: ['lolly', 'licorice'],
  prints: Evidence.given(
    'prints', 'Prints on the Gobstopper', 'churlock',
    "Two sets of prints came up under the powder. Lolly Popwell's are "
    "faint and all over it. Professor Licorice's are one long, thin hand, "
    "wrapped round the rings.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1871',
  hints: {
    ...farmHints,
    'trophygap': "Heavy, and round, and gone. Who in this house dusts that "
        "shelf, and who sits by it?",
    'calendar': "The night of the harvest moon was a Wednesday, then. "
        "Remember that, the next time anybody shows you a date.",
    'puller': "A machine that counts, at a rate written on the side. That "
        "is the farmhand placed, I should say.",
    'fplanner': "Friday, and the University. So somebody at the "
        "University was about to have a very bad Friday.",
    'umbrella': "Bone dry, in a night of rain. Who told us they came home "
        "soaked to the stick?",
    'spats': "Spotless, in a night of rain and mud. Who told us they came "
        "home soaked to the stick?",
    'aniseed': "On top of the corn, so after he fell. Marsha knows every "
        "dessert in this house. Ask her whose that is.",
    'stilts': "On top of the corn, so after he fell. Marsha knows every "
        "dessert in this house. Ask her who walks like that.",
    'gobcrawl': "Hidden in a hurry, by somebody who knew the dark corners. "
        "I should dust it.",
    'gobfurrow': "Buried in the field, by somebody who knew where the "
        "earth was soft. I should dust it.",
    'uniletter': "A man about to be shown up as a thief. That is a motive, "
        "and an urgent one. But was he here to act on it?",
    'seedtags': "New labels over old. That is a motive, and an urgent "
        "one. But was he here to act on it?",
    'ticket': "Read every word of it, Churlock, the small print most of "
        "all, and then go and look at the kitchen calendar.",
    'prints': printsHintFarm,
  },
  accuseHints: [
    "Before you name anyone, Churlock: do we know the very minute he died? "
        "Then find where each of the five was at that minute.",
    "Four of them can be placed by a slip of paper or a machine. One says "
        "he was not on the farm at all. Is there anything that proves it?",
    "Look at what was left in the cellar, and at the weapon once it is "
        "dusted. Then ask Marsha who it could belong to.",
    "A ticket is only proof if it is the right ticket, old chap. Read the "
        "date, look for the guard's punch, and then ask who was on the "
        "landing at eleven and what they heard.",
  ],
  topics: {
    'butterscotch': [
      Topic(
        'what', 'What happened to him?',
        "Victim's Cornelius Kernel, the candy corn king. One blow to the "
        "back of the head with something round and heavy as a cannonball. "
        "Knocked him clean off his tip. We traced where he fell in icing "
        "sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Something round, heavy and hard. Bigger than a fist. It isn't "
        "down here.",
      ),
      sheriffHome,
      Topic(
        'creamery', 'Can the creamery man vouch for Gus?',
        "I rang them first thing. Fudge, the driver, says Gus handed him "
        "four churns at the barn door on the stroke of eleven and talked "
        "his ear off about tractors.",
        heard: ['gus/where'],
      ),
      sheriffChart,
    ],
    'jellybean': [
      ...deputyTopics,
      Topic(
        'train', 'Did the Professor come in on the last train?',
        "The station master says nobody got off at Kernel Halt last night "
        "at all, sir. Not a soul. He waited in the rain to wave at them, "
        "and he's cross about it.",
        heard: ['licorice/where'],
      ),
    ],
    'marsha': [
      marshaWhere,
      Topic(
        'about', aboutQ,
        "Gruff, and a bit of a crust on him, but soft in the middle. He'd "
        "taken against the Professor this week. Wouldn't say why. Ate his "
        "pie in the office with the door shut.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to say it. But Gus has been in a black mood since "
        "Sunday's card game, and he's strong as an ox.",
      ),
      Topic(
        'umbrella', "The Professor's umbrella is dry.",
        "Is it? It was in the stand when I locked up at nine, I remember, "
        "because I thought: he'll get drenched in town without it. And I "
        "never heard him come in at all. I'd left the pie out.",
        needs: ['umbrella', 'spats'],
      ),
      Topic(
        'trace', 'Whose is this, left by the body?',
        "Liquorice. Black liquorice, and long legs like a heron's. That's "
        "the Professor and nobody else on this farm. But he was in town, "
        "wasn't he?",
        needs: ['aniseed', 'stilts'],
      ),
      Topic(
        'pie', 'Did the Professor eat his pie?',
        "Not a crumb. It was there on the sill at six, cold. That's not "
        "like him. He'd eat a pie in his sleep.",
        heard: ['licorice/where'],
      ),
      marshaCard,
      ...marshaCommon,
    ],
    'gus': [
      gusWhere,
      Topic(
        'about', aboutQ,
        "Best farmer in Candy Land, and knew it. Took my wages back off me "
        "at cards every Sunday for twenty years. I'd do it all again.",
      ),
      Topic(
        'suspect', suspectQ,
        "The city folk. The Professor, if you ask me, with his little "
        "packets and his locked cabinet. I saw his lamp burning at half "
        "past ten from the barn. Thought he'd left it on.",
      ),
      Topic(
        'seed', "Somebody took seed from the farmer's chest.",
        "The rainbow seed. Kernel bred that himself, ten years in the "
        "back field. He found the chest half empty on Sunday and nearly "
        "had a seizure. Said he knew who.",
        needs: ['uniletter', 'seedtags', 'fplanner'],
      ),
      ...gusCommon,
    ],
    'lolly': [
      lollyWhere,
      Topic(
        'about', aboutQ,
        "Daddy? Stubborn as a stalk. He wanted me on the farm and I wanted "
        "the city. We fought about it every single day, and I'd give "
        "anything for one more fight.",
      ),
      Topic(
        'suspect', suspectQ,
        "Taffy, I suppose. He's strong enough to lift a cow, and Daddy "
        "docked his wages. ...No. Not Taffy. I don't know.",
      ),
      Topic(
        'footsteps', 'Did anyone pass you on the landing?',
        "Nobody passed me. But the Professor's door went at eleven, I'm "
        "sure of it: it squeals on the second creak. And something went "
        "down the back stairs on two thin feet. I thought it was the "
        "Professor's cat. He hasn't got a cat.",
        needs: ['partyline'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the gobstopper.',
        "I dust that shelf every Sunday. It's my one chore. Daddy said a "
        "girl who wants to be a star can start by polishing his.",
        needs: ['prints'],
      ),
      ...lollyCommon,
    ],
    'taffy': [
      taffyWhere,
      Topic(
        'about', aboutQ,
        "Fair man. Hard, but fair. Docked me when I broke things, paid me "
        "when I didn't. I break a lot of things.",
      ),
      Topic(
        'suspect', suspectQ,
        "Couldn't say. I was crankin'. You don't look up when you're "
        "crankin'.",
      ),
      taffyPoem,
      ...taffyCommon,
    ],
    'licorice': [
      licoriceWhere,
      Topic(
        'about', aboutQ,
        "A brilliant farmer and an impossible man. We disagreed about "
        "everything, from crossing to kernels. I shall miss our arguments.",
      ),
      Topic(
        'suspect', suspectQ,
        "Statistically, Detective, the foreman. They always have keys to "
        "everything, and grudges to match.",
      ),
      Topic(
        'proof', 'Can you prove you came home on the last train?',
        "Naturally. I keep my tickets: one never knows when one will be "
        "asked to account for one's movements by a churro. Here.",
        gives: Evidence.given(
          'ticket', 'Railway Ticket', 'licorice',
          "The Professor's ticket: “Candy Line Railway. Candy City to "
          "Kernel Halt. Last train, 11:20 PM. Thursday the 14th.” The card "
          "is crisp, and nobody has punched it.",
          icon: Icons.train,
        ),
      ),
      Topic(
        'umbrella', 'Your umbrella never left the hall.',
        "I bought another in town. A cheap one. It turned inside out at "
        "the station and I threw it in a hedge. ...A large hedge.",
        needs: ['umbrella', 'spats'],
      ),
      Topic(
        'station', 'Nobody got off the last train at Kernel Halt.',
        "The station master is a short-sighted gumball with a grudge. I "
        "got off at the far end of the platform. In the dark.",
        heard: ['jellybean/train'],
      ),
      Topic(
        'door', 'Lolly heard your door at eleven.',
        "The house settles, Detective. Old timber. Every door here squeals "
        "when the wind gets up.",
        heard: ['lolly/footsteps'],
      ),
      Topic(
        'seed', 'Your rainbow corn is grown from his seed.',
        "Seed is seed, Detective. What matters is what one does with it. "
        "He grew candy corn. I was going to change the world.",
        needs: ['uniletter', 'seedtags'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the gobstopper.',
        "I examined it on Sunday. A remarkable example of concentric "
        "crystallisation. I am a scientist. I touch things.",
        needs: ['prints'],
      ),
      ...licoriceCommon,
    ],
  },
);

/// The colour of a missing trophy.
const gold2 = Color(0xFFFFD54F);

/// What Watsonut makes of prints on a weapon, on the farm.
const printsHintFarm =
    "A print tells you who touched a thing, and where they held it. Not "
    "when, and not why. Put it to each of them in turn, old chap, and then "
    "see whether the rest of the farm agrees.";
