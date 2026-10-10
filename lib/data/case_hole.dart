import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// The rare one. All five residents are innocent, and can prove it: the
/// killer is the sixth name on the sergeant's list, which was torn off
/// before Churlock ever saw it. Watsonut's hints here are lies, more often
/// than not, and his moustache holds still while he tells them.
const holeCase = MysteryCase(
  id: 'hole',
  title: 'The Hole Truth',
  culprits: {'watsonut'},
  nextVictims: ['graham', 'penny', 'cannoli', 'tira', 'barry'],
  herringCount: 10,
  solution:
      "Long John Watsonut was born in Donut County, and thirty years ago Mrs. "
      "Senclair paid for the medical degree he never finished. He had been "
      "her physician, and her secret, ever since. This week she resolved to "
      "tell his partner everything. Last night he dined at the house as "
      "J. W., the doctor who stays over when her heart is troublesome, "
      "borrowed a piping syringe from the kitchen at twenty to eleven, and "
      "at 11:05 met her in the cellar and drew every drop of custard out of "
      "her. At dawn he was back in his bowler hat, standing at Churlock's "
      "shoulder. The sergeant's list of everyone in the house had six "
      "names; Watsonut tore off the sixth and locked it in her own desk. "
      "All five residents could prove where they were. And every time he "
      "steered the detective toward one of them, his moustache never moved.",
  core: [
    souffle,
    boots,
    phoneTira,
    steadyScoresheet,
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Tomorrow's page: "
      "“10 AM. Mr. Churlock, of Biscuit Street. Tell him about J. before "
      "J. can talk me out of it again.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
    Evidence(
      'tornsheet', 'Torn Strip of Paper', 'study', 0,
      "Folded very small at the back of the drawer: a strip torn from the "
      "right-hand edge of a police form. The printing matches the "
      "sergeant's list of suspects exactly, and so does the tear. There is "
      "a sixth name on it. “Dr. Long John Watsonut, physician. Born Donut County. "
      "Guest of the deceased. Slept in the house last night.”",
      icon: Icons.content_cut, color: Color(0xFFFFAB91), inside: 'desk',
    ),
  ],
  variants: [
    timeOfDeath,
    [
      Evidence(
        'chainlink', 'Gold Chain Link', 'cellar', 1,
        "Lying in the spilled custard beside the outline: a single link of "
        "very fine gold chain, pulled open. The kind of chain a gentleman "
        "hangs an eyeglass on.",
        icon: Icons.link, color: gold,
      ),
      Evidence(
        'drizzle', 'Dark Smear', 'cellar', 2,
        "A dark brown smear on the flagstones beside the outline, on top of "
        "the custard. It is not powder. It is set, and glossy, and it "
        "cracks like icing.",
        icon: Icons.water_drop, color: Color(0xFF5D3A1A),
      ),
    ],
    [
      Evidence(
        'syringesack', 'Piping Syringe', 'pantry', 3,
        "Pushed deep into a flour sack: a big brass piping syringe from the "
        "kitchen, the plunger drawn right back, and full to the top with "
        "vanilla custard. It wants dusting for fingerprints.",
        inside: 'sacks',
      ),
      Evidence(
        'syringedirt', 'Piping Syringe', 'backyard', 0,
        "Buried in the loose earth: a big brass piping syringe from the "
        "kitchen, the plunger drawn right back, and full to the top with "
        "vanilla custard. It wants dusting for fingerprints.",
        inside: 'dirt',
      ),
    ],
    [
      Evidence(
        'wwnote', 'Note Signed J. W.', 'study', 1,
        "Pressed inside a medical dictionary on the shelf: “Éclaire. You "
        "promised you would never tell him. Thirty years ago is thirty "
        "years ago. Meet me in the cellar at eleven and name your price. "
        "J. W.”",
        icon: Icons.mail, color: paper,
      ),
      Evidence(
        'wwbill', 'Receipted Account', 'cellar', 0,
        "Locked in the strongbox, an account receipted every year for "
        "thirty years: “For professional discretion. Paid with thanks. "
        "J. W.” Across this year's, in Mrs. Senclair's hand: “No more. He "
        "must be told.”",
        icon: Icons.receipt_long, color: paper, inside: 'strongbox',
      ),
    ],
    [
      Evidence(
        'guestcot', 'Camp Bed', 'storage', 4,
        "A camp bed made up among the trunks, and slept in. There is a "
        "round dent in the pillow where something like a hat was set down, "
        "and under the bed a black leather bag, empty, stamped J. W.",
        icon: Icons.bed, color: Color(0xFFBCAAA4),
      ),
      Evidence(
        'sixthplace', 'Supper Table', 'dining', 3,
        "Last night's supper has not been cleared. There are six places "
        "laid, not five. Graham's card at the sixth reads only: “J. W. No "
        "walnuts.”",
        icon: Icons.restaurant, color: Color(0xFFE0E0E0),
      ),
    ],
  ],
  herrings: [
    will, bills, dismissal, spade, jobAd, recipe, threat, berryStain, crumbs,
    cocoa, sauceDrip, betting, savings, diary, iou, sabre, slipper,
    scratches, letters, medal,
  ],
  weapons: {'syringesack', 'syringedirt'},
  printsOn: ['penny'],
  prints: Evidence.given(
    'prints', 'Prints on the Syringe', 'churlock',
    "Two sets of prints came up under the powder. One is Penny Cotta's, on "
    "the barrel: it is her syringe. The other is a whole hand around the "
    "plunger, sharp and fresh. I have held it against all five cards on "
    "the police chart, twice. It matches none of them.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1871',
  hints: {
    ...commonHints,
    ...timeHints,
    'phone': phoneHint,
    'souffle': souffleHint,
    'scoresheet': "No gaps at all, and each man watching the other. I "
        "should say that settles the pair of them.",
    'boots': "Mud proves nothing, Churlock. A gardener may come in by any "
        "door he pleases. I should press him, and press him hard.",
    'planner': "J.? A month, old chap. June, or July. She was a busy "
        "woman. I shouldn't dwell on it.",
    'tornsheet': "Churlock. Old friend. I can explain that. ...No. No, I "
        "don't suppose I can.",
    'chainlink': "The Colonel wears his eyeglass on a chain, Churlock. "
        "There you are. I should look no further.",
    'drizzle': "Cocoa. The niece is covered in the stuff from head to "
        "foot. Open and shut, I should have thought.",
    'syringesack': "A kitchen thing, from the kitchen, hidden in the "
        "pantry. It's the housekeeper. Arrest the housekeeper and have "
        "done.",
    'syringedirt': "A kitchen thing, and buried by somebody with a spade. "
        "The housekeeper and the gardener between them. Have done with "
        "it.",
    'wwnote': "J. W.? Might be anybody, old chap. A jam wholesaler. A "
        "jeweller. I shouldn't waste a minute on it.",
    'wwbill': "J. W.? Might be anybody, old chap. A jam wholesaler. A "
        "jeweller. I shouldn't waste a minute on it.",
    'guestcot': "Some relative of the cook's, I expect, long gone. There "
        "is nothing in it. Do come away.",
    'sixthplace': "Butlers lay a spare place out of habit, Churlock. "
        "There is nothing in it. Do come away.",
    'prints': "Smudges. The police chart is never wrong: if a print isn't "
        "on the chart, it is nobody's. Put it out of your mind.",
  },
  lies: {
    'boots', 'planner', 'chainlink', 'drizzle', 'syringesack', 'syringedirt',
    'wwnote', 'wwbill', 'guestcot', 'sixthplace', 'prints',
    'accuse:0', 'accuse:1', 'accuse:2', 'accuse:3',
  },
  shaky: {
    'planner', 'tornsheet', 'chainlink', 'drizzle', 'syringesack',
    'syringedirt', 'wwnote', 'wwbill', 'guestcot', 'sixthplace', 'prints',
    'accuse:2', 'accuse:3',
  },
  greetings: {
    'glaze': "Morning, Detective. Watch your step around the outline. "
        "...Long John? Long John Watsonut! It's Glaze, from the old street. "
        "Well, hello! Twenty years. I never knew you had left Donut County.",
  },
  accuseHints: [
    "Five suspects and five alibis, Churlock, so one alibi is false. I "
        "should start with the gardener. Nobody saw him for two hours.",
    "The Colonel owes her a fortune, and he wears a chain. Need I say "
        "more? Take the Colonel.",
    "That list is complete, old chap. Five names. I counted them myself "
        "when the sergeant handed it to me. Pay no mind to the edge of it.",
    "Arrest the housekeeper. It was her syringe. Please, Churlock. Arrest "
        "somebody, and let us go home.",
  ],
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "One small hole, Detective, and every drop of custard drawn out of "
        "her through it, neat as you like. Whoever did this knew exactly "
        "where a pastry keeps her filling.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Something with a needle or a nozzle, and a plunger to pull. "
        "There'll be a pint of custard in it, wherever it is.",
      ),
      Topic(
        'home', 'Who was in the house?',
        "Five residents on your list, all home, every door latched from "
        "the inside. Funny thing, though. I'd have sworn I filled that "
        "form right across to the margin. I gave it to your partner at the "
        "door to pass to you.",
      ),
      Topic(
        'list', 'Is this strip torn from your list?',
        "That's it! That's the end of my form. Six names I took down, "
        "Detective, not five: the five who live here, and the doctor who "
        "was stopping the night. I handed all six to your partner.",
        needs: ['tornsheet'],
      ),
      sprinklesChart,
    ],
    'glaze': [
      ...glazeTopics,
      Topic(
        'nomatch', 'There is a print on the weapon that is not on your chart.',
        "Then it isn't one of the five, Detective. We printed everybody "
        "on the Sarge's list. If somebody was in this house last night "
        "and isn't on that list, I'd like to know why not.",
        needs: ['prints'],
      ),
    ],
    'penny': [
      pennyWhere,
      Topic(
        'about', aboutQ,
        "Strict, but fair. Her heart had been troubling her this week, and "
        "her temper with it. She'd something on her mind she wouldn't "
        "tell me.",
      ),
      Topic(
        'suspect', suspectQ,
        "I've gone round and round it, Detective, and I can't make it any "
        "of us. Everybody was somewhere. It's as if there was one more in "
        "the house than there was.",
      ),
      Topic(
        'syringe', 'This is your piping syringe.',
        "My big one, for éclairs! It was asked for at twenty to eleven, "
        "at my kitchen door. To give Madam her drops, he said. I never "
        "looked round from the oven. I thought nothing of it. He's been "
        "coming here for years.",
        needs: ['syringesack', 'syringedirt'],
      ),
      Topic(
        'doctor', 'Who asked you for it?',
        "Why, the doctor. Madam's doctor. He always stops the night when "
        "her heart's bad. I couldn't tell you his name, we only ever say "
        "“the doctor”. A round gentleman. Very dark. Smells of chocolate.",
        heard: ['penny/syringe'],
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
        "It is not a butler's place to speculate, sir. Though on this "
        "occasion I confess I cannot make the arithmetic come out.",
      ),
      Topic(
        'sixth', 'Who was the sixth at supper?',
        "Madam's physician, sir. He dines and stays whenever her heart is "
        "troublesome. I know him only by the initials on his bag. He comes "
        "in a dressing gown and slippers by the garden door, and is gone "
        "before I am up.",
        needs: ['sixthplace', 'guestcot'],
      ),
      Topic(
        'name', 'Your doctor is named on this strip.',
        "Is it indeed, sir. I had only the initials. I should not have "
        "known the gentleman in a bowler hat and a moustache. Last night "
        "he wore neither. ...Sir, I do not wish to alarm you, but he is "
        "standing directly behind you.",
        needs: ['tornsheet'],
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
        "Dashed if I know, sir. I have suspected each of them in turn "
        "since breakfast and each of them has an answer.",
      ),
      Topic(
        'chain', 'Is this link from your monocle chain?',
        "Mine, sir? Count them. Forty links, and not one missing. Mine is "
        "a soldier's chain, thick as bootlace. That is a fine little "
        "thing. A professional man's chain. A lawyer's. A doctor's.",
        needs: ['chainlink'],
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
        "Darling, I've no idea, and it's maddening. Usually one simply "
        "knows.",
      ),
      Topic(
        'smear', 'Is this smear your cocoa?',
        "Darling, look at me. I am dusted. I am not iced. That is icing, "
        "chocolate icing, the kind that drips. Nobody who lives in this "
        "house is made of that.",
        needs: ['drizzle'],
      ),
      Topic(
        'footsteps', 'Did anyone pass you on the landing?',
        "Somebody came down from the storage nook just as I picked up the "
        "telephone, darling. In slippers. I took it for Graham and didn't "
        "turn round. But Graham was at chess, wasn't he?",
        needs: ['phone'],
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
        "Couldn't say, guv. I'll tell you one thing for nothin', mind. "
        "The dog never barked all night, and somebody was in and out of "
        "that garden door. So it was somebody he knows.",
      ),
      ...barryCommon,
    ],
  },
);
