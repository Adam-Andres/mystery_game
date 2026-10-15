import 'farm_case_chute.dart';
import 'farm_case_crank.dart';
import 'farm_case_cream.dart';
import 'farm_case_line.dart';
import 'farm_case_moon.dart';
import 'farm_case_pull.dart';
import 'farm_case_slice.dart';
import 'models.dart';

/// Across the farm's seven mysteries, as in the mansion's, every resident
/// is a killer exactly twice: three have one killer and four have two.
const farmCases = <MysteryCase>[
  moonCase, pullCase, creamCase, sliceCase, chuteCase, lineCase, crankCase,
];
