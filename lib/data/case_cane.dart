import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// Two killers, one of whom has a perfectly genuine alibi: she never left
/// her oven. She only opened a door.
const caneCase = MysteryCase(
  id: 'cane',
  title: 'Raising Cane',
  culprits: {'penny', 'barry'},
  nextVictims: ['graham', 'tira', 'cannoli'],
  herringCount: 10,
  solution:
      "Mrs. Senclair was to sign away Senclair Confections this morning, "
      "recipes and all, and turn out the staff. Penny Cotta, whose recipe "
      "had made the fortune, and Barry Tart, who was to be dismissed, had "
      "put down a deposit together on a tea garden they could not pay for. "
      "Penny's soufflé was real, and she never left it. She did not need "
      "to. At twenty to eleven she drew the bolt of the back door, six feet "
      "from her oven, let Barry in out of the rain, and handed him the "
      "sugarloaf. At 11:05 he struck Mrs. Senclair with it in the cellar, "
      "where she went every night to lock the wine rack. He slept by the "
      "boiler; his boots were put on the mat for show. The dog, who barks "
      "whenever that door opens after dark, barked once, at twenty to "
      "eleven, and not at midnight. And in the latch book Penny handed "
      "over, the midnight entry stands above the one for half past eleven: "
      "she wrote it first.",
  core: [
    Evidence(
      'loafstand', 'Sugarloaf Stand', 'pantry', 1,
      "The stand where the household sugarloaf is kept: a cone of hard "
      "sugar as tall as a top hat, and about as heavy as a brick. The blue "
      "paper wrapper lies flat and empty, with the sugar nippers beside it. "
      "The loaf is gone.",
      icon: Icons.change_history, color: Color(0xFFE3F2FD),
    ),
    souffle,
    boots,
    phoneTira,
    steadyScoresheet,
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Today's page: "
      "“10 AM, Bourbon & Sons. Sign the sale: the company, the name, and "
      "every recipe. Staff to go at the month end. Tell them nothing.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
  ],
  variants: [
    timeOfDeath,
    [
      Evidence(
        'mudprint', 'Heel Print', 'cellar', 1,
        "A heel print pressed into the spilled custard beside the outline, "
        "in the red clay of the strawberry beds. It is on top of the "
        "custard, and the clay was still wet when it was made.",
        icon: Icons.directions_walk, color: Color(0xFFBF6B4A),
      ),
      Evidence(
        'seedglaze', 'Seeds in the Custard', 'cellar', 2,
        "A smear of set red glaze on the flagstones beside the outline, "
        "full of tiny strawberry seeds. It lies on top of the spilled "
        "custard, so it got there afterwards.",
        icon: Icons.grain, color: Color(0xFFE57373),
      ),
    ],
    [
      Evidence(
        'loafdirt', 'Sugarloaf', 'backyard', 0,
        "A spade's depth down in the loose earth: the sugarloaf. The point "
        "is cracked clean off, and there is custard in the crack. It wants "
        "dusting for fingerprints.",
        inside: 'dirt',
      ),
      Evidence(
        'loafkennel', 'Sugarloaf', 'backyard', 0,
        "Pushed to the back of the kennel: the sugarloaf. Pupcake has "
        "licked one side quite smooth. The point is cracked clean off, and "
        "there is custard in the crack. It wants dusting for fingerprints.",
        inside: 'kennel',
      ),
    ],
    [
      Evidence(
        'deed', 'Deposit Receipt', 'boiler', 0,
        "Folded small under Barry's sandwiches: “Received from P. Cotta and "
        "B. Tart, jointly, a deposit on the Old Mill tea garden and "
        "nursery. The balance of 2,000 cubes falls due at the month end, or "
        "the deposit is forfeit.”",
        icon: Icons.request_quote, color: paper, inside: 'kitbag',
      ),
      Evidence(
        'signboard', 'Painted Design', 'kitchen', 0,
        "Rolled up behind the cooking sherry, a design for a signboard, "
        "painted with some care: “COTTA & TART. Teas, Tarts and Bedding "
        "Plants.” On the back, in Penny's hand: “Wants 2,000 by month end. "
        "We have 300.”",
        icon: Icons.brush, color: Color(0xFFF8BBD0), inside: 'cupboard',
      ),
    ],
  ],
  herrings: [
    will, bills, dismissal, spade, jobAd, recipe, threat, berryStain, crumbs,
    cocoa, sauceDrip, betting, diary, iou, slipper, scratches, letters,
    medal,
  ],
  weapons: {'loafdirt', 'loafkennel'},
  printsOn: ['penny', 'barry'],
  prints: Evidence.given(
    'prints', 'Prints on the Sugarloaf', 'churlock',
    "Two sets of prints came up under the powder. Penny Cotta's are small "
    "and neat around the base, where a cook holds a loaf to nip it. The "
    "other is one large hand wrapped right round the narrow end, as you "
    "would grip a club. It is Barry Tart's.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1884',
  hints: {
    ...commonHints,
    ...timeHints,
    'phone': phoneHint,
    'souffle': "I believe in that pudding, Churlock. She was at that oven "
        "all hour. But notice what else is in that kitchen, six feet from "
        "the oven.",
    'boots': "Read whose handwriting that is, old chap. We have one "
        "dessert's word for when that door was opened, and no more.",
    'scoresheet': "No gaps, and each man watching the other. Those two "
        "were in the parlor till midnight. I wonder what they heard at "
        "midnight.",
    'loafstand': "Kept in Penny's pantry. Whoever took it either lives in "
        "that kitchen or walked through it.",
    'planner': "Every servant in this house was to lose their place. That "
        "is a motive for three of them. We want something narrower.",
    'mudprint': "Garden clay, on top of the custard, wet. And yet the "
        "gardener was locked out of doors until midnight. Who says so?",
    'seedglaze': "On top of the custard, so after she fell. And yet the "
        "only tart in the house was locked out until midnight. Who says so?",
    'loafdirt': "Out in the yard. And the only way into that yard is "
        "through one room. I should dust it.",
    'loafkennel': "Out in the yard. And the only way into that yard is "
        "through one room. I should dust it.",
    'deed': "Two names on one piece of paper, Churlock. And a sum neither "
        "of them could find by the month end.",
    'signboard': "Two names on one piece of board, Churlock. And a sum "
        "neither of them could find by the month end.",
    'latchbook': "Read it from top to bottom, old chap, as it was written. "
        "In the order it was written.",
    'prints': "One of those is how you hold sugar. The other is how you "
        "hold a cudgel. Ask him how his hand came to be on it, and then ask "
        "the butler who really carries in the groceries.",
  },
  accuseHints: [
    "Every one of the five has an alibi this time, Churlock, and I believe "
        "four of them. So look for the alibi that is true and still does "
        "not matter.",
    "Barry was locked out until midnight. Who told us so? One dessert, in "
        "her own handwriting. Now ask the rest of the house what they heard "
        "at midnight, and what the dog did.",
    "The weapon came from the pantry and ended up in the yard. To do "
        "either, you must pass through the kitchen. Who was in the kitchen, "
        "and what did she say she saw?",
    "She never left her oven, old chap, and she never had to. A bolt can "
        "be drawn in ten seconds. Read the latch book again, line by line, "
        "and then name the one who opened the door and the one who came "
        "through it.",
  ],
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "One blow from above, Detective, with something hard and heavy that "
        "comes to a blunt point. Cracked her shell like an egg. We traced "
        "where she fell in powdered sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Couldn't tell you. Shaped like a cone, weighs as much as a brick, "
        "and it isn't down here. Whoever swung it took it away with them.",
      ),
      whoWasHome,
      sprinklesChart,
    ],
    'glaze': [
      ...glazeTopics,
      Topic(
        'tread', 'Could that mark have been made this morning?',
        "Not a chance. Nobody has been within a yard of that outline since "
        "we chalked it but me and the Sarge, and we kept the gardener shut "
        "in the boiler room till you came. It was there when we arrived.",
        needs: ['mudprint', 'seedglaze'],
      ),
    ],
    'penny': [
      pennyWhere,
      Topic(
        'about', aboutQ,
        "Strict, but fair, I always said. She paid on time. Thirty years I "
        "cooked for that woman, Detective, and I'd have cooked thirty more.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to stir the pot... but Miss Tira does love her "
        "aunt's fortune a great deal more than she loved her aunt.",
      ),
      Topic(
        'loaf', 'Your sugarloaf is missing.',
        "My sugarloaf! It was on its stand at supper, in its blue paper. I "
        "nipped a piece off for the soufflé at ten and wrapped it up again. "
        "Somebody's had it out of my pantry.",
        needs: ['loafstand'],
      ),
      Topic(
        'yard', 'The sugarloaf was hidden out in the yard.',
        "In the yard? Well, nobody went out through my kitchen while I was "
        "basting, I can promise you that. It must have been carried out "
        "after half eleven, when I'd gone up.",
        needs: ['loafdirt', 'loafkennel'],
      ),
      Topic(
        'book', 'May I see the night-latch book?',
        "The latch book? It hangs by the front door. Here's last night's "
        "page. Graham latches up and signs, and I sign for anyone I let in "
        "after. It's all in order.",
        needs: ['boots'],
        gives: Evidence.given(
          'latchbook', 'Night-Latch Book', 'penny',
          "Last night's page of the latch book, three entries, one under "
          "another. “10:00. All doors latched. G.C.” Then, in Penny's "
          "hand: “12:00. Let Barry in from the greenhouse. P.C.” And below "
          "that, also hers: “11:30. Soufflé out, oven banked, kitchen "
          "lamps down. P.C.”",
        ),
      ),
      Topic(
        'order', 'You wrote midnight above half past eleven.',
        "Did I? I... I'll have left a line and gone back to fill it in. "
        "I was all of a wobble, Detective. I'm all of a wobble now.",
        needs: ['latchbook'],
      ),
      Topic(
        'prints', 'Your fingerprints are on the sugarloaf.',
        "It's my sugar, Detective. I nip it every day of my life. You'd "
        "find my fingerprints on every loaf in Donut County.",
        needs: ['prints'],
      ),
      Topic(
        'carried', 'Barry says he carried the sugar in for you.',
        "He did, bless him. Tuesday. It's a weight, a full loaf, and my "
        "wrists aren't what they were.",
        heard: ['barry/prints'],
      ),
      Topic(
        'teagarden', 'You and Barry have paid a deposit on a tea garden.',
        "It's a daydream, Detective, that's all. An old woman and a "
        "gardener and a pot of tea. We'd never have found the balance. "
        "...We'd never have found it.",
        needs: ['deed', 'signboard'],
      ),
      Topic(
        'sale', 'She was selling the company, and your recipe with it.',
        "Selling? She never said one word to me. Not one. I'd no idea "
        "until this minute.",
        needs: ['planner'],
      ),
      pennyLog,
      pennyRecipe,
      pennySauce,
      ...pennyCommon,
      ...pennyYard,
    ],
    'graham': [
      Topic(
        'where', whereQ,
        "In the parlor, sir, at chess with the Colonel, from half past ten "
        "until two minutes to midnight. Neither of us left the board.",
      ),
      Topic(
        'about', aboutQ,
        "Thirty years I served Madam. She was exacting, as a great house "
        "requires. I shall miss ironing her newspaper.",
      ),
      Topic(
        'suspect', suspectQ,
        "It is not a butler's place to speculate, sir. Though I will say "
        "that they always blame the butler, and I find it tiresome.",
      ),
      Topic(
        'eleven', 'Why was she in the cellar at eleven at night?',
        "Madam locked the wine rack herself at eleven each night, sir, and "
        "took the key to bed. She had done so for thirty years. Everybody "
        "under this roof could set a watch by it.",
      ),
      Topic(
        'dog', 'Did you hear Penny let Barry in at midnight?',
        "I did not, sir, though the Colonel and I were in the parlor until "
        "two minutes to, and I was in the hall directly after. I will say "
        "this: the dog barks whenever that back door is opened after dark. "
        "One hears it all over the house.",
        heard: ['penny/letin'],
      ),
      Topic(
        'delivery', 'Barry says he carried the sugar in on Tuesday.',
        "The grocer delivers on Thursdays, sir, at four. I signed for one "
        "sugarloaf yesterday afternoon and carried it to the pantry "
        "myself. The gardener was not in the house, and Mrs. Cotta was at "
        "the market.",
        heard: ['barry/prints'],
      ),
      Topic(
        'sale', 'She was selling the company and dismissing the staff.',
        "I had gathered as much, sir. I have my savings and a sister in "
        "Shortbread. It would have been an inconvenience. It was not a "
        "catastrophe.",
        needs: ['planner'],
      ),
      ...grahamCommon,
      ...grahamYard,
    ],
    'cannoli': [
      Topic(
        'where', whereQ,
        "In the parlor, thrashing Graham at chess! Half ten to midnight, "
        "never left my chair. A soldier holds his position, what!",
      ),
      Topic(
        'about', aboutQ,
        "Éclaire? Dear old friend! Generous to a fault. We understood one "
        "another perfectly.",
      ),
      Topic(
        'suspect', suspectQ,
        "The niece, sir. Cherchez la heiress! She was on that telephone "
        "half the night, and who is to say what she was arranging?",
      ),
      Topic(
        'bark', 'When did the dog bark last night?',
        "Twenty to eleven, sir, on the dot. Put me clean off my gambit. "
        "Yapped for a minute and stopped. At midnight? Silent as the "
        "grave. We were packing up the pieces. I'd have heard.",
        heard: ['graham/dog'],
      ),
      cannoliIou,
      cannoliProof,
      cannoliBetting,
      cannoliMedal,
    ],
    'tira': [
      Topic(
        'where', whereQ,
        "On the telephone on the landing, darling, from ten to eleven until "
        "half past. Madame Leine was describing the new spring hats in "
        "exhaustive detail.",
      ),
      Topic(
        'about', aboutQ,
        "Aunt Éclaire was a sweet old thing with a very hard glaze. Yes, I "
        "inherit. No, I didn't do it. I look dreadful in black.",
      ),
      Topic(
        'suspect', suspectQ,
        "Graham, darling. He's been sour as lemon curd for a month. "
        "Something about a reference. It's always the quiet, square ones.",
      ),
      Topic(
        'bark', 'When did the dog bark last night?',
        "Once, darling, at twenty to eleven. I remember because I was "
        "about to ring Madame Leine and had to wait for the little beast "
        "to stop. Not a yap after that, and I was awake until one.",
        heard: ['graham/dog'],
      ),
      Topic(
        'chess', 'Could you hear the chess players?',
        "The Colonel roars “check” as if he were ordering a charge, "
        "darling. Every few minutes, all the way to midnight. And Graham "
        "sighing in between.",
        needs: ['scoresheet'],
      ),
      ...tiraCommon,
    ],
    'barry': [
      Topic(
        'where', whereQ,
        "Out in the greenhouse 'til midnight, coverin' the strawberries "
        "against the frost. Penny let me in — door was latched. Left me "
        "boots on the mat like she always nags me to.",
      ),
      barryAbout,
      Topic(
        'suspect', suspectQ,
        "That niece, guv. She'll have the lot now, won't she. And the "
        "Colonel owes more than he's worth.",
      ),
      Topic(
        'mud', 'Your heel print is in the custard.',
        "I'm through that cellar ten times a day to get to me boiler, guv. "
        "Must've trod there this mornin', in all the fuss.",
        needs: ['mudprint'],
      ),
      Topic(
        'glaze', 'Your glaze is on the cellar floor, on top of the custard.',
        "I'm through that cellar ten times a day to get to me boiler, guv. "
        "I shed seeds like a dog sheds hair. That'll be from this mornin'.",
        needs: ['seedglaze'],
      ),
      Topic(
        'prints', 'Your hand is round the end of the sugarloaf.',
        "Carried the shoppin' in for Penny, didn't I. Tuesday. She can't "
        "lift a full loaf with them wrists. Ask her.",
        needs: ['prints'],
      ),
      Topic(
        'knock', 'Nobody heard you knock at midnight. Not even the dog.',
        "I knocked soft, guv. Didn't want to wake the house. And the dog "
        "knows me. He don't bark at me.",
        heard: ['graham/dog'],
      ),
      Topic(
        'barked', 'The dog barked at twenty to eleven.',
        "Fox, most likely. Or the rain. He barks at the rain. I was in the "
        "greenhouse, guv, I told you.",
        heard: ['tira/bark'],
      ),
      Topic(
        'teagarden', 'You and Penny have paid a deposit on a tea garden.',
        "A fella can dream, can't he? Me on the beddin' plants, her on the "
        "scones. Never would've come to nothin'.",
        needs: ['deed', 'signboard'],
      ),
      ...barryBasics,
    ],
  },
);
