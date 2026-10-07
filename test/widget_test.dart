import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystery/data/cases.dart';
import 'package:mystery/data/house.dart';
import 'package:mystery/game_state.dart';
import 'package:mystery/main.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

void main() {
  group('case data', () {
    for (final mystery in allCases) {
      test('${mystery.title} is consistent', () {
        final residentIds = residents.map((p) => p.id).toSet();
        final evidenceIds = mystery.evidence.map((e) => e.id).toSet();
        expect(evidenceIds.length, mystery.evidence.length);
        expect(residentIds.containsAll(mystery.culprits), isTrue);
        expect(
          {...mystery.culprits, ...mystery.nextVictims},
          residentIds,
        );
        for (final e in mystery.evidence) {
          expect(rooms.any((r) => r.id == e.room), isTrue, reason: e.id);
        }
        for (final p in [...residents, ...police]) {
          expect(mystery.topics[p.id], isNotEmpty, reason: p.id);
          // Everyone must be standing somewhere Churlock can reach.
          expect(
            placements.values.any((l) => l.any((pl) => pl.$1 == p.id)),
            isTrue,
            reason: p.id,
          );
        }
        for (final topics in mystery.topics.values) {
          for (final t in topics) {
            if (t.needs != null) expect(evidenceIds, contains(t.needs));
          }
        }
      });
    }
  });

  group('verdict', () {
    test('exact culprits win', () {
      final g = GameState()..newGame(caseIndex: 1);
      g
        ..toggleAccused('tira')
        ..toggleAccused('graham')
        ..makeArrest();
      expect(g.phase, Phase.ended);
      expect(g.won, isTrue);
      expect(g.nextVictim, isNull);
    });

    test('a third suspect cannot be added', () {
      final g = GameState()..newGame(caseIndex: 0);
      g
        ..toggleAccused('tira')
        ..toggleAccused('graham')
        ..toggleAccused('penny');
      expect(g.accused, {'tira', 'graham'});
    });

    test('no arrest without a suspect', () {
      final g = GameState()..newGame(caseIndex: 0);
      g.makeArrest();
      expect(g.phase, Phase.playing);
    });

    test('wrong accusation frees the killer to strike a free resident', () {
      final g = GameState()..newGame(caseIndex: 0);
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
      final g = GameState()..newGame(caseIndex: 1);
      g
        ..toggleAccused('tira')
        ..makeArrest();
      expect(g.won, isFalse);
      expect(g.freeKillers, {'graham'});
      expect(g.nextVictim!.id, 'penny');
    });

    test('killer plus an innocent is not a win, but nobody else dies', () {
      final g = GameState()..newGame(caseIndex: 0);
      g
        ..toggleAccused('cannoli')
        ..toggleAccused('tira')
        ..makeArrest();
      expect(g.won, isFalse);
      expect(g.nextVictim, isNull);
    });
  });

  testWidgets('play through to a correct arrest', (tester) async {
    final g = GameState();
    await tester.pumpWidget(MysteryApp(state: g));
    await tester.tap(_key('start'));
    await tester.pump();
    g.newGame(caseIndex: 0);
    await tester.pump();

    // Briefing, then down to the cellar.
    await tester.tap(_key('close-dialogue'));
    await tester.pump();
    await tester.tap(_key('go-down'));
    await tester.pump();
    expect(g.roomId, 'cellar');

    await tester.tap(_key('evidence-watch'));
    await tester.pump();
    expect(g.found, contains('watch'));
    await tester.tap(_key('close-dialogue'));
    await tester.pump();

    await tester.tap(_key('person-sprinkles'));
    await tester.pump();
    await tester.tap(_key('topic-0'));
    await tester.pump();
    expect(g.hasAsked('sprinkles', 0), isTrue);
    await tester.tap(_key('close-dialogue'));
    await tester.pump();

    await tester.tap(_key('notebook'));
    await tester.pump();
    expect(find.textContaining('Stopped Pocket Watch'), findsOneWidget);
    await tester.tap(_key('close-panel'));
    await tester.pump();

    // The accusation can only be made from the entrance hall.
    expect(_key('solve'), findsNothing);
    await tester.tap(_key('go-up'));
    await tester.pump();
    await tester.tap(_key('solve'));
    await tester.pump();
    await tester.tap(_key('accuse-cannoli'));
    await tester.pump();
    await tester.tap(_key('arrest'));
    await tester.pump();
    expect(find.text('CASE CLOSED'), findsOneWidget);
  });

  testWidgets('every room lays out without errors', (tester) async {
    for (var i = 0; i < allCases.length; i++) {
      final g = GameState();
      await tester.pumpWidget(MysteryApp(key: UniqueKey(), state: g));
      g.newGame(caseIndex: i);
      g.closeDialogue();
      for (final room in rooms) {
        g.roomId = room.id;
        g.closeDialogue();
        await tester.pump();
        for (final e in g.evidenceHere.toList()) {
          g.inspect(e);
          await tester.pump();
          g.closeDialogue();
        }
        for (final (id, _) in placements[room.id] ?? const <(String, double)>[]) {
          final p = personById(id);
          g.talkTo(p);
          await tester.pump();
          for (final (index, _) in g.topicsFor(id)) {
            g.ask(p, index);
            await tester.pump();
          }
          g.closeDialogue();
        }
      }
      g.openPanel(Panel.notebook);
      await tester.pump();
      g.openPanel(Panel.accuse);
      await tester.pump();
      g
        ..toggleAccused('penny')
        ..toggleAccused('barry')
        ..makeArrest();
      await tester.pump();
      expect(find.text('THE KILLER STRIKES AGAIN'), findsOneWidget);
    }
  });
}
