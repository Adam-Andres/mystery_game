import 'package:flutter/material.dart';

import 'audio/lines.dart';
import 'audio/voice.dart';
import 'data/house.dart';
import 'game_state.dart';
import 'screens/cutscene.dart';
import 'screens/ending_screen.dart';
import 'screens/game_screen.dart';
import 'screens/title_screen.dart';

void main() => runApp(const MysteryApp());

class MysteryApp extends StatefulWidget {
  const MysteryApp({super.key, this.state, this.voice});

  /// Lets tests supply a game with a known case.
  final GameState? state;

  /// Lets tests run without sound.
  final Voice? voice;

  @override
  State<MysteryApp> createState() => _MysteryAppState();
}

class _MysteryAppState extends State<MysteryApp> {
  late final GameState g = widget.state ?? GameState();
  late final Voice voice = widget.voice ?? Voice();
  Dialogue? _spoken;

  @override
  void initState() {
    super.initState();
    g.addListener(_speakDialogue);
  }

  @override
  void dispose() {
    g.removeListener(_speakDialogue);
    voice.stop();
    super.dispose();
  }

  /// Voices each new line of dialogue in its speaker's own voice.
  void _speakDialogue() {
    final d = g.dialogue;
    if (identical(d, _spoken)) return;
    _spoken = d;
    if (d == null) {
      voice.release(this);
    } else {
      voice.say((voice: d.speaker.id, text: d.text), owner: this);
    }
  }

  Widget _screen() {
    switch (g.phase) {
      case Phase.title:
        return TitleScreen(onStart: g.newGame);
      case Phase.intro:
        return Cutscene(
          kind: CutsceneKind.arrival,
          lines: introLines,
          voice: voice,
          doneLabel: 'Enter the mansion',
          onDone: g.beginInvestigation,
        );
      case Phase.playing:
        return GameScreen(g, voice: voice);
      case Phase.outro:
        final (kind, lines) = g.won
            ? (CutsceneKind.solved, winLines)
            : g.nextVictim != null
                ? (CutsceneKind.struckAgain, loseAgainLines)
                : (CutsceneKind.halfBaked, loseHalfLines);
        return Cutscene(
          kind: kind,
          lines: lines,
          voice: voice,
          prisoners: [for (final id in g.accused) personById(id)],
          doneLabel: 'See the verdict',
          onDone: g.showVerdict,
        );
      case Phase.ended:
        return EndingScreen(g, voice: voice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Senclair Affair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: Colors.black,
        // The whole game is laid out on a fixed 960x540 stage and scaled to fit.
        body: SizedBox.expand(
          child: FittedBox(
            child: SizedBox(
              width: sceneW,
              height: sceneH,
              child: ClipRect(
                child: ListenableBuilder(
                  listenable: g,
                  builder: (context, _) => KeyedSubtree(
                    key: ValueKey(g.phase),
                    child: _screen(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
