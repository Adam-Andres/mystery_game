import 'house.dart';
import 'models.dart';
import 'case_brew.dart';
import 'case_cake.dart';
import 'case_cane.dart';
import 'case_cask.dart';
import 'case_flat.dart';
import 'case_hat.dart';
import 'case_hole.dart';
import 'case_iron.dart';

export 'common.dart' show briefing;

/// Across the seven mysteries, every resident is a killer exactly twice.
const senclairCases = <MysteryCase>[
  flatCase, brewCase, cakeCase, caskCase, caneCase, hatCase, ironCase,
];

/// The rare eighth mystery, in which none of the residents did it.
const senclairTwist = holeCase;

/// The mysteries of the place being played.
List<MysteryCase> get allCases => world.cases;

/// Whether the place being played has a rare mystery, and what it is.
bool get hasTwist => world.twist != null;
MysteryCase get twistCase => world.twist!;
