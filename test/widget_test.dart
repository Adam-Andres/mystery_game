import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystery/audio/lines.dart';
import 'package:mystery/audio/voice.dart';
import 'package:mystery/data/cases.dart';
import 'package:mystery/data/hints.dart';
import 'package:mystery/data/house.dart';
import 'package:mystery/data/models.dart';
import 'package:mystery/game_state.dart';
import 'package:mystery/main.dart';
import 'package:mystery/screens/minigames.dart';
import 'package:mystery/widgets/dessert_figure.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

class _RecordingPlayer implements ClipPlayer {
  int stops = 0;
  final played = <String>[];

  @override
  Future<void> play(String asset) async => played.add(asset);

  @override
  void stop() => stops++;

  @override
  void setMuted(bool muted) => mutes.add(muted);

  final mutes = <bool>[];
}

void main() {
  group('case data', () {
    for (final mystery in allCases) {
      test('${mystery.title} is consistent', () {
        final residentIds = residents.map((p) => p.id).toSet();
        final poolIds = mystery.pool.map((e) => e.id).toSet();
        expect(
          poolIds.length,
          mystery.pool.length,
          reason: 'duplicate evidence id',
        );
        final allIds = {
          ...poolIds,
          ...mystery.gifts.map((e) => e.id),
          mystery.prints.id,
        };
        expect(allIds.length, mystery.pool.length + mystery.gifts.length + 1);
        expect(poolIds, containsAll(mystery.weapons));
        expect(residentIds, containsAll(mystery.printsOn));
        expect(mystery.deskCode, hasLength(4));
        expect(residentIds.containsAll(mystery.culprits), isTrue);
        expect({...mystery.culprits, ...mystery.nextVictims}, residentIds);
        expect(mystery.herrings.length, greaterThan(mystery.herringCount));
        for (final e in mystery.pool) {
          if (e.inside != null) {
            // Hidden evidence lives in furniture in the same room.
            expect(nookById(e.inside!).room, e.room, reason: e.id);
          } else {
            expect(slots[e.room]!.length, greaterThan(e.slot), reason: e.id);
          }
          if (e.puzzle != Puzzle.none) {
            expect(e.pieces, isNotEmpty, reason: e.id);
          }
        }

        // Two clues may share a spot only if they can never appear together.
        final spots = <String, int>{};
        void claim(Evidence e, int group) {
          if (e.inside != null) return;
          final spot = '${e.room}#${e.slot}';
          expect(
            spots[spot] ?? group,
            group,
            reason: '${e.id} overlaps at $spot',
          );
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
          expect(
            topics.map((t) => t.id).toSet().length,
            topics.length,
            reason: p.id,
          );
          statements.addAll(topics.map((t) => GameState.keyOf(p.id, t)));
          expect(
            placements.values.any((l) => l.any((pl) => pl.$1 == p.id)),
            isTrue,
            reason: p.id,
          );
        }
        for (final topics in mystery.topics.values) {
          for (final t in topics) {
            expect(allIds, containsAll(t.needs), reason: t.id);
            expect(statements, containsAll(t.heard), reason: t.id);
          }
        }
      });

      test('${mystery.title} draws varied evidence', () {
        final index = allCases.indexOf(mystery);
        final draws = <String>{};
        for (var seed = 0; seed < 40; seed++) {
          final g = GameState(random: Random(seed))
            ..newGame(caseIndex: index, skipIntro: true);
          final ids = g.evidence.map((e) => e.id).toSet();
          expect(ids.length, mystery.evidenceCount);
          expect(g.evidence.length, mystery.evidenceCount);
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
          final g = GameState(random: Random(seed))
            ..newGame(caseIndex: index, skipIntro: true);
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

    test('every resident is a killer in exactly two mysteries', () {
      for (final p in residents) {
        expect(
          allCases.where((c) => c.culprits.contains(p.id)),
          hasLength(2),
          reason: p.id,
        );
      }
    });

    test('every tool opens somewhere, and every such place has a tool', () {
      final wanted = {
        for (final n in nooks)
          if (n.needs != null) n.needs!,
      };
      expect(wanted, {for (final i in items) i.id});
    });

    test('a new game never repeats the previous mystery', () {
      final g = GameState(random: Random(7), twistChance: 0);
      final seen = <String>{};
      String? last;
      for (var i = 0; i < 60; i++) {
        g.newGame();
        expect(g.mystery.id, isNot(last));
        last = g.mystery.id;
        seen.add(last);
      }
      expect(seen, hasLength(7));
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

  testWidgets('the desk dial clicks only at the number it wants', (
    tester,
  ) async {
    final effects = _RecordingPlayer();
    final voice = Voice(SilentPlayer(), effects);
    await tester.pumpWidget(
      MaterialApp(
        home: VoiceScope(
          voice: voice,
          child: Scaffold(
            body: Center(
              child: DialLock(combination: const [10, 69, 36], onTry: (_) => true),
            ),
          ),
        ),
      ),
    );
    for (var n = 0; n < 12; n++) {
      await tester.tap(_key('dial-right'));
    }
    await tester.pump();
    final clicks = [
      for (final (i, clip) in effects.played.indexed)
        if (clip.contains('click')) i,
    ];
    // The tenth notch, and no other.
    expect(clicks, [9]);
    expect(effects.played, hasLength(12));
    expect(find.text('(click)'), findsNothing);

    // With the sound off, the click is shown instead.
    voice.toggleMute();
    for (var n = 0; n < 98; n++) {
      await tester.tap(_key('dial-right'));
    }
    await tester.pump();
    expect(find.text('(click)'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('(click)'), findsNothing);
  });

  group('the rare mystery', () {
    test('turns up as often as it is set to', () {
      final always = GameState(random: Random(1), twistChance: 1)..newGame();
      expect(always.mystery.id, twistCase.id);
      final never = GameState(random: Random(1), twistChance: 0)..newGame();
      expect(never.mystery.id, isNot(twistCase.id));
      final g = GameState(random: Random(5), twistChance: 1 / 20);
      var twists = 0;
      for (var i = 0; i < 2000; i++) {
        g.newGame();
        if (g.mystery.id == twistCase.id) twists++;
      }
      expect(twists, inInclusiveRange(60, 140));
    });

    test('is consistent, and none of the residents did it', () {
      final m = twistCase;
      expect(m.culprits, {watsonut.id});
      expect(allCases, isNot(contains(m)));
      final ids = {
        ...m.pool.map((e) => e.id),
        ...m.gifts.map((e) => e.id),
        m.prints.id,
      };
      expect(ids.length, m.pool.length + m.gifts.length + 1);
      expect(ids, containsAll(m.weapons));
      for (final e in m.pool) {
        if (e.inside != null) {
          expect(nookById(e.inside!).room, e.room, reason: e.id);
        } else {
          expect(slots[e.room]!.length, greaterThan(e.slot), reason: e.id);
        }
      }
      // The strip is in the locked desk, and nowhere else.
      expect(m.core.singleWhere((e) => e.id == 'tornsheet').inside, 'desk');
      for (final c in allCases) {
        expect(c.pool.any((e) => e.id == 'tornsheet'), isFalse);
        expect(c.lies, isEmpty);
        expect(c.shaky, isEmpty);
      }
      final statements = {
        for (final entry in m.topics.entries)
          for (final t in entry.value) GameState.keyOf(entry.key, t),
      };
      for (final t in m.topics.values.expand((l) => l)) {
        expect(ids, containsAll(t.needs), reason: t.id);
        expect(statements, containsAll(t.heard), reason: t.id);
      }
      // He lies about some things and not others.
      final hinted = {...ids, for (var i = 0; i < 4; i++) 'accuse:$i'};
      expect(hinted, containsAll(m.lies));
      expect(hinted, containsAll(m.shaky));
      expect(m.lies.length, lessThan(hinted.length));
      expect(m.lies.contains('souffle'), isFalse);
    });

    testWidgets('is solved by putting back the strip he tore off', (
      tester,
    ) async {
      final g = GameState(random: Random(4));
      final player = _RecordingPlayer();
      await tester.pumpWidget(MysteryApp(state: g, voice: Voice(player)));
      g.newGame(twist: true, skipIntro: true);
      await tester.pump();
      expect(g.mystery.id, twistCase.id);

      // The list of suspects is torn in every mystery, with a scroll bar
      // that scrolls nothing; here there is nobody extra to accuse yet.
      g.openPanel(Panel.accuse);
      await tester.pump();
      expect(_key('list-torn'), findsOneWidget);
      expect(_key('idle-scrollbar'), findsOneWidget);
      await tester.drag(_key('idle-scrollbar'), const Offset(60, 0));
      await tester.pump();
      expect(_key('accuse-watsonut'), findsNothing);
      expect(_key('attach-sheet'), findsNothing);
      g.closePanel();

      // His hints: a lie about what points at him, in a shaking voice and
      // with a still moustache; the truth about the rest.
      g.hintsUsed = 1;
      final clue = g.evidence.firstWhere(
        (e) => e.id == 'chainlink' || e.id == 'drizzle',
      );
      g.inspect(clue);
      g.askHint(about: clue);
      await tester.pump();
      expect(g.dialogue!.lying, isTrue);
      expect(g.dialogue!.voice, shakyVoice);
      expect(player.played.last, contains(shakyVoice));
      expect(
        tester
            .widgetList<DessertFigure>(find.byType(DessertFigure))
            .where((f) => f.stiff),
        isNotEmpty,
      );
      final souffle = g.evidence.firstWhere((e) => e.id == 'souffle');
      g.askHint(about: souffle);
      await tester.pump();
      expect(g.dialogue!.lying, isFalse);
      expect(g.dialogue!.voice, isNull);
      g.closeDialogue();

      // The strip is in the desk. Fitted back, it adds a sixth suspect.
      final desk = nookById('desk');
      expect(g.tryCode(desk, deskCombination.join('-')), isTrue);
      g.inspect(g.evidence.firstWhere((e) => e.id == 'tornsheet'));
      g.closeDialogue();
      g.openPanel(Panel.accuse);
      await tester.pump();
      await tester.tap(_key('attach-sheet'));
      await tester.pump();
      expect(_key('list-whole'), findsOneWidget);
      await tester.tap(_key('accuse-watsonut'));
      await tester.pump();
      await tester.tap(_key('arrest'));
      await tester.pump();
      expect(g.won, isTrue);
      await tester.pump(const Duration(seconds: 4));
      await tester.tap(_key('cutscene-done'));
      await tester.pump();
      expect(find.text('CASE CLOSED'), findsOneWidget);
    });

    test('is lost by arresting a resident', () {
      final g = GameState()..newGame(twist: true, skipIntro: true);
      g
        ..toggleAccused('cannoli')
        ..makeArrest();
      expect(g.won, isFalse);
      expect(g.freeKillers, {watsonut.id});
      expect(g.nextVictim, isNotNull);
    });
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

  /// Lets Churlock finish crossing the room to whatever was clicked.
  Future<void> approach(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  }

  /// Lets a room-to-room walk run to its end.
  Future<void> walk(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 1800));
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
    // Nothing can be clicked until Watsonut has said his piece.
    await tester.pump();
    expect(find.text(watsonut.greeting), findsOneWidget);
    await tester.tap(_key('notebook'), warnIfMissed: false);
    await tester.tap(_key('go-down'), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 1));
    expect(g.panel, Panel.none);
    expect(g.roomId, 'entrance');
    expect(find.text(watsonut.greeting), findsOneWidget);
    await tester.pump(const Duration(seconds: 12));
    await tester.tap(_key('go-down'));
    await tester.pump();
    // Mid-walk the room has not changed yet, and clicks are ignored.
    await tester.pump(const Duration(milliseconds: 300));
    expect(g.roomId, 'entrance');
    await tester.tap(_key('notebook'), warnIfMissed: false);
    expect(g.panel, Panel.none);
    await walk(tester);
    expect(g.roomId, 'cellar');

    // Churlock walks over to a clue before he examines it.
    final clue = g.evidenceHere.first;
    await tester.tap(_key('evidence-${clue.id}'));
    await tester.pump();
    expect(g.found, isNot(contains(clue.id)));
    await approach(tester);
    expect(g.found, contains(clue.id));
    await tester.tap(_key('close-dialogue'));
    await tester.pump();

    await tester.tap(_key('person-sprinkles'));
    await approach(tester);
    await tester.tap(_key('topic-what'));
    await tester.pump();
    expect(g.asked, contains('sprinkles/what'));
    // The sergeant hands over the fingerprint chart when asked.
    await tester.ensureVisible(_key('topic-chart'));
    await tester.pump();
    await tester.tap(_key('topic-chart'));
    await tester.pump();
    expect(g.found, contains('chart'));
    expect(_key('dialogue-note'), findsOneWidget);
    await tester.tap(_key('close-dialogue'));
    await tester.pump();

    await tester.tap(_key('notebook'));
    await tester.pump();
    expect(find.textContaining(clue.name), findsOneWidget);

    // Clicking a notebook entry brings it back up, over the notebook.
    await tester.tap(_key('note-${clue.id}'));
    await tester.pump();
    expect(g.dialogue!.speaker.id, 'churlock');
    expect(g.dialogue!.text, clue.description);
    await tester.tap(_key('close-dialogue'));
    await tester.pump();
    expect(g.panel, Panel.notebook);
    await tester.tap(_key('note-sprinkles/what'));
    await tester.pump();
    expect(g.dialogue!.speaker.id, 'sprinkles');
    expect(g.dialogue!.talk, isFalse);
    expect(find.textContaining('You asked'), findsOneWidget);
    await tester.tap(_key('close-dialogue'));
    await tester.pump();
    // A handed-over document can be reviewed too.
    await tester.tap(_key('note-chart'));
    await tester.pump();
    expect(g.dialogue!.title, 'Fingerprint Chart');
    await tester.tap(_key('close-dialogue'));
    await tester.pump();

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
    final g = GameState(random: Random(1))
      ..newGame(caseIndex: 0, skipIntro: true);
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

  test('the killer hands over a forgery with a flaw in it', () {
    Evidence gift(int caseIndex, String id) =>
        allCases[caseIndex].gifts.firstWhere((e) => e.id == id);
    // The Colonel misspells her surname only when he is guilty.
    expect(gift(0, 'extension').description, contains('Sinclair'));
    expect(gift(1, 'extension').description, contains('Senclair'));
    // The tally adds up to 146, not the 144 it claims.
    expect(
      gift(1, 'tally').description,
      contains('Forks, 48. Knives, 48. Spoons, 50. Total, 144'),
    );
    // Penny's log has Madam alive after the time of death only in her case.
    expect(gift(2, 'ovenlog').description, contains('11:20'));
    expect(gift(0, 'ovenlog').description, isNot(contains('11:20')));
  });

  testWidgets('minigames can be completed by hand', (tester) async {
    final g = GameState(random: Random(4));
    await tester.pumpWidget(MysteryApp(state: g, voice: Voice(SilentPlayer())));
    g.newGame(caseIndex: 1, skipIntro: true);
    g.evidence = allCases[1].pool.toList()
      ..addAll([...allCases[1].gifts, allCases[1].prints]);
    await tester.pump();

    // Pencil rubbing on the butler's notepad.
    final notepad = g.evidence.firstWhere((e) => e.id == 'notepad');
    g.inspect(notepad);
    await tester.pump();
    expect(g.task, Task.rubbing);
    expect(g.found, isNot(contains('notepad')));
    final page = tester.getTopLeft(_key('rubbing-page'));
    for (var y = 80.0; y <= 220; y += 28) {
      final stroke = await tester.startGesture(page + Offset(60, y));
      for (var x = 60.0; x <= 500; x += 20) {
        await stroke.moveTo(page + Offset(x, y));
      }
      await stroke.up();
    }
    await tester.pump();
    await tester.tap(_key('puzzle-done'));
    await tester.pump();
    expect(g.found, contains('notepad'));
    expect(find.textContaining('tonight, at eleven'), findsOneWidget);
    g.closeDialogue();

    // A torn letter: swap strips until they are in order.
    final letter = g.evidence.firstWhere((e) => e.id == 'solicitor');
    g.inspect(letter);
    await tester.pump();
    expect(g.task, Task.torn);
    for (var slot = 0; slot < letter.pieces.length; slot++) {
      final want = letter.pieces[slot];
      final at = [
        for (var i = 0; i < letter.pieces.length; i++)
          tester
              .widget<Text>(
                find.descendant(
                  of: _key('strip-$i'),
                  matching: find.byType(Text),
                ),
              )
              .data,
      ].indexOf(want);
      if (at != slot) {
        await tester.tap(_key('strip-$slot'));
        await tester.tap(_key('strip-$at'));
        await tester.pump();
      }
    }
    await tester.tap(_key('puzzle-done'));
    await tester.pump();
    expect(g.found, contains('solicitor'));
    g.closeDialogue();

    // The desk has a dial: right, left, right, pressing the knob at each
    // number. The dial will not turn the wrong way.
    final desk = nookById('desk');
    g.search(desk);
    await tester.pump();
    var at = 0;
    Future<void> dial(List<int> code) async {
      for (final (i, number) in code.indexed) {
        final right = i.isEven;
        var turns = right ? (number - at) % 100 : (at - number) % 100;
        if (turns == 0) turns = 100;
        for (var n = 0; n < turns; n++) {
          await tester.tap(_key(right ? 'dial-right' : 'dial-left'));
        }
        await tester.pump();
        at = number;
        await tester.tap(_key('dial-set'));
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    await tester.tap(_key('dial-left'));
    await tester.pump();
    expect(find.textContaining('Dial reads  0'), findsOneWidget);
    await dial([5, 3, 8]);
    expect(g.isOpen(desk), isFalse);
    expect(find.textContaining('does not give'), findsOneWidget);
    await dial(deskCombination);
    expect(g.isOpen(desk), isTrue);
    await tester.tap(_key('evidence-planner'));
    await tester.pump();
    expect(g.found, contains('planner'));
    g.closeDialogue();
    g.closePanel();

    // Dusting the urn: raise three prints, then name each owner.
    final urn = g.evidence.firstWhere((e) => e.id == 'urn');
    g.inspect(urn);
    g.closeDialogue();
    g.found.add('chart');
    g.inspect(urn);
    await tester.pump();
    expect(g.task, Task.prints);
    // The stage is scaled to the window, so scale the brush strokes with it.
    final surface = tester.getRect(_key('dust-surface'));
    final scale = surface.width / 600;
    for (final spot in const [
      Offset(130, 120),
      Offset(310, 90),
      Offset(480, 140),
    ]) {
      final brush = await tester.startGesture(surface.topLeft + spot * scale);
      for (var i = 0; i < 14; i++) {
        await brush.moveBy(Offset(i.isEven ? 4 : -4, 0));
      }
      await brush.up();
    }
    await tester.pump();
    await tester.tap(_key('lift-prints'));
    await tester.pump();
    await tester.tap(_key('chart-barry'));
    await tester.pump();
    expect(find.textContaining('Not a match'), findsOneWidget);
    for (final owner in g.mystery.printsOn) {
      await tester.tap(_key('chart-$owner'));
      await tester.pump();
    }
    expect(g.found, contains('prints'));
    expect(find.textContaining('Three sets of prints'), findsOneWidget);
  });

  test('muting silences narration without stopping or skipping it', () {
    final player = _RecordingPlayer();
    final voice = Voice(player);
    voice.say(introLines[0]);
    final stopsBefore = player.stops;
    voice.toggleMute();
    expect(player.mutes, [true]);
    expect(player.stops, stopsBefore, reason: 'the clip must keep its place');
    // Lines that begin while muted still play, silently.
    voice.say(introLines[1]);
    expect(player.played, hasLength(2));
    voice.toggleMute();
    expect(player.mutes, [true, false]);
  });

  group('Watsonut', () {
    test('checks that the first hint of a game was meant', () {
      final g = GameState(random: Random(2))
        ..newGame(caseIndex: 0, skipIntro: true);
      final clue = g.evidence.firstWhere((e) => e.id == 'rack');
      g.inspect(clue);
      g.askHint(about: clue);
      expect(g.hintPrompt, isTrue);
      expect(g.hintsUsed, 0);
      // Declining gives nothing, and he will ask again next time.
      g.answerHintPrompt(wanted: false);
      expect(g.hintsUsed, 0);
      expect(g.dialogue!.speaker.id, 'churlock');
      g.askHint(about: clue);
      expect(g.hintPrompt, isTrue);
      g.answerHintPrompt(wanted: true);
      expect(g.hintsUsed, 1);
      expect(g.dialogue!.speaker.id, 'watsonut');
      expect(g.dialogue!.text, contains("Penny's kitchen"));
      // After the first, hints come without the question.
      g.askHint(about: g.evidence.firstWhere((e) => e.id == 'boots'));
      expect(g.hintPrompt, isFalse);
      expect(g.hintsUsed, 2);
    });

    test('points to who can explain a red herring', () {
      final g = GameState(random: Random(2))
        ..newGame(caseIndex: 0, skipIntro: true);
      final will = allCases[0].herrings.firstWhere((e) => e.id == 'will');
      expect(hintFor(g.mystery, will), contains('Tira Misu'));
      final stain = allCases[0].herrings.firstWhere(
        (e) => e.id == 'berrystain',
      );
      expect(hintFor(g.mystery, stain), contains('Penny Cotta and Barry Tart'));
    });

    test('says the same of a document whether or not it is forged', () {
      String onNote(int caseIndex) => hintFor(
        allCases[caseIndex],
        allCases[caseIndex].gifts.firstWhere((e) => e.id == 'extension'),
      );
      expect(onNote(0), onNote(1));
    });

    test('gives four hints on the accusation screen, one at a time', () {
      final g = GameState(random: Random(2))
        ..newGame(caseIndex: 2, skipIntro: true);
      g.openPanel(Panel.accuse);
      g.askHint();
      expect(g.hintPrompt, isTrue);
      g.answerHintPrompt(wanted: true);
      for (var i = 1; i <= 4; i++) {
        expect(g.accuseHintsGiven, i);
        expect(g.dialogue!.text, g.mystery.accuseHints[i - 1]);
        expect(g.dialogue!.note, 'Hint $i of 4');
        g.closeDialogue();
        g.askHint();
      }
      // A fifth request does nothing.
      expect(g.moreAccuseHints, isFalse);
      expect(g.dialogue, isNull);
      expect(g.hintsUsed, 4);
      expect(g.panel, Panel.accuse);
    });

    test('a speaker is known to be talking, even with no sound', () async {
      final voice = Voice(SilentPlayer());
      voice.toggleMute();
      await voice.say((voice: 'penny', text: 'x' * 200), owner: voice);
      expect(voice.isSpeaking('penny'), isTrue);
      expect(voice.isSpeaking('graham'), isFalse);
      voice.release(voice);
      expect(voice.isSpeaking('penny'), isFalse);
    });

    testWidgets('tools are picked up, shown in boxes, and open things', (
      tester,
    ) async {
      final g = GameState(random: Random(3));
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: 4, skipIntro: true);
      await tester.pump();
      expect(_key('held-shovel'), findsNothing);

      // The earth cannot be dug without the shovel.
      final dirt = nookById('dirt');
      g.enter(roomById('backyard'));
      await tester.pump();
      expect(_key('sight-pupcake'), findsOneWidget);
      g.search(dirt);
      await tester.pump();
      expect(g.isOpen(dirt), isFalse);
      expect(_key('use-item'), findsNothing);
      expect(find.text(dirt.barred), findsOneWidget);
      g.closePanel();

      g.enter(roomById('boiler'));
      await tester.pump();
      await tester.tap(_key('item-shovel'));
      await approach(tester);
      expect(g.items, ['shovel']);
      expect(find.textContaining('Picked up'), findsOneWidget);
      g.closeDialogue();
      await tester.pump();
      expect(_key('item-shovel'), findsNothing);
      expect(_key('held-shovel'), findsOneWidget);

      g.enter(roomById('backyard'));
      g.search(dirt);
      await tester.pump();
      await tester.tap(_key('use-item'));
      await tester.pump();
      expect(g.isOpen(dirt), isTrue);
      expect(g.evidenceIn(dirt), isNotEmpty);
      g.closePanel();

      // The strongbox wants its pins lifted in this game's order.
      final box = nookById('strongbox');
      g.take(itemById('lockpicks'));
      g.closeDialogue();
      g.enter(roomById('cellar'));
      g.search(box);
      await tester.pump();
      await tester.tap(_key('pin-${g.pinOrder[1]}'));
      await tester.pump();
      expect(g.isOpen(box), isFalse);
      for (final pin in g.pinOrder) {
        await tester.tap(_key('pin-$pin'));
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(g.isOpen(box), isTrue);
      g.closePanel();

      // Pupcake moves out of his doorway for a biscuit.
      final kennel = nookById('kennel');
      g.take(itemById('biscuit'));
      g.closeDialogue();
      g.enter(roomById('backyard'));
      g.search(kennel);
      await tester.pump();
      final before = tester.getCenter(_key('sight-pupcake'));
      await tester.tap(_key('use-item'));
      await tester.pump();
      expect(g.isOpen(kennel), isTrue);
      g.closePanel();
      await tester.pump();
      expect(tester.getCenter(_key('sight-pupcake')), isNot(before));
      for (final item in items) {
        expect(_key('held-${item.id}'), findsOneWidget);
      }
    });

    testWidgets('explains himself once, on the way in', (tester) async {
      final g = GameState(random: Random(2));
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: 0);
      g.beginInvestigation();
      await tester.pump();
      await tester.pump();
      expect(find.text(watsonut.greeting), findsOneWidget);
      await tester.pump(const Duration(seconds: 12));
      expect(_key('watsonut-remark'), findsNothing);
      // Prodding him afterwards gets a remark, not the explanation again.
      await tester.tap(_key('watsonut'));
      await tester.pump();
      expect(find.text(watsonut.greeting), findsNothing);
      expect(find.text(idleRemarks.first), findsOneWidget);
      expect(g.dialogue, isNull);
    });

    testWidgets('speaks up when Churlock stands idle, and follows him', (
      tester,
    ) async {
      final g = GameState(random: Random(2));
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      await tester.pump();
      expect(_key('watsonut'), findsOneWidget);
      await tester.pump(const Duration(seconds: 39));
      expect(_key('watsonut-remark'), findsNothing);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(_key('watsonut-remark'), findsOneWidget);
      expect(find.text(idleRemarks.first), findsOneWidget);
      // It clears by itself, and the next one waits another forty seconds.
      await tester.pump(const Duration(seconds: 8));
      expect(_key('watsonut-remark'), findsNothing);

      // He stays at Churlock's heel when they go to look at something.
      final before = tester.getCenter(_key('watsonut'));
      await tester.tap(_key('nook-closet'));
      await approach(tester);
      expect(g.panel, Panel.nook);
      expect(
        tester.getCenter(_key('watsonut')).dx,
        greaterThan(before.dx + 20),
      );
      g.closePanel();
      await tester.pump();

      // Asking about a find goes through the one-time confirmation.
      g.inspect(g.evidenceHere.first);
      await tester.pump();
      await tester.tap(_key('ask-watsonut'));
      await tester.pump();
      expect(find.text('Ask Watsonut for a hint?'), findsOneWidget);
      await tester.tap(_key('hint-yes'));
      await tester.pump();
      expect(g.dialogue!.speaker.id, 'watsonut');
    });
  });

  test('a closing screen does not silence the next one', () {
    final player = _RecordingPlayer();
    final voice = Voice(player);
    final outro = Object();
    final verdict = Object();
    voice.say(winLines.first, owner: outro);
    // The verdict starts speaking before the outro is torn down.
    voice.say((voice: narrator, text: allCases.first.solution), owner: verdict);
    final stopsBefore = player.stops;
    voice.release(outro);
    expect(player.stops, stopsBefore);
    voice.release(verdict);
    expect(player.stops, stopsBefore + 1);
  });

  testWidgets('every room lays out without errors', (tester) async {
    for (var i = 0; i < allCases.length; i++) {
      final g = GameState(random: Random(i));
      await tester.pumpWidget(
        MysteryApp(key: UniqueKey(), state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: i, skipIntro: true);
      // Show every possible clue at once.
      g.evidence = allCases[i].pool.toList();
      g.closeDialogue();
      for (final room in rooms) {
        g.enter(room);
        await tester.pump();
        Future<void> examine(Evidence e) async {
          g.inspect(e);
          await tester.pump();
          if (g.panel == Panel.puzzle) {
            g.completeTask();
            await tester.pump();
          }
          g.closeDialogue();
        }

        for (final e in g.evidenceHere.toList()) {
          await examine(e);
        }
        for (final n in g.nooksHere) {
          g.search(n);
          await tester.pump();
          expect(g.tryCode(n, deskCombination.join('-')), isTrue);
          await tester.pump();
          for (final e in g.evidenceIn(n).toList()) {
            await examine(e);
          }
          for (final junk in n.junk) {
            g.remark(junk);
            await tester.pump();
            g.closeDialogue();
          }
          g.closePanel();
        }
      }
      // With the chart in hand, every weapon in the pool can be dusted.
      g.found.add('chart');
      final weapon = g.evidence.firstWhere(
        (e) => g.mystery.weapons.contains(e.id),
      );
      expect(g.canDust(weapon), isTrue);
      g.inspect(weapon);
      await tester.pump();
      expect(g.task, Task.prints);
      g.completeTask();
      await tester.pump();
      expect(g.found, contains('prints'));
      g.closeDialogue();
      for (var pass = 0; pass < 4; pass++) {
        for (final room in rooms) {
          g.enter(room);
          for (final (id, _)
              in placements[room.id] ?? const <(String, double)>[]) {
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
      final innocents = residents
          .map((p) => p.id)
          .where((id) => !g.mystery.culprits.contains(id));
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
