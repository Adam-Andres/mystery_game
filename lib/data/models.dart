import 'package:flutter/material.dart';

enum Dessert {
  churro,
  donutPink,
  donutGlazed,
  pannaCotta,
  tart,
  tiramisu,
  cannoli,
  cracker,
}

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.role,
    required this.dessert,
    this.greeting = '',
  });

  final String id;
  final String name;
  final String role;
  final Dessert dessert;
  final String greeting;
}

/// A question Churlock can ask. If [needs] is set, the question only appears
/// once that piece of evidence has been found.
class Topic {
  const Topic(this.question, this.answer, {this.needs});

  final String question;
  final String answer;
  final String? needs;
}

class Evidence {
  const Evidence({
    required this.id,
    required this.name,
    required this.description,
    required this.room,
    required this.pos,
    this.icon = Icons.auto_awesome,
    this.color = const Color(0xFFFFE082),
  });

  final String id;
  final String name;
  final String description;
  final String room;

  /// Centre of the clickable spot, in scene coordinates (960x540).
  final Offset pos;
  final IconData icon;
  final Color color;
}

class MysteryCase {
  const MysteryCase({
    required this.id,
    required this.title,
    required this.culprits,
    required this.evidence,
    required this.topics,
    required this.solution,
    required this.nextVictims,
  });

  final String id;
  final String title;
  final Set<String> culprits;
  final List<Evidence> evidence;

  /// Person id -> everything they can be asked in this case.
  final Map<String, List<Topic>> topics;
  final String solution;

  /// Innocent residents, in the order the killer would silence them.
  final List<String> nextVictims;
}

class Room {
  const Room({
    required this.id,
    required this.name,
    required this.level,
    required this.col,
    required this.wall,
    required this.floor,
  });

  final String id;
  final String name;

  /// 0 = basement, 1 = ground floor, 2 = attic.
  final int level;
  final int col;
  final Color wall;
  final Color floor;

  String get levelName => const ['Basement', 'Ground Floor', 'Attic'][level];
}
