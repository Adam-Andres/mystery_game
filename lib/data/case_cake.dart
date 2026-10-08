import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// A single killer, whose alibi is an object rather than a person.
const cakeCase = MysteryCase(
  id: 'cake',
  title: 'The Twelve-Year Fruitcake',
  culprits: {'penny'},
  nextVictims: ['barry', 'graham', 'tira', 'cannoli'],
  solution:
      "Thirty years ago Mrs. Senclair built her fortune on Penny Cotta's cream "
      "puff recipe and never paid her a cube; now she meant to retire Penny "
      "without notice. Penny's alibi was a soufflé — but it was never baked "
      "last night. The oven was cold and the eggs untouched, and Barry saw an "
      "empty kitchen at eleven. At 11:05 she struck Mrs. Senclair in the "
      "cellar with the rock-hard Christmas fruitcake, leaving a drip of her "
      "own sauce beneath the body, then “found” her in the morning. The "
      "chess players were heard throughout, Tira was on the telephone, and "
      "Barry was locked outside. The oven log she handed over was written "
      "afterwards: it has Madam ringing down at 11:20, a quarter of an hour "
      "after she died.",
  core: [
    Evidence(
      'tin', 'Empty Cake Tin', 'pantry', 1,
      "A large tin on the pantry shelf labelled “Senclair Christmas "
      "Fruitcake — 12 years old. DO NOT EAT.” The tin is empty. A ring in "
      "the dust shows it was lifted down very recently.",
      icon: Icons.inventory_2, color: Color(0xFFE3F2FD),
    ),
    souffle,
    boots,
    phoneTira,
    Evidence(
      'scoresheet', 'Chess Scoresheet', 'parlor', 0,
      "Graham's meticulous record of last night's game. A move is entered "
      "every two or three minutes from 10:32 until 11:58 without a break, "
      "each one initialled by both players.",
      icon: Icons.assignment, color: paper,
    ),
    Evidence(
      'notepad', "Butler's Notepad", 'dining', 0,
      "Graham's household notepad. The top sheet is gone, but the rubbing "
      "raises what was written on it: “Eggs: a fresh dozen came today. Order "
      "none.” A shopping note.",
      icon: Icons.sticky_note_2, color: paper,
      puzzle: Puzzle.rubbing,
      pieces: ['Eggs: a fresh dozen', 'came today.', 'Order none.'],
    ),
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Today's page: "
      "“9 AM, the agency sends the new housekeeper. Tell P.C. after "
      "breakfast, not before.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
  ],
  variants: [
    timeOfDeath,
    [
      Evidence(
        'underdrip', 'Sauce Beneath the Body', 'cellar', 1,
        "The officers marked this where they lifted the remains: a drop of "
        "red berry sauce on the flagstones UNDERNEATH where Mrs. Senclair "
        "lay. It was on the floor before she fell on it.",
        icon: Icons.water_drop, color: Color(0xFFE53935),
      ),
      Evidence(
        'drydrip', 'Dried Sauce Drip', 'cellar', 2,
        "A drop of red berry sauce beside the outline, dried to a dark, "
        "cracked crust. The drips at the top of the stairs from this morning "
        "would still be glossy; this one is hours older.",
        icon: Icons.water_drop, color: Color(0xFF8E2420),
      ),
    ],
    [
      Evidence(
        'eggs', 'Egg Basket', 'kitchen', 4,
        "The egg basket on the counter, with yesterday's delivery slip: "
        "“1 dozen, fresh.” All twelve eggs are still in it. A Needy Soufflé "
        "takes six.",
        icon: Icons.egg, color: Color(0xFFFFF3E0),
      ),
      Evidence(
        'ovenash', 'Cold Oven', 'kitchen', 2,
        "The kitchen oven. The firebox holds nothing but old grey ash, cold "
        "right through, and the coal scuttle beside it is full to the brim.",
        icon: Icons.fireplace, color: Color(0xFFB0BEC5),
      ),
    ],
    [
      recipe,
      Evidence(
        'retire', 'Letter to an Agency', 'study', 0,
        "On Mrs. Senclair's desk, ready to post: “Please send a modern "
        "housekeeper at once. The present one, P. Cotta, is to be retired "
        "without notice or pension. She makes the same puddings she made "
        "thirty years ago.”",
        icon: Icons.mail, color: paper,
        puzzle: Puzzle.torn,
        pieces: [
          'Please send a modern housekeeper at once.',
          'The present one, P. Cotta,',
          'is to be retired',
          'without notice or pension.',
          'She makes the same puddings as ever.',
        ],
      ),
    ],
    [
      Evidence(
        'cakesack', 'Christmas Fruitcake', 'pantry', 3,
        "Pushed deep into a flour sack: a fruitcake as hard as granite. One "
        "corner is freshly chipped, and there is custard on it. It wants "
        "dusting for fingerprints.",
        inside: 'sacks',
      ),
      Evidence(
        'cakecrate', 'Christmas Fruitcake', 'storage', 1,
        "At the bottom of a crate of old curtains: a fruitcake as hard as "
        "granite. One corner is freshly chipped, and there is custard on it. "
        "It wants dusting for fingerprints.",
        inside: 'crates',
      ),
    ],
  ],
  herrings: [
    will, bills, iou, regiment, dismissal, spade, jobAd, cocoa, crumbs,
    threat, berryStain, sabre, betting, savings, diary,
    Evidence(
      'ricottadrip', 'White Cream Drips', 'entrance', 4,
      "A few spots of thick white ricotta on the floor at the top of the "
      "cellar steps, dried at the edges.",
      icon: Icons.water_drop, color: Colors.white,
    ),
  ],
  weapons: {'cakesack', 'cakecrate'},
  printsOn: ['penny'],
  prints: Evidence.given(
    'prints', 'Prints on the Fruitcake', 'churlock',
    "Only one dessert's prints came up on the fruitcake: Penny Cotta's. "
    "They are sharp and greasy. But then she baked it, twelve years ago, "
    "and it has sat in her pantry ever since. There are no others at all.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1879',
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "Struck from behind, once, with something heavy. She went down like "
        "a dropped tray. We traced where she fell in powdered sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Dense, blunt, about the size of a brick. We picked raisins and "
        "candied peel out of the, er, point of impact. Fruitcake, Detective. "
        "An old one. One dessert could swing it.",
      ),
      whoWasHome,
      sprinklesChart,
    ],
    'glaze': [
      ...glazeTopics,
      Topic(
        'under', 'There was sauce underneath the body.',
        "I noted that myself when we moved her. Whatever dripped there, "
        "dripped before she hit the floor, or as she did. Nobody slid it "
        "under her afterwards.",
        needs: ['underdrip'],
      ),
      Topic(
        'dry', 'How long does berry sauce take to dry like that?',
        "Fresh sauce stays tacky a couple of hours. That spot was bone dry "
        "and cracked when we arrived at seven, and the housekeeper says she "
        "only came down at half six.",
        needs: ['drydrip'],
      ),
      Topic(
        'fresh', 'Would twelve-year-old fingerprints still be sharp?',
        "After twelve years in a tin? They'd be dull as dust, Detective, if "
        "they came up at all. Sharp and greasy means fresh. Hours old, not "
        "years.",
        needs: ['prints'],
      ),
    ],
    'penny': [
      pennyWhere,
      Topic(
        'about', aboutQ,
        "Strict, but fair. She paid on time and never once called me “jelly”. "
        "She'd been in a temper with the whole household this week, mind. "
        "Nobody was spared.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to stir the pot... but Miss Tira does love her aunt's "
        "fortune a great deal more than she loved her aunt.",
      ),
      Topic(
        'sauce', 'There is red berry sauce beside the body.',
        "Well, of course it is. I told you — I went all to pieces when I "
        "found her this morning, and my topping runs when I'm upset.",
        needs: ['underdrip', 'drydrip'],
      ),
      Topic(
        'tin', 'The Christmas fruitcake is gone from its tin.',
        "Gone? Twelve years that thing has sat up there. Madam wouldn't let "
        "me throw it out. Well, the pantry is never locked, Detective. "
        "Anybody could have reached it down.",
        needs: ['tin'],
      ),
      Topic(
        'eggs', 'All twelve of yesterday\'s eggs are still in the basket.',
        "I used up last week's eggs first. Waste not, want not.",
        needs: ['eggs'],
      ),
      Topic(
        'oven', 'Your oven is stone cold and the coal has not been touched.',
        "I always sweep out the grate the moment I've finished baking. And "
        "I had coal left over from the day before. Habit, Detective.",
        needs: ['ovenash'],
      ),
      Topic(
        'window', 'Barry says the kitchen was empty at eleven.',
        "Barry was half frozen and seeing things. I may have stepped into "
        "the scullery for sugar. For a moment.",
        heard: ['barry/window'],
      ),
      Topic(
        'smell', 'Tira says there was no smell of baking last night.',
        "Miss Tira had a telephone pressed to one side of her head and the "
        "Colonel's cigar up the other. I shouldn't rely on her nose.",
        heard: ['tira/smell'],
      ),
      Topic(
        'retire', 'She was going to retire you without notice.',
        "Was she? She said nothing to me. Thirty years, and the same "
        "puddings — well. They were good enough to build her a factory.",
        needs: ['retire'],
      ),
      Topic(
        'prints', 'Your fingerprints are on the fruitcake.',
        "My prints, on my own cake, from my own pantry? I baked the thing, "
        "Detective. I'd be more surprised if you'd found the Colonel's.",
        needs: ['prints'],
      ),
      Topic(
        'log', pennyLogQ, pennyLogA,
        needs: ['souffle'],
        gives: ovenLogForged,
      ),
      pennyRecipe,
      ...pennyCommon,
    ],
    'graham': [
      Topic(
        'where', whereQ,
        "In the parlor, sir, at chess with the Colonel, from half past ten "
        "until midnight. Neither of us left the board.",
      ),
      Topic(
        'about', aboutQ,
        "Thirty years I served Madam. She was exacting, as a great house "
        "requires. I shall miss ironing her newspaper.",
      ),
      Topic(
        'suspect', suspectQ,
        "It is not a butler's place to speculate, sir. Though I will say that "
        "they always blame the butler, and I find it tiresome.",
      ),
      Topic(
        'sheet', 'Your scoresheet shows no breaks at all.',
        "Every move timed and initialled by both players, sir. The Colonel "
        "insists upon it, as he believes that I cheat. I believe the same of "
        "him. It makes for an honest record.",
        needs: ['scoresheet'],
      ),
      Topic(
        'eggs', 'Would Penny bake with last week\'s eggs?',
        "Mrs. Cotta, sir? Never. There were no eggs left from last week; I "
        "signed for the new dozen yesterday because the larder was bare. And "
        "she permits nothing but the freshest. She says a soufflé knows.",
        heard: ['penny/eggs'],
      ),
      Topic(
        'brandy', 'There is ricotta at the top of the cellar steps.',
        "The Colonel fetched up his own brandy at eight o'clock, sir, rather "
        "than ring for me. I disapproved, and entered it in the cellar book.",
        needs: ['ricottadrip'],
      ),
      ...grahamCommon,
    ],
    'cannoli': [
      Topic(
        'where', whereQ,
        "In the parlor, thrashing Graham at chess! Half ten to midnight, "
        "never left my chair. A soldier holds his position, what!",
      ),
      Topic(
        'about', aboutQ,
        "Éclaire? Splendid woman. Very patient with a chap's temporary "
        "financial embarrassments.",
      ),
      Topic(
        'suspect', suspectQ,
        "The niece, sir. Cherchez la heiress! Failing her, that gardener is "
        "forever lurking about below stairs.",
      ),
      Topic(
        'sheet', 'You initialled every move on Graham\'s scoresheet.',
        "Had to, sir. The fellow moves his bishops when one blinks. Never "
        "took my eyes off him in an hour and a half. He'll tell you the same "
        "of me, the cheek of it.",
        needs: ['scoresheet'],
      ),
      Topic(
        'drip', 'You left ricotta at the top of the cellar steps.',
        "Went down for a decent brandy at eight, sir. Graham pours like a "
        "miser. Éclaire was alive and well and telling me so at supper.",
        needs: ['ricottadrip'],
      ),
      cannoliIou,
      cannoliProof,
      cannoliBetting,
      cannoliRegiment,
      cannoliSabre,
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
        "Graham and the Colonel, darling, thick as thieves over that "
        "chessboard. Each one swears the other never moved. How convenient.",
      ),
      Topic(
        'check', 'Could the chess players have slipped out?',
        "I only wish they had, darling. The Colonel bellowed “CHECK!” up "
        "the stairwell every few minutes the whole time I was on the "
        "telephone, and Graham sniffed after every one. It was like a "
        "metronome. Neither of them drew breath long enough to murder anyone.",
        heard: ['graham/where'],
      ),
      Topic(
        'smell', 'Penny was baking a soufflé at that hour.',
        "Was she? How odd. When Penny bakes, the whole stairwell reeks of "
        "it for hours. Last night I smelt nothing but the Colonel's cigar.",
        heard: ['penny/where'],
      ),
      ...tiraCommon,
    ],
    'barry': [
      Topic(
        'where', whereQ,
        "Out in the greenhouse 'til midnight, coverin' the strawberries "
        "against the frost. Came up to the house the once, about eleven, "
        "after me tea flask, but the door was latched so I went back. Penny "
        "let me in at midnight.",
      ),
      barryAbout,
      Topic(
        'suspect', suspectQ,
        "That Colonel owes her a packet, and Miss Tira gets the lot. Take "
        "your pick, guv.",
      ),
      Topic(
        'window', 'Penny says she never left her oven.',
        "Does she? When I came up at eleven I looked in the kitchen window, "
        "hopin' she'd pass me flask out. Lamp lit, oven dark, no Penny. I "
        "stood there a good five minutes. Thought she'd gone to bed.",
        heard: ['penny/where'],
      ),
      Topic(
        'coal', 'The kitchen coal scuttle is still full.',
        "'Course it is, I filled it at six like every evenin'. If it's "
        "still full this mornin', nobody's fired that oven. An hour's bakin' "
        "burns half of it.",
        needs: ['ovenash'],
      ),
      Topic(
        'leftover', 'Penny says she had coal left from the day before.',
        "Not a lump, guv. She was scrapin' the bottom when I filled it — "
        "said so herself, and none too kindly.",
        heard: ['penny/oven'],
      ),
      ...barryCommon,
    ],
  },
);
