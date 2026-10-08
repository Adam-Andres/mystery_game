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

/// A question Churlock can ask.
///
/// It appears once any of the [needs] evidence has been found (if there is
/// any) and every statement in [heard] — written `person/topicId` — has been
/// listened to.
class Topic {
  const Topic(
    this.id,
    this.question,
    this.answer, {
    this.needs = const [],
    this.heard = const [],
  });

  final String id;
  final String question;
  final String answer;
  final List<String> needs;
  final List<String> heard;

  bool get isFollowUp => needs.isNotEmpty || heard.isNotEmpty;
}

class Evidence {
  const Evidence(
    this.id,
    this.name,
    this.room,
    this.slot,
    this.description, {
    this.icon = Icons.auto_awesome,
    this.color = const Color(0xFFFFE082),
  });

  final String id;
  final String name;
  final String room;

  /// Index into the room's list of evidence positions.
  final int slot;
  final String description;
  final IconData icon;
  final Color color;
}

/// A mystery. Each playthrough shows all of [core], one clue from each list
/// in [variants], and [herringCount] of the [herrings] chosen at random.
class MysteryCase {
  const MysteryCase({
    required this.id,
    required this.title,
    required this.culprits,
    required this.core,
    required this.variants,
    required this.herrings,
    this.herringCount = 7,
    required this.topics,
    required this.solution,
    required this.nextVictims,
  });

  final String id;
  final String title;
  final Set<String> culprits;
  final List<Evidence> core;
  final List<List<Evidence>> variants;
  final List<Evidence> herrings;
  final int herringCount;

  /// Person id -> everything they can be asked in this case.
  final Map<String, List<Topic>> topics;
  final String solution;

  /// Innocent residents, in the order the killer would silence them.
  final List<String> nextVictims;

  Iterable<Evidence> get pool => [
        ...core,
        for (final group in variants) ...group,
        ...herrings,
      ];

  int get evidenceCount => core.length + variants.length + herringCount;
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
