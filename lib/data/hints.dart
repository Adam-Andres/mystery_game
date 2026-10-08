import 'house.dart';
import 'models.dart';

String _list(List<String> names) => names.length == 1
    ? names.single
    : '${names.sublist(0, names.length - 1).join(', ')} and ${names.last}';

/// What Watsonut says about [e] when asked. Key clues have a hint written
/// for them; for the rest he suggests who might explain it.
String hintFor(MysteryCase mystery, Evidence e) {
  final written = mystery.hints[e.id];
  if (written != null) return written;
  final people = [
    for (final entry in mystery.topics.entries)
      if (entry.value.any((t) => t.needs.contains(e.id)))
        personById(entry.key).name,
  ];
  if (people.isEmpty) {
    return "I can't see that it tells us much on its own, old chap. Note it "
        "down and press on.";
  }
  return "I can't make head or tail of it myself, Churlock. But I should put "
      "it to ${_list(people)}, and watch their face.";
}
