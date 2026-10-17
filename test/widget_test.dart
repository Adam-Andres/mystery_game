import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystery/audio/lines.dart';
import 'package:mystery/audio/voice.dart';
import 'package:mystery/data/cases.dart';
import 'package:mystery/data/hints.dart';
import 'package:mystery/data/house.dart';
import 'package:mystery/data/senclair.dart';
import 'package:mystery/data/farm.dart';
import 'package:mystery/data/models.dart';
import 'package:mystery/game_state.dart';
import 'package:mystery/main.dart';
import 'package:mystery/audio/ambience.dart';
import 'package:mystery/settings.dart';
import 'package:mystery/save.dart';
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

/// A player whose clips never report that they have finished, as a browser
/// that has run out of media players behaves.
class _HangingPlayer implements ClipPlayer {
  @override
  Future<void> play(String asset) => Completer<void>().future;

  @override
  void stop() {}

  @override
  void setMuted(bool muted) {}
}

void main() {
  group('case data', () {
    tearDown(() => world = senclair);
    for (final (w, mystery) in [
      for (final w in worlds)
        for (final m in w.cases) (w, m),
    ]) {
      test('${mystery.title} is consistent', () {
        world = w;
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
        world = w;
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
        world = w;
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

    test('everybody who lives in the house has somewhere to sleep', () {
      for (final id in ['mbedroom', 'groom', 'croom', 'proom', 'shed']) {
        final room = roomById(id);
        // Each can be walked to from the rest of the house.
        expect(
          Dir.values.any((d) => neighbor(room, d) != null),
          isTrue,
          reason: id,
        );
        expect(slots[id], isNotEmpty, reason: id);
        expect(nooks.where((n) => n.room == id), isNotEmpty, reason: id);
        // And every mystery has things to find there.
        for (final c in [...allCases, twistCase]) {
          expect(c.pool.where((e) => e.room == id), isNotEmpty, reason: id);
        }
      }
      // The three new tools each open something in one of them.
      for (final (tool, place) in [
        ('brasskey', 'cabinet'),
        ('stepstool', 'wardrobetop'),
        ('crowbar', 'floorboard'),
      ]) {
        expect(nookById(place).needs, tool);
        final g = GameState(random: Random(1), twistChance: 0)
          ..newGame(caseIndex: 0, skipIntro: true);
        expect(g.isOpen(nookById(place)), isFalse);
        g.take(itemById(tool));
        g.forceOpen(nookById(place));
        expect(g.isOpen(nookById(place)), isTrue);
        expect(g.items, isEmpty);
      }
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

  test('Watsonut explains the map only where there are no keys to show', () {
    // With a keyboard the keys are written beside the buttons instead.
    expect(arrivalGreeting(touch: false), watsonut.greeting);
    expect(arrivalGreeting(touch: true), startsWith(watsonut.greeting));
    expect(arrivalGreeting(touch: true), contains('tap the little map'));
  });

  group('keys', () {
    testWidgets('are shown beside their buttons, and open and shut them', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final g = GameState(random: Random(2), twistChance: 0);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      await tester.pump();
      expect(find.text('Settings  [Esc]'), findsOneWidget);
      expect(find.textContaining('[N]'), findsOneWidget);
      expect(find.text('Map  [M]'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
      await tester.pump();
      expect(g.panel, Panel.notebook);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
      await tester.pump();
      expect(g.panel, Panel.none);
      // Escape opens the settings, and backs out of anything.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(g.panel, Panel.menu);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(g.panel, Panel.none);
      g.openPanel(Panel.notebook);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(g.panel, Panel.none);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('can be changed in the settings, and are remembered', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final store = MemoryStore();
      final settings = Settings(store);
      final g = GameState(random: Random(2), twistChance: 0);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer()), settings: settings),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      await tester.pump();
      g.openPanel(Panel.menu);
      await tester.pump();
      await tester.tap(_key('bind-notebook'));
      await tester.pump();
      expect(find.textContaining('press a key'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
      await tester.pump();
      expect(find.text('Notebook: J'), findsOneWidget);
      // The panel is still open: the key was taken for the setting.
      expect(g.panel, Panel.menu);
      // Taking a key that is in use swaps the two.
      await tester.tap(_key('bind-map'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
      await tester.pump();
      expect(find.text('Map: J'), findsOneWidget);
      expect(find.text('Notebook: M'), findsOneWidget);
      // An arrow key is refused.
      await tester.tap(_key('bind-map'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(find.text('Map: J'), findsOneWidget);

      g.closePanel();
      await tester.pump();
      expect(find.text('Map  [J]'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(g.panel, Panel.map);
      g.closePanel();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
      await tester.pump();
      expect(g.panel, Panel.none);

      final again = Settings(store);
      expect(again.keyName('map'), 'J');
      expect(again.keyName('notebook'), 'M');
      expect(again.keyName('menu'), 'Esc');
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('are not offered on a touch screen', (tester) async {
      final g = GameState(random: Random(2), twistChance: 0);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      await tester.pump();
      expect(find.text('Settings'), findsOneWidget);
      expect(_key('map-hint'), findsNothing);
      g.openPanel(Panel.menu);
      await tester.pump();
      expect(_key('bind-map'), findsNothing);
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

  testWidgets('a sound that never ends cannot leave the player stuck', (
    tester,
  ) async {
    final g = GameState(random: Random(2));
    await tester.pumpWidget(
      MysteryApp(state: g, voice: Voice(_HangingPlayer())),
    );
    g.newGame(caseIndex: 0);
    g.beginInvestigation();
    await tester.pump();
    await tester.pump();
    // Held while Watsonut speaks, as usual.
    await tester.tap(_key('notebook'), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 2));
    expect(g.panel, Panel.none);
    // But not for ever.
    await tester.pump(const Duration(seconds: 45));
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(_key('notebook'));
    await tester.pump();
    expect(g.panel, Panel.notebook);
  });

  testWidgets('the arrow keys go back to moving once the dial is closed', (
    tester,
  ) async {
    final g = GameState(random: Random(2));
    await tester.pumpWidget(MysteryApp(state: g, voice: Voice(SilentPlayer())));
    g.newGame(caseIndex: 0, skipIntro: true);
    g.enter(roomById('study'));
    await tester.pump();
    g.search(nookById('desk'));
    await tester.pump();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(find.textContaining('Dial reads  1'), findsOneWidget);
    expect(g.roomId, 'study');
    g.closePanel();
    await tester.pump();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump();
    expect(g.roomId, 'landing');
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
              child: DialLock(
                combination: const [10, 69, 36],
                onTry: (_) => true,
              ),
            ),
          ),
        ),
      ),
    );
    for (var n = 0; n < 12; n++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    }
    await tester.pump();
    final clicks = [
      for (final (i, clip) in effects.played.indexed)
        if (clip.contains('click')) i,
    ];
    // The tenth notch, and no other.
    expect(clicks, [9]);
    expect(effects.played, hasLength(12));
    // With the voices on there is only the sound: no box says so.
    for (var n = 0; n < 98; n++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    }
    await tester.pump();
    expect(find.text('click'), findsNothing);
    expect(_key('dial-status'), findsNothing);
    // With them off, a box says it for as long as the dial rests there.
    voice.toggleMute();
    await tester.tap(_key('dial-reset'));
    await tester.pump();
    for (var n = 0; n < 10; n++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    }
    await tester.pump();
    expect(find.text('click'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('click'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(find.text('click'), findsNothing);
    voice.toggleMute();

    // Dragging round the dial turns it too.
    await tester.tap(_key('dial-reset'));
    await tester.pump();
    final centre = tester.getCenter(_key('dial'));
    final finger = await tester.startGesture(centre + const Offset(0, -80));
    for (var deg = 3; deg <= 90; deg += 3) {
      final a = deg * pi / 180;
      await finger.moveTo(centre + Offset(80 * sin(a), -80 * cos(a)));
    }
    await finger.up();
    await tester.pump();
    final reading = int.parse(
      RegExp(r'Dial reads\s+(\d+)')
          .firstMatch(
            tester
                .widget<Text>(
                  find.descendant(
                    of: _key('dial-readout'),
                    matching: find.byType(Text),
                  ),
                )
                .data!,
          )!
          .group(1)!,
    );
    expect(reading, inInclusiveRange(15, 25));
  });

  group('the Kernel farm', () {
    tearDown(() => world = senclair);

    testWidgets(
      'is reached from the title screen, with its own files and tune',
      (tester) async {
        final store = MemoryStore();
        final music = SilentAmbience();
        final g = GameState(random: Random(3), store: store);
        await tester.pumpWidget(
          MysteryApp(state: g, voice: Voice(SilentPlayer()), ambience: music),
        );
        expect(find.text('The Senclair Affair'), findsWidgets);
        expect(music.track, 'title.wav');
        expect(_key('world-back'), findsNothing);
        await tester.tap(_key('world-next'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(world, farm);
        expect(find.text('The Candy Corn Caper'), findsWidgets);
        expect(music.track, 'farm.wav');
        expect(find.text('New case'), findsNWidgets(3));
        expect(_key('world-next'), findsNothing);

        // A case on the farm, kept apart from the mansion's files.
        await tester.tap(_key('start'));
        await tester.pump();
        g.beginInvestigation();
        await tester.pump();
        await tester.pump(const Duration(seconds: 24));
        expect(g.roomId, 'porch');
        expect(farm.cases, contains(g.mystery));
        expect(store.slots.keys, [3]);
        expect(find.text('Lolly Popwell'), findsNothing);
        g.enter(roomById('frontroom'));
        await tester.pump();
        expect(find.text('Lolly Popwell'), findsOneWidget);
        g.toTitle();
        await tester.pump();
        expect(find.text('Continue'), findsOneWidget);

        // And back again, where the mansion's files are untouched.
        await tester.tap(_key('world-back'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(world, senclair);
        expect(music.track, 'title.wav');
        expect(find.text('New case'), findsNWidgets(3));
      },
    );

    test('has a shelter by the porch and bedrooms upstairs', () {
      world = farm;
      expect(neighbor(roomById('porch'), Dir.down)?.id, 'rootcellar');
      expect(roomById('rootcellar').name, 'Tornado Shelter');
      expect(topLevel, 3);
      for (final id in ['lollyroom', 'kernelroom']) {
        expect(roomById(id).level, 3);
        expect(nooks.where((n) => n.room == id), isNotEmpty, reason: id);
        for (final c in farm.cases) {
          expect(c.pool.where((e) => e.room == id), isNotEmpty, reason: id);
        }
      }
      expect(neighbor(roomById('frontroom'), Dir.up)?.id, 'kernelroom');
      expect(neighbor(roomById('kernelroom'), Dir.left)?.id, 'lollyroom');
      // The two new tools each open something up there.
      for (final (tool, place) in [
        ('boltcutters', 'suitcase'),
        ('prybar', 'blanketchest'),
      ]) {
        expect(nookById(place).needs, tool);
        expect(items.where((i) => i.id == tool), hasLength(1));
      }
    });

    test('has five suspects, the police, and no rare mystery', () {
      world = farm;
      expect(residents.map((p) => p.id), [
        'lolly',
        'taffy',
        'gus',
        'marsha',
        'licorice',
      ]);
      expect(hasTwist, isFalse);
      final g = GameState(random: Random(1), twistChance: 1)..newGame();
      expect(farm.cases, contains(g.mystery));
      // One or two killers in each, as in the mansion.
      for (final c in farm.cases) {
        expect(c.culprits.length, inInclusiveRange(1, 2));
      }
      expect(farm.cases.map((c) => c.culprits.length).toSet(), {1, 2});
      // Seven mysteries, and each of the five does it twice.
      expect(farm.cases, hasLength(7));
      for (final p in residents) {
        expect(
          farm.cases.where((c) => c.culprits.contains(p.id)),
          hasLength(2),
          reason: p.id,
        );
      }
      // Most of the farm is out of doors.
      expect(
        rooms
            .where(
              (r) =>
                  farm.outdoors.contains(r.id) ||
                  farm.outbuildings.contains(r.id),
            )
            .length,
        greaterThan(rooms.length ~/ 2),
      );
    });

    testWidgets('is solved the same way as the mansion', (tester) async {
      world = farm;
      final g = GameState(random: Random(2));
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      await tester.pump();
      expect(_key('solve'), findsOneWidget);
      g.openPanel(Panel.accuse);
      await tester.pump();
      expect(find.text('Who murdered Farmer Kernel?'), findsOneWidget);
      for (final id in g.mystery.culprits) {
        await tester.tap(_key('accuse-$id'));
      }
      await tester.pump();
      await tester.tap(_key('arrest'));
      await tester.pump();
      expect(g.won, isTrue);
      await tester.pump(const Duration(seconds: 4));
      await tester.tap(_key('cutscene-done'));
      await tester.pump();
      expect(
        find.textContaining('Candy Land can sleep soundly'),
        findsOneWidget,
      );
    });
  });

  group('saving', () {
    test('a game in progress survives being closed and reopened', () {
      final store = MemoryStore();
      final g = GameState(random: Random(3), twistChance: 0, store: store);
      expect(g.restore(), isFalse);
      g.newGame(skipIntro: true);
      g.enter(roomById('boiler'));
      g.take(itemById('shovel'));
      g.closeDialogue();
      final clue = g.evidenceHere.first;
      g.inspect(clue);
      g.closeDialogue();
      final topic = g.topicsFor('barry').first;
      g.ask(personById('barry'), topic);
      g.closeDialogue();
      g.tryCode(nookById('desk'), g.combination.join('-'));
      g.hintsUsed = 2;
      g.closeDialogue();
      expect(store.saved, isNotNull);

      // A fresh program, with a different run of luck, opens the same save.
      final again = GameState(random: Random(99), store: store);
      expect(again.restore(), isTrue);
      expect(again.phase, Phase.playing);
      expect(again.mystery.id, g.mystery.id);
      expect(again.roomId, 'boiler');
      expect(
        [for (final e in again.evidence) e.id],
        [for (final e in g.evidence) e.id],
      );
      expect(again.found, g.found);
      expect(again.visited, g.visited);
      expect(again.items, ['shovel']);
      expect(again.asked, g.asked);
      expect(again.unlocked, {'desk'});
      expect(again.combination, g.combination);
      expect(again.pinOrder, g.pinOrder);
      expect(again.hintsUsed, 2);
      expect(again.itemsHere, isEmpty);
    });

    test('nothing is kept once the case is over', () {
      final store = MemoryStore();
      final g = GameState(random: Random(3), twistChance: 0, store: store)
        ..newGame(skipIntro: true);
      expect(store.saved, isNotNull);
      g
        ..toggleAccused('penny')
        ..makeArrest();
      expect(store.saved, isNull);
    });

    test('a save that no longer makes sense is thrown away', () {
      final store = MemoryStore()..saved = '{"version":1,"case":"nonsense"}';
      final g = GameState(store: store);
      expect(g.restore(), isFalse);
      expect(g.phase, Phase.title);
      expect(store.saved, isNull);
    });

    testWidgets('the rare mystery is saved as itself', (tester) async {
      final store = MemoryStore();
      final g = GameState(store: store)..newGame(twist: true, skipIntro: true);
      g.found.add('tornsheet');
      g.attachSheet();
      final again = GameState(store: store);
      expect(again.restore(), isTrue);
      expect(again.mystery.id, twistCase.id);
      expect(again.sheetAttached, isTrue);
    });

    testWidgets('the menu resets a case, but only when asked twice', (
      tester,
    ) async {
      final store = MemoryStore();
      final g = GameState(random: Random(3), twistChance: 0, store: store);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(skipIntro: true);
      await tester.pump();
      await tester.tap(_key('menu'));
      await tester.pump();
      expect(g.panel, Panel.menu);
      await tester.tap(_key('reset'));
      await tester.pump();
      expect(g.phase, Phase.playing);
      expect(find.textContaining('Really?'), findsOneWidget);
      // Left alone, it goes back to being a button that does nothing rash.
      await tester.pump(const Duration(seconds: 5));
      expect(find.textContaining('Really?'), findsNothing);
      final before = g.mystery.id;
      await tester.tap(_key('reset'));
      await tester.pump();
      await tester.tap(_key('reset'));
      await tester.pump();
      // A different mystery, from its beginning, in the same case file.
      expect(g.phase, Phase.intro);
      expect(g.mystery.id, isNot(before));
      expect(g.slot, 0);
      expect(g.found, isEmpty);
      g.beginInvestigation();
      await tester.pump();
      expect(store.slots.keys, [0]);
      await tester.pump(const Duration(seconds: 24));
    });

    testWidgets('three case files are kept apart on the title screen', (
      tester,
    ) async {
      final store = MemoryStore();
      final g = GameState(random: Random(3), twistChance: 0, store: store);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      expect(find.text('New case'), findsNWidgets(3));

      // A new case in the second file.
      await tester.tap(_key('slot-1'));
      await tester.pump();
      expect(g.phase, Phase.intro);
      g.beginInvestigation();
      await tester.pump();
      await tester.pump(const Duration(seconds: 24));
      final second = g.mystery.id;
      g.enter(roomById('kitchen'));
      await tester.pump();
      expect(store.slots.keys, [1]);

      // The main menu leaves it in its file.
      await tester.tap(_key('menu'));
      await tester.pump();
      await tester.tap(_key('to-title'));
      await tester.pump();
      expect(g.phase, Phase.title);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.textContaining('Kitchen'), findsOneWidget);

      // Another in the third, and then back to the second where it was.
      await tester.tap(_key('slot-2'));
      await tester.pump();
      g.beginInvestigation();
      await tester.pump();
      await tester.pump(const Duration(seconds: 24));
      expect(g.mystery.id, isNot(second));
      g.toTitle();
      await tester.pump();
      expect(find.text('Continue'), findsNWidgets(2));
      await tester.tap(_key('slot-1'));
      await tester.pump();
      expect(g.phase, Phase.playing);
      expect(g.mystery.id, second);
      expect(g.roomId, 'kitchen');
    });

    testWidgets('settings are changed in the menu and remembered', (
      tester,
    ) async {
      final store = MemoryStore();
      final settings = Settings(store);
      final voice = Voice(SilentPlayer());
      final g = GameState(random: Random(3), twistChance: 0, store: store);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: voice, settings: settings),
      );
      g.newGame(skipIntro: true);
      await tester.pump();
      await tester.tap(_key('menu'));
      await tester.pump();
      // The title music is not offered here, only on the title screen.
      expect(_key('setting-music'), findsNothing);
      await tester.tap(_key('setting-voices'));
      await tester.pump();
      expect(voice.muted, isTrue);
      await tester.tap(_key('setting-haptics'));
      await tester.tap(_key('text-size-3'));
      await tester.pump();
      expect(settings.textScale, greaterThan(1.3));
      // There is no loudspeaker button any more: it is all in here.
      expect(_key('mute'), findsNothing);
      await tester.tap(_key('setting-voices'));
      await tester.pump();
      expect(voice.muted, isFalse);
      g.closePanel();
      await tester.pump();

      final again = Settings(store);
      expect(again.voices, isTrue);
      expect(again.haptics, isFalse);
      expect(again.textSize, 3);

      // Big text still fits the dialogue box.
      g.talkTo(personById('penny'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('the settings can be reached while Watsonut is talking', (
      tester,
    ) async {
      final settings = Settings();
      final g = GameState(random: Random(3), twistChance: 0);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer()), settings: settings),
      );
      g.newGame(caseIndex: 0);
      g.beginInvestigation();
      await tester.pump();
      await tester.pump();
      expect(find.text(arrivalGreeting(touch: true)), findsOneWidget);
      // Everything else is still held.
      await tester.tap(_key('notebook'), warnIfMissed: false);
      await tester.pump();
      expect(g.panel, Panel.none);
      await tester.tap(_key('menu-early'));
      await tester.pump();
      expect(g.panel, Panel.menu);
      await tester.tap(_key('setting-voices'));
      await tester.pump();
      expect(settings.voices, isFalse);
      await tester.tap(_key('close-panel'));
      await tester.pump();
      expect(g.panel, Panel.none);
      await tester.pump(const Duration(seconds: 24));
    });

    testWidgets('the settings can be opened from the title screen', (
      tester,
    ) async {
      final settings = Settings();
      final music = SilentAmbience();
      final g = GameState();
      await tester.pumpWidget(
        MysteryApp(
          state: g,
          voice: Voice(SilentPlayer()),
          settings: settings,
          ambience: music,
        ),
      );
      await tester.tap(_key('title-settings'));
      await tester.pump();
      await tester.tap(_key('setting-haptics'));
      await tester.pump();
      expect(settings.haptics, isFalse);
      await tester.tap(_key('setting-music'));
      await tester.pump();
      expect(music.musicMuted, isTrue);
      // Only the settings: there is no case here to leave or reset.
      expect(_key('to-title'), findsNothing);
      expect(_key('reset'), findsNothing);
      await tester.tap(_key('close-panel'));
      await tester.pump();
      expect(_key('setting-haptics'), findsNothing);
      expect(g.phase, Phase.title);
    });

    testWidgets('a case file can be reset from the title screen', (
      tester,
    ) async {
      final store = MemoryStore();
      final g = GameState(random: Random(3), twistChance: 0, store: store);
      g.slot = 1;
      g.newGame(skipIntro: true);
      g.toTitle();
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      expect(find.text('Continue'), findsOneWidget);
      // There is nothing to reset in an empty file.
      await tester.tap(_key('erase-0'), warnIfMissed: false);
      await tester.pump();
      expect(find.textContaining('Really?'), findsNothing);
      // It asks twice, like the one in the game.
      await tester.tap(_key('erase-1'));
      await tester.pump();
      expect(store.slots, isNotEmpty);
      expect(find.textContaining('Really?'), findsOneWidget);
      await tester.tap(_key('erase-1'));
      await tester.pump();
      expect(store.slots, isEmpty);
      expect(find.text('New case'), findsNWidgets(3));
      expect(g.phase, Phase.title);
    });

    testWidgets('the voices and the haptics are switched off separately', (
      tester,
    ) async {
      final rain = SilentAmbience();
      final voice = Voice(SilentPlayer());
      final settings = Settings();
      await tester.pumpWidget(
        MysteryApp(
          state: GameState(),
          voice: voice,
          settings: settings,
          ambience: rain,
        ),
      );
      expect(rain.muted, isFalse);
      settings.update((s) => s.haptics = false);
      expect(rain.muted, isTrue);
      expect(voice.muted, isFalse);
      settings.update((s) => s.haptics = true);
      settings.update((s) => s.voices = false);
      expect(voice.muted, isTrue);
      expect(rain.muted, isFalse);
    });

    testWidgets('thunder follows the lightning by a few seconds', (
      tester,
    ) async {
      final storm = SilentAmbience();
      final g = GameState(random: Random(3), twistChance: 0);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer()), ambience: storm),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      await tester.pump();
      expect(storm.rumbles, 0);
      // Within a minute there has been a strike, and its thunder.
      await tester.pump(const Duration(seconds: 61));
      await tester.pump(const Duration(seconds: 5));
      expect(storm.rumbles, greaterThan(0));
      // And in the opening scene, after each flash.
      final arrival = SilentAmbience();
      final g2 = GameState(random: Random(3), twistChance: 0);
      await tester.pumpWidget(
        MysteryApp(
          key: UniqueKey(),
          state: g2,
          voice: Voice(SilentPlayer()),
          ambience: arrival,
        ),
      );
      g2.newGame(caseIndex: 0);
      await tester.pump();
      // Never sooner than the first flash and its four fifths of a second.
      await tester.pump(const Duration(milliseconds: 1800));
      expect(arrival.rumbles, 0);
      await tester.pump(const Duration(seconds: 6));
      await tester.pump();
      expect(arrival.rumbles, 1);
    });

    testWidgets('the lamps sputter below, and the animals speak up', (
      tester,
    ) async {
      final house = SilentAmbience();
      final g = GameState(random: Random(3), twistChance: 0);
      // Watsonut is kept quiet, so that only the people spoken to here talk.
      final settings = Settings()..update((s) => s.remarks = false);
      await tester.pumpWidget(
        MysteryApp(
          state: g,
          voice: Voice(SilentPlayer()),
          settings: settings,
          ambience: house,
        ),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      await tester.pump();
      // Purrfait, in the hall: never sooner than ten seconds, and about
      // half the time out of a chance every ten to fifteen.
      await tester.pump(const Duration(seconds: 9));
      expect(house.creatures, isEmpty);
      await tester.pump(const Duration(minutes: 5));
      expect(house.creatures, isNotEmpty);
      expect(house.creatures.length, lessThan(30));
      // Never while somebody is talking, however long they go on.
      house.creatures.clear();
      g.talkTo(personById('sprinkles'));
      await tester.pump(const Duration(minutes: 5));
      expect(house.creatures, isEmpty);
      g.closeDialogue();
      await tester.pump(const Duration(minutes: 5));
      expect(house.creatures, isNotEmpty);
      // Pupcake, in the yard.
      house.creatures.clear();
      g.enter(roomById('backyard'));
      await tester.pump(const Duration(minutes: 5));
      expect(house.creatures.toSet(), {'bark'});
      // Neither of them anywhere else; but down below, the lamps.
      house.creatures.clear();
      g.enter(roomById('cellar'));
      expect(house.weather!.volume, 0);
      expect(house.weather!.hum, greaterThan(0));
      await tester.pump(const Duration(minutes: 2));
      expect(house.creatures, isEmpty);
      expect(house.flickers, greaterThan(0));
    });

    testWidgets('the rain sounds different from room to room', (tester) async {
      final rain = SilentAmbience();
      final g = GameState(random: Random(3), twistChance: 0);
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer()), ambience: rain),
      );
      // On the title screen there is no rain, only the music, whether or
      // not a case has just been left.
      expect(rain.weather, Weather.none);
      expect(rain.music, isTrue);
      g.newGame(caseIndex: 0, skipIntro: true);
      expect(rain.weather, Weather.indoors);
      expect(rain.music, isFalse);
      g.toTitle();
      expect(rain.weather, Weather.none);
      expect(rain.music, isTrue);
      // The music gives way to the storm as the opening scene begins.
      g.newGame(caseIndex: 0);
      expect(rain.weather, Weather.outside);
      expect(rain.music, isFalse);
      g.beginInvestigation();
      expect(rain.weather, Weather.indoors);
      g.enter(roomById('cellar'));
      expect(rain.weather, Weather.basement);
      g.enter(roomById('study'));
      expect(rain.weather, Weather.attic);
      g.enter(roomById('backyard'));
      expect(rain.weather, Weather.outside);
      // It stops for a case well solved, and not otherwise.
      g
        ..toggleAccused('cannoli')
        ..makeArrest();
      expect(rain.weather, Weather.none);
      await tester.pump();
    });
  });

  testWidgets('the map in the corner goes straight to a room already seen', (
    tester,
  ) async {
    final g = GameState(random: Random(2));
    await tester.pumpWidget(MysteryApp(state: g, voice: Voice(SilentPlayer())));
    g.newGame(caseIndex: 0, skipIntro: true);
    g.enter(roomById('kitchen'));
    g.enter(roomById('entrance'));
    await tester.pump();
    await tester.tap(_key('map'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(g.panel, Panel.map);
    // Penny, in the kitchen, has not been spoken to yet.
    expect(_key('talk-kitchen'), findsOneWidget);
    expect(_key('talk-entrance'), findsNothing);
    // M shuts the map, and opens it again.
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump();
    expect(g.panel, Panel.none);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(g.panel, Panel.map);
    // The kitchen has been seen and has things left in it; the study has
    // not been seen at all.
    expect(_key('unexplored-kitchen'), findsOneWidget);
    expect(find.text('Kitchen'), findsOneWidget);
    expect(find.text("Mrs. Senclair's Study"), findsNothing);
    await tester.tap(_key('map-study'));
    await tester.pump();
    expect(g.panel, Panel.map);
    // Off to the kitchen, by way of a loading screen.
    await tester.tap(_key('map-kitchen'));
    await tester.pump();
    expect(_key('loading'), findsOneWidget);
    expect(find.textContaining('On the way to the Kitchen'), findsOneWidget);
    expect(g.roomId, 'entrance');
    await tester.pump(const Duration(milliseconds: 1400));
    expect(g.roomId, 'kitchen');
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pump();
    expect(_key('loading'), findsNothing);
    expect(g.panel, Panel.none);

    // The speech bubble goes once everything she has to say is heard.
    expect(g.someoneToHear(roomById('kitchen')), isTrue);
    final penny = personById('penny');
    for (var before = -1; before != g.asked.length;) {
      before = g.asked.length;
      for (final topic in g.topicsFor('penny')) {
        g.ask(penny, topic);
      }
    }
    g.closeDialogue();
    expect(g.someoneToHear(roomById('kitchen')), isFalse);

    // The question mark goes when there is nothing left to find there.
    final kitchen = roomById('kitchen');
    expect(g.unexplored(kitchen), isTrue);
    g.found.addAll(
      g.evidence.where((e) => e.room == 'kitchen').map((e) => e.id),
    );
    g.unlocked.addAll(nooks.where((n) => n.room == 'kitchen').map((n) => n.id));
    g.taken.addAll(items.where((i) => i.room == 'kitchen').map((i) => i.id));
    expect(g.unexplored(kitchen), isFalse);
  });

  testWidgets('they go out to the yard and back by the door', (tester) async {
    final g = GameState(random: Random(2));
    await tester.pumpWidget(MysteryApp(state: g, voice: Voice(SilentPlayer())));
    g.newGame(caseIndex: 0, skipIntro: true);
    g.enter(roomById('kitchen'));
    await tester.pump();
    // The arrow sits on the door, in both rooms.
    final kitchenDoor = doorOf('kitchen', Dir.left)!;
    final scale = tester.getSize(find.byType(MaterialApp)).width / sceneW;
    Offset inScene(Finder f) => tester.getCenter(f) / scale;
    expect(kitchenDoor.inflate(8).contains(inScene(_key('go-left'))), isTrue);
    await tester.tap(_key('go-left'));
    await tester.pump();
    // Partway there the door is opening, and Churlock is making for it.
    await tester.pump(const Duration(milliseconds: 1300));
    expect(
      find.byWidgetPredicate(
        (w) => w is CustomPaint && '${w.painter}'.contains('_DoorPainter'),
      ),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pump();
    expect(g.roomId, 'backyard');
    final yardDoor = doorOf('backyard', Dir.right)!;
    expect(yardDoor.inflate(8).contains(inScene(_key('go-right'))), isTrue);
    await tester.tap(_key('go-right'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump();
    expect(g.roomId, 'kitchen');
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

      // The list of suspects is torn, with a scroll bar that scrolls
      // nothing, and there is nobody extra to accuse yet.
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
      expect(g.tryCode(desk, g.combination.join('-')), isTrue);
      g.search(desk);
      await tester.pump();
      // The strip is not on show: it is behind the loose lining.
      expect(_key('evidence-planner'), findsOneWidget);
      expect(_key('evidence-tornsheet'), findsNothing);
      await tester.tap(_key('loose-corner'));
      await tester.pump();
      expect(_key('hidden-jewels'), findsNothing);
      expect(g.found, isNot(contains('tornsheet')));
      await tester.tap(_key('evidence-tornsheet'));
      await tester.pump();
      expect(g.found, contains('tornsheet'));
      g.closeDialogue();
      g.closePanel();
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

    testWidgets('elsewhere the compartment holds only jewellery', (
      tester,
    ) async {
      final g = GameState(random: Random(4));
      await tester.pumpWidget(
        MysteryApp(state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(caseIndex: 0, skipIntro: true);
      final desk = nookById('desk');
      g.tryCode(desk, g.combination.join('-'));
      g.search(desk);
      await tester.pump();
      await tester.tap(_key('loose-corner'));
      await tester.pump();
      expect(_key('evidence-tornsheet'), findsNothing);
      await tester.tap(_key('hidden-jewels'));
      await tester.pump();
      expect(g.dialogue!.text, looseCorner.text);
      g.closeDialogue();
      g.closePanel();

      // And nobody has torn the list of suspects.
      g.openPanel(Panel.accuse);
      await tester.pump();
      expect(_key('list-whole'), findsOneWidget);
      expect(_key('list-torn'), findsNothing);
      expect(_key('idle-scrollbar'), findsNothing);
      expect(_key('attach-sheet'), findsNothing);
    });

    test('the dial has a new combination every game', () {
      final g = GameState(random: Random(9), twistChance: 0);
      final seen = <String>{};
      for (var i = 0; i < 30; i++) {
        g.newGame();
        expect(g.combination, hasLength(3));
        expect(g.combination.every((n) => n >= 0 && n < 100), isTrue);
        seen.add(g.combination.join('-'));
      }
      expect(seen.length, greaterThan(25));
    });

    test(
      'the butler mentions the compartment when asked about the initials',
      () {
        final g = GameState()..newGame(twist: true, skipIntro: true);
        bool offered() => g.topicsFor('graham').any((t) => t.id == 'initials');
        expect(offered(), isFalse);
        g.found.add(
          g.evidence.firstWhere((e) => e.id == 'wwnote' || e.id == 'wwbill').id,
        );
        expect(offered(), isTrue);
        final topic = g
            .topicsFor('graham')
            .firstWhere((t) => t.id == 'initials');
        expect(topic.answer, contains('behind the lining'));
        for (final c in allCases) {
          for (final t in c.topics.values.expand((l) => l)) {
            expect(t.answer, isNot(contains('lining')));
          }
        }
      },
    );

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
    expect(find.text(arrivalGreeting(touch: true)), findsOneWidget);
    await tester.tap(_key('notebook'), warnIfMissed: false);
    await tester.tap(_key('go-down'), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 1));
    expect(g.panel, Panel.none);
    expect(g.roomId, 'entrance');
    expect(find.text(arrivalGreeting(touch: true)), findsOneWidget);
    await tester.pump(const Duration(seconds: 24));
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

    // The desk has a dial, turned with the arrow keys: right, left, right.
    // Turning back sets a number, and reaching the last one opens it.
    final desk = nookById('desk');
    g.search(desk);
    await tester.pump();
    Future<void> turn(bool right, int notches) async {
      for (var n = 0; n < notches; n++) {
        await tester.sendKeyEvent(
          right ? LogicalKeyboardKey.arrowRight : LogicalKeyboardKey.arrowLeft,
        );
      }
      await tester.pump(const Duration(milliseconds: 200));
    }

    // It will not turn left to begin with.
    await turn(false, 3);
    expect(find.textContaining('Dial reads  0'), findsOneWidget);
    expect(find.text('RIGHT'), findsOneWidget);
    // Turning back well past the number drops the tumblers.
    final [first, second, third] = g.combination;
    await turn(true, first + 3);
    await turn(false, 1);
    expect(find.textContaining('did not catch'), findsOneWidget);
    expect(find.textContaining('Dial reads  0'), findsOneWidget);
    // The right numbers, with the reset button tried on the way.
    await turn(true, first);
    await tester.tap(_key('dial-reset'));
    await tester.pump();
    expect(find.textContaining('Dial reads  0'), findsOneWidget);
    // A notch or two past the click is forgiven, and set as the number.
    await turn(true, first + 2);
    await turn(false, (first - second) % 100);
    expect(find.text('LEFT'), findsOneWidget);
    expect(find.textContaining('Set so far  $first  '), findsOneWidget);
    expect(g.isOpen(desk), isFalse);
    await turn(true, (third - second) % 100);
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
      // Each tool is used up by what it opens, and what it opened stays so.
      expect(g.items, isEmpty);
      for (final item in items) {
        expect(_key('held-${item.id}'), findsNothing);
      }
      for (final n in [dirt, box, kennel]) {
        expect(g.isOpen(n), isTrue);
      }
      g.enter(roomById('boiler'));
      await tester.pump();
      expect(_key('item-shovel'), findsNothing);
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
      expect(find.text(arrivalGreeting(touch: true)), findsOneWidget);
      await tester.pump(const Duration(seconds: 24));
      expect(_key('watsonut-remark'), findsNothing);
      // Prodding him afterwards gets a remark, not the explanation again.
      await tester.tap(_key('watsonut'));
      await tester.pump();
      expect(find.text(arrivalGreeting(touch: true)), findsNothing);
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

  testWidgets('no arrow sits on top of anything else that can be clicked', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(960, 540);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final clashes = <String>[];
    addTearDown(() => world = senclair);
    for (final (w, mystery) in [
      for (final w in worlds)
        for (final m in [...w.cases, ?w.twist]) (w, m),
    ]) {
      world = w;
      final g = GameState(random: Random(1));
      await tester.pumpWidget(
        MysteryApp(key: UniqueKey(), state: g, voice: Voice(SilentPlayer())),
      );
      g.newGame(
        caseIndex: mystery == w.twist ? null : w.cases.indexOf(mystery),
        twist: mystery == w.twist,
        skipIntro: true,
      );
      // Every possible clue at once, wherever it might be lying.
      g.evidence = mystery.pool.toList();
      for (final room in rooms) {
        g.enter(room);
        await tester.pump();
        // Only the round button itself: the name under it may run on.
        final arrows = {
          for (final d in Dir.values)
            if (_key('go-${d.name}').evaluate().isNotEmpty)
              d: tester
                  .getRect(
                    find.descendant(
                      of: _key('go-${d.name}'),
                      matching: find.byType(Icon),
                    ),
                  )
                  .inflate(11),
        };
        final things = {
          for (final e in g.evidenceHere)
            e.id: Rect.fromCircle(center: evidencePos(e), radius: 22),
          for (final n in g.nooksHere)
            n.id: Rect.fromCircle(center: n.pos, radius: 20),
          for (final i in g.itemsHere)
            i.id: Rect.fromCircle(center: i.pos, radius: 22),
        };
        // The name under each arrow, and under each piece of furniture,
        // at about the width it has in the real font.
        double wide(String text) => text.length * 5.8 + 12;
        final names = <String, Rect>{
          for (final arrow in arrows.entries)
            if (neighbor(room, arrow.key) case final Room next)
              if (doorOf(room.id, arrow.key) == null)
                '${arrow.key.name} name': switch (arrow.key) {
                  Dir.left => Rect.fromLTWH(
                    arrow.value.left,
                    arrow.value.bottom,
                    wide(next.name),
                    18,
                  ),
                  Dir.right => Rect.fromLTWH(
                    arrow.value.right - wide(next.name),
                    arrow.value.bottom,
                    wide(next.name),
                    18,
                  ),
                  _ => Rect.fromCenter(
                    center: arrow.value.bottomCenter.translate(0, 9),
                    width: wide(next.name),
                    height: 18,
                  ),
                },
        };
        final labelled = {
          ...things,
          for (final n in g.nooksHere)
            '${n.id} name': Rect.fromCenter(
              center: n.pos.translate(0, 32),
              width: wide(n.name),
              height: 16,
            ),
        };
        for (final arrow in {
          ...arrows.map((d, r) => MapEntry(d.name, r)),
          ...names,
        }.entries) {
          for (final thing in labelled.entries) {
            if (arrow.value.overlaps(thing.value)) {
              clashes.add('${room.id}: ${arrow.key} over ${thing.key}');
            }
          }
        }
      }
    }
    expect(clashes.toSet(), isEmpty);
  });

  testWidgets('every room lays out without errors', (tester) async {
    addTearDown(() => world = senclair);
    for (final (w, i) in [
      for (final w in worlds)
        for (var i = 0; i < w.cases.length; i++) (w, i),
    ]) {
      world = w;
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
          expect(g.tryCode(n, g.combination.join('-')), isTrue);
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
      await tester.pump(const Duration(seconds: 24));
      g.showVerdict();
      await tester.pump();
      expect(find.text('THE KILLER STRIKES AGAIN'), findsOneWidget);
    }
  });
}
