import 'package:flutter/material.dart';

import 'common.dart' show paper, aboutQ, suspectQ;
import 'farm_case_moon.dart' show printsHintFarm;
import 'farm_common.dart';
import 'models.dart';

/// A single killer whose alibi is a telephone line that never dropped,
/// because she took it with her.
const lineCase = MysteryCase(
  id: 'fline',
  title: 'On the Line',
  culprits: {'lolly'},
  nextVictims: ['marsha', 'gus', 'taffy', 'licorice'],
  herringCount: 10,
  solution:
      "Farmer Kernel had written a new will leaving the farm to the Candy "
      "Land Agricultural Society, and had torn up the Talent Bureau's offer "
      "to his daughter with “OVER MY DEAD BODY” across it. Lolly Popwell's "
      "alibi was the telephone: an audition down the line from ten to "
      "eleven till half past, and the exchange swears the line never "
      "dropped. But she had spliced forty feet of Gus's barn cable into "
      "the telephone cord, and carried the receiver down to the top of the "
      "cellar steps, singing. At four minutes past eleven she set it down, "
      "struck her father with the brass doorstop from the front door, and "
      "was back on the line two minutes later, out of breath. The Bureau "
      "marked her down for it. The letter she produced, saying she sang "
      "without a single pause, is in her own pink ink. Marsha was at her "
      "pie, Gus at the barn door, Taffy at the puller, and the Professor on "
      "the last train home.",
  core: [
    Evidence(
      'stopgap',
      'Missing Doorstop',
      'porch',
      4,
      "A bare patch on the porch boards by the front door, where the brass "
          "doorstop stands: a cast candy corn the size of a loaf, heavy enough "
          "to hold the door in a gale. It is gone.",
      icon: Icons.door_front_door,
      color: Color(0xFFFFD54F),
    ),
    harvestPie,
    creamSlip,
    ticketGood,
    partyLine,
    Evidence(
      'puller',
      'Taffy Puller',
      'pressroom',
      1,
      "The taffy puller. Its counter reads 1,190 pulls since the batch went "
          "in at 10:40, and the batch came out at 11:40 as soft as a pillow. A "
          "brass plate on the side: “Hand-cranked. Twenty pulls a minute. Do "
          "not force.”",
      icon: Icons.settings,
      color: Color(0xFFF48FB1),
    ),
  ],
  variants: [
    farmTimeOfDeath,
    [
      Evidence(
        'splicedcord',
        'Telephone Cord',
        'frontroom',
        6,
        "Under the telephone table, the cord has been unscrewed from the "
            "wall plate and spliced to a great coil of black barn cable. "
            "Uncoiled, it would reach out of the front door, across the yard, "
            "and down into the root cellar.",
        icon: Icons.cable,
        color: Color(0xFF616161),
      ),
      Evidence(
        'stairgroove',
        'Groove on the Steps',
        'farmyard',
        2,
        "Along the edge of the storm-cellar steps, a thin groove worn through "
            "the wax polish, as if a cable had been dragged up and down them. "
            "The wax shavings are fresh.",
        icon: Icons.linear_scale,
        color: Color(0xFFBCAAA4),
      ),
    ],
    [
      Evidence(
        'stopcrawl',
        'Brass Doorstop',
        'rootcellar',
        0,
        "Pushed to the back of the crawlspace: the brass doorstop from the "
            "front door, a candy corn cast in solid brass, with a crust of the "
            "real thing on its point. It wants dusting for fingerprints.",
        inside: 'crawlspace',
      ),
      Evidence(
        'stopfurrow',
        'Brass Doorstop',
        'cornfield',
        0,
        "Buried in the furrow: the brass doorstop from the front door, a "
            "candy corn cast in solid brass, with a crust of the real thing on "
            "its point. It wants dusting for fingerprints.",
        inside: 'furrow',
      ),
    ],
    [
      Evidence(
        'newwillf',
        'New Will',
        'office',
        0,
        "In the deed box, signed and witnessed last week: “The farm, the "
            "corn and the cows to the Candy Land Agricultural Society. My "
            "daughter has made her choice, and it is the city.”",
        icon: Icons.description,
        color: Colors.white,
        inside: 'nightstand',
      ),
      Evidence(
        'bureauoffer',
        "The Bureau's Offer",
        'frontroom',
        0,
        "In Lolly's dressing table, torn in half and taped together: “The Talent "
            "Bureau offers Miss Popwell a place, if she can be in Candy City by "
            "Friday.” Across it, in her father's hand: “OVER MY DEAD BODY.”",
        icon: Icons.mail,
        color: paper,
        inside: 'vanity',
      ),
    ],
    [
      Evidence(
        'pinkshard',
        'Pink Splinter',
        'rootcellar',
        1,
        "A splinter of pink and white sugar-glass, like a chip off a "
            "lollipop stripe, lying on top of the spilled candy corn at the "
            "foot of the steps.",
        icon: Icons.auto_awesome,
        color: Color(0xFFF48FB1),
      ),
      Evidence(
        'stickprint',
        'Round Print',
        'rootcellar',
        2,
        "One small, round print pressed into the spilled sugar, as though "
            "somebody had stood there on the end of a stick. It is on top of "
            "the scattered corn.",
        icon: Icons.circle,
        color: Color(0xFFBCAAA4),
      ),
    ],
  ],
  herrings: [...farmHerrings, lovePoem],
  weapons: {'stopcrawl', 'stopfurrow'},
  printsOn: ['marsha', 'lolly'],
  prints: Evidence.given(
    'prints',
    'Prints on the Doorstop',
    'churlock',
    "Two sets of prints came up under the powder. Marsha Mallow's are old "
        "and faint, under the polish. Lolly Popwell's are fresh, and wrapped "
        "round the narrow end.",
    icon: Icons.fingerprint,
    color: Color(0xFFB2EBF2),
  ),
  deskCode: '1883',
  hints: {
    ...farmHints,
    ...farmPieHints,
    'stopgap':
        "Heavy, and brass, and kept by the front door, where "
        "anybody going out across the yard would pass it.",
    'puller':
        "A machine that counts, at a rate written on its own side, "
        "and a batch that came out soft. That places the farmhand, I "
        "should say.",
    'ticket':
        "Punched by the guard, on the right night. I should say that "
        "places the Professor well enough.",
    'partyline':
        "The line never dropped, it says. It does not say where "
        "the receiver was. Ask somebody who was listening at the other "
        "end.",
    'splicedcord':
        "A telephone that can walk, Churlock. Where would forty "
        "feet of cable reach from that table?",
    'stairgroove':
        "Something long and thin dragged up and down the "
        "cellar steps last night. Not a body. A cable.",
    'stopcrawl':
        "Hidden in the dark, by somebody who knew where the dark "
        "was. I should dust it.",
    'stopfurrow':
        "Buried in the field, by somebody who knew where the "
        "earth was soft. I should dust it.",
    'newwillf':
        "Everything to the Society. Somebody lost a farm last "
        "week, and may only just have found out.",
    'bureauoffer':
        "Over my dead body. A father should be careful what he "
        "writes.",
    'pinkshard':
        "Pink and white stripes, on top of the corn. Marsha knows "
        "every dessert on this farm. Ask her.",
    'stickprint':
        "Somebody who stands on a stick. Marsha knows every "
        "dessert on this farm. Ask her.",
    'bureaunote':
        "Compare it with what the Sheriff heard from the Bureau "
        "itself. And look at the ink.",
    'prints': printsHintFarm,
  },
  accuseHints: [
    "Before you name anyone, Churlock: do we know the very minute he died? "
        "Then find where each of the five was at that minute.",
    "Every one of the five has an alibi on paper. One of them is a "
        "telephone line. A line can be long.",
    "Look under the telephone table, and at the cellar steps. Then ask the "
        "Sheriff to ring the other end of that call.",
    "Two minutes of silence in the middle of a song, a cord that reaches "
        "the cellar, and a doorstop with a fresh hand round it. Name her.",
  ],
  topics: {
    'butterscotch': [
      Topic(
        'what',
        'What happened to him?',
        "Victim's Cornelius Kernel, the candy corn king. One blow with "
            "something heavy and pointed. It went through his white stripe. "
            "We traced where he fell in icing sugar.",
      ),
      Topic(
        'weapon',
        'What was the weapon?',
        "Heavy, metal, pointed, about the size of a loaf. It isn't down "
            "here.",
      ),
      sheriffHome,
      Topic(
        'creamery',
        'Can the creamery man vouch for Gus?',
        "I rang them first thing. Fudge, the driver, says Gus handed him "
            "four churns at the barn door on the stroke of eleven and talked "
            "his ear off about tractors.",
        heard: ['gus/where'],
      ),
      Topic(
        'bureau',
        'Can the Talent Bureau vouch for Lolly?',
        "I rang them. Their man says she sang beautifully, the whole of "
            "“Sweet on the City” twice. Except that at four minutes past eleven "
            "she stopped dead, in the middle of a high note, for two minutes, "
            "and came back puffing like a train. He's marked her down for "
            "breath.",
        heard: ['lolly/where'],
      ),
      sheriffChart,
    ],
    'jellybean': deputyTopics,
    'marsha': [
      marshaWhere,
      Topic(
        'about',
        aboutQ,
        "Gruff, and a bit of a crust on him, but soft in the middle. He and "
            "Miss Lolly had a terrible row on Sunday. He tore something up and "
            "threw it in the stove, and she fished it out.",
      ),
      Topic(
        'suspect',
        suspectQ,
        "I don't like to say it. But Gus has been in a black mood since "
            "Sunday's card game, and he's strong as an ox.",
      ),
      Topic(
        'trace',
        'Whose is this, left by the body?',
        "Pink and white stripes, and a round little print like a stick "
            "end. That's Miss Lolly. Oh, no. Oh, not her.",
        needs: ['pinkshard', 'stickprint'],
      ),
      Topic(
        'myprints',
        'Your fingerprints are on the doorstop.',
        "I polish it every Saturday. It's a candy corn. He liked it "
            "shining.",
        needs: ['prints'],
      ),
      marshaCard,
      ...marshaCommon,
    ],
    'gus': [
      gusWhere,
      Topic(
        'about',
        aboutQ,
        "Best farmer in Candy Land, and knew it. Changed his will last "
            "week. I witnessed it. Didn't read it. You don't.",
      ),
      Topic('suspect', suspectQ, "City folk. The Professor, if you ask me."),
      Topic(
        'cable',
        'Is this your barn cable?',
        "That's mine. Forty feet of it gone off the reel since Sunday. I "
            "thought the Professor had it for one of his experiments.",
        needs: ['splicedcord'],
      ),
      ...gusCommon,
    ],
    'lolly': [
      lollyWhere,
      Topic(
        'about',
        aboutQ,
        "Daddy? Stubborn as a stalk. He wanted me on the farm and I wanted "
            "the city. We fought about it every day.",
      ),
      Topic(
        'suspect',
        suspectQ,
        "Gus. Daddy took his wages every Sunday for twenty years. Nobody "
            "takes that for twenty years.",
      ),
      Topic(
        'proof',
        'Can anyone at the Bureau vouch for you?',
        "They sent a note after. I have it. Every note, without a breath. "
            "Here.",
        gives: Evidence.given(
          'bureaunote',
          'Note from the Bureau',
          'lolly',
          "A note on pink paper, in purple ink: “Miss Popwell sang without a "
              "single pause from 10:50 until 11:30. A remarkable breath. The "
              "Talent Bureau.” The dot over every i is a tiny heart.",
        ),
      ),
      Topic(
        'pause',
        'You stopped singing for two minutes at 11:04.',
        "I had a frog in my throat. Singers do. I put the receiver down and "
            "had a glass of water.",
        heard: ['butterscotch/bureau'],
      ),
      Topic(
        'cord',
        'The telephone cord reaches the cellar.',
        "I wanted to sing out on the porch. The acoustics are better. Daddy "
            "never let me take the telephone anywhere.",
        needs: ['splicedcord', 'stairgroove'],
      ),
      Topic(
        'newwill',
        'Your father left the farm to the Society.',
        "He told me on Sunday. I laughed. I didn't believe him.",
        needs: ['newwillf', 'bureauoffer'],
      ),
      Topic(
        'myprints',
        'Your fingerprints are on the doorstop.',
        "I kick it out of the way every morning. Sometimes I pick it up. "
            "It's heavy. I'm stronger than I look.",
        needs: ['prints'],
      ),
      ...lollyCommon,
    ],
    'taffy': [
      taffyWhere,
      Topic(
        'about',
        aboutQ,
        "Fair man. Hard, but fair. Hard on Miss Lolly most of all.",
      ),
      Topic(
        'suspect',
        suspectQ,
        "Couldn't say. I was crankin'. Heard her singin' through the "
            "floor, mind. Sounded like it was comin' from the cellar, not "
            "house.",
      ),
      taffyPoem,
      ...taffyCommon,
    ],
    'licorice': [
      licoriceWhere,
      Topic(
        'about',
        aboutQ,
        "A brilliant farmer and an impossible man. He was leaving the farm "
            "to the Agricultural Society, he told me. To spite somebody.",
      ),
      Topic(
        'suspect',
        suspectQ,
        "I was on a train, Detective. I suspect the timetable.",
      ),
      ...licoriceCommon,
    ],
  },
);
