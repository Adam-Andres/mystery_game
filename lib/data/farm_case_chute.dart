import 'package:flutter/material.dart';

import 'common.dart' show paper, aboutQ, suspectQ;
import 'farm_case_moon.dart' show printsHintFarm;
import 'farm_common.dart';
import 'models.dart';

/// Two killers whose alibis are perfectly true. Neither of them had to be
/// in the cellar: one sent him there, and the other pulled a lever.
const chuteCase = MysteryCase(
  id: 'fchute',
  title: 'Down the Chute',
  culprits: {'marsha', 'gus'},
  nextVictims: ['lolly', 'taffy', 'licorice'],
  herringCount: 10,
  solution:
      "The farm's pension fund passed, on Farmer Kernel's death, to his two "
      "longest-serving hands: Gus Gumdrop and Marsha Mallow. On Friday he "
      "meant to dissolve it. Neither of them went near the root cellar. At "
      "five to eleven Marsha sent the farmer down with a note, to fetch up "
      "a sack of potatoes for a pie that has no potatoes in it, and stood "
      "him under the mouth of the corn chute. Gus handed his churns to the "
      "creamery man at eleven, unlocked the chute with the key Marsha had "
      "been keeping for him, and at 11:05 pulled the lever. A ton of candy "
      "corn came down on the farmer. Both alibis were true. The barn log "
      "Gus produced says the chute was padlocked and the only key on his "
      "belt, but the key was in Marsha's recipe box. Lolly was on the "
      "telephone, Taffy at the puller, and the Professor on the last "
      "train home.",
  core: [
    Evidence(
      'chutelever',
      'Chute Lever',
      'barn',
      5,
      "The iron lever of the corn chute, which drops candy corn from the "
          "barn store into the root cellar bins. It has been pulled right "
          "down, and the grease on it is fresh. It wants dusting for "
          "fingerprints.",
    ),
    Evidence(
      'cornheap',
      'Heap of Corn',
      'rootcellar',
      2,
      "A mountain of candy corn under the mouth of the chute in the cellar "
          "ceiling, burying the outline almost to the top. It came down all at "
          "once.",
      icon: Icons.landslide,
      color: Color(0xFFFF9800),
    ),
    harvestPie,
    creamSlip,
    partyLine,
    ticketGood,
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
    Evidence(
      'chutekey',
      'Brass Key',
      'fkitchen',
      0,
      "Tucked in Marsha's recipe box among the scone cards: a brass key "
          "on a tag stamped “CHUTE. G.G.”",
      icon: Icons.key,
      color: Color(0xFFFFD54F),
      inside: 'recipebox',
    ),
  ],
  variants: [
    farmTimeOfDeath,
    [
      Evidence(
        'potatonote',
        'Note in the Corn',
        'rootcellar',
        1,
        "Half buried in the spilled corn, a note in a round, careful hand: "
            "“Cornelius, fetch up a sack of potatoes from the bin under the "
            "chute, there's a dear. For the pie. M.”",
        icon: Icons.sticky_note_2,
        color: paper,
      ),
      Evidence(
        'recipecard',
        'Pie Recipe',
        'fkitchen',
        4,
        "Marsha's card for the Harvest Moon Pie, propped on the counter: "
            "pumpkin, sugar, eggs, cream, cinnamon. There are no potatoes in "
            "it, and never have been.",
        icon: Icons.receipt_long,
        color: paper,
      ),
    ],
    [
      Evidence(
        'pensionfund',
        'Pension Fund',
        'office',
        0,
        "In the rolltop, the deed of the farm pension fund: “On the death "
            "of C. Kernel, the fund passes in full to his two longest-serving "
            "hands, G. Gumdrop and M. Mallow.” Across it: “Dissolve. Friday.”",
        icon: Icons.savings,
        color: paper,
        inside: 'rolltop',
      ),
      Evidence(
        'dissolve',
        'Letter to the Bank',
        'office',
        0,
        "In the deed box, unsent: “Sirs, I wish the staff pension fund "
            "closed on Friday and the money returned to me. Two of them have "
            "been counting on it for twenty years, and I am tired of being "
            "counted.”",
        icon: Icons.mail,
        color: paper,
        inside: 'nightstand',
      ),
    ],
  ],
  herrings: [...farmHerrings, lovePoem],
  weapons: {'chutelever'},
  printsOn: ['taffy', 'gus'],
  prints: Evidence.given(
    'prints',
    'Prints on the Lever',
    'churlock',
    "Two sets of prints came up under the powder. Taffy Pulman's are old, "
        "under the grease. Gus Gumdrop's are fresh, and wrapped right round "
        "the grip, on top of it.",
    icon: Icons.fingerprint,
    color: Color(0xFFB2EBF2),
  ),
  deskCode: '1876',
  hints: {
    ...farmHints,
    ...farmPhoneHints,
    ...farmPieHints,
    'chutelever':
        "Pulled from the barn, Churlock, and it fell in the "
        "cellar. Nobody had to be anywhere near him. Dust it.",
    'cornheap':
        "All at once, from above. Who works the chute, and who "
        "could see down it?",
    'chutekey':
        "The key to the chute, marked for the foreman, in the "
        "cook's recipe box. Two people, one key.",
    'puller':
        "A machine that counts, at a rate written on its own side, "
        "and a batch that came out soft. That places the farmhand, I "
        "should say.",
    'ticket':
        "Punched by the guard, on the right night. I should say that "
        "places the Professor well enough.",
    'potatonote':
        "Signed M., and sending him to stand exactly under the "
        "chute. I should look at what goes into that pie.",
    'recipecard':
        "No potatoes, Churlock. So what was anybody doing "
        "fetching potatoes for it?",
    'pensionfund':
        "Two names, one fund, and a word written across it. "
        "That is a motive for two.",
    'dissolve':
        "Two of them counting on it for twenty years. That is a "
        "motive for two.",
    'barnlog': "Where does it say the key was? And where did we find it?",
    'prints': printsHintFarm,
  },
  accuseHints: [
    "Before you name anyone, Churlock: do we know how he died, and from "
        "where? Find out what came down on him.",
    "Every one of the five has an alibi, and I believe all five. So ask "
        "who did not need to be in the cellar at all.",
    "Somebody sent him to stand in one particular spot, and somebody held "
        "the key to what came down on it. Look for a note, and a key.",
    "A note signed M., a key in the cook's box, and a lever with the "
        "foreman's hand round it. Name them both.",
  ],
  topics: {
    'butterscotch': [
      Topic(
        'what',
        'What happened to him?',
        "Victim's Cornelius Kernel, the candy corn king. Buried, Detective. "
            "A ton of his own corn came down the chute on top of him. We had "
            "to dig to find the outline.",
      ),
      Topic(
        'weapon',
        'Could it have been an accident?',
        "That chute's padlocked at the barn end. Has been since Monday, "
            "when Taffy jammed it. Somebody unlocked it and pulled the lever. "
            "From the barn, mind. Not from down here.",
      ),
      sheriffHome,
      Topic(
        'creamery',
        'Can the creamery man vouch for Gus?',
        "I rang them first thing. Fudge, the driver, says Gus handed him "
            "four churns at the barn door on the stroke of eleven, and was "
            "still standing in the doorway when the cart pulled away at two "
            "minutes past.",
        heard: ['gus/where'],
      ),
      sheriffChart,
    ],
    'jellybean': deputyTopics,
    'marsha': [
      marshaWhere,
      Topic(
        'about',
        aboutQ,
        "Gruff, and a bit of a crust on him. Thirty years I cooked for "
            "that man. Thirty years, and what had I to show for it but a "
            "promise?",
      ),
      Topic(
        'suspect',
        suspectQ,
        "I don't like to say it. But the Professor's been sly lately, "
            "creeping about with his packets.",
      ),
      Topic(
        'note',
        'Did you send him down for potatoes?',
        "Potatoes? I never did. I never wrote that. Somebody's copied my "
            "hand.",
        needs: ['potatonote'],
      ),
      Topic(
        'nopotato',
        'There are no potatoes in your pie.',
        "Well, no, dear. Who'd put potatoes in a pie? ...Oh.",
        heard: ['marsha/note'],
      ),
      Topic(
        'key',
        'The chute key was in your recipe box.',
        "Gus gives it me to mind when he's in the loft. He loses things. "
            "That's all. That's all it is.",
        needs: ['chutekey'],
      ),
      Topic(
        'pension',
        'You and Gus share the pension fund.',
        "Twenty years we've waited on that fund, dear. It was promised. "
            "And on Friday it was to go. Just like that.",
        needs: ['pensionfund', 'dissolve'],
      ),
      marshaCard,
      ...marshaCommon,
    ],
    'gus': [
      gusWhere,
      Topic(
        'about',
        aboutQ,
        "Best farmer in Candy Land, and knew it. Promised me and Marsha a "
            "pension, twenty years back. Took it away on Sunday, over cards.",
      ),
      Topic(
        'suspect',
        suspectQ,
        "The girl. Lolly. Big Sugar write to her every month. With him "
            "gone, it's hers to sell.",
      ),
      Topic(
        'chute',
        'The corn chute came down on him.',
        "Padlocked since Monday. I've the only key. On my belt, always.",
        needs: ['cornheap'],
      ),
      Topic(
        'log',
        'Do you keep a log of the barn?',
        "Every night. It's on the nail. Take it.",
        gives: Evidence.given(
          'barnlog',
          'Barn Log',
          'gus',
          "Gus's barn log for last night, in big careful capitals: “11:00 "
              "CHURNS TO FUDGE. 11:10 BEDDED DOWN IN LOFT. CHUTE PADLOCKED SINCE "
              "MONDAY. ONLY KEY ON MY BELT.”",
        ),
      ),
      Topic(
        'key',
        'The chute key was in Marsha’s recipe box.',
        "...Was it. I give it her to mind, sometimes. When I'm up the "
            "loft. A man loses things in hay.",
        needs: ['chutekey'],
      ),
      Topic(
        'myprints',
        'Your hand is round the chute lever.',
        "I work that chute every week. My hand's been round it twenty "
            "years.",
        needs: ['prints'],
      ),
      Topic(
        'pension',
        'You and Marsha share the pension fund.',
        "Promised, twenty years. He took it back over a hand of cards. "
            "Marked cards.",
        needs: ['pensionfund', 'dissolve'],
      ),
      ...gusCommon,
    ],
    'lolly': [
      lollyWhere,
      Topic(
        'about',
        aboutQ,
        "Daddy? Stubborn as a stalk. He'd been on about the pension all "
            "week. Said the staff had him by the purse strings.",
      ),
      Topic(
        'suspect',
        suspectQ,
        "Taffy jammed the chute on Monday. But Taffy wouldn't. Taffy "
            "couldn't. I don't know.",
      ),
      Topic(
        'note',
        'Did you hear anything from the kitchen?',
        "Marsha, at ten to eleven, at the front door: “Go on out to the "
            "cellar, Cornelius, there's a dear.” And a lot of grumbling. Then "
            "the cellar door.",
        needs: ['partyline'],
      ),
      ...lollyCommon,
    ],
    'taffy': [
      taffyWhere,
      Topic(
        'about',
        aboutQ,
        "Fair man. Hard, but fair. Docked me for jammin' the chute "
            "Monday. Fair enough.",
      ),
      Topic('suspect', suspectQ, "Couldn't say. I was crankin'."),
      Topic(
        'rumble',
        'Did you hear anything from the cellar?',
        "The chute, at five past eleven. Sounds like thunder through the "
            "press shed wall. Thought Gus was fillin' the bins at night, which "
            "he never does.",
        needs: ['puller'],
      ),
      Topic(
        'myprints',
        'Your fingerprints are on the chute lever.',
        "From Monday. I jammed it, didn't I. Gus took the key off me after.",
        needs: ['prints'],
      ),
      taffyPoem,
      ...taffyCommon,
    ],
    'licorice': [
      licoriceWhere,
      Topic(
        'about',
        aboutQ,
        "A brilliant farmer and an impossible man. Lately he was obsessed "
            "with money. Who was owed it, who was waiting for it.",
      ),
      Topic(
        'suspect',
        suspectQ,
        "I was on a train, Detective. But if you want a scientist's "
            "opinion: who would profit by the hour of his death?",
      ),
      ...licoriceCommon,
    ],
  },
);
