import 'package:flutter/material.dart';

import 'common.dart' show paper, aboutQ, suspectQ;
import 'farm_case_moon.dart' show printsHintFarm;
import 'farm_common.dart';
import 'models.dart';

/// A single killer, whose alibi is a slip of paper from somebody with no
/// reason to lie, who was not where everybody thinks.
const creamCase = MysteryCase(
  id: 'fcream',
  title: 'The Cream of the Crop',
  culprits: {'gus'},
  nextVictims: ['taffy', 'lolly', 'marsha', 'licorice'],
  herringCount: 10,
  solution:
      "Forty years ago Gus Gumdrop's father staked the Gumdrop farm on a "
      "hand of cards, and lost it to Cornelius Kernel. Gus had worked the "
      "land that should have been his for twenty-two years, and on Sunday "
      "he learned that the farmer was selling it to Big Sugar and letting "
      "him go. His alibi was the creamery slip that said he handed over the "
      "churns at the barn door at eleven. But the driver never comes to "
      "the barn: he takes the churns from the stand at the gate at half "
      "past ten, and writes eleven on every slip from habit. Gus left the "
      "churns out early, went down to the root cellar, and at 11:05 struck "
      "the farmer with a full iron milk churn. The cows were never milked "
      "at all, and bellowed all night. The milking card he produced lists "
      "Fudge Ripple, a cow sold to the Nougat farm on the first of the "
      "month. Marsha was at her pie, Lolly on the telephone, Taffy at the "
      "puller, and the Professor on the last train home.",
  core: [
    harvestPie,
    partyLine,
    ticketGood,
    Evidence(
      'puller', 'Taffy Puller', 'pressroom', 1,
      "The taffy puller. Its counter reads 1,190 pulls since the batch went "
      "in at 10:40, and the batch came out at 11:40 as soft as a pillow. A "
      "brass plate on the side: “Hand-cranked. Twenty pulls a minute. Do "
      "not force.”",
      icon: Icons.settings, color: Color(0xFFF48FB1),
    ),
    creamSlip,
    Evidence(
      'emptystall', 'Empty Stall', 'barn', 4,
      "A stall swept clean and empty. The painted nameplate over it still "
      "reads FUDGE RIPPLE, but a card is tacked beneath: “Sold to Nougat "
      "Farm, the 1st. Good riddance, she kicked.”",
      icon: Icons.house_siding, color: Color(0xFFBCAAA4),
    ),
    Evidence(
      'fplanner', "Farmer's Daybook", 'office', 0,
      "Farmer Kernel's daybook, locked in the rolltop. Today's page: "
      "“10 AM. Big Sugar's man, with the papers. Tell G.G. after. Not "
      "before. He'll take it hard.”",
      icon: Icons.event_note, color: paper, inside: 'rolltop',
    ),
  ],
  variants: [
    farmTimeOfDeath,
    [
      Evidence(
        'gatestand', 'Churn Stand', 'pasture', 2,
        "The churn stand by the farm gate, where the creamery cart turns. "
        "Four empty churns are back on it, and chalked on the post in the "
        "driver's hand: “Kernel. 4 churns. 10:25.”",
        icon: Icons.signpost, color: Color(0xFFBCAAA4),
      ),
      Evidence(
        'fullcows', 'Bellowing Cows', 'barn', 1,
        "The chocolate cows, lowing in their stalls, every one of them "
        "full to bursting. Nobody milked them last night.",
        icon: Icons.pets, color: Color(0xFF8D6E63),
      ),
    ],
    [
      Evidence(
        'churncrawl', 'Dented Milk Churn', 'rootcellar', 0,
        "Shoved to the back of the crawlspace: an iron milk churn, still "
        "half full, with a deep dent in the rim and a crust of crushed "
        "candy corn in it. It wants dusting for fingerprints.",
        inside: 'crawlspace',
      ),
      Evidence(
        'churnloft', 'Dented Milk Churn', 'barn', 0,
        "Hidden under the hay in the loft: an iron milk churn, still half "
        "full, with a deep dent in the rim and a crust of crushed candy corn "
        "in it. It wants dusting for fingerprints.",
        inside: 'hayloft',
      ),
    ],
    [
      Evidence(
        'oldiou', 'Old Wager', 'barn', 0,
        "At the bottom of the feed bin, in a biscuit tin: a yellowed card. "
        "“I, Gideon Gumdrop, stake the Gumdrop farm on this hand. Lost to "
        "C. Kernel.” Across it, in fresh pencil: “HE CHEATED.”",
        icon: Icons.style, color: paper, inside: 'feedbin',
      ),
      Evidence(
        'saleagreement', 'Bill of Sale', 'office', 0,
        "In the rolltop, a draft from Big Sugar & Co.: “The Kernel farm, "
        "its corn and cows, to be sold entire. The foreman, G. Gumdrop, is "
        "not to be kept on.” It is ready to sign.",
        icon: Icons.description, color: Colors.white, inside: 'rolltop',
      ),
    ],
    [
      Evidence(
        'greensugar', 'Green Sugar', 'rootcellar', 1,
        "A scatter of coarse green sugar crystals at the foot of the cellar "
        "steps, on top of the spilled candy corn. They are not the farmer's: "
        "he was striped, and smooth.",
        icon: Icons.grain, color: Color(0xFF81C784),
      ),
      Evidence(
        'haybootprint', 'Boot Print with Hay', 'rootcellar', 2,
        "A broad, round boot print in the spilled sugar, with wisps of hay "
        "pressed into it. It is on top of the scattered corn.",
        icon: Icons.directions_walk, color: Color(0xFFBCAAA4),
      ),
    ],
  ],
  herrings: [...farmHerrings, lovePoem],
  weapons: {'churncrawl', 'churnloft'},
  printsOn: ['taffy', 'gus'],
  prints: Evidence.given(
    'prints', 'Prints on the Churn', 'churlock',
    "Two sets of prints came up under the powder. Taffy Pulman's are on "
    "the handles. Gus Gumdrop's are round the rim, where the dent is.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1880',
  hints: {
    ...farmHints,
    ...farmPhoneHints,
    ...farmPieHints,
    'puller': "A machine that counts, at a rate written on its own side, "
        "and a batch that came out soft. That places the farmhand, I "
        "should say.",
    'ticket': "Punched by the guard, on the right night. I should say that "
        "places the Professor well enough.",
    'emptystall': "Sold on the first. A cow that is not here cannot be "
        "milked. Remember her name.",
    'fplanner': "Tell G.G. after, not before. So somebody was not supposed "
        "to know what was coming. I wonder if he did.",
    'gatestand': "Chalked at twenty-five past ten. And the slip says "
        "eleven. One of them is wrong. Ask the Sheriff which.",
    'fullcows': "Full to bursting. Who told us they milked these cows at "
        "eleven o'clock?",
    'churncrawl': "Hidden in the dark, by somebody who knew where the dark "
        "was. I should dust it.",
    'churnloft': "Hidden up a ladder that has gone missing. Whose bed is "
        "in that loft? I should dust it.",
    'oldiou': "He cheated. Somebody has carried that for forty years, "
        "Churlock.",
    'saleagreement': "The farm, the corn and the cows, and one name left "
        "off the list.",
    'greensugar': "Not the farmer's. Marsha knows every dessert on this "
        "farm. Ask her whose sugar that is.",
    'haybootprint': "Hay, in the cellar. Marsha knows every boot on this "
        "farm. Ask her whose that is.",
    'milkcard': "Read the names, old chap. Every cow on that card ought to "
        "be standing in the barn.",
    'prints': printsHintFarm,
  },
  accuseHints: [
    "Before you name anyone, Churlock: do we know the very minute he died? "
        "Then find where each of the five was at that minute.",
    "Every one of the five has an alibi on paper. Which of those papers was "
        "written by somebody who actually saw them?",
    "Go to the gate and look at the churn stand, and then go and listen to "
        "the cows.",
    "A slip that says eleven out of habit, a card that names a cow sold "
        "last month, and a churn with a dent in the rim. Name him.",
  ],
  topics: {
    'butterscotch': [
      Topic(
        'what', 'What happened to him?',
        "Victim's Cornelius Kernel, the candy corn king. One almighty blow "
        "with something heavy and round-rimmed. We traced where he fell in "
        "icing sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Heavy, iron, with a rim to it. There's milk splashed on the "
        "potatoes, Detective. Make of that what you will.",
      ),
      sheriffHome,
      Topic(
        'creamery', 'Can the creamery man vouch for Gus?',
        "Funny you should ask. I rang them. Fudge says he never goes up to "
        "the barn, not in twenty years: he takes the churns off the stand "
        "at the gate at half past ten, and leaves a slip in an empty one. "
        "Writes eleven on all of them. Habit.",
        heard: ['gus/where'],
      ),
      sheriffChart,
    ],
    'jellybean': deputyTopics,
    'marsha': [
      marshaWhere,
      Topic(
        'about', aboutQ,
        "Gruff, and a bit of a crust on him, but soft in the middle. He'd "
        "had a man from Big Sugar in the office on Sunday. Came out "
        "looking ten years older.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to say it. But Miss Lolly wanted the farm sold more "
        "than anything in the world.",
      ),
      Topic(
        'trace', 'Whose is this, left on the steps?',
        "Green sugar, and a round boot with hay in it. That's Gus. Nobody "
        "else on this farm is green, and nobody else sleeps in the hay.",
        needs: ['greensugar', 'haybootprint'],
      ),
      marshaCard,
      ...marshaCommon,
    ],
    'gus': [
      gusWhere,
      Topic(
        'about', aboutQ,
        "Best farmer in Candy Land, and knew it. Took my wages back off me "
        "at cards every Sunday for twenty years. I let him.",
      ),
      Topic(
        'suspect', suspectQ,
        "The girl. Lolly. Big Sugar write to her every month. With him gone, "
        "it's hers to sell.",
      ),
      Topic(
        'milking', 'Which cows did you milk last night?',
        "All of 'em, same as always. I wrote it on my card. Here.",
        gives: Evidence.given(
          'milkcard', 'Milking Card', 'gus',
          "Gus's milking card for last night: “11 PM. Bessie, Clover, Fudge "
          "Ripple and Toffee. Four churns, full. Handed to Fudge at the "
          "barn door.”",
        ),
      ),
      Topic(
        'stand', 'The driver chalked the churns at 10:25, at the gate.',
        "Then his watch is wrong. Or his chalk is. I handed them over at "
        "eleven.",
        needs: ['gatestand'],
      ),
      Topic(
        'driver', 'The driver says he never comes up to the barn.',
        "He's getting old. He forgets. We all do.",
        heard: ['butterscotch/creamery'],
      ),
      Topic(
        'cows', 'Your cows were never milked.',
        "They're always like that in the rain. Bellowing. Makes 'em "
        "nervous.",
        needs: ['fullcows'],
      ),
      Topic(
        'fudge', 'Fudge Ripple was sold on the first.',
        "...Was she. So she was. I wrote it from habit. Twenty years, you "
        "write the same names.",
        needs: ['milkcard', 'emptystall'],
      ),
      Topic(
        'wager', 'Your father lost this farm at cards.',
        "To a man who marked the aces. You've seen the pack. Forty years "
        "I've known it. Forty years I've said nothing.",
        needs: ['oldiou'],
      ),
      Topic(
        'sale', 'The farmer was selling up, and letting you go.',
        "Was he. Nobody tells the foreman anything.",
        needs: ['saleagreement', 'fplanner'],
      ),
      Topic(
        'myprints', 'Your fingerprints are on the churn.',
        "I fill those churns every night. My prints are on every churn on "
        "this farm.",
        needs: ['prints'],
      ),
      ...gusCommon,
    ],
    'lolly': [
      lollyWhere,
      Topic(
        'about', aboutQ,
        "Daddy? Stubborn as a stalk. He wanted me on the farm and I wanted "
        "the city. And then on Sunday he said he'd sell it anyway, to Big "
        "Sugar, and go and live by the sea. I laughed. I couldn't help it.",
      ),
      Topic(
        'suspect', suspectQ,
        "Not Gus. Gus is like a big green uncle. Somebody from outside, it "
        "must have been.",
      ),
      Topic(
        'cows', 'Did you hear anything from the barn?',
        "The cows, all night, bellowing like a brass band. I had to put a "
        "finger in my other ear to hear the Talent Bureau. Gus usually "
        "milks them quiet by eleven.",
        needs: ['partyline'],
      ),
      ...lollyCommon,
    ],
    'taffy': [
      taffyWhere,
      Topic(
        'about', aboutQ,
        "Fair man. Hard, but fair. Docked me when I broke things, paid me "
        "when I didn't.",
      ),
      Topic(
        'suspect', suspectQ,
        "Couldn't say. I was crankin'. You don't look up when you're "
        "crankin'.",
      ),
      Topic(
        'myprints', 'Your fingerprints are on the churn.',
        "On the handles. I carry the churns down to the gate on Sundays "
        "when Gus's back is bad. Last Sunday, that was.",
        needs: ['prints'],
      ),
      taffyPoem,
      ...taffyCommon,
    ],
    'licorice': [
      licoriceWhere,
      Topic(
        'about', aboutQ,
        "A brilliant farmer and an impossible man. He was going to sell "
        "the whole farm to a factory. I told him it was a crime against "
        "corn.",
      ),
      Topic(
        'suspect', suspectQ,
        "I was on a train, Detective. But if you want a scientist's "
        "opinion: look at whoever stood to lose the most.",
      ),
      ...licoriceCommon,
    ],
  },
);
