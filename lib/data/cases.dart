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
const allCases = [
  flatCase, brewCase, cakeCase, caskCase, caneCase, hatCase, ironCase,
];

/// The rare eighth mystery, in which none of the residents did it.
const twistCase = holeCase;
