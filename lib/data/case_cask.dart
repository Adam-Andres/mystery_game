import 'package:flutter/material.dart';

import 'common.dart';
import 'models.dart';

/// Two killers whose alibis are objects, and who each claim to have seen or
/// heard the other.
const caskCase = MysteryCase(
  id: 'cask',
  title: 'The Cask of Amaretto',
  culprits: {'barry', 'cannoli'},
  nextVictims: ['graham', 'penny', 'tira'],
  herringCount: 10,
  solution:
      "For a year Colonel Cannoli and Barry Tart had been carrying Mrs. "
      "Senclair's vintage port out through the yard and selling it, and she "
      "meant to count the rack herself at eleven and send for the police at "
      "nine. The Colonel put through a telephone call at ten to eleven, set "
      "the gramophone playing a record of his own memoirs into the "
      "mouthpiece, and went downstairs. Barry had never covered a single "
      "strawberry: he came in from the yard by the coal chute. At 11:05 the "
      "two of them knocked out both chocks at once and rolled a full cask of "
      "amaretto onto her. Barry climbed back out to knock at midnight, and "
      "each swore to having noticed the other. But the landing window does "
      "not face the garden, and the log Barry produced has him working by "
      "the light of a full moon, on a night when it never stopped raining. "
      "Penny was at her oven, and Graham and Tira were together over a cup "
      "of cocoa that the kitchen bell slip times to the minute.",
  core: [
    Evidence(
      'cask', 'Fallen Cask', 'cellar', 2,
      "A full cask of amaretto, off its cradle and lying across the outline. "
      "The cradle holds a cask with a wooden chock at either end, and both "
      "chocks have been knocked clean out. It wants dusting for fingerprints.",
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
    Evidence(
      'gramophone', 'Gramophone', 'landing', 4,
      "The parlor gramophone, carried up to the landing and set down beside "
      "the telephone table with its horn turned toward the instrument. The "
      "needle rests at the very end of a record: “MY CAMPAIGNS, by Col. "
      "Cannoli. Read by the author. Side two, 38 minutes.”",
      icon: Icons.album, color: Color(0xFFCFD8DC),
    ),
    Evidence(
      'cocoatray', 'Cocoa Tray', 'parlor', 2,
      "A tray on the parlor table: one cup with a skin on the dregs, and a "
      "kitchen slip in Penny's hand. “Parlor bell, 10:58. Cocoa up at 11:00 "
      "by Graham. Cup not back by 11:20, so he is being talked at.”",
      icon: Icons.coffee, color: Color(0xFFBCAAA4),
    ),
    Evidence(
      'strawbeds', 'Strawberry Beds', 'backyard', 1,
      "Barry's strawberry beds. Every plant lies bare to the sky, limp and "
      "blackened. The frost cloths sit just inside the greenhouse door in a "
      "folded stack, bone dry.",
      icon: Icons.grass, color: Color(0xFF81C784),
    ),
    Evidence(
      'planner', 'Appointment Book', 'study', 0,
      "Mrs. Senclair's appointment book, kept under lock. Yesterday's page: "
      "“11 PM, count the port myself. Tell nobody.” Today's: “9 AM, Sgt. "
      "Sprinkles.”",
      icon: Icons.event_note, color: paper, inside: 'desk',
    ),
  ],
  variants: [
    timeOfDeath,
    [
      Evidence(
        'porthole', 'Landing Porthole', 'landing', 3,
        "The only window on the landing: a round porthole over the front "
        "door. It looks down the lane, past the lollipop trees. No part of "
        "the back garden can be seen from it.",
        icon: Icons.panorama_fish_eye, color: Color(0xFFB2EBF2),
      ),
      Evidence(
        'lampcold', 'Greenhouse Lamp', 'backyard', 0,
        "Barry's lamp, on its hook inside the greenhouse door. The reservoir "
        "is full to the brim and the wick is new and white. It has not been "
        "lit this week.",
        icon: Icons.light, color: Color(0xFFFFE082),
      ),
    ],
    [
      Evidence(
        'chute', 'Coal Hatch', 'backyard', 2,
        "The coal hatch in the back wall of the house, which drops straight "
        "into the boiler-room bunker. Its bolt is on the outside and has "
        "been drawn. On the rim, a smear of red glaze and a few crumbs of "
        "shortcrust.",
        icon: Icons.sensor_door, color: _iron,
      ),
      Evidence(
        'sootsocks', 'Sooty Socks', 'boiler', 0,
        "Rolled up at the bottom of Barry's bag: a pair of thick socks, "
        "black to the ankle with coal dust. One toe has a stiff yellow "
        "crust on it. Custard.",
        icon: Icons.dry_cleaning, color: _iron, inside: 'kitbag',
      ),
    ],
    [
      Evidence(
        'bottles', 'Buried Bottles', 'backyard', 0,
        "Under the loose earth, a sack of empty '08 port bottles and a "
        "pencilled tally on a seed packet: “Jolly Dodger Inn. 38 bottles at "
        "300 cubes. Half to B., half to the Col.”",
        icon: Icons.liquor, color: Color(0xFF8D6E63), inside: 'dirt',
      ),
      Evidence(
        'tally', "Mrs. Senclair's Count", 'cellar', 0,
        "Locked in the strongbox, in her own hand: “'08 port. Sixty on "
        "Graham's book, twenty-two on the rack. It does not go up my stairs, "
        "so it goes out by the yard, and that wants two: one to hand it up "
        "and one to take it. I shall count it myself at eleven.”",
        icon: Icons.fact_check, color: paper, inside: 'strongbox',
      ),
    ],
    [
      Evidence(
        'seeds', 'Seeds in the Custard', 'cellar', 1,
        "A smear of set red glaze on the flagstones beside the outline, "
        "full of tiny strawberry seeds. It lies on top of the spilled "
        "custard, so it got there afterwards.",
        icon: Icons.grain, color: Color(0xFFE57373),
      ),
      Evidence(
        'ricottacask', 'Cream on the Cradle', 'cellar', 1,
        "On the empty cradle, at the end nearest the wall: a thick thumb of "
        "white ricotta, pressed into the wood where somebody leaned hard to "
        "knock out the chock.",
        icon: Icons.water_drop, color: Colors.white,
      ),
    ],
  ],
  herrings: [
    will, bills, dismissal, spade, jobAd, recipe, threat, berryStain, crumbs,
    cocoa, sauceDrip, betting, savings, diary, slipper, scratches, letters,
    medal,
  ],
  weapons: {'cask'},
  printsOn: ['graham', 'barry', 'cannoli'],
  prints: Evidence.given(
    'prints', 'Prints on the Cask', 'churlock',
    "Three sets of prints came up under the powder. Graham Cracker's are on "
    "the tap and the bung, where a cellarman's would be. The other two are "
    "each a whole hand, flat and pushing, one on either end hoop: Barry "
    "Tart's at one end, Colonel Cannoli's at the other.",
    icon: Icons.fingerprint, color: Color(0xFFB2EBF2),
  ),
  deskCode: '1894',
  hints: {
    ...commonHints,
    ...timeHints,
    'boots': bootsHint,
    'souffle': souffleHint,
    'phone': "The operator's word that a line stayed open, Churlock. Not "
        "that anyone stood at the end of it. Who heard him talking?",
    'gramophone': "Thirty-eight minutes a side. How long was that telephone "
        "call? And ask the others whose gramophone that is, and where it "
        "ought to be.",
    'cocoatray': "A slip of paper with the time on it, written by somebody "
        "with no reason to care. That is worth more than any amount of "
        "swearing.",
    'strawbeds': "Somebody told us he spent two hours last night doing "
        "precisely this job. Ask him to explain the result.",
    'planner': "She meant to catch somebody at eleven. I wonder whether "
        "that somebody knew she was coming.",
    'cask': "Both chocks out, old chap. Could one dessert be at both ends "
        "of a cask at once? Dust it, and ask the man who keeps the cellar.",
    'porthole': "Has anybody told you what they saw from this landing? "
        "Stand where they stood, and look where they say they looked.",
    'lampcold': "Never lit. Has anybody told you they saw a light out "
        "there last night?",
    'chute': "A way into the house that Graham does not latch at ten. And "
        "whoever used it left a little of himself on the rim.",
    'sootsocks': "A man who walks about in his socks is a man who does not "
        "want his boots heard. Or his boots found muddy somewhere they "
        "should not be.",
    'bottles': "Half to B., half to the Col. Two names, one secret, and a "
        "lady who was about to find it out.",
    'tally': "She worked out for herself that it took two. I should ask "
        "the butler how wine could leave this cellar without passing him.",
    'seeds': "On top of the custard, so after she fell. Penny knows every "
        "glaze and filling in this house. Ask her whose that is.",
    'ricottacask': "Somebody leaned hard on that end. Penny knows every "
        "filling in this house. And if there was a hand at that end, whose "
        "was at the other?",
    'frostlog': "Read it with last night's weather in mind, Churlock. All "
        "of it. And compare it with what the Colonel says he saw.",
    'prints': "Graham's are where a butler's belong. The other two are "
        "where you put your hands to shove. Ask each of them how his came "
        "to be there, and then ask Graham whether it is true.",
  },
  accuseHints: [
    "Everybody in this house seems to have an alibi, Churlock, and two of "
        "those alibis are things rather than people: a telephone slip and a "
        "pair of boots. Ask what each of those things really proves.",
    "Three of them can be placed by a slip of paper written by somebody "
        "else at the time. The other two can only be placed by each other. "
        "Which two say they saw or heard one another last night?",
    "Go up to the landing and look hard at what is standing beside the "
        "telephone. Then go out to the yard and look at the strawberries.",
    "A cask with a chock at either end, and a full hand on either hoop. "
        "One of those hands came in through the coal hatch, and the other "
        "left a record playing. Name them both.",
  ],
  topics: {
    'sprinkles': [
      Topic(
        'what', 'What happened to her?',
        "Victim is Mrs. Éclaire Senclair, founder of Senclair Confections. "
        "A full cask of amaretto came off its cradle and went over her, "
        "Detective. We traced where she lay in powdered sugar. If it "
        "weren't for the chocks I'd have called it an accident.",
      ),
      Topic(
        'weapon', 'Could it have been an accident?',
        "Not a chance. That cradle has a chock each end, and both are out. "
        "Knock out one and the cask only slews round. To send it straight "
        "off the front you want both gone at the same moment. Work that out "
        "for yourself.",
      ),
      whoWasHome,
      sprinklesChart,
    ],
    'glaze': glazeTopics,
    'penny': [
      pennyWhere,
      Topic(
        'about', aboutQ,
        "Strict, and getting stricter. She'd taken to counting things "
        "lately. The spoons, the sugar, the bottles downstairs. She said "
        "somebody in this house took her for a fool.",
      ),
      Topic(
        'suspect', suspectQ,
        "I'd not like to say. But Graham holds the cellar keys and writes "
        "the cellar book, and it's the cellar she was fretting over.",
      ),
      Topic(
        'bell', 'You wrote out a slip for the cocoa.',
        "I write a slip for everything that leaves my kitchen. The parlor "
        "bell went at two minutes to eleven, I had the pan on already, and "
        "Graham took the cup through on the stroke. He wasn't back for it "
        "by twenty past. I heard Miss Tira laughing, so I knew why.",
        needs: ['cocoatray'],
      ),
      Topic(
        'polish', 'Where was Graham before the bell rang?',
        "Next door at the silver, from half past ten. You can hear every "
        "fork through that hatch, and he hums when he polishes. It never "
        "stopped until the bell.",
        heard: ['graham/where'],
      ),
      Topic(
        'seeds', 'Whose glaze has strawberry seeds in it?',
        "Not mine. Mine's a sauce, it runs. A glaze that sets, with the "
        "seeds left in? That's a tart. There's only the one tart in this "
        "house, Detective, and he sleeps by the boiler.",
        needs: ['seeds'],
      ),
      Topic(
        'ricotta', 'Whose filling is ricotta?',
        "The Colonel's. He leaks when he strains himself, poor man. I top "
        "him up on Sundays. If you've found a lot of it in one place, he "
        "was pushing at something.",
        needs: ['ricottacask'],
      ),
      Topic(
        'backdoor', 'Did anybody come in by your back door before midnight?',
        "Not a soul. It's in my kitchen, and I was stood six feet from it "
        "the whole hour. Graham shot the bolt at ten and I drew it myself "
        "at midnight for Barry. It shrieks. I'd have heard.",
        needs: ['chute', 'sootsocks'],
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
        "In the dining room, sir, polishing the silver, from half past ten. "
        "At two minutes to eleven the parlor bell rang. I took Miss Tira "
        "her cocoa at eleven precisely, and was detained until twenty past "
        "upon the subject of hats.",
      ),
      Topic(
        'about', aboutQ,
        "Thirty years I served Madam, sir. Of late she had begun to check "
        "my cellar book against the rack. I did not take it personally. I "
        "took it as a sign that something was wrong with the rack.",
      ),
      Topic(
        'suspect', suspectQ,
        "It is not my place, sir. I will observe that the Colonel treats "
        "the cellar as his own, and that the gardener is in and out of the "
        "boiler room next to it at all hours.",
      ),
      Topic(
        'voice', 'Could you hear the Colonel on the telephone?',
        "Through the ceiling, sir, for forty minutes. The Siege of Fort "
        "Fondant, word for word as he tells it each Christmas. I remarked "
        "to Miss Tira that he did not once pause to let the other gentleman "
        "reply.",
        needs: ['phone'],
      ),
      Topic(
        'gramophone', 'There is a gramophone beside the telephone.',
        "That is the parlor gramophone, sir. It was not in the parlor when "
        "I brought in the cocoa. The records are the Colonel's own. He had "
        "his memoirs pressed at his own expense, and gives them as "
        "presents.",
        needs: ['gramophone'],
      ),
      Topic(
        'cask', 'How does a cask come off its cradle?',
        "It does not, sir, unless it is helped. There is a chock at either "
        "end, and both must come out together. I can tap that cask. I "
        "could no more shift it alone than I could shift the house.",
        needs: ['cask'],
      ),
      Topic(
        'prints', 'Your fingerprints are on the cask.',
        "On the tap and the bung, I should hope, sir. I draw from it every "
        "Saturday for the trifle. I have never had occasion to put my hands "
        "on the hoops.",
        needs: ['prints'],
      ),
      Topic(
        'chock', 'Barry says he helped you chock the cask on Saturday.',
        "Nobody assists me in the cellar, sir. I should not permit it. The "
        "gardener's hands are seldom clean and the cask has not been moved "
        "since it was laid down in the spring.",
        heard: ['barry/prints'],
      ),
      Topic(
        'stock', 'Thirty-eight bottles of port are missing.',
        "Then they did not leave by my stairs, sir. I lock the cellar door "
        "at six and I hold the key. There is, however, a doorway through "
        "to the boiler room, and the coalman's hatch above the bunker "
        "opens from the yard.",
        needs: ['bottles', 'tally'],
      ),
      ...grahamCommon,
      ...grahamYard,
    ],
    'cannoli': [
      Topic(
        'where', whereQ,
        "On the telephone on the landing, sir! Ten to eleven until half "
        "past, with old Brigadier Brûlée at the Officers' Club. The "
        "operator will tell you the line never dropped.",
      ),
      Topic(
        'about', aboutQ,
        "Éclaire? A dear friend, and a generous hostess. Kept a splendid "
        "cellar. I shall miss her table.",
      ),
      Topic(
        'suspect', suspectQ,
        "The butler, sir. Keys to everything and a face like a locked "
        "drawer. Not the gardener: I can vouch for the gardener myself.",
      ),
      Topic(
        'saw', 'How can you vouch for Barry?',
        "Saw his lamp, sir! Bobbing about in the greenhouse the whole time "
        "I was talking. Watched it from the landing window. Poor devil, out "
        "in that weather.",
        heard: ['cannoli/suspect'],
      ),
      Topic(
        'porthole', 'The landing window faces the front lane.',
        "Does it? Then I saw it reflected. In the rain, sir. A soldier "
        "develops a sense for these things in the field.",
        needs: ['porthole'],
        heard: ['cannoli/saw'],
      ),
      Topic(
        'lamp', "Barry's lamp was never lit.",
        "Not lit? Then it was his pipe. A glow, sir. I distinctly saw a "
        "glow. Does the fellow smoke? He ought to.",
        needs: ['lampcold'],
        heard: ['cannoli/saw'],
      ),
      Topic(
        'gramophone', 'Why is the gramophone beside the telephone?',
        "Regimental tradition, sir! One plays the march down the line for "
        "the chaps at the club. I carried it up for that. If my memoirs "
        "were on the turntable, they were there already.",
        needs: ['gramophone'],
      ),
      Topic(
        'paused', 'They say you never once paused for a reply.',
        "The Brigadier is a famously good listener, sir. Hasn't got a word "
        "in since the relief of Fort Fondant.",
        heard: ['graham/voice'],
      ),
      Topic(
        'prints', 'Your hand is on the end of the cask.',
        "I draw myself a glass from time to time, what. Graham knows. He "
        "writes it in his little book. One steadies the thing.",
        needs: ['prints'],
      ),
      Topic(
        'port', "Somebody has been selling Mrs. Senclair's port.",
        "Selling it? Monstrous. I drink it, sir. I don't sell it. Ask at "
        "the Jolly Dodger whether they have ever seen me. ...Any inn. Ask "
        "at any inn.",
        needs: ['bottles', 'tally'],
      ),
      Topic(
        'ricotta', 'Your filling is on the cradle.',
        "I shed, sir. Old war wound. I dare say there is a dab of me on "
        "every stick of furniture in this house.",
        needs: ['ricottacask'],
      ),
      cannoliBetting,
      cannoliMedal,
    ],
    'tira': [
      Topic(
        'where', whereQ,
        "In the parlor, darling, with Madame Leine's spring catalogue, from "
        "half past ten. I rang for cocoa just before eleven, Graham brought "
        "it, and I held him captive until twenty past. He has no opinions "
        "about feathers whatsoever.",
      ),
      Topic(
        'about', aboutQ,
        "Aunt Éclaire was a sweet old thing with a very hard glaze. Yes, I "
        "inherit. No, I didn't do it. I look dreadful in black.",
      ),
      Topic(
        'suspect', suspectQ,
        "Somebody who drinks, darling. Auntie had started counting the "
        "bottles, and nobody counts bottles unless bottles are going.",
      ),
      Topic(
        'voice', 'Could you hear the Colonel on the telephone?',
        "For forty minutes, darling, straight above my head. That same old "
        "siege. And do you know, he never once said “what”. He says "
        "“what” after everything. I thought the Brigadier must have died.",
        needs: ['phone'],
      ),
      Topic(
        'gramophone', 'The gramophone is up on the landing.',
        "So THAT is where it went. I wanted a waltz at half past ten and it "
        "had vanished out of the parlor. I assumed Graham had confiscated "
        "it again.",
        needs: ['gramophone'],
      ),
      ...tiraCommon,
    ],
    'barry': [
      Topic(
        'where', whereQ,
        "Out in the greenhouse 'til midnight, coverin' the strawberries "
        "against the frost. I could hear the Colonel boomin' down the "
        "telephone clear across the garden the whole time. Penny let me in "
        "— door was latched. Left me boots on the mat.",
      ),
      barryAbout,
      Topic(
        'suspect', suspectQ,
        "Butler's got the keys to that cellar, guv. Nobody else. And he's "
        "been lookin' sick as a parrot ever since she started countin'.",
      ),
      Topic(
        'beds', 'Not one of your strawberries is covered.',
        "Ah. Well. I did the ones inside, see. Them outside beds is past "
        "savin'. No sense wastin' a good cloth.",
        needs: ['strawbeds'],
      ),
      Topic(
        'log', 'Can you show me what you did out there last night?',
        "Wrote it all down, guv, like I always do. Back of a seed packet. "
        "Take it. That's two hours' honest graft, that is.",
        needs: ['strawbeds'],
        gives: Evidence.given(
          'frostlog', "Barry's Frost Log", 'barry',
          "A seed packet, pencilled on the back in Barry's hand: “Thurs "
          "night. Hard frost. Covered all the strawbs, 10 till 12. Sky "
          "clear as a bell and a full moon, bright enough to work by. No "
          "lamp wanted.”",
        ),
      ),
      Topic(
        'moon', 'The Colonel says he watched your lamp. You say you had none.',
        "Did he? He'll have seen the moon on the glass, I expect. Bright "
        "old night, it was.",
        needs: ['frostlog'],
        heard: ['cannoli/saw'],
      ),
      Topic(
        'chute', 'The coal hatch was unbolted, with your glaze on it.',
        "Coalman uses that, guv. Bolt's on the outside so he can tip a "
        "load in. Anybody could draw it. And I lean on that wall every day "
        "of me life.",
        needs: ['chute'],
      ),
      Topic(
        'socks', 'There is custard on your socks.',
        "I shovel in me socks, guv, saves the boots. And Penny gives me "
        "the custard skins. Must've dropped a bit.",
        needs: ['sootsocks'],
      ),
      Topic(
        'seeds', 'Your glaze is on the cellar floor, on top of the custard.',
        "I'm through that cellar ten times a day to get to me boiler, guv. "
        "I shed seeds like a dog sheds hair.",
        needs: ['seeds'],
      ),
      Topic(
        'prints', 'Your hand is on the end of the cask.',
        "Helped the butler chock it Saturday, didn't I. Ask him. Heavy old "
        "thing.",
        needs: ['prints'],
      ),
      Topic(
        'port', "Somebody has been selling Mrs. Senclair's port.",
        "Not me, guv. Wouldn't know port from paraffin. I'm a tea man.",
        needs: ['bottles', 'tally'],
      ),
      ...barryCommon,
    ],
  },
);

const _iron = Color(0xFF90A4AE);
