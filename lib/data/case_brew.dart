import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// Two killers, who are each other's only alibi.
const brewCase = MysteryCase(
  id: 'brew',
  title: 'A Bitter Brew',
  culprits: {'tira', 'graham'},
  nextVictims: ['penny', 'cannoli', 'barry'],
  solution:
      "Mrs. Senclair was about to sign a new will, cutting off her niece Tira "
      "and dismissing Graham without a pension for helping Tira pawn her "
      "pearls. The espresso urn is too heavy for one dessert, so it took two — "
      "and while Penny, the Colonel and Barry can each be placed elsewhere by "
      "something independent, Tira and Graham vouch only for one another. "
      "Their silver inventory never happened: the dining room was dark and "
      "silent all evening. At eleven Tira lured her aunt downstairs while "
      "Graham fetched the urn, and together they tipped it. The tally sheet "
      "they signed was written afterwards, in a hurry: its forks, knives and "
      "spoons add up to 146, not 144.",
  core: [
    Evidence(
      'urn', 'Overturned Espresso Urn', 'cellar', 2,
      "The huge brass urn from the pantry, emptied over the victim. Its two "
      "handles are set far apart, one each side. There are no drag marks: it "
      "was carried here level, then tipped. It wants dusting for fingerprints.",
    ),
    Evidence(
      'notepad', "Butler's Notepad", 'dining', 0,
      "Graham's household notepad: thick cream paper with a silver “S” "
      "monogram. The top sheet has been torn off, but the rubbing raises "
      "what was written on it: “It must be tonight, at eleven.”",
      icon: Icons.sticky_note_2, color: paper,
      puzzle: Puzzle.rubbing,
      pieces: ['It must be', 'tonight,', 'at eleven.'],
    ),
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Today's page: "
      "“10 AM, Crumble and Crumble. Sign. Tell T. and G. afterwards, not "
      "before.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
    souffle,
    boots,
    Evidence(
      'phone', 'Telephone Log', 'landing', 0,
      "The operator's slip beside the attic telephone: “Outgoing call, "
      "10:50 PM – 11:30 PM. Caller: Col. Cannoli. To: Fort Fondant Officers' "
      "Club. Line never dropped.”",
      icon: Icons.phone_in_talk, color: Color(0xFFB2EBF2),
    ),
  ],
  variants: [
    timeOfDeath,
    [
      Evidence(
        'tracks', 'Empty Urn Stand', 'pantry', 0,
        "Where the espresso urn normally sits. In the spilled flour there is "
        "a wide scrape where something heavy was lifted off, and two separate "
        "sets of prints, one either side of it, heading for the cellar.",
      ),
      Evidence(
        'wetprints', 'Coffee Footprints', 'cellar', 1,
        "Coffee footprints leading away from the puddle toward the stairs. "
        "There are two trails, side by side, of two quite different sizes.",
        icon: Icons.directions_walk, color: Color(0xFF8D6E63),
      ),
    ],
    [
      Evidence(
        'newwill', 'Unsigned New Will', 'study', 0,
        "A draft on Mrs. Senclair's desk, to be signed today: “I revoke all "
        "bequests to my niece Tira Misu. My butler, G. Cracker, is dismissed "
        "without pension. Both know why. Everything goes to the Donut County "
        "Home for Day-Old Pastries.”",
        icon: Icons.description, color: Colors.white,
      ),
      Evidence(
        'solicitor', "Solicitor's Letter", 'entrance', 3,
        "On the mat under the letterbox, opened and re-folded: “Madam, as "
        "instructed, the new will disinheriting Miss Misu and dismissing "
        "Mr. Cracker without pension is ready. I shall bring it for your "
        "signature tomorrow at ten. — Crumble & Crumble.”",
        icon: Icons.mail, color: paper,
        puzzle: Puzzle.torn,
        pieces: [
          'Madam, as instructed, the new will',
          'disinheriting Miss Misu and dismissing',
          'Mr. Cracker without pension is ready.',
          'I shall bring it for your signature',
          'tomorrow at ten. — Crumble & Crumble',
        ],
      ),
    ],
    [
      Evidence(
        'silver', 'Silver Cabinet', 'dining', 1,
        "The family silver, gleaming. A tag in Penny's handwriting hangs on "
        "the door: “Counted & polished — yesterday, 3 PM. All 144 pieces "
        "present.”",
      ),
      Evidence(
        'candles', 'Chandelier Candles', 'dining', 5,
        "The chandelier is the only light fitting in the dining room. Every "
        "candle in it is brand new, the wicks still white and waxed. None of "
        "them has ever been lit.",
        icon: Icons.light, color: Color(0xFFFFE082),
      ),
    ],
    [
      Evidence(
        'gloves', 'Coffee-Stained Gloves', 'bedroom', 1,
        "Stuffed under Tira's mattress: a pair of elegant evening gloves, "
        "soaked through with espresso and still damp.",
        icon: Icons.back_hand, color: Color(0xFFBCAAA4),
      ),
      Evidence(
        'tickets', 'Packed Suitcase', 'storage', 0,
        "A suitcase at the bottom of a crate, initialled G.C. Inside: a spare "
        "collar and two one-way train tickets to Biscotti Bay for tonight — "
        "“Mr. G. Cracker” and “Miss T. Misu”.",
        icon: Icons.luggage, color: Color(0xFFBCAAA4), inside: 'crates',
      ),
      Evidence(
        'note', 'Half-Burnt Note', 'boiler', 1,
        "Fished from the furnace grate: “...she signs TOMORROW. It must be "
        "tonight, at eleven. I shall fetch it up; you bring her down. Burn "
        "this.” Unsigned, on thick cream paper with a silver “S” monogram.",
        icon: Icons.local_fire_department, color: Color(0xFFFFAB40),
        puzzle: Puzzle.torn,
        pieces: [
          '...she signs TOMORROW.',
          'It must be tonight, at eleven.',
          'I shall fetch it up;',
          'you bring her down.',
          'Burn this.',
        ],
      ),
    ],
  ],
  herrings: [
    iou, sabre, dismissal, spade, recipe, berryStain, sauceDrip, threat,
    cocoa, crumbs, jobAd, betting, savings, diary,
    Evidence(
      'ricottadrip', 'White Cream Drips', 'landing', 4,
      "A little pool of thick white ricotta on the landing floorboards, "
      "directly below the telephone, and nowhere else.",
      icon: Icons.water_drop, color: Colors.white,
    ),
    Evidence(
      'pearls', 'Empty Pearl Case', 'study', 2,
      "At the back of the drawer, a velvet jewel case stamped “Senclair "
      "Pearls”. It is empty. In the lid, a pawnbroker's ticket dated last "
      "month.",
      icon: Icons.diamond, color: Color(0xFFE1BEE7), inside: 'desk',
    ),
  ],
  weapons: {'urn'},
  printsOn: ['penny', 'tira', 'graham'],
  prints: Evidence.given(
    'prints', 'Prints on the Urn', 'churlock',
    "Three sets of prints came up under the powder. On the lid, Penny "
    "Cotta's: she fills it every morning. On the left handle, Tira Misu's. "
    "On the right handle, Graham Cracker's.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1892',
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "Somebody drenched her, Detective — gallons of scalding espresso, "
        "poured until she went soggy and simply fell apart. We outlined what "
        "was left in powdered sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "That brass espresso urn lying on its side. Take a good look at it.",
      ),
      Topic(
        'weight', 'How heavy is that urn?',
        "Full? Glaze and I tried to right it between us and nearly lost our "
        "icing. I had a go on my own first. Couldn't get one side off the "
        "floor.",
        needs: ['urn'],
      ),
      whoWasHome,
      sprinklesChart,
    ],
    'glaze': glazeTopics,
    'penny': [
      pennyWhere,
      Topic(
        'about', aboutQ,
        "Strict, but fair. She'd been upset lately — her pearls went missing "
        "last month, and she'd been shut up with her solicitor ever since.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to stir the pot... but the Colonel owes Madam a "
        "fortune, and Barry was in her bad books over the strawberries.",
      ),
      Topic(
        'dark', 'Graham says he and Tira were counting silver next door.',
        "Last night? The dining room is right through that wall, Detective. "
        "From half ten on it was dark and silent as a fridge. No light under "
        "the door, not a clink. And you can't count a hundred and forty-four "
        "pieces of silver without a clink.",
        heard: ['graham/where'],
      ),
      Topic(
        'lamp', 'Graham says they worked by a shaded lamp.',
        "A lamp? The only lamp on this floor is the one on my kitchen table, "
        "and it never left my sight. I was reading my basting times by it.",
        heard: ['graham/dark'],
      ),
      Topic(
        'silver', 'Your tag says you counted the silver at 3 PM.',
        "Every piece, and polished it too. It's counted on the first of the "
        "month, and that was yesterday afternoon. Nobody had any call to "
        "count it again that night.",
        needs: ['silver'],
      ),
      Topic(
        'candles', 'The dining-room candles have never been lit.',
        "I should think not, I only put them in yesterday afternoon. Still "
        "white, are they? Then nobody has had a light on in that room since.",
        needs: ['candles'],
      ),
      Topic(
        'cocoa', 'Did Tira fetch port from the cellar at nine?',
        "She did, that much is true. Whether nine was the only time she went "
        "down, I couldn't tell you. I had my head in an oven.",
        needs: ['cocoa'],
      ),
      Topic(
        'boom', 'Could you hear the Colonel on the telephone?',
        "Hear him? The whole county could. He was bellowing about the Battle "
        "of Blancmange for the best part of an hour. It came down the "
        "stairwell like a brass band.",
        heard: ['cannoli/where'],
      ),
      Topic(
        'carry', 'Does Graham carry the urn to the breakfast table?',
        "That urn? It hasn't left its stand in twenty years, Detective. I "
        "fill the coffee pot from it and carry the pot. Nobody carries the "
        "urn anywhere. Nobody could.",
        heard: ['graham/prints'],
      ),
      pennyLog,
      pennyRecipe,
      pennySauce,
      ...pennyCommon,
    ],
    'graham': [
      Topic(
        'where', whereQ,
        "In the dining room, sir, conducting the silver inventory with Miss "
        "Tira's kind assistance. Half past ten until half past eleven. One "
        "hundred and forty-four pieces, all present.",
      ),
      Topic(
        'about', aboutQ,
        "Thirty years I served Madam. She was exacting, as a great house "
        "requires. I shall miss ironing her newspaper.",
      ),
      Topic(
        'suspect', suspectQ,
        "It is not a butler's place to speculate, sir. I will observe only "
        "that the Colonel is deeply in debt to Madam.",
      ),
      Topic(
        'dark', 'Penny says the dining room was dark and silent.',
        "We worked by a single shaded lamp, sir, so as not to disturb the "
        "house. And one lays silver down on baize. It makes no sound.",
        heard: ['penny/dark'],
      ),
      Topic(
        'silver', 'Penny had already counted the silver at 3 PM.',
        "Mrs. Cotta counts, sir. I verify. It is the difference between a "
        "housekeeper and a butler.",
        needs: ['silver'],
      ),
      Topic(
        'candles', 'The dining-room candles have never been lit.',
        "As I say, sir, we did not use the chandelier. One does not burn "
        "Madam's good candles to count spoons.",
        needs: ['candles'],
      ),
      Topic(
        'notepad', 'What did you write on the missing sheet?',
        "A reminder to wind the hall clock, sir. Tonight, at eleven. It "
        "keeps poor time if one is late.",
        needs: ['notepad'],
      ),
      Topic(
        'note', 'This burnt note is on your monogrammed paper.',
        "Madam's paper, sir, not mine. There is a pad of it in every room of "
        "this house. Anyone might have used it.",
        needs: ['note'],
      ),
      Topic(
        'will', 'She was dismissing you without a pension.',
        "Madam said nothing of the kind to me, sir. One would naturally be "
        "distressed, after thirty years.",
        needs: ['newwill', 'solicitor'],
      ),
      Topic(
        'tickets', 'Two tickets to Biscotti Bay, Graham?',
        "A holiday, sir, long planned. Miss Tira dislikes queues and asked "
        "me to purchase her ticket along with my own. That is all.",
        needs: ['tickets'],
      ),
      Topic(
        'pearls', 'What happened to the Senclair pearls?',
        "Mislaid, sir. Madam was forever mislaying things. I could not say "
        "how a pawn ticket came to be in the case.",
        needs: ['pearls'],
      ),
      Topic(
        'tally', 'Is there any record of your silver count?',
        "Certainly, sir. Our tally sheet from last night, signed by Miss "
        "Tira and myself. I trust that settles the matter.",
        heard: ['graham/where'],
        gives: Evidence.given(
          'tally', 'Silver Tally Sheet', 'graham',
          "The sheet Graham says he and Tira filled in last night: “Forks, "
          "48. Knives, 48. Spoons, 50. Total, 144 pieces, all present. "
          "Counted 10:30 to 11:30 PM. Signed, G. Cracker and T. Misu.”",
        ),
      ),
      Topic(
        'prints', 'Your fingerprints are on the urn.',
        "I carry that urn to the breakfast table daily, sir. With "
        "assistance. One would expect to find them.",
        needs: ['prints'],
      ),
      ...grahamCommon,
    ],
    'tira': [
      Topic(
        'where', whereQ,
        "Helping Graham count the silver in the dining room, darling. Half "
        "ten to half eleven. Frightfully dull — spoons, spoons, spoons.",
      ),
      Topic(
        'about', aboutQ,
        "Aunt Éclaire was a sweet old thing with a very hard glaze. We "
        "adored each other. Everyone knows I am her sole heir.",
      ),
      Topic(
        'suspect', suspectQ,
        "The Colonel, darling. He owes her mountains of sugar. Or that "
        "muddy little gardener she was about to sack.",
      ),
      Topic(
        'dark', 'Penny says the dining room was dark and silent.',
        "Penny had her head in an oven, darling. She wouldn't have noticed "
        "a brass band marching through the hall.",
        heard: ['penny/dark'],
      ),
      Topic(
        'lamp', 'Where did the lamp you worked by come from?',
        "Lamp? We had the chandelier blazing, darling, one can't count "
        "spoons in the gloom. ...Why, what did Graham say?",
        heard: ['graham/dark'],
      ),
      Topic(
        'gloves', 'Your gloves are soaked in espresso.',
        "I spilled my after-dinner coffee, darling. All of it. I'm a "
        "tiramisu; we're practically made of coffee. I hid them because "
        "Auntie paid for them and would have shrieked.",
        needs: ['gloves'],
      ),
      Topic(
        'will', 'Your aunt was cutting you out of her will.',
        "Auntie rewrote her will every time her bunions ached, darling, and "
        "tore it up again by Friday. Nobody took it seriously. Least of all me.",
        needs: ['newwill', 'solicitor'],
      ),
      Topic(
        'tickets', 'You have a train ticket to Biscotti Bay for tonight.',
        "A little seaside air, darling, for my nerves. Graham queued for me. "
        "Is a girl not allowed a holiday?",
        needs: ['tickets'],
      ),
      Topic(
        'pearls', 'What happened to the Senclair pearls?',
        "Auntie lost them, found them, lost them again. I never touched the "
        "ugly things.",
        needs: ['pearls'],
      ),
      Topic(
        'cocoa', 'Your cocoa is all over the wine rack.',
        "I went down for the port at nine, darling. Graham wrote it in his "
        "little book. Auntie was alive and scolding me for it at ten.",
        needs: ['cocoa'],
      ),
      Topic(
        'prints', 'Your fingerprints are on the urn.',
        "I helped Graham move it on Sunday, darling, when the footman was "
        "off. Once. It was frightfully heavy and I broke a nail.",
        needs: ['prints'],
      ),
      tiraDiary,
    ],
    'cannoli': [
      Topic(
        'where', whereQ,
        "On the telephone on the attic landing, sir! Ten to eleven until "
        "half past, swapping war stories with old Major Meringue at the "
        "Fort Fondant Officers' Club.",
      ),
      Topic(
        'about', aboutQ,
        "Éclaire? Splendid woman. Very patient with a chap's temporary "
        "financial embarrassments.",
      ),
      Topic(
        'suspect', suspectQ,
        "The housekeeper found the body, sir. In my experience the chap who "
        "finds the body wants watching. Or the gardener. Never trust a tart.",
      ),
      Topic(
        'dining', 'Did you pass the dining room last night?',
        "Came down the stairs at half past eleven when I rang off, sir, "
        "straight past it. Door shut, no light under it, quiet as a "
        "churchyard. Why, was somebody meant to be in there?",
        heard: ['graham/where'],
      ),
      Topic(
        'drip', 'There is ricotta on the floor by the telephone.',
        "I stood on that spot for forty minutes, sir. A chap drips. Old war "
        "wound. I'd be more worried if there were none.",
        needs: ['ricottadrip'],
      ),
      cannoliIou,
      cannoliProof,
      cannoliBetting,
      cannoliSabre,
    ],
    'barry': [
      Topic(
        'where', whereQ,
        "Out in the greenhouse 'til midnight, coverin' the strawberries "
        "against the frost. Penny let me in — door was latched. Left me boots "
        "on the mat like she always nags me to.",
      ),
      barryAbout,
      Topic(
        'suspect', suspectQ,
        "Couldn't say, guv. But whoever it was had a strong back. I haul "
        "coal all day and I can't shift that coffee urn on me own.",
      ),
      Topic(
        'furnace', 'I pulled a burnt note out of your furnace.',
        "Ain't my writin', guv — I can barely spell “fertiliser”. But when I "
        "came in at midnight the furnace door was open and the fire "
        "fresh-poked. I banked it meself at six. Somebody had been at it.",
        needs: ['note'],
      ),
      ...barryCommon,
    ],
  },
);
