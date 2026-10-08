import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../audio/lines.dart';
import '../audio/voice.dart';
import '../data/house.dart';
import '../data/models.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/exterior_painter.dart';
import '../widgets/ui.dart';

enum CutsceneKind {
  /// Churlock drives up through the storm and walks to the door.
  arrival,

  /// The right culprits are driven away at dawn.
  solved,

  /// The wrong dessert is driven away, and a killer watches from the tower.
  struckAgain,

  /// The killer is caught, but an innocent goes with them.
  halfBaked,
}

/// A narrated scene outside the mansion. The narration is spoken line by line
/// with subtitles; the player may skip at any time.
class Cutscene extends StatefulWidget {
  const Cutscene({
    super.key,
    required this.kind,
    required this.lines,
    required this.voice,
    required this.onDone,
    required this.doneLabel,
    this.prisoners = const [],
  });

  final CutsceneKind kind;
  final List<VoiceLine> lines;
  final Voice voice;
  final VoidCallback onDone;
  final String doneLabel;

  /// Who is riding in the police wagon.
  final List<Person> prisoners;

  @override
  State<Cutscene> createState() => _CutsceneState();
}

class _CutsceneState extends State<Cutscene> with TickerProviderStateMixin {
  late final AnimationController _scene = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  )..forward();
  late final AnimationController _rain = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  static const double _lift = 84;

  int _line = 0;
  bool _finished = false;
  bool _disposed = false;
  Timer? _timer;
  Completer<void>? _pause;

  bool get _arrival => widget.kind == CutsceneKind.arrival;
  bool get _gloomy => widget.kind != CutsceneKind.solved;

  @override
  void initState() {
    super.initState();
    _narrate();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    if (!(_pause?.isCompleted ?? true)) _pause!.complete();
    widget.voice.release(this);
    _scene.dispose();
    _rain.dispose();
    super.dispose();
  }

  /// Speaks each line in turn. Every line also stays up for a reading-speed
  /// minimum, so the scene still paces itself with the sound off.
  Future<void> _narrate() async {
    for (var i = 0; i < widget.lines.length; i++) {
      if (_disposed) return;
      setState(() => _line = i);
      final line = widget.lines[i];
      await Future.wait([
        widget.voice.say(line, owner: this),
        _wait(Duration(milliseconds: 700 + line.text.length * 60)),
      ]);
    }
    if (!_disposed) setState(() => _finished = true);
  }

  Future<void> _wait(Duration d) {
    final pause = Completer<void>();
    _pause = pause;
    _timer = Timer(d, () {
      if (!pause.isCompleted) pause.complete();
    });
    return pause.future;
  }

  /// 0..1 progress of [t] through the window [from]..[to].
  static double _span(double t, double from, double to) =>
      ((t - from) / (to - from)).clamp(0.0, 1.0);

  /// A brief double flicker of lightning around each strike time.
  double _flash(double t) {
    if (!_gloomy) return 0;
    final strikes = _arrival ? const [.09, .46, .8] : const [.2, .58];
    var flash = 0.0;
    for (final s in strikes) {
      final d = (t - s) * 22;
      if (d >= 0 && d < .5) flash = max(flash, d < .08 || (d > .16 && d < .22) ? 1 : .25 * (1 - d * 2));
    }
    return flash;
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.lines[_line];
    final speaker = line.voice == narrator ? 'Narrator' : personById(line.voice).name;
    return Stack(
      children: [
        // The stage sits high in the frame so the lane clears the subtitles.
        Positioned.fill(
          child: ColoredBox(
            color: _gloomy ? const Color(0xFF22231C) : const Color(0xFF45603A),
          ),
        ),
        Positioned(
          left: 0,
          top: -_lift,
          width: sceneW,
          height: sceneH,
          child: AnimatedBuilder(
            animation: Listenable.merge([_scene, _rain]),
            builder: (context, _) => _stage(_scene.value),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 12,
          child: Plaque(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(speaker, style: kHeading.copyWith(fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(line.text, style: kBody),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                MuteButton(widget.voice),
                const SizedBox(width: 6),
                GoldButton(
                  key: const ValueKey('cutscene-done'),
                  label: _finished ? widget.doneLabel : 'Skip',
                  icon: _finished ? Icons.arrow_forward : Icons.skip_next,
                  onPressed: widget.onDone,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stage(double t) {
    final lurking = widget.kind == CutsceneKind.struckAgain ? _span(t, .5, .62) : 0.0;
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: ExteriorPainter(gloomy: _gloomy, time: t, lurker: lurking),
          ),
        ),
        if (_arrival) ..._arrivalActors(t) else ..._departureActors(t),
        if (_gloomy)
          Positioned.fill(
            child: CustomPaint(
              painter: RainPainter(
                cycle: _rain.value,
                flash: _flash(t),
                heavy: widget.kind == CutsceneKind.struckAgain,
              ),
            ),
          ),
      ],
    );
  }

  Widget _car(double x, {required double roll, required bool lights}) {
    return Positioned(
      left: x,
      top: 398,
      child: CustomPaint(
        size: const Size(220, 112),
        painter: CarPainter(roll: roll, lights: lights),
      ),
    );
  }

  /// Churlock, drawn with his feet at [feet] and shrunk by [scale].
  Widget _detective(Offset feet, {double scale = 1, double sway = 0, double opacity = 1}) {
    const width = 92.0;
    return Positioned(
      left: feet.dx - width / 2,
      top: feet.dy - width * 1.3,
      child: Opacity(
        opacity: opacity,
        child: Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..rotateZ(sway)
            ..scaleByDouble(scale, scale, 1, 1),
          child: const DessertFigure(Dessert.churro, width: width),
        ),
      ),
    );
  }

  List<Widget> _arrivalActors(double t) {
    // The car pulls up, he climbs out, then waddles up the path to the door.
    final drive = Curves.easeOutCubic.transform(_span(t, 0, .2));
    final carX = -260 + 350 * drive;
    final walk = Curves.easeInOut.transform(_span(t, .3, .72));
    final step = t * 2 * pi * 34;
    final walking = walk > 0 && walk < 1;
    final feet = Offset.lerp(const Offset(350, 506), const Offset(681, 404), walk)!;
    return [
      _car(carX, roll: drive * 22, lights: true),
      if (t > .25)
        _detective(
          feet.translate(0, walking ? -sin(step).abs() * 5 : 0),
          scale: 1 - .5 * walk,
          sway: walking ? sin(step) * .08 : 0,
          // He steps out of the car, and at the end goes in through the door.
          opacity: _span(t, .25, .29) * (1 - _span(t, .74, .8)),
        ),
    ];
  }

  List<Widget> _departureActors(double t) {
    // The wagon waits by the path, then drives off down the lane.
    final drive = Curves.easeInCubic.transform(_span(t, .16, .6));
    final wagonX = 520 + 520 * drive;
    final happy = widget.kind == CutsceneKind.solved;
    final hop = happy ? -sin(t * 2 * pi * 12).abs() * 6 : 0.0;
    return [
      _car(90, roll: 0, lights: false),
      _detective(Offset(370, 506 + hop), sway: happy ? 0 : -.1),
      Positioned(
        left: wagonX,
        top: 384,
        child: SizedBox(
          width: 250,
          height: 130,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: WagonPainter(roll: drive * 26, blink: (t * 40).floor().isEven),
                ),
              ),
              Positioned.fromRect(
                rect: WagonPainter.window,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final p in widget.prisoners)
                      DessertFigure(p.dessert, width: 40, jailed: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
