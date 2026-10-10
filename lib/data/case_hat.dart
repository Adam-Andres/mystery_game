import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// A single killer whose alibi is perfectly true, for the wrong time: the
/// stopped watch was put forward.
const hatCase = MysteryCase(
  id: 'hat',
  title: 'Hat Trick',
  culprits: {'tira'},
  nextVictims: ['cannoli', 'graham', 'penny', 'barry'],
  herringCount: 10,
  solution:
      "Tira Misu had been signing her aunt's name on cheques to her "
      "milliner, and Mrs. Senclair had asked the bank manager and the "
      "sergeant to call at nine. At twenty-five to eleven Tira coaxed her "
      "down to the cellar, and at twenty to eleven ran her through with a "
      "hatpin. Then she put the hands forward to five past eleven, broke "
      "them there, and was on the telephone by ten to, with an operator to "
      "swear to it. But Mrs. Senclair was carrying one of Graham's hour "
      "candles, lit at ten and ringed every ten minutes, and it went out "
      "when she fell with four rings burned. At twenty to eleven the chess "
      "game had begun, the soufflé was in the oven and the gardener was "
      "latched out. Only Tira was nowhere. The note she produced has her "
      "aunt complaining of the telephone call, which began ten minutes "
      "after she died.",
  core: [
    Evidence(
      'candle', 'Fallen Candle', 'cellar', 2,
      "Mrs. Senclair's candle, lying beside the outline and snuffed in its "
      "own wax where it fell. It is one of the household's hour candles, "
      "ringed in red at even spaces down its length. Four rings have burned "
      "away. The fifth has not been touched.",
      icon: Icons.local_fire_department, color: Color(0xFFFFE082),
    ),
    souffle,
    boots,
    phoneTira,
    steadyScoresheet,
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Today's page: "
      "“9 AM, the bank manager, and Sgt. Sprinkles with him. T. is not to "
      "be warned.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
  ],
  variants: [
    [
      Evidence(
        'watch', 'Stopped Pocket Watch', 'cellar', 0,
        "Mrs. Senclair's pocket watch, lying inside the outline with the "
        "glass broken. The hands stopped at 11:05 PM. The winding crown is "
        "pulled out on its stem, and there is a brown, powdery smudge on "
        "it.",
        icon: Icons.watch_later, color: gold,
      ),
      Evidence(
        'clock', 'Fallen Cellar Clock', 'cellar', 3,
        "The old cellar clock lies face-up among the barrels with its "
        "pendulum snapped and the hands frozen at 11:05 PM. The glass door "
        "over the face hangs open, unbroken, and there is a brown, powdery "
        "fingermark on the minute hand.",
        icon: Icons.access_time_filled, color: gold,
      ),
    ],
    [
      Evidence(
        'pinchest', 'Hatpin', 'landing', 0,
        "Slid between two folded sheets: a nine-inch steel hatpin with a "
        "pearl head. It is sticky with custard for its whole length. It "
        "wants dusting for fingerprints.",
        inside: 'chest',
      ),
      Evidence(
        'pincrate', 'Hatpin', 'storage', 0,
        "At the bottom of a crate, rolled in hat-shop tissue: a nine-inch "
        "steel hatpin with a pearl head. It is sticky with custard for its "
        "whole length. It wants dusting for fingerprints.",
        inside: 'crates',
      ),
    ],
    [
      Evidence(
        'cheques', 'Returned Cheques', 'cellar', 0,
        "Locked in the strongbox: three cheques to Madame Leine's Hat "
        "Boutique, returned by the bank and stamped SIGNATURE IRREGULAR. "
        "Pinned to them, in Mrs. Senclair's hand: “I never signed these. "
        "She has been practising my name.”",
        icon: Icons.payments, color: paper, inside: 'strongbox',
      ),
      Evidence(
        'bankletter', "Bank Manager's Letter", 'entrance', 3,
        "On the mat under the letterbox, torn across: “Madam, we confirm "
        "that three cheques drawn on your account in favour of a milliner "
        "bear a signature that is not yours. As you ask, I shall call at "
        "nine with the police.”",
        icon: Icons.mail, color: paper,
        puzzle: Puzzle.torn,
        pieces: [
          'Madam, we confirm that three cheques',
          'drawn on your account in favour of a milliner',
          'bear a signature that is not yours.',
          'As you ask, I shall call at nine',
          'with the police.',
        ],
      ),
    ],
    [
      Evidence(
        'heelmarks', 'Marks on the Cellar Steps', 'entrance', 5,
        "The dust on the cellar steps holds two sets of prints going down "
        "side by side: a flat slipper, and a small, sharp heel. Only the "
        "heel comes back up.",
        icon: Icons.directions_walk, color: Color(0xFFBCAAA4),
      ),
      Evidence(
        'cocoadoor', 'Cellar Hatch Handle', 'entrance', 5,
        "The brass handle of the cellar hatch has been polished until it "
        "shines. On top of the polish there is a set of dainty fingermarks "
        "in cocoa powder.",
        icon: Icons.blur_on, color: Color(0xFF8D6E63),
      ),
    ],
  ],
  herrings: [
    will, bills, dismissal, spade, jobAd, recipe, threat, berryStain, crumbs,
    cocoa, sauceDrip, betting, savings, diary, iou, slipper, scratches,
    letters, medal,
  ],
  weapons: {'pinchest', 'pincrate'},
  printsOn: ['tira'],
  prints: Evidence.given(
    'prints', 'Prints on the Hatpin', 'churlock',
    "One set of prints came up under the powder, and only one: Tira Misu's, "
    "on the pearl head. It is her hatpin, so that by itself is no more than "
    "one would expect. But nobody else has ever held it.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1876',
  hints: {
    ...commonHints,
    'boots': bootsHint,
    'watch': "A watch stops when it breaks, Churlock. It does not pull out "
        "its own crown first. That is how one sets the hands. I should want "
        "a second opinion on the time, from something nobody thought to "
        "tamper with.",
    'clock': "A clock that fell in a struggle would have broken its glass. "
        "Somebody opened that door and touched the hand. I should want a "
        "second opinion on the time, from something nobody thought to "
        "tamper with.",
    'candle': "Four rings, old chap. Now, who makes those candles, when "
        "was this one lit, and how long does a ring take to burn?",
    'phone': "The operator's word, and I believe every minute of it. From "
        "ten to eleven. Not a minute before.",
    'souffle': souffleHint,
    'scoresheet': "Notice when it begins, Churlock, not only that it has "
        "no gaps.",
    'planner': "She meant to have somebody arrested at nine. And that "
        "somebody was not to be warned. I wonder if she was.",
    'pinchest': "A hatpin. In this house that narrows the field to one "
        "wardrobe. But owning a thing is not using it. Dust it.",
    'pincrate': "A hatpin. In this house that narrows the field to one "
        "wardrobe. But owning a thing is not using it. Dust it.",
    'cheques': "A motive, and an urgent one: by nine this morning it "
        "would have been too late.",
    'bankletter': "A motive, and an urgent one: by nine this morning it "
        "would have been too late.",
    'heelmarks': "Two went down and one came up. When were those steps "
        "last swept? The butler will know to the minute.",
    'cocoadoor': "On top of the polish. So the question is when that "
        "handle was last polished. The butler will know to the minute.",
    'auntnote': "Consider when it must have been written, Churlock, from "
        "what it says. Then consider when she died.",
    'prints': "Hers alone. It proves little, as she'll be quick to tell "
        "you. It is the clock we must break, not the pin.",
  },
  accuseHints: [
    "Everyone has an alibi for five past eleven, Churlock. Suspiciously "
        "good ones. What if five past eleven is the wrong question?",
    "Look again at the thing that told us the time, and at how it was "
        "found. Then look for something else in that cellar that keeps "
        "time, and ask Graham how it works.",
    "Once you have the true minute, go round all five again. Three of "
        "them were already where they say by half past ten, and a fourth "
        "was latched out at ten. Who had not yet begun their alibi?",
    "The Colonel heard something in the hall just after the game began. "
        "And the note she gave you could only have been written by "
        "somebody who was alive to hear a telephone call.",
  ],
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "One neat hole, Detective, straight through the shell, and every "
        "drop of custard let out of her. She went down like a punctured "
        "tyre. We traced where she fell in powdered sugar.",
      ),
      Topic(
        'weapon', 'What was the weapon?',
        "Something long, thin and sharp. A skewer, a knitting needle, a "
        "meat thermometer. It isn't down here. It'd hide almost anywhere.",
      ),
      whoWasHome,
      sprinklesChart,
    ],
    'glaze': [
      ...glazeTopics,
      Topic(
        'earlier', 'Could she have died earlier than eleven?',
        "Custard doesn't tell the time to ten minutes, Detective. Half "
        "past ten, half past eleven, it sets the same. I said “around "
        "eleven” because that's what the hands said. If the hands are "
        "wrong, so am I.",
        needs: ['candle'],
      ),
    ],
    'penny': [
      pennyWhere,
      Topic(
        'about', aboutQ,
        "Strict, but fair. She'd had a face like thunder since the post "
        "came on Tuesday, mind. Something from the bank. She wouldn't say "
        "what.",
      ),
      Topic(
        'suspect', suspectQ,
        "I don't like to stir the pot... but the Colonel owes her a "
        "fortune, and Graham's not been himself for a month.",
      ),
      Topic(
        'last', 'When did you last see her alive?',
        "Twenty-five past ten. She put her head round my door to say "
        "goodnight and took a peppermint, same as always. I put the "
        "soufflé in five minutes after and never left it.",
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
        'candle', 'Tell me about the ringed candles.',
        "Hour candles, sir. I pour them myself and test each batch against "
        "the hall clock: one ring burns in ten minutes, neither more nor "
        "less. I light Madam's at ten precisely, when I latch the doors, "
        "and put it into her hand.",
        needs: ['candle'],
      ),
      Topic(
        'polish', 'When were the cellar door and steps last cleaned?',
        "At ten o'clock last night, sir, as on every night. When I have "
        "latched the doors I sweep the cellar steps and polish the door "
        "furniture. Whatever is on them now was put there after ten.",
        needs: ['heelmarks', 'cocoadoor'],
      ),
      Topic(
        'began', 'When exactly did the chess begin?',
        "At half past ten, sir. I entered the first move at 10:32. The "
        "Colonel was in his chair before I was.",
        needs: ['scoresheet'],
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
        "That gardener, sir. Forever lurking about below stairs. Not the "
        "niece: she was on the telephone, and the operator says so.",
      ),
      Topic(
        'hall', 'Did you hear anything in the hall after the game began?',
        "Now you mention it, sir, yes. We had barely opened. Twenty-five "
        "to eleven, say. Éclaire's voice in the hall: “This had better be "
        "worth my slippers.” And somebody answered her with a “darling”. "
        "Then the cellar door.",
        heard: ['graham/candle'],
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
        'footsteps', 'Did anyone pass you on the landing?',
        "Not a soul, darling. I was draped over that telephone table for "
        "forty minutes and nothing came up those stairs at all.",
        needs: ['phone'],
      ),
      Topic(
        'last', 'When did you last see your aunt?',
        "At dinner, darling. But she left me this. I found it on the "
        "telephone table when I rang off at half past. You see? She went "
        "down there by herself, at eleven.",
        gives: Evidence.given(
          'auntnote', "Aunt Éclaire's Note", 'tira',
          "A note Tira says her aunt left on the telephone table: “Tira. I "
          "can hear you chattering on that telephone again. I am going "
          "down to lock the rack myself. Do not wait up. É.S.”",
          icon: Icons.mail,
        ),
      ),
      Topic(
        'before', 'Where were you at twenty to eleven?',
        "Twenty to? Dressing, darling. One does not ring Madame Leine in "
        "curlers. Alone, naturally. Why twenty to? The watch said five "
        "past.",
        needs: ['candle'],
        heard: ['graham/candle'],
      ),
      Topic(
        'crown', 'There is cocoa on the hands that told us the time.',
        "I went down for the port at nine, darling. I dust everything I "
        "touch. I dare say I brushed against it.",
        needs: ['watch', 'clock'],
      ),
      Topic(
        'door', 'Your cocoa is on the cellar door, on top of the polish.',
        "Then Graham polished early, darling. He polishes everything. One "
        "can hardly be blamed for his timetable.",
        needs: ['cocoadoor'],
        heard: ['graham/polish'],
      ),
      Topic(
        'darling', 'The Colonel heard someone say “darling” to her at 10:35.',
        "Everybody says darling, darling. Penny says it to the cat. "
        "...We haven't a cat. To the dog, then.",
        heard: ['cannoli/hall'],
      ),
      Topic(
        'cheques', 'You have been signing her name on cheques.',
        "A misunderstanding, darling. Auntie always said I might put "
        "things on her account. I merely put them on it rather more "
        "directly.",
        needs: ['cheques', 'bankletter'],
      ),
      Topic(
        'pin', 'One of your hatpins is covered in custard.',
        "I own forty hatpins, darling, and I lose one a week. Anyone might "
        "have picked it up off the hall table.",
        needs: ['pinchest', 'pincrate'],
      ),
      Topic(
        'prints', 'Only your fingerprints are on the hatpin.',
        "Well of course they are, it's mine. Whoever used it had the wit "
        "to wear gloves. I should have thought that cleared me.",
        needs: ['prints'],
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
        "Couldn't say, guv. I was out the back from ten. Latched out, "
        "like every night. Whatever happened, happened without me.",
      ),
      ...barryCommon,
    ],
  },
);
