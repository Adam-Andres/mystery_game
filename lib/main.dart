import 'package:flutter/material.dart';

import 'audio/lines.dart';
import 'audio/ambience.dart';
import 'audio/voice.dart';
import 'data/house.dart';
import 'data/models.dart';
import 'game_state.dart';
import 'save.dart';
import 'settings.dart';
import 'screens/cutscene.dart';
import 'screens/ending_screen.dart';
import 'screens/game_screen.dart';
import 'screens/title_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await DeviceStore.open();
  runApp(
    MysteryApp(
      state: GameState(store: store),
      settings: Settings(store),
    ),
  );
}

class MysteryApp extends StatefulWidget {
  const MysteryApp({
    super.key,
    this.state,
    this.voice,
    this.settings,
    this.ambience,
  });

  /// Lets tests supply a game with a known case.
  final GameState? state;

  /// Lets tests run without sound.
  final Voice? voice;

  final Settings? settings;

  /// The rain. Tests have none unless they bring their own.
  final Ambience? ambience;

  @override
  State<MysteryApp> createState() => _MysteryAppState();
}

class _MysteryAppState extends State<MysteryApp> {
  late final GameState g = widget.state ?? GameState();
  late final Voice voice = widget.voice ?? Voice();
  late final Settings settings = widget.settings ?? Settings();
  late final Ambience ambience =
      widget.ambience ??
      (widget.voice == null ? createAmbience() : SilentAmbience());
  Dialogue? _spoken;

  @override
  void initState() {
    super.initState();
    g.addListener(_speakDialogue);
    g.addListener(_setWeather);
    settings.addListener(_applySettings);
    // The loudspeaker button on screen and the setting are one and the same.
    voice.addListener(_noteMute);
    _applySettings();
    _setWeather();
  }

  void _noteMute() {
    if (settings.voices == voice.muted) {
      settings.update((s) => s.voices = !voice.muted);
    }
  }

  /// The settings that are about sound take effect at once.
  void _applySettings() {
    if (voice.muted == settings.voices) voice.toggleMute();
    // The voices and the sounds of the house are switched off separately.
    ambience.setMuted(!settings.haptics);
    ambience.setMusicMuted(!settings.music);
  }

  /// The rain is loud outside, drums on the attic roof, and is all but
  /// gone in the basement. It stops for a case well solved.
  void _setWeather() {
    ambience.set(switch (g.phase) {
      Phase.playing => switch (g.room) {
        final r when world.outdoors.contains(r.id) => Weather.outside,
        // Rain on a tin roof.
        final r when world.outbuildings.contains(r.id) => Weather.attic,
        Room(level: 0) => Weather.basement,
        final r when r.level == world.atticLevel => Weather.attic,
        _ => Weather.indoors,
      },
      Phase.outro || Phase.ended => g.won ? Weather.none : Weather.outside,
      // It is quiet on the title screen, and pours as he arrives.
      Phase.title => Weather.none,
      _ => Weather.outside,
    });
    // The title screen has its music, which fades as the story begins.
    ambience.setTrack(world.music);
    ambience.setMusic(g.phase == Phase.title);
  }

  @override
  void dispose() {
    g.removeListener(_speakDialogue);
    g.removeListener(_setWeather);
    settings.removeListener(_applySettings);
    voice.removeListener(_noteMute);
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
      voice.say((voice: d.voice ?? d.speaker.id, text: d.text), owner: this);
    }
  }

  Widget _screen() {
    switch (g.phase) {
      case Phase.title:
        return TitleScreen(g);
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
        body: SettingsScope(
          settings: settings,
          child: AmbienceScope(
            ambience: ambience,
            child: Listener(
              // A browser plays nothing until the page has been touched.
              onPointerDown: (_) => ambience.wake(),
              child: VoiceScope(
                voice: voice,
                child: SizedBox.expand(
                  child: FittedBox(
                    child: SizedBox(
                      width: sceneW,
                      height: sceneH,
                      child: ClipRect(
                        child: ListenableBuilder(
                          listenable: g,
                          builder: (context, _) => AnimatedSwitcher(
                            // The title fades to black, and the opening
                            // scene comes up out of it. Everything else
                            // cuts.
                            duration: g.phase == Phase.intro
                                ? const Duration(milliseconds: 2600)
                                : Duration.zero,
                            switchInCurve: const Interval(.55, 1),
                            switchOutCurve: const Interval(.55, 1),
                            child: KeyedSubtree(
                              key: ValueKey(g.phase),
                              child: _screen(),
                            ),
                          ),
                        ),
                      ),
                    ),
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
