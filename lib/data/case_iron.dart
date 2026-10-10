import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// A single killer whose alibi is another suspect, who slept through it.
const ironCase = MysteryCase(
  id: 'iron',
  title: 'Pressing Matters',
  culprits: {'graham'},
  nextVictims: ['cannoli', 'penny', 'tira', 'barry'],
  herringCount: 10,
  solution:
      "For thirty years Graham Cracker had kept two sets of household "
      "books, and the auditor was coming at nine. At ten he borrowed "
      "Penny's poppy-seed syrup and carried all three flat irons through to "
      "the dining room. He poured the syrup into the Colonel's nightcap, "
      "and by a quarter to eleven the Colonel was asleep at the chessboard. "
      "At eleven, when Mrs. Senclair went down to lock the wine rack as she "
      "did every night, Graham followed with the great goose iron, and at "
      "11:05 he pressed her flat. Then he sat down again, wrote out forty "
      "minutes of chess by himself, and woke the Colonel with “Your move, "
      "sir.” Tira, on the telephone, heard nothing from the parlor but "
      "snoring. And the game Graham invented cannot be played: the Colonel "
      "loses his queen at move fifteen, and gives check with her at move "
      "twenty-four.",
  core: [
    Evidence(
      'ironrack', 'Iron Trivet', 'kitchen', 4,
      "The trivet beside the stove where the flat irons are kept warm. "
      "Three places, graded by size. The small iron and the middle iron are "
      "here. The place of the big one, the fourteen-pound goose iron, is an "
      "empty ring of rust.",
      icon: Icons.iron, color: Color(0xFFB0BEC5),
    ),
    Evidence(
      'glasses', 'Brandy Glasses', 'parlor', 2,
      "Two brandy glasses beside the chessboard. One is clean and dry. The "
      "other has a sticky purple film in the bottom, with tiny blue-black "
      "seeds in it. It smells of the nursery.",
      icon: Icons.wine_bar, color: Color(0xFFCE93D8),
    ),
    souffle,
    boots,
    phoneTira,
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Today's page: "
      "“9 AM, Mr. Abacus, the auditor. Thirty years of household books. "
      "G. to give up his keys at breakfast.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
  ],
  variants: [
    timeOfDeath,
    [
      Evidence(
        'ironchest', 'Goose Iron', 'landing', 0,
        "Under the bottom sheet, wrapped in a pillowcase: the big flat "
        "iron. The sole plate has been wiped, but there is custard baked "
        "into the rivets. It wants dusting for fingerprints.",
        inside: 'chest',
      ),
      Evidence(
        'ironcloset', 'Goose Iron', 'entrance', 2,
        "On the floor at the back of the closet, under a fallen coat: the "
        "big flat iron. The sole plate has been wiped, but there is custard "
        "baked into the rivets. It wants dusting for fingerprints.",
        inside: 'closet',
      ),
    ],
    [
      Evidence(
        'realbooks', 'Two Account Books', 'cellar', 0,
        "Locked in the strongbox, side by side: the household accounts in "
        "copperplate, as shown to Mrs. Senclair each month, and a second "
        "book in pencil with the true figures. Over thirty years they "
        "differ by 31,000 sugar cubes.",
        icon: Icons.menu_book, color: Color(0xFFD7CCC8), inside: 'strongbox',
      ),
      Evidence(
        'passbook', 'Bank Passbook', 'dining', 2,
        "Tucked behind the brandy decanter: a bank passbook in the name of "
        "G. Cracker. A deposit every Friday for thirty years, each for the "
        "same small sum. The total is 31,000 sugar cubes. A butler's wage "
        "would not come to half of it.",
        icon: Icons.account_balance, color: paper,
      ),
    ],
    [
      Evidence(
        'syrup', 'Poppy-Seed Syrup', 'kitchen', 0,
        "A brown bottle in the cupboard, labelled in Penny's hand: "
        "“Poppy-seed syrup. For coughs. ONE spoonful. Sleep follows.” The "
        "level stands three fingers below her pencil mark, and a purple "
        "dribble has run down the label.",
        icon: Icons.medication_liquid, color: Color(0xFFCE93D8),
        inside: 'cupboard',
      ),
      Evidence(
        'cushion', "The Colonel's Armchair", 'parlor', 4,
        "The wing of the Colonel's armchair has a patch of ricotta on it "
        "the size of a saucer, at the height of a sleeping head, and his "
        "spare monocle has slipped down between the cushions.",
        icon: Icons.chair, color: Color(0xFFBCAAA4),
      ),
    ],
    [
      Evidence(
        'cornerprint', 'Print in the Custard', 'cellar', 1,
        "Pressed into the spilled custard beside the outline: the print of "
        "one sharp, square corner, with a few honey-brown crumbs in it. It "
        "is on top of the custard, so it was made afterwards.",
        icon: Icons.crop_square, color: Color(0xFFD8A55C),
      ),
      Evidence(
        'scorch', 'Scorch Mark', 'cellar', 2,
        "A scorch on the flagstones beside the outline, in the shape of a "
        "flat iron's sole. The iron was hot when it was set down. Fused "
        "into the mark is one honey-brown crumb with a square edge.",
        icon: Icons.whatshot, color: Color(0xFFFF8A65),
      ),
    ],
  ],
  herrings: [
    will, bills, dismissal, spade, jobAd, recipe, threat, berryStain, crumbs,
    cocoa, sauceDrip, betting, savings, diary, iou, sabre, slipper,
    scratches, medal, letters,
  ],
  weapons: {'ironchest', 'ironcloset'},
  printsOn: ['penny', 'graham'],
  prints: Evidence.given(
    'prints', 'Prints on the Iron', 'churlock',
    "Two sets of prints came up under the powder. Penny Cotta's are old "
    "and faint, all along the wooden handle: she irons the sheets. Over "
    "them, on the hot sole plate itself, is one sharp thumb where somebody "
    "wiped it in a hurry. It is Graham Cracker's.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1869',
  hints: {
    ...commonHints,
    ...timeHints,
    'boots': bootsHint,
    'phone': "The operator vouches for her, and I believe it. But she was "
        "stood on that landing for forty minutes with her ears open. What "
        "did she hear from downstairs?",
    'souffle': souffleHint,
    'ironrack': "Fourteen pounds of iron, gone from Penny's kitchen. She "
        "counts her wooden spoons, Churlock. She will know who had it "
        "last.",
    'glasses': "One glass used and one not. So one of the two at that "
        "board drank, and one only poured. Ask Penny what is purple, full "
        "of seeds, and smells of the nursery.",
    'planner': "Thirty years of books, and the keys to be given up at "
        "breakfast. I wonder what an auditor would have found.",
    'ironchest': "Wrapped up and put away tidily, by somebody who knows "
        "where the linen lives. Dust it.",
    'ironcloset': "Put out of sight in a hurry, by somebody who passed "
        "through the hall. Dust it.",
    'realbooks': "Two sets of books. That is not a grievance, old chap, "
        "that is a prison sentence, and it was due at nine this morning.",
    'passbook': "Every Friday for thirty years. That is not a grievance, "
        "old chap, that is a prison sentence, and it was due at nine this "
        "morning.",
    'syrup': "Sleep follows. Three fingers gone. Ask Penny who asked her "
        "for that bottle, and what reason they gave.",
    'cushion': "A man does not drool on a chair wing while he is winning "
        "at chess. Ask him how the game went. Then ask somebody who could "
        "hear it.",
    'cornerprint': "Crumbs like those turn up in the pantry every day, "
        "and innocently. But these are in the cellar, and on top of the "
        "custard.",
    'scorch': "Still hot when it was put down. So it came straight from "
        "wherever irons are kept hot. Who had the irons last night?",
    'scoresheet': "Play it through in your head, Churlock, move by move. "
        "Every move ought to be possible.",
    'prints': "Hers are old and where a laundress's belong. His is fresh, "
        "and on the part nobody touches unless they are wiping it.",
  },
  accuseHints: [
    "Two of them say they sat at a chessboard together all night, "
        "Churlock. That is two alibis resting on one another. Was anybody "
        "else in a position to hear that game?",
    "Look at the two glasses on the chess table, and then look in Penny's "
        "cupboard. One of those two players was not awake for all of it.",
    "If one of them slept, the other was alone, and wrote the record of "
        "the game by himself. Ask for that record and read every move.",
    "The Colonel snored, and Tira heard him. Nobody heard the butler. "
        "And a queen that is taken at move fifteen does not give check at "
        "move twenty-four.",
  ],
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "Pressed, Detective. Flat as a napkin, and as smooth. Whatever did "
        "it was heavy, and it was hot. We traced where she lay in powdered "
        "sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Something flat and heavy with a handle on top. If this were a "
        "laundry I'd know exactly what to look for. It isn't down here.",
      ),
      whoWasHome,
      sprinklesChart,
    ],
    'glaze': glazeTopics,
    'penny': [
      pennyWhere,
      Topic(
        'about', aboutQ,
        "Strict, but fair. She paid on time and never once called me "
        "“jelly”. She'd taken to going through the books of an evening, "
        "this last month. Every bill since the year dot.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to stir the pot... but Miss Tira does love her "
        "aunt's fortune a great deal more than she loved her aunt.",
      ),
      Topic(
        'iron', 'Your biggest flat iron is missing.',
        "The goose! Fourteen pounds, that iron. Graham carried all three "
        "through to the dining room at ten, to press the napkins and "
        "tomorrow's Gazette. He brought two back hot at half eleven and "
        "said the goose was cooling. I never thought.",
        needs: ['ironrack'],
      ),
      Topic(
        'syrup', 'What is purple, full of seeds, and smells of the nursery?',
        "My poppy-seed syrup. One spoonful and you sleep the clock round. "
        "Graham asked me for the bottle at ten. He said Madam had a cough. "
        "Madam never coughed in her life, now I come to think.",
        needs: ['glasses', 'syrup'],
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
        "until two minutes to midnight. Neither of us left the board. The "
        "Colonel was in unusually fine form.",
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
        'record', 'Is there a record of the game?',
        "Every move, sir, timed and initialled by both players. I should "
        "be obliged if you would return it. It was one of the Colonel's "
        "better evenings and he will wish to frame it.",
        gives: Evidence.given(
          'scoresheet', 'Chess Scoresheet', 'graham',
          "Graham's record of the game, a move every two or three minutes "
          "from 10:32 to 11:58, each one initialled twice. Among them: "
          "“Move 15, 10:47. Bishop takes the Colonel's queen.” And further "
          "down: “Move 24, 11:12. The Colonel's queen to king seven. "
          "Check.” The Colonel wins at move 41.",
          icon: Icons.assignment,
        ),
      ),
      Topic(
        'eleven', 'Why was she in the cellar at eleven at night?',
        "Madam locked the wine rack herself at eleven each night, sir, and "
        "took the key to bed. She had done so for thirty years. Everybody "
        "under this roof could set a watch by it.",
      ),
      Topic(
        'glasses', 'Only one of the brandy glasses was used.',
        "The Colonel takes a nightcap, sir. I do not drink while I am in "
        "livery. I poured it for him myself at half past ten.",
        needs: ['glasses'],
      ),
      Topic(
        'syrup', 'Penny says you borrowed her sleeping syrup.',
        "For Madam's cough, sir. I left the bottle on her tray. If some of "
        "it found its way into the brandy, I can only suppose the Colonel "
        "mistook it for a liqueur.",
        heard: ['penny/syrup'],
      ),
      Topic(
        'snore', 'Tira heard snoring from the parlor, and no chess.',
        "The Colonel breathes heavily when he concentrates, sir. It is "
        "frequently mistaken for sleep. He was thinking.",
        heard: ['tira/heard'],
      ),
      Topic(
        'queen', "The Colonel's queen is taken at move 15 and moves at 24.",
        "A slip of the pen, sir. One writes “queen” for “rook” late in the "
        "evening. The Colonel initialled it, you will observe.",
        needs: ['scoresheet'],
      ),
      Topic(
        'iron', 'You had all three irons in the dining room.',
        "I iron Madam's newspaper each morning, sir, and the napkins at "
        "night. I returned the irons to Mrs. Cotta when I had done. If she "
        "counted two, I can only say that the hour was late.",
        heard: ['penny/iron'],
      ),
      Topic(
        'crumb', 'Your crumbs are in the cellar, on top of the custard.',
        "I am in the cellar daily, sir, to keep the book. I shed. It is a "
        "condition of being what I am.",
        needs: ['cornerprint', 'scorch'],
      ),
      Topic(
        'books', 'You have put away 31,000 sugar cubes.',
        "Thirty years of prudent saving, sir, and a small legacy from an "
        "aunt in Shortbread. I should be glad to explain it to any "
        "auditor.",
        needs: ['realbooks', 'passbook'],
      ),
      Topic(
        'auditor', 'The auditor was to take your keys this morning.',
        "Madam mentioned it, sir. I welcomed it. A butler's books should "
        "bear inspection.",
        needs: ['planner'],
      ),
      Topic(
        'prints', 'Your thumb is on the sole of the iron.',
        "I test the heat with my thumb, sir. Every butler does. It is how "
        "one avoids scorching The Gazette.",
        needs: ['prints'],
      ),
      ...grahamCommon,
      ...grahamYard,
    ],
    'cannoli': [
      Topic(
        'where', whereQ,
        "In the parlor, at chess with Graham, half ten to midnight. Played "
        "like a tiger, sir! The fellow tells me I won. First time in "
        "eleven years.",
      ),
      Topic(
        'about', aboutQ,
        "Éclaire? Dear old friend! Generous to a fault. We understood one "
        "another perfectly.",
      ),
      Topic(
        'suspect', suspectQ,
        "The niece, sir. Cherchez la heiress! Failing her, that gardener "
        "is forever lurking about below stairs.",
      ),
      Topic(
        'nightcap', 'Tell me about your nightcap.',
        "Graham poured it, sir, at half past ten. Dashed sweet, I thought. "
        "Purple, too. I took it for a new bottle and said nothing. One "
        "doesn't criticise another man's cellar.",
        needs: ['glasses'],
      ),
      Topic(
        'doze', 'Tira heard you snoring for forty minutes.',
        "Snoring? I may have rested my eyes, sir. A soldier sleeps when he "
        "can. One moment Graham was pouring, and the next he was saying "
        "“Your move, sir,” and the clock stood at half past eleven. "
        "...Good Lord.",
        heard: ['tira/heard'],
      ),
      Topic(
        'queen', 'Do you remember giving check with your queen?',
        "My queen, sir? I lost her early. I remember that distinctly, "
        "because I said a word one doesn't say in front of a butler. I "
        "never got her back. Did I check him with her? I have no memory "
        "of it at all.",
        needs: ['scoresheet'],
      ),
      cannoliIou,
      cannoliProof,
      cannoliSabre,
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
        "The Colonel, darling. He owes Auntie a fortune and he has the "
        "manners of a man who knows it.",
      ),
      Topic(
        'heard', 'What could you hear from the parlor during your call?',
        "The Colonel, darling, snoring like a kettle with a grudge. From "
        "about a quarter to eleven until nearly half past. Not one "
        "“check”, not one “what”. I assumed Graham had bored him "
        "unconscious.",
        needs: ['phone'],
      ),
      Topic(
        'footsteps', 'Did anyone pass you on the landing?',
        "Not then, darling. But somebody came up to the linen chest after "
        "I'd rung off and gone to my room. A very neat, square sort of "
        "tread.",
        needs: ['ironchest'],
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
        "Butler's had the keys to this place thirty year, guv, and the "
        "old girl had just started askin' where the coal money went. I "
        "only know 'cause she asked me.",
      ),
      ...barryCommon,
    ],
  },
);
