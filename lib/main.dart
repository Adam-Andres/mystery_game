import 'package:flutter/material.dart';

import 'data/house.dart';
import 'game_state.dart';
import 'screens/ending_screen.dart';
import 'screens/game_screen.dart';
import 'screens/title_screen.dart';

void main() => runApp(const MysteryApp());

class MysteryApp extends StatefulWidget {
  const MysteryApp({super.key, this.state});

  /// Lets tests supply a game with a known case.
  final GameState? state;

  @override
  State<MysteryApp> createState() => _MysteryAppState();
}

class _MysteryAppState extends State<MysteryApp> {
  late final GameState g = widget.state ?? GameState();

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
                  builder: (context, _) => switch (g.phase) {
                    Phase.title => TitleScreen(onStart: g.newGame),
                    Phase.playing => GameScreen(g),
                    Phase.ended => EndingScreen(g),
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
