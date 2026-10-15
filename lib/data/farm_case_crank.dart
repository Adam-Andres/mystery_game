import 'package:flutter/material.dart';

import 'common.dart' show paper, whereQ, aboutQ, suspectQ;
import 'farm_case_moon.dart' show printsHintFarm;
import 'farm_common.dart';
import 'models.dart';

/// A single killer whose alibi is a machine that could not have been
/// turned at all.
const crankCase = MysteryCase(
  id: 'fcrank',
  title: 'No Crank',
  culprits: {'taffy'},
  nextVictims: ['lolly', 'marsha', 'gus', 'licorice'],
  herringCount: 10,
  solution:
      "For three summers Taffy Pulman had been pulling taffy from Kernel "
      "sugar on Kernel time and selling it at the county fair under his own "
      "name, and on Friday the farmer meant to fetch the police. Taffy's "
      "alibi was the puller's counter: 1,190 pulls, a fair hour's cranking. "
      "But he cranked that batch at eight o'clock, not at eleven, and left "
      "it on the slab, where it went cold and gathered dust. At eleven he "
      "took the iron crank handle off the machine, went down to the root "
      "cellar, and at 11:05 struck the farmer with it. Without its handle "
      "the puller could not be turned at all, and that night, for the first "
      "time in years, it never squealed. His tally card has the batch warm "
      "as toast at midnight. Marsha was at her pie, Gus at the barn door, "
      "Lolly on the telephone, and the Professor on the last train home.",
  core: [
    harvestPie,
    creamSlip,
    partyLine,
    ticketGood,
    Evidence(
      'puller', 'Taffy Puller', 'pressroom', 1,
      "The taffy puller. Its counter reads 1,190 pulls since the batch went "
      "in. A brass plate on the side: “Hand-cranked. Twenty pulls a "
      "minute. Do not force.”",
      icon: Icons.settings, color: Color(0xFFF48FB1),
    ),
    Evidence(
      'nocrank', 'Empty Socket', 'pressroom', 3,
      "On the side of the taffy puller, the square socket where its iron "
      "crank handle fits. It is empty. Without the handle the machine "
      "cannot be turned at all.",
      icon: Icons.settings, color: Color(0xFF90A4AE),
    ),
  ],
  variants: [
    farmTimeOfDeath,
    [
      Evidence(
        'crankvat', 'Crank Handle', 'pressroom', 0,
        "At the bottom of the syrup vat, felt for with a ladle: the iron "
        "crank handle from the taffy puller, with a crust of candy corn "
        "under the syrup on its knob. It wants dusting for fingerprints.",
        inside: 'vat',
      ),
      Evidence(
        'crankfeed', 'Crank Handle', 'barn', 0,
        "Pushed to the bottom of the feed bin: the iron crank handle from "
        "the taffy puller, with a crust of candy corn on its knob. It wants "
        "dusting for fingerprints.",
        inside: 'feedbin',
      ),
    ],
    [
      Evidence(
        'dustybatch', "Last Night's Taffy", 'pressroom', 2,
        "Last night's batch on the cooling slab: cold right through, hard "
        "at the edges, and with a fine skin of dust on top. It was pulled "
        "hours before midnight.",
        icon: Icons.blur_on, color: Color(0xFFF8BBD0),
      ),
      Evidence(
        'squeal', 'Oil Can', 'pressroom', 4,
        "An oil can on the shelf by the puller, labelled in Taffy's hand: "
        "“For the squeal. Every night, or it wakes the house.” It is full. "
        "Nobody oiled the puller last night.",
        icon: Icons.oil_barrel, color: Color(0xFFFFCA28),
      ),
    ],
    [
      Evidence(
        'fairtakings', 'Fair Takings', 'pressroom', 0,
        "In Taffy's footlocker, a cash box: “Pulman's Prize Taffy. County "
        "Fair takings, three summers: 900 cubes.” The labels on the empty "
        "sweet bags read “Made with KERNEL sugar.”",
        icon: Icons.savings, color: Color(0xFFFFD54F), inside: 'footlocker',
      ),
      Evidence(
        'thiefnote', "Farmer's Note", 'office', 0,
        "In the rolltop, in the farmer's hand: “T.P. has been pulling taffy "
        "from my sugar on my time and selling it at the fair as his own. "
        "The Sheriff, Friday.”",
        icon: Icons.mail, color: paper, inside: 'rolltop',
      ),
    ],
    [
      Evidence(
        'pinkthumb', 'Sticky Thumbprint', 'rootcellar', 1,
        "A pink, sticky thumbprint on the cellar rail, stretched out long "
        "as though the thumb that made it had given a little. It is on top "
        "of the spilled candy corn.",
        icon: Icons.fingerprint, color: Color(0xFFF48FB1),
      ),
      Evidence(
        'stretchsteps', 'Stretched Footprints', 'rootcellar', 2,
        "Footprints on the cellar steps, each one pulled out long at the "
        "heel, as if the walker were made of something that stretched. They "
        "are on top of the scattered corn.",
        icon: Icons.directions_walk, color: Color(0xFFBCAAA4),
      ),
    ],
  ],
  herrings: [...farmHerrings, lovePoem],
  weapons: {'crankvat', 'crankfeed'},
  printsOn: ['gus', 'taffy'],
  prints: Evidence.given(
    'prints', 'Prints on the Crank Handle', 'churlock',
    "Two sets of prints came up under the powder. Gus Gumdrop's are old, "
    "on the shaft. Taffy Pulman's are fresh, and wrapped right round the "
    "knob.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1886',
  hints: {
    ...farmHints,
    ...farmPhoneHints,
    ...farmPieHints,
    'puller': "A machine that counts. But it does not say when it was "
        "turned, old chap. Only how often.",
    'nocrank': "No handle, no cranking. So who has been turning it, and "
        "when?",
    'ticket': "Punched by the guard, on the right night. I should say that "
        "places the Professor well enough.",
    'crankvat': "Hidden in the syrup, by somebody at home in that room. I "
        "should dust it.",
    'crankfeed': "Hidden in the barn, a long way from the machine it came "
        "off. I should dust it.",
    'dustybatch': "Cold and dusty. Marsha knows taffy. Ask her how long "
        "that has been sitting.",
    'squeal': "Full. So the machine went unoiled last night. Ask the house "
        "whether it heard it squeal.",
    'fairtakings': "Kernel sugar, sold under another name. That is a "
        "motive, and an urgent one.",
    'thiefnote': "The Sheriff, Friday. Somebody's Friday was going to be "
        "very unpleasant.",
    'pinkthumb': "Pink, and stretched. Marsha knows every dessert on this "
        "farm. Ask her.",
    'stretchsteps': "Somebody who stretches. Marsha knows every dessert on "
        "this farm. Ask her.",
    'tally': "Warm as toast at midnight, it says. Go and feel the batch, "
        "Churlock.",
    'prints': printsHintFarm,
  },
  accuseHints: [
    "Before you name anyone, Churlock: do we know the very minute he died? "
        "Then find where each of the five was at that minute.",
    "Every one of the five has an alibi, and one of them is a machine. A "
    "counter says how much, not when.",
    "Look at the side of the puller, and at the batch on the slab. Then "
    "ask the house whether the puller squealed last night.",
    "A machine with no handle, a batch pulled hours early, and a crank "
        "with a fresh hand round it. Name him.",
  ],
  topics: {
    'butterscotch': [
      Topic(
        'what', 'What happened to him?',
        "Victim's Cornelius Kernel, the candy corn king. One blow with "
        "something iron, bent, with a knob on the end. We traced where he "
        "fell in icing sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Iron, bent like an elbow, a knob on one end and a square on the "
        "other. It isn't down here.",
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
    'jellybean': deputyTopics,
    'marsha': [
      marshaWhere,
      Topic(
        'about', aboutQ,
        "Gruff, and a bit of a crust on him. He'd been counting the sugar "
        "sacks all week. Said the sugar was walking.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to say it. But the Professor's been sly lately, "
        "creeping about with his packets.",
      ),
      Topic(
        'fresh', 'How long has that taffy been sitting?',
        "Hours, dear. Fresh pulled taffy's warm for an hour and soft till "
        "morning. That's cold right through, and dusty. That was pulled "
        "before supper.",
        needs: ['dustybatch'],
      ),
      Topic(
        'trace', 'Whose is this, left on the steps?',
        "Pink, and stretched. That's Taffy. Nobody else on this farm "
        "stretches. Oh, the poor lamb.",
        needs: ['pinkthumb', 'stretchsteps'],
      ),
      marshaCard,
      ...marshaCommon,
    ],
    'gus': [
      gusWhere,
      Topic(
        'about', aboutQ,
        "Best farmer in Candy Land, and knew it. He'd found Taffy's taffy "
        "on a stall at the fair. Came home purple.",
      ),
      Topic(
        'suspect', suspectQ,
        "Can't say. I was at the barn door from eleven.",
      ),
      Topic(
        'quiet', 'Did you hear the puller last night?',
        "No, and I'll tell you a thing: I always do. It squeals like a pig "
        "all the way across the yard. Last night, quiet as a church.",
        heard: ['taffy/where'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the crank handle.',
        "I fit a new handle on that machine every spring when Taffy snaps "
        "the old one. Did it in April.",
        needs: ['prints'],
      ),
      ...gusCommon,
    ],
    'lolly': [
      lollyWhere,
      Topic(
        'about', aboutQ,
        "Daddy? Stubborn as a stalk. He was in a temper about the fair "
        "all week. Something about stripes.",
      ),
      Topic(
        'suspect', suspectQ,
        "Not Taffy. Taffy's sweet. ...I don't know.",
      ),
      Topic(
        'squeak', 'Could you hear the puller from the telephone?',
        "Every night it comes up through the floor, eek-eek-eek, and I "
        "have to hum over it. Last night, not a squeak. I sang my whole "
        "audition in peace.",
        needs: ['partyline'],
      ),
      ...lollyCommon,
    ],
    'taffy': [
      Topic(
        'where', whereQ,
        "In the press shed, crankin' the puller, from twenty to eleven till "
        "twenty to twelve. Counter'll tell you. 1,190 pulls. Fair hour's "
        "work.",
      ),
      Topic(
        'about', aboutQ,
        "Fair man. Hard, but fair. Didn't like me much.",
      ),
      Topic(
        'suspect', suspectQ,
        "Gus. Twenty years of losin' at cards. I'd have snapped.",
      ),
      Topic(
        'tallyask', 'Did you keep a tally of the pulls?',
        "Always do. Here. Every batch.",
        gives: Evidence.given(
          'tally', 'Pull Tally', 'taffy',
          "Taffy's tally card for last night, in big round letters: “Batch "
          "in 10:40. Batch out 11:40. 1,190 pulls with the big crank. Warm "
          "as toast at midnight.”",
        ),
      ),
      Topic(
        'socket', 'Your puller has no crank handle.',
        "Snapped it. Again. Last thing at night, after the batch. I chucked "
        "it somewhere. I'll fit another.",
        needs: ['nocrank'],
      ),
      Topic(
        'cold', 'Your batch was cold and dusty by midnight.',
        "Cold night. Dusty room. It happens.",
        needs: ['dustybatch', 'squeal'],
      ),
      Topic(
        'fair', 'You sold Kernel taffy at the fair.',
        "My pullin'. My arms. His sugar, all right. But my arms.",
        needs: ['fairtakings', 'thiefnote'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the crank handle.',
        "It's my machine. Course they are.",
        needs: ['prints'],
      ),
      taffyPoem,
      ...taffyCommon,
    ],
    'licorice': [
      licoriceWhere,
      Topic(
        'about', aboutQ,
        "A brilliant farmer and an impossible man. He was going to the "
        "Sheriff on Friday about somebody. He enjoyed telling me so.",
      ),
      Topic(
        'suspect', suspectQ,
        "I was on a train, Detective. I suspect the timetable.",
      ),
      ...licoriceCommon,
    ],
  },
);
