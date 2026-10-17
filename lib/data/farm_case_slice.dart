import 'package:flutter/material.dart';

import 'common.dart' show paper, whereQ, aboutQ, suspectQ;
import 'farm_case_moon.dart' show printsHintFarm;
import 'farm_common.dart';
import 'models.dart';

/// Two killers: the cook, whose pie went unturned, and the lodger, who was
/// never on the train.
const sliceCase = MysteryCase(
  id: 'fslice',
  title: 'A Slice Too Many',
  culprits: {'marsha', 'licorice'},
  nextVictims: ['gus', 'lolly', 'taffy'],
  herringCount: 13,
  solution:
      "Marsha Mallow and Professor Licorice had sold the Kernel candy corn "
      "recipe and seed to Big Sugar, half each, and Farmer Kernel had found "
      "the letters. The Professor never took the last train: he came home "
      "early and kept to his room, and his ticket was never punched. At "
      "five to eleven Marsha left her pie and took the farmer down to the "
      "tornado shelter for a look at the corn, and at 11:05 the Professor "
      "struck him with her iron skillet. Her pie went a quarter of an hour "
      "unturned and burnt black on one side, and two slices were gone from "
      "it by midnight. The bake card she produced has the Professor coming "
      "in off the last train at twenty past eleven, when the timetable on "
      "the porch has that train leaving Candy City at that very minute. "
      "Lolly was on the telephone, Taffy at the puller, and Gus at the barn "
      "door with the creamery man.",
  core: [
    Evidence(
      'harvestpie', 'Harvest Pie', 'fkitchen', 1,
      "Marsha's Harvest Moon Pie, which must be turned in the oven every "
      "three minutes. The lattice is golden, but tip it up and one side of "
      "the bottom is burnt black. Two slices are gone.",
      icon: Icons.cake, color: Color(0xFFFFCC80),
    ),
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
    timetable,
    Evidence(
      'ticket', 'Railway Ticket', 'greenhouse', 1,
      "On the Professor's potting bench, a railway ticket: “Candy Line Railway. "
      "Candy City to Kernel Halt. Last train, 11:20 PM. Wednesday the "
      "13th.” Nobody has punched it.",
      icon: Icons.train, color: paper,
    ),
    Evidence(
      'skilletgap', 'Empty Hook', 'fkitchen', 2,
      "Over the hearth, a row of iron pans on hooks, graded by size. The "
      "biggest hook is empty, and there is a clean round mark on the wall "
      "where the great skillet hangs.",
      icon: Icons.soup_kitchen, color: Color(0xFF90A4AE),
    ),
  ],
  variants: [
    farmTimeOfDeath,
    [
      Evidence(
        'twoplates', 'Two Plates', 'fkitchen', 4,
        "On the counter, two plates with pie crumbs on them, and two forks. "
        "One fork is a little cake fork. The other has been licked clean, "
        "and there is a black, aniseed-smelling smear on the handle.",
        icon: Icons.restaurant, color: Color(0xFFE0E0E0),
      ),
      Evidence(
        'pietin', 'Pie Slices', 'fkitchen', 6,
        "On the kitchen dresser, two slices of Harvest Moon Pie on a "
        "saucer, and a long black liquorice hair stuck to the crust of one.",
        icon: Icons.cake, color: Color(0xFFFFCC80),
      ),
    ],
    [
      Evidence(
        'skilletcrawl', 'Iron Skillet', 'rootcellar', 0,
        "Pushed to the back of the escape tunnel: the great iron skillet from "
        "the kitchen, wiped, with a crust of candy corn baked into the rim. "
        "It wants dusting for fingerprints.",
        inside: 'crawlspace',
      ),
      Evidence(
        'skilletvat', 'Iron Skillet', 'pressroom', 0,
        "Sunk at the bottom of the syrup vat: the great iron skillet from "
        "the kitchen, with a crust of candy corn on the rim. It wants "
        "dusting for fingerprints.",
        inside: 'vat',
      ),
    ],
    [
      Evidence(
        'recipesale', 'Letter from Big Sugar', 'fkitchen', 0,
        "In Marsha's recipe box, under the scones: “Big Sugar & Co. "
        "acknowledges the Kernel candy corn recipe, received from M.M. The "
        "balance follows on delivery of the seed from R.L. Half each.”",
        icon: Icons.mail, color: paper, inside: 'recipebox',
      ),
      Evidence(
        'seedbig', 'Seed Packet', 'greenhouse', 0,
        "In the specimen cabinet, a fat packet of seed addressed to Big "
        "Sugar & Co., and a note pinned to it in two hands: “Our half on "
        "delivery. M.” “And mine. R.”",
        icon: Icons.grain, color: Color(0xFFFFCC80), inside: 'specimens',
      ),
    ],
    [
      Evidence(
        'flourhand', 'Floury Handprint', 'rootcellar', 1,
        "A soft, floury handprint on the shelter rail, and beside it on the "
        "step a long strand of black liquorice. Both are on top of the "
        "spilled candy corn.",
        icon: Icons.back_hand, color: Colors.white,
      ),
      Evidence(
        'twotracks', 'Footprints on the Steps', 'rootcellar', 2,
        "In the spilled sugar on the shelter steps, two trails of prints: "
        "one round and puffy, one long and thin, as if on a stick. They are "
        "on top of the scattered corn.",
        icon: Icons.directions_walk, color: Color(0xFFBCAAA4),
      ),
    ],
  ],
  herrings: [...farmHerrings, lovePoem],
  weapons: {'skilletcrawl', 'skilletvat'},
  printsOn: ['marsha', 'licorice'],
  prints: Evidence.given(
    'prints', 'Prints on the Skillet', 'churlock',
    "Two sets of prints came up under the powder. Marsha Mallow's are soft "
    "and round, all over the handle. Professor Licorice's are one long, "
    "thin hand, round the handle above hers.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1874',
  hints: {
    ...farmHints,
    ...farmPhoneHints,
    'harvestpie': "Burnt on one side, Churlock. A pie that must be turned "
        "every three minutes went a good while without it. Who was "
        "supposed to be turning it?",
    'puller': "A machine that counts, at a rate written on its own side, "
        "and a batch that came out soft. That places the farmhand, I "
        "should say.",
    'timetable': "Leaves at twenty past eleven, arrives twelve minutes to "
        "midnight. Remember that the next time anybody tells you when a "
        "train came in.",
    'ticket': "Read every word of it, old chap. A guard punches a ticket "
        "when it is used.",
    'skilletgap': "Heavy, and iron, and gone from the cook's own wall.",
    'twoplates': "Two forks, Churlock. Somebody had company over pie, and "
        "one of them leaves a black smear.",
    'pietin': "Two slices, and a liquorice hair in one. Who was eating pie "
        "with the cook at midnight?",
    'skilletcrawl': "Hidden in the dark, by somebody who knew where the "
        "dark was. I should dust it.",
    'skilletvat': "Sunk in the syrup, by somebody who hoped it would stay "
        "there. I should dust it.",
    'recipesale': "Two sets of initials, and half each. That is a "
        "partnership, old chap.",
    'seedbig': "Two notes in two hands on one packet. That is a "
        "partnership, old chap.",
    'flourhand': "Flour, and liquorice, side by side on top of the corn.",
    'twotracks': "Two trails, side by side, of two very different feet.",
    'bakecard': "Read it line by line against the timetable on the porch, "
        "Churlock.",
    'prints': printsHintFarm,
  },
  accuseHints: [
    "Before you name anyone, Churlock: do we know the very minute he died? "
        "Then find where each of the five was at that minute.",
    "Three of them are placed by a telephone slip, a creamery slip and a "
        "machine. The other two are placed by a pie and a train. Look at "
        "both of those very hard.",
    "The pie was burnt, and the ticket was never punched. And somebody "
        "ate pie with the cook before midnight.",
    "Read Marsha's bake card against the timetable by the front door. A "
        "train cannot arrive the minute it leaves. Name them both.",
  ],
  topics: {
    'butterscotch': [
      Topic(
        'what', 'What happened to him?',
        "Victim's Cornelius Kernel, the candy corn king. One flat, heavy "
        "blow to the back of the head. Something with a handle, I'd say. "
        "We traced where he fell in icing sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Flat, heavy, iron, with a handle. A spade, maybe. Or a pan. It "
        "isn't down here.",
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
      Topic(
        'where', whereQ,
        "In my kitchen from half past ten till half past eleven, turning my "
        "Harvest Moon Pie every three minutes. The Professor came in off "
        "the train at twenty past and I gave him a slice. Then I went to bed.",
      ),
      Topic(
        'about', aboutQ,
        "Gruff, and a bit of a crust on him. He'd been through my recipe "
        "box on Monday. Said he was looking for scones. He wasn't.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to say it. But Gus has been in a black mood since "
        "Sunday's card game, and he's strong as an ox.",
      ),
      Topic(
        'burnt', 'Your pie is burnt on one side.',
        "Oh! Is it? I... I must have been talking. The Professor came in "
        "and I was cutting his slice, and I forgot it. Just the once.",
        needs: ['harvestpie'],
      ),
      Topic(
        'card', 'May I see your bake card?',
        "Of course you may, dear. I write up every bake. There. It's all "
        "there.",
        gives: Evidence.given(
          'bakecard', 'Bake Card', 'marsha',
          "Marsha's bake card for last night, in pencil: “Harvest Moon Pie. "
          "IN 10:30. Turned every 3 minutes. 11:20, the Professor in off "
          "the last train, cut him a slice. OUT 11:30.”",
        ),
      ),
      Topic(
        'big', 'You sold the farm recipe to Big Sugar.',
        "It was my recipe as much as his! Thirty years I've made his corn "
        "taste of something. He never paid me a cube for it.",
        needs: ['recipesale', 'seedbig'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the skillet.',
        "It's my skillet, dear. I fry his breakfast in it every morning "
        "of my life.",
        needs: ['prints'],
      ),
      ...marshaCommon,
    ],
    'gus': [
      gusWhere,
      Topic(
        'about', aboutQ,
        "Best farmer in Candy Land, and knew it. He'd caught somebody "
        "selling his secrets, he told me on Sunday. Wouldn't say who. Said "
        "he'd be at the post office Friday.",
      ),
      Topic(
        'suspect', suspectQ,
        "City folk. I saw the Professor's lamp burning at half past ten, "
        "from the barn. Thought he'd left it on.",
      ),
      ...gusCommon,
    ],
    'lolly': [
      lollyWhere,
      Topic(
        'about', aboutQ,
        "Daddy? Stubborn as a stalk. He was in a fury on Monday about his "
        "recipe. Kept saying he'd been robbed from inside his own house.",
      ),
      Topic(
        'suspect', suspectQ,
        "Gus, I suppose. Daddy took his wages every Sunday for twenty "
        "years.",
      ),
      Topic(
        'smell', 'Did you notice anything from the front room?',
        "Burning. At quarter past eleven, burning pie, through the kitchen "
        "door. Marsha never burns anything. And two voices out in the yard, "
        "very low, going down.",
        needs: ['partyline'],
      ),
      ...lollyCommon,
    ],
    'taffy': [
      taffyWhere,
      Topic(
        'about', aboutQ,
        "Fair man. Hard, but fair. Docked me when I broke things.",
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
        "A brilliant farmer and an impossible man. He kept his recipe in "
        "his head and said so, as though that were something to be proud "
        "of.",
      ),
      Topic(
        'suspect', suspectQ,
        "Statistically, Detective, the foreman. They always have keys to "
        "everything, and grudges to match.",
      ),
      Topic(
        'ticket', 'Your ticket was never punched.',
        "The guard was asleep, Detective. It was the last train. Even "
        "guards sleep.",
        needs: ['ticket'],
      ),
      Topic(
        'station', 'Nobody got off the last train at Kernel Halt.',
        "The station master is a short-sighted gumball with a grudge. I "
        "got off at the far end of the platform. In the dark.",
        heard: ['jellybean/train'],
      ),
      Topic(
        'pie', 'You ate pie with Marsha before midnight.',
        "A slice. One cannot refuse Marsha. It would be like refusing the "
        "weather.",
        needs: ['twoplates', 'pietin'],
      ),
      Topic(
        'big', 'You sent the farm seed to Big Sugar.',
        "Science must be funded somehow, Detective. He would never have "
        "shared it. Seed wants to be grown.",
        needs: ['recipesale', 'seedbig'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the skillet.',
        "Marsha let me fry an egg. Once. I am a scientist. I do not cook, "
        "but I am curious.",
        needs: ['prints'],
      ),
      ...licoriceCommon,
    ],
  },
);
