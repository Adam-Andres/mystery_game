import 'package:flutter/material.dart';

import 'common.dart' show paper, whereQ, aboutQ, suspectQ;
import 'farm_case_moon.dart' show printsHintFarm;
import 'farm_common.dart';
import 'models.dart';

/// Two killers, who are each other's only alibi, and a machine that kept
/// on working for them.
const pullCase = MysteryCase(
  id: 'fpull',
  title: 'Pulled Together',
  culprits: {'lolly', 'taffy'},
  nextVictims: ['gus', 'marsha', 'licorice'],
  herringCount: 13,
  solution:
      "Lolly Popwell and Taffy Pulman were secretly engaged, and Farmer "
      "Kernel had found out. He meant to dismiss Taffy on Saturday and "
      "swore his daughter would never marry a farmhand while he lived. They "
      "said they spent the evening together in the press shed, Taffy "
      "cranking the puller while Lolly watched. But at twenty to eleven "
      "Taffy belted the puller to the windmill shaft, and it cranked "
      "itself, faster than any hand could, all night. Together they "
      "carried a barrel of rock candy to the top of the shelter steps and "
      "at 11:05 rolled it down onto the farmer. The tally Taffy produced "
      "counts 3,412 pulls in an hour, on a machine whose own brass plate "
      "says no hand can do more than twenty a minute. And the taffy came "
      "out hard as glass, because no hand had warmed it. Marsha was at her "
      "pie, Gus at the barn door with the creamery man, and the Professor "
      "on the last train home.",
  core: [
    Evidence(
      'rockbarrel', 'Barrel of Rock Candy', 'rootcellar', 2,
      "A barrel of rock candy at the foot of the shelter steps, split across "
      "the outline. It has a rope handle at either end, and a long dent "
      "down each step where it bounced. It wants dusting for fingerprints.",
    ),
    harvestPie,
    creamSlip,
    ticketGood,
    Evidence(
      'puller', 'Taffy Puller', 'pressroom', 1,
      "The taffy puller. Its counter reads 3,412 pulls since the batch went "
      "in at 10:40. A brass plate on the side: “Hand-cranked. Twenty pulls "
      "a minute. Do not force.”",
      icon: Icons.settings, color: Color(0xFFF48FB1),
    ),
    Evidence(
      'fplanner', "Farmer's Daybook", 'office', 0,
      "Farmer Kernel's daybook, locked in the rolltop. Saturday's page: "
      "“Pay off T.P. Then have it out with Lolly, once and for all.”",
      icon: Icons.event_note, color: paper, inside: 'rolltop',
    ),
  ],
  variants: [
    farmTimeOfDeath,
    [
      Evidence(
        'windbelt', 'Leather Belt', 'pressroom', 4,
        "A long leather belt, hooked round the flywheel of the taffy "
        "puller and running up through the window toward the windmill. It "
        "is fresh-greased, and it has worn a bright groove in the wheel.",
        icon: Icons.settings_input_component, color: Color(0xFF8D6E63),
      ),
      Evidence(
        'glassytaffy', "Last Night's Taffy", 'pressroom', 2,
        "Last night's batch of taffy, cooling on the slab. It is hard and "
        "glassy right through, and rings when it is tapped.",
        icon: Icons.blur_on, color: Color(0xFFF8BBD0),
      ),
    ],
    [
      Evidence(
        'ring', 'Ring Box', 'lollyroom', 0,
        "At the back of Lolly's dressing-table drawer, a little velvet box. In it, "
        "a ring twisted out of pink sugar, and a card: “To L. from T. "
        "When we are free.”",
        icon: Icons.diamond, color: Color(0xFFF48FB1), inside: 'vanity',
      ),
      Evidence(
        'dismissal', 'Notice of Dismissal', 'office', 0,
        "In the rolltop, in the farmer's hand: “T. Pulman to be paid off "
        "Saturday and off the farm by Sunday. My daughter will not marry a "
        "farmhand while I draw breath.”",
        icon: Icons.mail, color: paper, inside: 'rolltop',
      ),
    ],
    [
      Evidence(
        'pinkstrand', 'Pink Strand', 'rootcellar', 1,
        "A long pink strand of taffy wound round one rope handle of the "
        "barrel, and a splinter of pink sugar-glass, like a broken lollipop "
        "stripe, caught in the other.",
        icon: Icons.gesture, color: Color(0xFFF48FB1),
      ),
      Evidence(
        'twosets', 'Footprints on the Steps', 'rootcellar', 1,
        "In the spilled sugar on the shelter steps, two trails of prints "
        "going up side by side: one round and sticky, one small and "
        "pointed. They are on top of the scattered corn.",
        icon: Icons.directions_walk, color: Color(0xFFBCAAA4),
      ),
    ],
  ],
  herrings: [...farmHerrings, lovePoem],
  weapons: {'rockbarrel'},
  printsOn: ['gus', 'lolly', 'taffy'],
  prints: Evidence.given(
    'prints', 'Prints on the Barrel', 'churlock',
    "Three sets of prints came up under the powder. Gus Gumdrop's are all "
    "over the staves. Lolly Popwell's are on one rope handle. Taffy "
    "Pulman's are on the other.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1868',
  hints: {
    ...farmHints,
    ...farmPhoneHints,
    ...farmPieHints,
    'rockbarrel': "A handle at either end, old chap. Could one dessert "
        "carry that down a flight of steps? Dust it, and then ask the "
        "foreman who moves the barrels.",
    'puller': "A machine that counts, at a rate written on its own side. "
        "Do the sum, Churlock.",
    'ticket': "Punched by the guard, on the right night. I should say that "
        "places the Professor well enough.",
    'fplanner': "Saturday, and two sets of initials. Somebody's Saturday "
        "was going to be very unpleasant.",
    'windbelt': "A belt, to a windmill that never stops. A machine can be "
        "cranked by a hand, Churlock, or by the weather.",
    'glassytaffy': "Hard as glass. Marsha knows taffy. I should ask her "
        "what makes it go like that.",
    'ring': "When we are free. Free of what, I wonder, or of whom?",
    'dismissal': "Two names in one letter, and both of them losing "
        "everything by Sunday.",
    'pinkstrand': "Two traces, one at each end. Marsha knows every dessert "
        "on this farm. Ask her.",
    'twosets': "Two trails, side by side. Marsha knows every dessert on "
        "this farm, and their feet. Ask her.",
    'tally': "Do the sum, old chap. Pulls, minutes, and what the plate on "
        "the machine says a hand can manage.",
    'prints': printsHintFarm,
  },
  accuseHints: [
    "Before you name anyone, Churlock: do we know the very minute he died? "
        "Then find where each of the five was at that minute.",
    "Three of them are placed by a pie, a creamery slip and a railway "
        "ticket. The other two are placed only by each other, and a machine.",
    "Go down to the press shed and look hard at the puller, at what is "
        "joined to it, and at what came out of it.",
    "A barrel with a handle at either end, and a hand on each. And a "
        "tally of pulls that no hand could crank. Name them both.",
  ],
  topics: {
    'butterscotch': [
      Topic(
        'what', 'What happened to him?',
        "Victim's Cornelius Kernel, the candy corn king. A barrel of rock "
        "candy came down the shelter steps and went right over him. We "
        "traced where he lay in icing sugar.",
      ),
      Topic(
        'weapon', 'Could it have been an accident?',
        "That barrel lives in the corner behind the potatoes, Detective. "
        "Somebody carried it to the top of those steps first, and it's no "
        "one-man job. Work it out.",
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
        'line', 'Was the telephone line down last night?',
        "Down, sir? No. Miss Mallow rang the exchange on it at six this "
        "morning, and the exchange says there was nothing wrong with it "
        "all night. No calls, though. Not a single one.",
        heard: ['lolly/phone'],
      ),
    ],
    'marsha': [
      marshaWhere,
      Topic(
        'about', aboutQ,
        "Gruff, and a bit of a crust on him, but soft in the middle. He'd "
        "been shouting at Miss Lolly all week. Doors slamming. I turned "
        "the wireless up.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to say it. But the Professor's been sly lately, "
        "creeping about with his packets.",
      ),
      Topic(
        'glassy', 'Why would taffy come out hard as glass?',
        "Because nobody's hands were on it, dear. Taffy wants pulling by "
        "hand: the warmth keeps it soft. Pull it cold, by a machine, and "
        "it goes like a windowpane.",
        needs: ['glassytaffy'],
      ),
      Topic(
        'trace', 'Whose is this, left on the steps?',
        "Pink. Pink, and sticky, and a splinter of stripe. That's Taffy "
        "and Miss Lolly, both of them. Oh, dear. Oh, dear oh dear.",
        needs: ['pinkstrand', 'twosets'],
      ),
      marshaCard,
      ...marshaCommon,
    ],
    'gus': [
      gusWhere,
      Topic(
        'about', aboutQ,
        "Best farmer in Candy Land, and knew it. Hard on Taffy. Harder on "
        "Lolly. Said she'd break his heart, and I think she did.",
      ),
      Topic(
        'suspect', suspectQ,
        "Can't say. I was at the barn door from eleven. Couldn't see the "
        "house for rain.",
      ),
      Topic(
        'belt', 'Did you see anything odd on your way back from the gate?',
        "Now you ask. The windmill belt was running in through the press "
        "room window. Never seen that before. It's for the pump, that belt. "
        "I thought Taffy'd found a new way to be lazy.",
        heard: ['taffy/where'],
      ),
      Topic(
        'barrels', 'Who moves the barrels in the shelter?',
        "Me. Nobody else is let. That rock candy weighs as much as a cow. "
        "It takes two to lift it and I've never needed two.",
        needs: ['rockbarrel'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the barrel.',
        "All over it, I should hope. I stacked it. I stack them all.",
        needs: ['prints'],
      ),
      ...gusCommon,
    ],
    'lolly': [
      Topic(
        'where', whereQ,
        "In the press shed, with Taffy, from twenty to eleven till twenty "
        "to twelve. He was teaching me to pull taffy. It's very good for "
        "the arms. The counter on the machine will tell you.",
      ),
      Topic(
        'about', aboutQ,
        "Daddy? Stubborn as a stalk. He wanted me on the farm and I wanted "
        "the city. We fought about it every day.",
      ),
      Topic(
        'suspect', suspectQ,
        "Gus. Daddy took his wages every Sunday for twenty years. Nobody "
        "takes that for twenty years.",
      ),
      Topic(
        'phone', "Weren't you on the telephone last night?",
        "Not last night. The line was down, with the storm. So I went to "
        "watch Taffy. There was nothing else to do.",
      ),
      Topic(
        'line', 'The line was working all night.',
        "Was it? Well, I didn't try it. I just assumed. It always goes "
        "down in a storm.",
        heard: ['jellybean/line'],
      ),
      Topic(
        'ring', 'Taffy gave you a ring.',
        "It's sugar. It's a joke. He makes them for everyone.",
        needs: ['ring', 'dismissal'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the barrel.',
        "I steadied it, last week, when Gus was stacking. On the rope. "
        "Ask him.",
        needs: ['prints'],
      ),
      ...lollyCommon,
    ],
    'taffy': [
      Topic(
        'where', whereQ,
        "In the press shed, crankin' the puller, from twenty to eleven till "
        "twenty to twelve, with Miss Lolly watchin'. Stop crankin' for two "
        "minutes and the batch sets. Counter'll tell you.",
      ),
      Topic(
        'about', aboutQ,
        "Fair man. Hard, but fair. Never liked me.",
      ),
      Topic(
        'suspect', suspectQ,
        "The Professor. Him and his secrets. Wouldn't trust him with a "
        "pail.",
      ),
      Topic(
        'tallyask', 'Did you keep a tally of the pulls?',
        "Always do. Write it on a card, every batch. Here. Steady as a "
        "clock, I was.",
        gives: Evidence.given(
          'tally', 'Pull Tally', 'taffy',
          "Taffy's tally card for last night, in big round letters: "
          "“Batch in 10:40. Batch out 11:40. 3,412 pulls, by hand. Miss "
          "Lolly watchin' the whole time.”",
        ),
      ),
      Topic(
        'belt', 'The puller was belted to the windmill.',
        "That's for oilin'. You run it off the windmill to work the grease "
        "in. Before. Not during. Never during.",
        needs: ['windbelt'],
      ),
      Topic(
        'glassy', 'Your taffy came out hard as glass.',
        "Bad batch. Cold night. It happens.",
        needs: ['glassytaffy'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the barrel.',
        "Helped Gus stack it Saturday. On the rope.",
        needs: ['prints'],
      ),
      Topic(
        'stack', 'Gus says nobody helps him stack.',
        "Then he's forgotten. He's gettin' on.",
        heard: ['gus/barrels'],
      ),
      taffyPoem,
      ...taffyCommon,
    ],
    'licorice': [
      licoriceWhere,
      Topic(
        'about', aboutQ,
        "A brilliant farmer and an impossible man. He thought his daughter "
        "should marry a field. She thought otherwise.",
      ),
      Topic(
        'suspect', suspectQ,
        "I was on a train, Detective. I suspect the timetable.",
      ),
      ...licoriceCommon,
    ],
  },
);
