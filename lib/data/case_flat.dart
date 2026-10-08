import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// A single killer, whose alibi is another suspect.
const flatCase = MysteryCase(
  id: 'flat',
  title: 'The Flat Truth',
  culprits: {'cannoli'},
  nextVictims: ['graham', 'penny', 'barry', 'tira'],
  solution:
      "Colonel Cannoli owed Mrs. Senclair 50,000 sugar cubes, and she had "
      "learned that his medals were chocolate coins. At 10:45 he left the chess "
      "game, slipped silently through the kitchen behind Penny to take the "
      "marble rolling pin, and at 11:05 rolled Mrs. Senclair flat in the cellar. "
      "He hid the pin and was back at the board by 11:20. Every other resident "
      "can be placed elsewhere: Penny at her oven, Tira on the telephone, Barry "
      "locked outside, and Graham heard on his concertina the whole time. The "
      "note he produced, giving him until Christmas, was his own forgery: he "
      "signed it “Sinclair”, and she would hardly misspell her own name.",
  core: [
    Evidence(
      'rack', 'Rolling Pin Rack', 'kitchen', 0,
      "Penny's rack of rolling pins. Six hooks, five pins. The big marble one "
      "is missing. To reach it, somebody had to walk right through the kitchen.",
    ),
    souffle,
    boots,
    phoneTira,
    Evidence(
      'notepad', "Butler's Notepad", 'dining', 0,
      "Graham's household notepad. The top sheet is gone, but the rubbing "
      "raises what was written on it: “10:30, chess with the Colonel. He "
      "cheats.” An appointment, and by all accounts he kept it.",
      icon: Icons.sticky_note_2, color: paper,
      puzzle: Puzzle.rubbing,
      pieces: ['10:30 — chess with', 'the Colonel.', 'He cheats.'],
    ),
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Today's page: "
      "“9 AM, the Colonel. No more extensions, whatever he says. 11 AM, "
      "telephone Fort Fondant.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
  ],
  variants: [
    timeOfDeath,
    [
      Evidence(
        'ricotta', 'White Cream Drips', 'cellar', 1,
        "A trail of thick white cream leading away from the outline. You taste "
        "it (professionally). Sweet ricotta — not custard. Mrs. Senclair was "
        "filled with vanilla custard, so this came out of somebody else. It "
        "lies on top of the spilled custard, so it fell afterwards.",
        icon: Icons.water_drop, color: Colors.white,
      ),
      Evidence(
        'flakes', 'Pastry Flakes', 'cellar', 2,
        "Pressed into the spilled custard beside the outline: a few crisp, "
        "bubbly flakes of FRIED pastry shell. Mrs. Senclair was baked choux. "
        "These broke off somebody else during the struggle.",
        icon: Icons.grain, color: Color(0xFFC8843C),
      ),
    ],
    [
      Evidence(
        'pinboiler', 'Marble Rolling Pin', 'boiler', 0,
        "Shoved behind the boiler: a heavy marble rolling pin, hastily wiped. "
        "There is still custard in the handle grooves. It wants dusting for "
        "fingerprints.",
      ),
      Evidence(
        'pinpantry', 'Marble Rolling Pin', 'pantry', 3,
        "Pushed deep into a flour sack: a heavy marble rolling pin, hastily "
        "wiped. There is still custard in the handle grooves. It wants "
        "dusting for fingerprints.",
        inside: 'sacks',
      ),
    ],
    [
      Evidence(
        'ledger', 'Debt Ledger', 'study', 0,
        "Mrs. Senclair's ledger, open on her desk. “Col. Cannoli owes 50,000 "
        "sugar cubes. FINAL notice given. He pays by tomorrow or he leaves "
        "this house.”",
        icon: Icons.menu_book, color: Color(0xFFD7CCC8),
      ),
      Evidence(
        'notice', 'Final Notice', 'parlor', 1,
        "Crushed down the side of the armchair, a note in Mrs. Senclair's "
        "hand: “Colonel — 50,000 sugar cubes by tomorrow, or you pack your "
        "trunk. I mean it this time. É.S.”",
        icon: Icons.mail, color: paper,
        puzzle: Puzzle.torn,
        pieces: [
          'Colonel —',
          '50,000 sugar cubes by tomorrow,',
          'or you pack your trunk.',
          'I mean it this time.',
          'É.S.',
        ],
      ),
    ],
    [
      Evidence(
        'receipt', "The Colonel's Trunk", 'storage', 0,
        "Inside the lid of his uniform trunk, a receipt: “Sweet Victory "
        "Novelty Coins — 12 chocolate medals, assorted valour.” Clipped to it, "
        "a note in Mrs. Senclair's hand: “I know. The Regiment will too.”",
        inside: 'trunk',
      ),
      Evidence(
        'regiment', 'Letter from the Regiment', 'study', 5,
        "In the desk drawer, a reply from Fort Fondant: “Madam, we find no "
        "record of any Colonel Cannoli, nor of his medals.” Pinned to it, her "
        "unsent answer: “Then I shall tell all of Donut County what he is.”",
        icon: Icons.mail, color: paper, inside: 'desk',
      ),
    ],
    [
      Evidence(
        'scoresheet', 'Chess Scoresheet', 'parlor', 0,
        "Graham's meticulous record of last night's game, every move timed. "
        "There is a gap: nothing is entered between 10:45 and 11:20. Play "
        "then resumes until midnight.",
        icon: Icons.assignment, color: paper,
      ),
      Evidence(
        'decanter', 'Brandy Decanter', 'dining', 2,
        "The dining room's brandy decanter. The level sits exactly on a "
        "pencil mark dated last Christmas, and the stopper wears an "
        "undisturbed collar of dust.",
        icon: Icons.liquor, color: Color(0xFFFFB74D),
      ),
    ],
  ],
  herrings: [
    will, bills, cocoa, dismissal, spade, berryStain, jobAd, crumbs, recipe,
    sauceDrip, threat, betting, savings, diary,
  ],
  weapons: {'pinboiler', 'pinpantry'},
  printsOn: ['penny', 'cannoli'],
  prints: Evidence.given(
    'prints', 'Prints on the Rolling Pin', 'churlock',
    "Two sets of prints came up under the powder. One is Penny Cotta's, all "
    "over both handles: it is her rolling pin. The other is a single clear "
    "print on the marble barrel, and it belongs to Colonel Cannoli.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1887',
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "Somebody rolled her flat, Detective — squeezed the custard clean out "
        "of her. We traced where she fell in powdered sugar. Not a pretty "
        "sight. Barely a pastry.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Something long, heavy and round. A rolling pin, I'd bet a dozen on "
        "it. It's not down here. One dessert could manage it alone, if they "
        "were strong enough — but two could manage it easier.",
      ),
      whoWasHome,
      sprinklesChart,
    ],
    'glaze': glazeTopics,
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
        'pin', 'One of your rolling pins is missing.',
        "My marble pin! It hung there at supper. Somebody did come through "
        "behind me about a quarter to eleven — I didn't turn round, the "
        "soufflé was at a delicate stage. Not a word from them. Miss Tira "
        "can't pass without a “darling”, Graham always gives his little "
        "cough, and Barry leaves mud wherever he treads. I heard no darling "
        "and no cough, and my floor was spotless this morning.",
        needs: ['rack'],
      ),
      Topic(
        'ricotta', 'Who in this house uses ricotta?',
        "Uses it? Nobody eats the stuff. It's the Colonel's filling. He "
        "springs a leak when he exerts himself, poor man, and I top him up "
        "on Sundays. Mind you, he wanders all over the house.",
        needs: ['ricotta'],
      ),
      Topic(
        'flakes', 'Who in this house is fried?',
        "Fried? I bake, Detective, I never fry. The only fried shell under "
        "this roof is the Colonel's. Well — and yours, begging your pardon.",
        needs: ['flakes'],
      ),
      Topic(
        'flour', 'The pin was hidden in your flour sack.',
        "In my flour? It certainly wasn't there at ten past ten, when I "
        "measured out for the soufflé. I'd have broken a scoop on it.",
        needs: ['pinpantry'],
      ),
      Topic(
        'sherry', 'The Colonel says he drank your kitchen brandy.',
        "Kitchen brandy? There's cooking sherry, and it lives in the cupboard "
        "right beside my oven. Nobody opened that cupboard while I was "
        "basting. I'd have had an elbow in my ribs.",
        heard: ['cannoli/decanter'],
      ),
      Topic(
        'crimping', 'The Colonel says he helped you with the pastry.',
        "The Colonel? In my kitchen? He has never so much as buttered his "
        "own toast. Nobody touches my pins but me, Detective.",
        heard: ['cannoli/prints'],
      ),
      pennyLog,
      pennyRecipe,
      pennySauce,
      ...pennyCommon,
    ],
    'graham': [
      Topic(
        'where', whereQ,
        "In the parlor, sir, at chess with the Colonel, from half past ten "
        "until midnight.",
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
        'left', 'The Colonel says he never left his chair.',
        "The Colonel's memory flatters him, sir. At a quarter to eleven he "
        "rose, announced that he wanted a nightcap, and went out. He returned "
        "at twenty past, somewhat short of breath. I did not leave the parlor.",
        heard: ['cannoli/where'],
      ),
      Topic(
        'alone', 'So you were alone for 35 minutes. Doing what?',
        "Practising my concertina, sir. I do so only when I believe nobody is "
        "listening. I played without a pause until the Colonel came back and "
        "asked whose move it was.",
        heard: ['graham/left'],
      ),
      Topic(
        'gap', 'There is a 35-minute gap in your scoresheet.',
        "I record what occurs at the board, sir. Between 10:45 and 11:20, "
        "nothing occurred at the board. You might ask the Colonel why.",
        needs: ['scoresheet'],
      ),
      Topic(
        'decanter', 'Did anyone touch the dining-room brandy last night?',
        "That decanter has not been unstoppered since Christmas, sir. I mark "
        "the level in pencil, and I am rather proud of the dust it gathers.",
        needs: ['decanter'],
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
        "Éclaire? Dear old friend! Generous to a fault. We understood one "
        "another perfectly.",
      ),
      Topic(
        'suspect', suspectQ,
        "The niece, sir. Cherchez la heiress! Failing her, that gardener is "
        "forever lurking about below stairs.",
      ),
      Topic(
        'left', 'Graham says you left the game for 35 minutes.',
        "Did I? So I did. Slipped my mind entirely. Popped across to the "
        "dining room for a brandy, drank it by the window, came back. Hardly "
        "a state secret, what.",
        heard: ['graham/left'],
      ),
      Topic(
        'gap', 'Nothing happened at the chessboard from 10:45 to 11:20.',
        "A long think, sir! Chess is a game of patience. Graham sat there "
        "like a boiled owl the whole time. ...He says otherwise? Well. I may "
        "have stretched my legs.",
        needs: ['scoresheet'],
      ),
      Topic(
        'decanter', 'The dining-room brandy has not been touched since Christmas.',
        "Hasn't it? Then it was the other bottle. The kitchen brandy. Penny "
        "keeps one for her puddings. That was it. Ask her.",
        needs: ['decanter'],
        heard: ['cannoli/left'],
      ),
      Topic(
        'debt', 'She wanted her 50,000 sugar cubes by today.',
        "A gentleman's debts are his own affair, sir. Éclaire and I had an "
        "understanding. She always said “tomorrow”. It was a sort of joke "
        "between us.",
        needs: ['ledger', 'notice'],
      ),
      Topic(
        'medals', 'Your medals are chocolate, and she knew.',
        "Stage props, sir! For the Fort Fondant amateur theatricals. One "
        "doesn't wear the real ones to dinner. Gravy. Éclaire found it all "
        "most amusing.",
        needs: ['receipt', 'regiment'],
      ),
      Topic(
        'trace', 'Part of you was left beside the body.',
        "I shed, sir. Old war wound. I walk all over this house and I dare "
        "say there's a crumb of me in every room of it. Fetched a bottle "
        "from that cellar myself only — well, recently.",
        needs: ['ricotta', 'flakes'],
      ),
      Topic(
        'prints', 'Your fingerprint is on the rolling pin.',
        "On a rolling pin? Ah. Yes. I helped Penny with the pastry on Sunday. "
        "Crimping, and so forth. Ask her. She was most grateful.",
        needs: ['prints'],
      ),
      Topic(
        'proof', cannoliProofQ, cannoliProofA,
        needs: ['ledger', 'notice'],
        gives: extensionForged,
      ),
      cannoliBetting,
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
        'concertina', 'Graham says he was playing the concertina.',
        "Is THAT what it was? Wheeze, squawk, wheeze, for a solid half hour "
        "— I had a finger in my other ear to hear Madame Leine. It never "
        "stopped once, until I heard the Colonel boom “Whose move is it?”",
        heard: ['graham/alone'],
      ),
      Topic(
        'footsteps', 'Did anyone pass you on the landing?',
        "Not a soul, darling. I was draped over that telephone table for "
        "forty minutes and the only thing that came up those stairs was "
        "that dreadful music.",
        needs: ['phone'],
      ),
      ...tiraCommon,
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
        "Penny's got a grudge against the old girl that's older than I am. "
        "Somethin' about a recipe. And she's the one with the rollin' pins.",
      ),
      Topic(
        'pin', 'There was a rolling pin hidden behind your boiler.',
        "Not mine, guv! When I got in at midnight the boiler room door was "
        "hangin' open, and I always shut it to keep the warm in. Whoever "
        "stashed that did it before I was back.",
        needs: ['pinboiler'],
      ),
      ...barryCommon,
    ],
  },
);
