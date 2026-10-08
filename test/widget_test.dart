import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystery/audio/lines.dart';
import 'package:mystery/audio/voice.dart';
import 'package:mystery/data/cases.dart';
import 'package:mystery/data/house.dart';
import 'package:mystery/data/models.dart';
import 'package:mystery/game_state.dart';
import 'package:mystery/main.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

void main() {
  group('case data', () {
    for (final mystery in allCases) {
      test('${mystery.title} is consistent', () {
        final residentIds = residents.map((p) => p.id).toSet();
        final poolIds = mystery.pool.map((e) => e.id).toSet();
        expect(poolIds.length, mystery.pool.length, reason: 'duplicate evidence id');
        expect(residentIds.containsAll(mystery.culprits), isTrue);
        expect({...mystery.culprits, ...mystery.nextVictims}, residentIds);
        expect(mystery.herrings.length, greaterThan(mystery.herringCount));
        for (final e in mystery.pool) {
          expect(slots[e.room]!.length, greaterThan(e.slot), reason: e.id);
        }

        // Two clues may share a spot only if they can never appear together.
        final spots = <String, int>{};
        void claim(Evidence e, int group) {
          final spot = '${e.room}#${e.slot}';
          expect(spots[spot] ?? group, group, reason: '${e.id} overlaps at $spot');
          spots[spot] = group;
        }

        var group = 0;
        for (final e in [...mystery.core, ...mystery.herrings]) {
          claim(e, group++);
        }
        for (final variants in mystery.variants) {
          for (final e in variants) {
            claim(e, group);
          }
          group++;
        }

        final statements = <String>{};
        for (final p in [...residents, ...police]) {
          final topics = mystery.topics[p.id]!;
          expect(topics.map((t) => t.id).toSet().length, topics.length, reason: p.id);
          statements.addAll(topics.map((t) => GameState.keyOf(p.id, t)));
          expect(
            placements.values.any((l) => l.any((pl) => pl.$1 == p.id)),
            isTrue,
            reason: p.id,
          );
        }
        for (final topics in mystery.topics.values) {
          for (final t in topics) {
            expect(poolIds, containsAll(t.needs), reason: t.id);
            expect(statements, containsAll(t.heard), reason: t.id);
          }
        }
      });

      test('${mystery.title} draws varied evidence', () {
        final index = allCases.indexOf(mystery);
        final draws = <String>{};
        for (var seed = 0; seed < 40; seed++) {
          final g = GameState(random: Random(seed))..newGame(caseIndex: index, skipIntro: true);
          final ids = g.evidence.map((e) => e.id).toSet();
          expect(ids.length, mystery.evidenceCount);
          expect(ids, containsAll(mystery.core.map((e) => e.id)));
          for (final variants in mystery.variants) {
            expect(variants.where((e) => ids.contains(e.id)), hasLength(1));
          }
          draws.add((ids.toList()..sort()).join(','));
        }
        expect(draws.length, greaterThan(20));
      });

      test('${mystery.title}: every follow-up can be reached in some game', () {
        final index = allCases.indexOf(mystery);
        final reached = <String>{};
        for (var seed = 0; seed < 60; seed++) {
          final g = GameState(random: Random(seed))..newGame(caseIndex: index, skipIntro: true);
          g.found.addAll(g.evidence.map((e) => e.id));
          var before = -1;
          while (g.asked.length != before) {
            before = g.asked.length;
            for (final p in [...residents, ...police]) {
              for (final t in g.topicsFor(p.id)) {
                g.ask(p, t);
              }
            }
          }
          reached.addAll(g.asked);
        }
        for (final entry in mystery.topics.entries) {
          for (final t in entry.value) {
            expect(reached, contains(GameState.keyOf(entry.key, t)));
          }
        }
      });
    }

    test('a new game never repeats the previous mystery', () {
      final g = GameState(random: Random(7));
      final seen = <String>{};
      String? last;
      for (var i = 0; i < 60; i++) {
        g.newGame();
        expect(g.mystery.id, isNot(last));
        last = g.mystery.id;
        seen.add(last);
      }
      expect(seen, hasLength(3));
    });
  });

  test('every spoken line has a voice clip', () {
    final lines = allVoiceLines();
    expect(lines.length, greaterThan(150));
    final missing = [
      for (final l in lines)
        if (!File(clipAsset(l)).existsSync()) '${l.voice}: ${l.text}',
    ];
    expect(missing, isEmpty, reason: 'run tool/make_voices.py');
    final wanted = {for (final l in lines) clipAsset(l).split('/').last};
    final extra = Directory('assets/voice')
        .listSync()
        .map((f) => f.uri.pathSegments.last)
        .where((f) => !wanted.contains(f));
    expect(extra, isEmpty, reason: 'unused clips');
  });

  group('verdict', () {
    test('exact culprits win', () {
      final g = GameState()..newGame(caseIndex: 1, skipIntro: true);
      g
        ..toggleAccused('tira')
        ..toggleAccused('graham')
        ..makeArrest();
      expect(g.phase, Phase.outro);
      expect(g.won, isTrue);
      expect(g.nextVictim, isNull);
    });

    test('a third suspect cannot be added', () {
      final g = GameState()..newGame(caseIndex: 0, skipIntro: true);
      g
        ..toggleAccused('tira')
        ..toggleAccused('graham')
        ..toggleAccused('penny');
      expect(g.accused, {'tira', 'graham'});
    });

    test('no arrest without a suspect', () {
      final g = GameState()..newGame(caseIndex: 0, skipIntro: true);
      g.makeArrest();
      expect(g.phase, Phase.playing);
    });

    test('wrong accusation frees the killer to strike a free resident', () {
      final g = GameState()..newGame(caseIndex: 0, skipIntro: true);
      g
        ..toggleAccused('graham')
        ..toggleAccused('barry')
        ..makeArrest();
      expect(g.won, isFalse);
      expect(g.jailedInnocents, {'graham', 'barry'});
      expect(g.freeKillers, {'cannoli'});
      expect(g.nextVictim!.id, 'penny');
    });

    test('catching only one of two killers still loses', () {
      final g = GameState()..newGame(caseIndex: 1, skipIntro: true);
      g
        ..toggleAccused('tira')
        ..makeArrest();
      expect(g.won, isFalse);
      expect(g.freeKillers, {'graham'});
      expect(g.nextVictim!.id, 'penny');
    });

    test('killer plus an innocent is not a win, but nobody else dies', () {
      final g = GameState()..newGame(caseIndex: 0, skipIntro: true);
      g
        ..toggleAccused('cannoli')
        ..toggleAccused('tira')
        ..makeArrest();
      expect(g.won, isFalse);
      expect(g.nextVictim, isNull);
    });
  });

  /// Lets a room-to-room walk run to its end.
  Future<void> walk(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
  }

  testWidgets('play through to a correct arrest', (tester) async {
    final g = GameState(random: Random(1));
    await tester.pumpWidget(MysteryApp(state: g, voice: Voice(SilentPlayer())));
    await tester.tap(_key('start'));
    await tester.pump();
    expect(g.phase, Phase.intro);
    g.newGame(caseIndex: 0);
    await tester.pump();

    // The arrival scene narrates line by line, and can be skipped.
    expect(find.textContaining('gloomy morning'), findsOneWidget);
    await tester.pump(const Duration(seconds: 16));
    expect(find.textContaining('Five residents'), findsOneWidget);
    await tester.tap(_key('cutscene-done'));
    await tester.pump();
    expect(g.phase, Phase.playing);
    expect(g.roomId, 'entrance');
    await tester.tap(_key('go-down'));
    await tester.pump();
    // Mid-walk the room has not changed yet, and clicks are ignored.
    await tester.pump(const Duration(milliseconds: 300));
    expect(g.roomId, 'entrance');
    await tester.tap(_key('notebook'), warnIfMissed: false);
    expect(g.panel, Panel.none);
    await walk(tester);
    expect(g.roomId, 'cellar');

    final clue = g.evidenceHere.first;
    await tester.tap(_key('evidence-${clue.id}'));
    await tester.pump();
    expect(g.found, contains(clue.id));
    await tester.tap(_key('close-dialogue'));
    await tester.pump();

    await tester.tap(_key('person-sprinkles'));
    await tester.pump();
    await tester.tap(_key('topic-what'));
    await tester.pump();
    expect(g.asked, contains('sprinkles/what'));
    await tester.tap(_key('close-dialogue'));
    await tester.pump();

    await tester.tap(_key('notebook'));
    await tester.pump();
    expect(find.textContaining(clue.name), findsOneWidget);
    await tester.tap(_key('close-panel'));
    await tester.pump();

    // The accusation can only be made from the entrance hall.
    expect(_key('solve'), findsNothing);
    await tester.tap(_key('go-up'));
    await walk(tester);
    expect(g.roomId, 'entrance');
    await tester.tap(_key('solve'));
    await tester.pump();
    await tester.tap(_key('accuse-cannoli'));
    await tester.pump();
    await tester.tap(_key('arrest'));
    await tester.pump();
    expect(find.textContaining('rain has stopped'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.tap(_key('cutscene-done'));
    await tester.pump();
    expect(find.text('CASE CLOSED'), findsOneWidget);
  });

  test('statements unlock questions for other characters', () {
    final g = GameState(random: Random(1))..newGame(caseIndex: 0, skipIntro: true);
    bool offered(String person, String id) =>
        g.topicsFor(person).any((t) => t.id == id);
    Topic topic(String person, String id) =>
        g.mystery.topics[person]!.firstWhere((t) => t.id == id);

    expect(offered('graham', 'left'), isFalse);
    g.ask(personById('cannoli'), topic('cannoli', 'where'));
    expect(offered('graham', 'left'), isTrue);
    expect(offered('cannoli', 'left'), isFalse);
    g.ask(personById('graham'), topic('graham', 'left'));
    expect(offered('cannoli', 'left'), isTrue);

    expect(offered('penny', 'pin'), isFalse);
    g.found.add('rack');
    expect(offered('penny', 'pin'), isTrue);
  });

  testWidgets('every room lays out without errors', (tester) async {
    for (var i = 0; i < allCases.length; i++) {
      final g = GameState(random: Random(i));
      await tester.pumpWidget(MysteryApp(key: UniqueKey(), state: g, voice: Voice(SilentPlayer())));
      g.newGame(caseIndex: i, skipIntro: true);
      // Show every possible clue at once.
      g.evidence = allCases[i].pool.toList();
      g.closeDialogue();
      for (final room in rooms) {
        g.enter(room);
        await tester.pump();
        for (final e in g.evidenceHere.toList()) {
          g.inspect(e);
          await tester.pump();
          g.closeDialogue();
        }
      }
      for (var pass = 0; pass < 4; pass++) {
        for (final room in rooms) {
          g.enter(room);
          for (final (id, _) in placements[room.id] ?? const <(String, double)>[]) {
            final p = personById(id);
            g.talkTo(p);
            await tester.pump();
            for (final t in g.topicsFor(id)) {
              g.ask(p, t);
              await tester.pump();
            }
            g.closeDialogue();
          }
        }
      }
      g.openPanel(Panel.notebook);
      await tester.pump();
      g.openPanel(Panel.accuse);
      await tester.pump();
      final innocents = residents.map((p) => p.id).where((id) => !g.mystery.culprits.contains(id));
      g
        ..toggleAccused(innocents.first)
        ..toggleAccused(innocents.last)
        ..makeArrest();
      await tester.pump();
      await tester.pump(const Duration(seconds: 14));
      g.showVerdict();
      await tester.pump();
      expect(find.text('THE KILLER STRIKES AGAIN'), findsOneWidget);
    }
  });
}
