import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../audio/lines.dart';
import '../audio/voice.dart';
import '../data/house.dart';
import '../data/models.dart';
import '../game_state.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/pixel.dart';
import '../widgets/room_painter.dart';
import '../widgets/ui.dart';
import 'minigames.dart';
import 'panels.dart';

/// Y of the ground the characters stand on.
const double _standY = 478;

/// Where Churlock stands (top-left of his figure) when he is not walking.
const _home = Offset(38, _standY - 143);

/// Where he walks to when leaving in each direction: off the side of the
/// room, up the stairs, or down through the cellar hatch.
Offset _exitPoint(Dir d) => switch (d) {
      Dir.left => const Offset(-130, _standY - 143),
      Dir.right => const Offset(sceneW + 20, _standY - 143),
      Dir.up => const Offset(425, -40),
      Dir.down => const Offset(425, sceneH - 110),
    };

Dir _opposite(Dir d) => switch (d) {
      Dir.left => Dir.right,
      Dir.right => Dir.left,
      Dir.up => Dir.down,
      Dir.down => Dir.up,
    };

class GameScreen extends StatefulWidget {
  const GameScreen(this.g, {super.key, required this.voice});

  final GameState g;
  final Voice voice;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  // First half: Churlock walks out and the room fades to black. Second half:
  // the next room fades in as he walks to his usual spot.
  late final AnimationController _walk = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )
    ..addListener(_onTick)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) setState(() => _dir = null);
    });

  // A short walk across the room to whatever was clicked.
  late final AnimationController _approach = AnimationController(vsync: this)
    ..addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      final arrived = _onArrive;
      setState(() {
        _spot = _target;
        _onArrive = null;
      });
      arrived?.call();
    });

  /// Where Churlock is standing, and stays until he is sent somewhere else.
  Offset _spot = _home;
  Offset _from = _home;
  Offset _target = _home;
  VoidCallback? _onArrive;

  late final AnimationController _rain = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  // The basement lamps gutter now and then, never more than once in twenty
  // seconds.
  late final AnimationController _flicker = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  final _random = Random();
  Timer? _nextFlicker;

  void _scheduleFlicker() {
    _nextFlicker = Timer(Duration(seconds: 20 + _random.nextInt(25)), () {
      if (!mounted) return;
      _flicker.forward(from: 0);
      _scheduleFlicker();
    });
  }

  @override
  void initState() {
    super.initState();
    _scheduleFlicker();
  }

  /// How dark the flicker makes the room at point [t] of its run.
  static double _dimming(double t) {
    const steps = [.0, .6, .15, .7, .1, .0, .45, .0];
    return steps[(t * steps.length).floor().clamp(0, steps.length - 1)];
  }

  Dir? _dir;
  Room? _destination;

  GameState get g => widget.g;

  @override
  void dispose() {
    _nextFlicker?.cancel();
    _flicker.dispose();
    _walk.dispose();
    _approach.dispose();
    _rain.dispose();
    super.dispose();
  }

  bool get _moving => _dir != null || _approach.isAnimating;

  void _go(Dir d) {
    if (_moving) return;
    final next = g.destination(d);
    if (next == null) return;
    setState(() {
      _dir = d;
      _destination = next;
      // He leaves from wherever he happens to be standing.
      _from = _spot;
    });
    _walk.forward(from: 0);
  }

  /// Walks Churlock over to the thing at [point], then calls [then].
  void _walkTo(Offset point, VoidCallback then, {double reach = 62}) {
    if (_moving || g.busy) return;
    // Stand beside it, on whichever side keeps him on screen, with his feet
    // on the floor in front of it.
    final side = point.dx > 150 ? -1 : 1;
    final feet = (point.dy + 55).clamp(floorY + 70, _standY + 6);
    final target = Offset(point.dx + side * reach - 55, feet - 143);
    setState(() {
      _from = _spot;
      _target = target;
      _onArrive = then;
    });
    final distance = (target - _spot).distance;
    _approach.duration = Duration(milliseconds: (160 + distance * 1.5).round().clamp(200, 900));
    _approach.forward(from: 0);
  }

  void _onTick() {
    final next = _destination;
    if (next != null && _walk.value >= .5) {
      _destination = null;
      _spot = _home;
      g.enter(next);
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      if (g.dialogue != null) {
        g.closeDialogue();
      } else if (g.panel == Panel.puzzle) {
        g.cancelTask();
      } else if (g.panel != Panel.none) {
        g.closePanel();
      }
      return KeyEventResult.handled;
    }
    final dir = {
      LogicalKeyboardKey.arrowLeft: Dir.left,
      LogicalKeyboardKey.arrowRight: Dir.right,
      LogicalKeyboardKey.arrowUp: Dir.up,
      LogicalKeyboardKey.arrowDown: Dir.down,
    }[key];
    if (dir == null) return KeyEventResult.ignored;
    _go(dir);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final room = g.room;
    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: AbsorbPointer(
        absorbing: _moving,
        child: Stack(
          children: [
            // The room is a still picture, so it is drawn to pixels once.
            Positioned.fill(
              child: Pixelate(
                child: CustomPaint(painter: RoomPainter(room, caseId: g.mystery.id)),
              ),
            ),
            // Everything that moves shares a second pixel layer.
            Positioned.fill(
              child: Pixelate(
                child: Stack(
                  children: [
                    if (roomWindows.containsKey(room.id))
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _rain,
                            builder: (context, _) => CustomPaint(
                              painter: WindowRainPainter(room.id, _rain.value),
                            ),
                          ),
                        ),
                      ),
                    for (final e in g.evidenceHere)
                      Positioned(
                        left: evidencePos(e).dx - 24,
                        top: evidencePos(e).dy - 24,
                        child: _EvidenceSpot(
                          key: ValueKey('evidence-${e.id}'),
                          evidence: e,
                          found: g.found.contains(e.id) && !g.canDust(e),
                          dust: g.canDust(e),
                          onTap: () => _walkTo(evidencePos(e), () => g.inspect(e)),
                        ),
                      ),
                    for (final (id, x) in placements[room.id] ?? const <(String, double)>[])
                      Positioned(
                        left: x - 50,
                        top: _standY - 130,
                        child: IgnorePointer(
                          child: DessertFigure(
                            personById(id).dessert,
                            animate: true,
                            inScene: true,
                          ),
                        ),
                      ),
                    AnimatedBuilder(
                      animation: Listenable.merge([_walk, _approach]),
                      builder: (context, _) => _churlock(),
                    ),
                  ],
                ),
              ),
            ),
            if (room.level == 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _flicker,
                    builder: (context, _) => ColoredBox(
                      color: Colors.black.withValues(
                        alpha: _flicker.isAnimating ? _dimming(_flicker.value) : 0,
                      ),
                    ),
                  ),
                ),
              ),
            // Labels and buttons are kept crisp, above the pixel art.
            for (final (id, x) in placements[room.id] ?? const <(String, double)>[])
              _character(personById(id), x),
            for (final n in g.nooksHere) _nook(n),
            for (final d in Dir.values)
              if (neighbor(room, d) case final Room next) _arrow(d, next),
            Positioned(left: 14, top: 12, child: _RoomLabel(room)),
            Positioned(right: 14, top: 12, child: _Hud(g, widget.voice)),
            if (room.id == 'entrance')
              Positioned(
                left: 60,
                bottom: 16,
                child: GoldButton(
                  key: const ValueKey('solve'),
                  label: 'I solved the case',
                  icon: Icons.gavel,
                  color: kRed,
                  onPressed: () {
                    widget.voice.say(eurekaLine);
                    g.openPanel(Panel.accuse);
                  },
                ),
              ),
            // The fade between rooms, darkest at the moment of the switch.
            if (_dir != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: FadeTransition(
                    opacity: _walk.drive(
                      TweenSequence([
                        TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
                        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 28),
                        TweenSequenceItem(tween: ConstantTween(1.0), weight: 4),
                        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 28),
                        TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
                      ]),
                    ),
                    child: const ColoredBox(color: Colors.black),
                  ),
                ),
              ),
            if (g.panel != Panel.none) ...[
              Scrim(onTap: g.panel == Panel.puzzle ? null : g.closePanel),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: switch (g.panel) {
                    Panel.notebook => NotebookPanel(g),
                    Panel.accuse => AccusePanel(g),
                    Panel.nook => NookPanel(g),
                    _ => PuzzlePanel(g),
                  },
                ),
              ),
            ],
            // Dialogue sits above the panels, so finds inside furniture can
            // be read without closing it.
            if (g.dialogue != null) ...[
              Scrim(onTap: g.closeDialogue, opacity: .25),
              Positioned(left: 20, right: 20, bottom: 14, height: 236, child: DialoguePanel(g)),
            ],
          ],
        ),
      ),
    );
  }

  /// Churlock: standing where he last stopped, crossing the room to
  /// something, or waddling off to the next room.
  Widget _churlock() {
    final d = _dir;
    var pos = _spot;
    var facingLeft = false;
    var stairs = 1.0;
    var sway = 0.0;
    var bob = 0.0;
    if (d != null) {
      final t = _walk.value;
      final leaving = t < .5;
      final part = Curves.easeInOut.transform(leaving ? t * 2 : t * 2 - 1);
      // He arrives through the side opposite the one he left by.
      final from = leaving ? _from : _exitPoint(_opposite(d));
      final to = leaving ? _exitPoint(d) : _home;
      pos = Offset.lerp(from, to, part)!;
      facingLeft = to.dx < from.dx;
      // Stairs lead away from the viewer, so he shrinks as he climbs.
      final depth = leaving ? part : 1 - part;
      final vertical = leaving ? d : _opposite(d);
      if (vertical == Dir.up) stairs = 1 - .45 * depth;
      final step = t * 2 * pi * 9;
      sway = sin(step) * .09;
      bob = -sin(step).abs() * 7;
    } else if (_approach.isAnimating) {
      final t = Curves.easeInOut.transform(_approach.value);
      pos = Offset.lerp(_from, _target, t)!;
      facingLeft = _target.dx < _from.dx;
      final step = _approach.value * (_target - _from).distance / 26;
      sway = sin(step) * .09;
      bob = -sin(step).abs() * 6;
    }
    // Further back in the room he is drawn a little smaller.
    final feet = pos.dy + 143;
    final depthScale = stairs < 1 ? 1.0 : (.8 + .2 * (feet - floorY - 70) / (_standY - floorY - 70)).clamp(.8, 1.0);
    final scale = stairs * depthScale;
    return Positioned(
      left: pos.dx,
      top: pos.dy + bob,
      child: IgnorePointer(
        child: Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..rotateZ(sway)
            ..scaleByDouble(facingLeft ? -scale : scale, scale, 1, 1),
          child: DessertFigure(
            Dessert.churro,
            width: 110,
            // He stops fidgeting while he walks.
            animate: !_moving,
            inScene: true,
          ),
        ),
      ),
    );
  }

  /// A piece of furniture that can be searched.
  Widget _nook(Nook n) {
    return Positioned(
      left: n.pos.dx - 60,
      top: n.pos.dy - 20,
      width: 120,
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            key: ValueKey('nook-${n.id}'),
            onTap: () => _walkTo(n.pos, () => g.search(n)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kInk.withValues(alpha: .75),
                    shape: BoxShape.circle,
                    border: Border.all(color: kCream, width: 1.5),
                  ),
                  child: Icon(n.icon, color: kCream, size: 22),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(n.name, style: const TextStyle(color: kCream, fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The name tag over a character, and the area that can be clicked to
  /// talk to them. The figure itself is drawn in the pixel layer.
  Widget _character(Person p, double x) {
    return Positioned(
      left: x - 70,
      top: _standY - 130 - 26,
      width: 140,
      height: 156,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: ValueKey('person-${p.id}'),
          behavior: HitTestBehavior.opaque,
          onTap: () => _walkTo(Offset(x, _standY - 60), () => g.talkTo(p), reach: 100),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: kInk.withValues(alpha: .85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                p.name,
                style: const TextStyle(color: kGold, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _arrow(Dir d, Room next) {
    final (icon, alignment) = switch (d) {
      Dir.left => (Icons.arrow_back, const Alignment(-.98, -.25)),
      Dir.right => (Icons.arrow_forward, const Alignment(.98, -.25)),
      Dir.up => (Icons.arrow_upward, const Alignment(0, -.96)),
      Dir.down => (Icons.arrow_downward, const Alignment(0, .96)),
    };
    return Align(
      alignment: alignment,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: ValueKey('go-${d.name}'),
          onTap: () => _go(d),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: kInk.withValues(alpha: .8),
                  shape: BoxShape.circle,
                  border: Border.all(color: kGold, width: 2),
                ),
                child: Icon(icon, color: kGold, size: 30),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(next.name, style: const TextStyle(color: kCream, fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomLabel extends StatelessWidget {
  const _RoomLabel(this.room);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Plaque(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(room.name, style: kHeading),
          Text(room.levelName, style: const TextStyle(color: kCream, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  const _Hud(this.g, this.voice);

  final GameState g;
  final Voice voice;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MuteButton(voice),
        const SizedBox(width: 8),
        GoldButton(
          key: const ValueKey('notebook'),
          label: 'Notebook  ${g.found.length}/${g.evidence.length}',
          icon: Icons.menu_book,
          onPressed: () => g.openPanel(Panel.notebook),
        ),
        const SizedBox(width: 10),
        Plaque(
          padding: const EdgeInsets.all(7),
          child: Column(
            children: [
              for (var level = 2; level >= 0; level--)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var col = 0; col < 4; col++) _cell(level, col),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// One room on the mini-map: gold where Churlock is, cream once visited.
  Widget _cell(int level, int col) {
    Room? room;
    for (final r in rooms) {
      if (r.level == level && r.col == col) room = r;
    }
    final Color color;
    if (room == null) {
      color = Colors.transparent;
    } else if (room.id == g.roomId) {
      color = kGold;
    } else if (g.visited.contains(room.id)) {
      color = kCream.withValues(alpha: .55);
    } else {
      color = Colors.white12;
    }
    return Container(
      width: 16,
      height: 10,
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
  }
}

class _EvidenceSpot extends StatefulWidget {
  const _EvidenceSpot({
    super.key,
    required this.evidence,
    required this.found,
    required this.dust,
    required this.onTap,
  });

  final Evidence evidence;
  final bool found;

  /// Whether this is the weapon, ready to be dusted for prints.
  final bool dust;
  final VoidCallback onTap;

  @override
  State<_EvidenceSpot> createState() => _EvidenceSpotState();
}

class _EvidenceSpotState extends State<_EvidenceSpot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.evidence;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: widget.found
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(e.icon, color: e.color.withValues(alpha: .45), size: 28),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.check_circle, color: Color(0xFF81C784), size: 18),
                    ),
                  ],
                )
              : AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) => DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: e.color.withValues(alpha: .25 + .35 * _pulse.value),
                          blurRadius: 10 + 10 * _pulse.value,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                  child: Icon(
                    widget.dust ? Icons.fingerprint : e.icon,
                    color: e.color,
                    size: 30,
                    shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
        ),
      ),
    );
  }
}
