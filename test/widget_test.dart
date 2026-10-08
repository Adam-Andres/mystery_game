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
        expect(poolIds.length, mystery.pool.length, reason: 'duplicate evidence id');
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
          if (e.puzzle != Puzzle.none) expect(e.pieces, isNotEmpty, reason: e.id);
        }

        // Two clues may share a spot only if they can never appear together.
        final spots = <String, int>{};
        void claim(Evidence e, int group) {
          if (e.inside != null) return;
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
            expect(allIds, containsAll(t.needs), reason: t.id);
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

  /// Lets Churlock finish crossing the room to whatever was clicked.
  Future<void> approach(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  }

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

  test('the killer hands over a forgery with a flaw in it', () {
    Evidence gift(int caseIndex, String id) =>
        allCases[caseIndex].gifts.firstWhere((e) => e.id == id);
    // The Colonel misspells her surname only when he is guilty.
    expect(gift(0, 'extension').description, contains('Sinclair'));
    expect(gift(1, 'extension').description, contains('Senclair'));
    // The tally adds up to 146, not the 144 it claims.
    expect(gift(1, 'tally').description, contains('Forks, 48. Knives, 48. Spoons, 50. Total, 144'));
    // Penny's log has Madam alive after the time of death only in her case.
    expect(gift(2, 'ovenlog').description, contains('11:20'));
    expect(gift(0, 'ovenlog').description, isNot(contains('11:20')));
  });

  testWidgets('minigames can be completed by hand', (tester) async {
    final g = GameState(random: Random(4));
    await tester.pumpWidget(MysteryApp(state: g, voice: Voice(SilentPlayer())));
    g.newGame(caseIndex: 1, skipIntro: true);
    g.evidence = allCases[1].pool.toList()..addAll([...allCases[1].gifts, allCases[1].prints]);
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
          tester.widget<Text>(find.descendant(of: _key('strip-$i'), matching: find.byType(Text))).data,
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

    // The desk needs this mystery's combination.
    final desk = nookById('desk');
    g.search(desk);
    await tester.pump();
    await tester.tap(_key('try-lock'));
    await tester.pump();
    expect(g.isOpen(desk), isFalse);
    for (final (wheel, digit) in g.mystery.deskCode.split('').map(int.parse).indexed) {
      for (var i = 0; i < digit; i++) {
        await tester.tap(_key('wheel-up-$wheel'));
      }
    }
    await tester.pump();
    await tester.tap(_key('try-lock'));
    await tester.pump();
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
    for (final spot in const [Offset(130, 120), Offset(310, 90), Offset(480, 140)]) {
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
      await tester.pumpWidget(MysteryApp(key: UniqueKey(), state: g, voice: Voice(SilentPlayer())));
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
          expect(g.tryCode(n, g.mystery.deskCode), isTrue);
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
      final weapon = g.evidence.firstWhere((e) => g.mystery.weapons.contains(e.id));
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
