import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../audio/voice.dart';
import '../data/house.dart';
import '../game_state.dart';
import '../widgets/dessert_figure.dart' show fill, stroke;
import '../widgets/ui.dart';

const _paperColor = Color(0xFFF7EFD9);

/// The frame around whichever hands-on task is in progress.
class PuzzlePanel extends StatelessWidget {
  const PuzzlePanel(this.g, {super.key});

  final GameState g;

  @override
  Widget build(BuildContext context) {
    final e = g.puzzle!;
    final (title, hint, Widget game) = switch (g.task) {
      Task.rubbing => (
          'Pencil rubbing',
          'The top sheet is gone, but the pencil pressed through. Drag to '
              'shade the page and raise what was written.',
          RubbingGame(key: ValueKey(e.id), lines: e.pieces, onDone: g.completeTask),
        ),
      Task.torn => (
          'Torn to pieces',
          'Somebody tore this up. Click two strips to swap them until it '
              'reads in order.',
          TornGame(key: ValueKey(e.id), lines: e.pieces, onDone: g.completeTask),
        ),
      _ => (
          'Dusting for prints',
          'Drag the brush over the surface to bring up the prints, then '
              'match each one against the police chart.',
          PrintsGame(key: ValueKey(e.id), owners: g.mystery.printsOn, onDone: g.completeTask),
        ),
    };
    return Plaque(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('$title — ${e.name}', style: kHeading)),
              GoldButton(
                key: const ValueKey('leave-puzzle'),
                label: 'Leave it',
                onPressed: g.cancelTask,
              ),
            ],
          ),
          Text(hint, style: kBody.copyWith(fontSize: 13)),
          const SizedBox(height: 8),
          // Scaled down if need be, so a long letter still fits the frame.
          Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: game)),
        ],
      ),
    );
  }
}

/// Shade a notepad to reveal the indentations left by the sheet above.
class RubbingGame extends StatefulWidget {
  const RubbingGame({super.key, required this.lines, required this.onDone});

  final List<String> lines;
  final VoidCallback onDone;

  @override
  State<RubbingGame> createState() => _RubbingGameState();
}

class _RubbingGameState extends State<RubbingGame> {
  static const _size = Size(560, 280);
  static const _writing = Rect.fromLTWH(70, 70, 420, 150);
  static const _cols = 14;
  static const _rows = 5;

  final _strokes = <Offset>[];
  final _covered = <int>{};

  bool get _done => _covered.length >= _cols * _rows * .8;

  void _shade(Offset p) {
    setState(() {
      _strokes.add(p);
      // Track how much of the written area has been gone over.
      for (var c = 0; c < _cols; c++) {
        for (var r = 0; r < _rows; r++) {
          final cell = Offset(
            _writing.left + (c + .5) * _writing.width / _cols,
            _writing.top + (r + .5) * _writing.height / _rows,
          );
          if ((cell - p).distance < 30) _covered.add(c * _rows + r);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.precise,
          child: GestureDetector(
            key: const ValueKey('rubbing-page'),
            onPanStart: (d) => _shade(d.localPosition),
            onPanUpdate: (d) => _shade(d.localPosition),
            child: CustomPaint(
              size: _size,
              painter: _RubbingPainter(widget.lines, _strokes, _strokes.length, _writing),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GoldButton(
          key: const ValueKey('puzzle-done'),
          label: _done ? 'Read what it says' : 'Keep shading...',
          icon: Icons.edit,
          onPressed: _done ? widget.onDone : null,
        ),
      ],
    );
  }
}

class _RubbingPainter extends CustomPainter {
  _RubbingPainter(this.lines, this.strokes, this.count, this.writing);

  final List<String> lines;
  final List<Offset> strokes;
  final int count;
  final Rect writing;

  @override
  void paint(Canvas c, Size size) {
    final page = Offset.zero & size;
    c.drawRRect(RRect.fromRectAndRadius(page, const Radius.circular(6)), fill(_paperColor));
    // The ragged stub where the top sheet was torn away.
    for (var x = 0.0; x < size.width; x += 14) {
      c.drawCircle(Offset(x + 7, 0), 7, fill(const Color(0xFFE4D9BC)));
    }
    TextPainter(
      text: const TextSpan(
        text: 'S',
        style: TextStyle(color: Color(0xFFB0BEC5), fontSize: 34, fontStyle: FontStyle.italic),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(c, Offset(size.width - 44, 14));

    c.save();
    c.clipRRect(RRect.fromRectAndRadius(page, const Radius.circular(6)));
    c.saveLayer(page, Paint());
    final graphite = fill(const Color(0x55606468));
    for (final p in strokes) {
      c.drawCircle(p, 22, graphite);
    }
    // The dents in the paper stay pale where the pencil skims over them.
    final text = TextPainter(
      text: TextSpan(
        text: lines.join('\n'),
        style: TextStyle(
          fontSize: 34,
          height: 1.3,
          fontStyle: FontStyle.italic,
          foreground: Paint()
            ..blendMode = BlendMode.srcATop
            ..color = _paperColor,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: writing.width, maxWidth: writing.width);
    text.paint(c, Offset(writing.left, writing.center.dy - text.height / 2));
    c.restore();
    c.restore();
  }

  @override
  bool shouldRepaint(_RubbingPainter old) => old.count != count;
}

/// Put the strips of a torn letter back in order by swapping pairs.
class TornGame extends StatefulWidget {
  const TornGame({super.key, required this.lines, required this.onDone});

  final List<String> lines;
  final VoidCallback onDone;

  @override
  State<TornGame> createState() => _TornGameState();
}

class _TornGameState extends State<TornGame> {
  late final List<int> _order = _scramble(widget.lines.length);
  int? _picked;

  /// A fixed shuffle, the same each time the letter is looked at.
  static List<int> _scramble(int n) => [for (var i = 0; i < n; i++) (i * 2 + 2) % n];

  bool get _done {
    for (var i = 0; i < _order.length; i++) {
      if (_order[i] != i) return false;
    }
    return true;
  }

  void _tap(int slot) {
    if (_done) return;
    setState(() {
      final first = _picked;
      if (first == null) {
        _picked = slot;
      } else {
        final moved = _order[first];
        _order[first] = _order[slot];
        _order[slot] = moved;
        _picked = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var slot = 0; slot < _order.length; slot++)
          GestureDetector(
            key: ValueKey('strip-$slot'),
            onTap: () => _tap(slot),
            child: Transform.rotate(
              angle: _done ? 0 : (slot.isEven ? -.012 : .014),
              child: Container(
                width: 520,
                margin: EdgeInsets.symmetric(vertical: _done ? 0 : 3),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: _paperColor,
                  border: Border.all(
                    color: _picked == slot ? kRed : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Text(
                  widget.lines[_order[slot]],
                  style: const TextStyle(color: kInk, fontSize: 17, fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        GoldButton(
          key: const ValueKey('puzzle-done'),
          label: _done ? 'Read it' : 'Not in order yet...',
          icon: Icons.description,
          onPressed: _done ? widget.onDone : null,
        ),
      ],
    );
  }
}

/// Dust a surface for fingerprints, then match each against the chart.
class PrintsGame extends StatefulWidget {
  const PrintsGame({super.key, required this.owners, required this.onDone});

  /// Whose prints are on the weapon.
  final List<String> owners;
  final VoidCallback onDone;

  @override
  State<PrintsGame> createState() => _PrintsGameState();
}

class _PrintsGameState extends State<PrintsGame> {
  static const _surface = Size(600, 230);
  static const _spots = [Offset(130, 120), Offset(310, 90), Offset(480, 140)];

  final _powder = <Offset>[];
  late final List<double> _shown = List.filled(widget.owners.length, 0);
  bool _matching = false;
  int _index = 0;
  String? _message;

  bool get _dusted => _shown.every((v) => v >= 1);

  void _brush(Offset p) {
    setState(() {
      if (_powder.length < 500) _powder.add(p);
      for (var i = 0; i < _shown.length; i++) {
        if ((_spots[i] - p).distance < 48) _shown[i] = min(1, _shown[i] + .1);
      }
    });
  }

  void _guess(String person) {
    if (person != widget.owners[_index]) {
      setState(() => _message = 'Not a match. Look at the ridges again.');
      return;
    }
    if (_index + 1 == widget.owners.length) {
      widget.onDone();
    } else {
      setState(() {
        _index++;
        _message = 'A match: ${personById(person).name}. Now the next print.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => _matching ? _match() : _dust();

  Widget _dust() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.precise,
          child: GestureDetector(
            key: const ValueKey('dust-surface'),
            onPanStart: (d) => _brush(d.localPosition),
            onPanUpdate: (d) => _brush(d.localPosition),
            child: SizedBox.fromSize(
              size: _surface,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _PowderPainter(_powder, _powder.length)),
                  ),
                  for (var i = 0; i < _shown.length; i++)
                    Positioned(
                      left: _spots[i].dx - 34,
                      top: _spots[i].dy - 44,
                      child: Transform.rotate(
                        angle: (i - 1) * .35,
                        child: CustomPaint(
                          size: const Size(68, 88),
                          painter: PrintPainter(
                            widget.owners[i],
                            color: Colors.white.withValues(alpha: _shown[i]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GoldButton(
          key: const ValueKey('lift-prints'),
          label: _dusted
              ? 'Compare with the chart'
              : 'Prints raised: ${_shown.where((v) => v >= 1).length}',
          icon: Icons.fingerprint,
          onPressed: _dusted ? () => setState(() => _matching = true) : null,
        ),
      ],
    );
  }

  Widget _match() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Print ${_index + 1} of ${widget.owners.length}',
              style: kBody.copyWith(color: kGold, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF20262B),
              child: Transform.rotate(
                angle: (_index - 1) * .35,
                child: CustomPaint(
                  size: const Size(120, 156),
                  painter: PrintPainter(widget.owners[_index], color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 190,
              child: Text(
                _message ?? 'Whose is it? Click the matching print.',
                style: kBody.copyWith(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        for (final p in residents)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              key: ValueKey('chart-${p.id}'),
              onTap: () => _guess(p.id),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 104,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _paperColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomPaint(size: const Size(74, 96), painter: PrintPainter(p.id)),
                      const SizedBox(height: 6),
                      Text(
                        p.name,
                        style: const TextStyle(color: kInk, fontSize: 11, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PowderPainter extends CustomPainter {
  _PowderPainter(this.powder, this.count);

  final List<Offset> powder;
  final int count;

  @override
  void paint(Canvas c, Size size) {
    final slab = Offset.zero & size;
    c.drawRRect(RRect.fromRectAndRadius(slab, const Radius.circular(10)), fill(const Color(0xFF2A3136)));
    c.save();
    c.clipRRect(RRect.fromRectAndRadius(slab, const Radius.circular(10)));
    for (final p in powder) {
      c.drawCircle(p, 30, fill(const Color(0x14FFFFFF)));
    }
    c.restore();
  }

  @override
  bool shouldRepaint(_PowderPainter old) => old.count != count;
}

/// A resident's fingerprint. Each dessert has a ridge pattern of its own.
class PrintPainter extends CustomPainter {
  PrintPainter(this.person, {this.color = const Color(0xFF263238)});

  final String person;
  final Color color;

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    final centre = Offset(w / 2, h / 2);
    final ridge = stroke(color, w * .034);
    c.save();
    c.clipPath(Path()..addOval(Offset.zero & s));
    switch (person) {
      case 'penny':
        // Whorl: rings around a centre.
        for (var k = 1; k <= 9; k++) {
          c.drawOval(Rect.fromCenter(center: centre, width: k * w * .12, height: k * h * .12), ridge);
        }
      case 'graham':
        // Square whorl, as befits a cracker.
        for (var k = 1; k <= 9; k++) {
          c.drawRect(Rect.fromCenter(center: centre, width: k * w * .12, height: k * h * .12), ridge);
        }
      case 'cannoli':
        // A single spiral.
        final spiral = Path()..moveTo(centre.dx, centre.dy);
        for (var a = 0.0; a < 12 * pi; a += .15) {
          final r = a / (12 * pi) * h * .62;
          spiral.lineTo(centre.dx + cos(a) * r * w / h, centre.dy + sin(a) * r);
        }
        c.drawPath(spiral, ridge);
      case 'tira':
        // Layered arches.
        for (var y = -h * .2; y < h * 1.2; y += h * .085) {
          final arch = Path()..moveTo(0, y + h * .14);
          arch.quadraticBezierTo(w / 2, y - h * .14, w, y + h * .14);
          c.drawPath(arch, ridge);
        }
      default:
        // Loops, open at the bottom.
        for (var k = 1; k <= 8; k++) {
          final d = k * w * .065;
          final loop = Path()
            ..moveTo(centre.dx - d, h)
            ..lineTo(centre.dx - d, h * .46)
            ..arcToPoint(Offset(centre.dx + d, h * .46), radius: Radius.circular(d))
            ..lineTo(centre.dx + d, h);
          c.drawPath(loop, ridge);
        }
    }
    c.restore();
  }

  @override
  bool shouldRepaint(PrintPainter old) => old.person != person || old.color != color;
}

/// The combination dial on the study desk. Nothing in the house says what
/// the combination is: it is found by ear. The dial is turned by dragging
/// round it or with the arrow keys, one way for each number and the other
/// way for the next. It gives a loud click as it passes the number each
/// tumbler wants; turning back sets the number it had reached, and the last
/// number opens the lock as soon as the dial arrives at it.
class DialLock extends StatefulWidget {
  const DialLock({super.key, required this.combination, required this.onTry});

  final List<int> combination;

  /// Returns whether the numbers set, joined by dashes, opened the lock.
  final bool Function(String code) onTry;

  @override
  State<DialLock> createState() => _DialLockState();
}

class _DialLockState extends State<DialLock> {
  static const _notches = 100;
  static const _size = 230.0;

  /// Notches turned since the dial was last at rest on zero; right is up.
  int _steps = 0;
  int _moved = 0;
  final _set = <int>[];
  String _message = '';
  double _drag = 0;

  /// True for a moment after the dial has clicked, for players with the
  /// sound off.
  bool _caught = false;
  Timer? _catchTimer;

  int get _reading => _steps % _notches;

  /// The first and third numbers are dialled to the right.
  bool get _rightward => _set.length.isEven;

  bool get _last => _set.length == widget.combination.length - 1;

  // The arrow keys turn the dial while it is on screen, and go back to
  // whatever had them before when it is not.
  final _focus = FocusNode(debugLabel: 'dial');
  FocusNode? _previous;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _previous = FocusManager.instance.primaryFocus;
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _catchTimer?.cancel();
    final previous = _previous;
    if (_focus.hasFocus && previous != null && previous.context != null) {
      previous.requestFocus();
    }
    _focus.dispose();
    super.dispose();
  }

  void _reset([String message = '']) {
    _catchTimer?.cancel();
    setState(() {
      _steps = 0;
      _moved = 0;
      _drag = 0;
      _set.clear();
      _caught = false;
      _message = message;
    });
  }

  void _turn({required bool right}) {
    if (right != _rightward) {
      // Turning back sets the number the dial had reached.
      if (_moved == 0) return;
      if (_last || _reading != widget.combination[_set.length]) {
        _reset('That did not catch. The tumblers drop back.');
        return;
      }
      _set.add(_reading);
      _moved = 0;
    }
    final voice = VoiceScope.maybeOf(context);
    setState(() {
      _steps += right ? 1 : -1;
      _moved++;
      _message = '';
      _caught = false;
    });
    if (_reading != widget.combination[_set.length]) {
      voice?.tick();
      return;
    }
    voice?.click();
    // The last tumbler opens the lock the moment the dial reaches it.
    if (_last && widget.onTry([..._set, _reading].join('-'))) return;
    // With the sound off there is nothing to hear, so it is shown instead.
    if (voice?.muted ?? false) {
      setState(() => _caught = true);
      _catchTimer?.cancel();
      _catchTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _caught = false);
      });
    }
  }

  /// Dragging round the dial, with a finger or the mouse, turns it a notch
  /// at a time. It takes a firmer pull to turn it back than to keep going,
  /// so that a wobble does not set a number by accident.
  void _onDrag(DragUpdateDetails d) {
    const centre = Offset(_size / 2, _size / 2);
    final from = d.localPosition - d.delta - centre;
    final to = d.localPosition - centre;
    var swept = to.direction - from.direction;
    if (swept > pi) swept -= 2 * pi;
    if (swept < -pi) swept += 2 * pi;
    _drag += swept;
    const notch = 2 * pi / _notches;
    while (true) {
      final right = _drag > 0;
      final needed = right == _rightward || _moved == 0 ? notch : notch * 3;
      if (_drag.abs() < needed) break;
      _drag -= right ? needed : -needed;
      _turn(right: right);
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight) {
      _turn(right: true);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      _turn(right: false);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final entered = [
      for (var i = 0; i < widget.combination.length; i++)
        i < _set.length ? '${_set[i]}' : '··',
    ].join('  ');
    final dial = SizedBox(
      width: _size,
      height: _size + 10,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 10,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: GestureDetector(
                key: const ValueKey('dial'),
                onPanUpdate: _onDrag,
                child: AnimatedRotation(
                  turns: _steps / _notches,
                  duration: const Duration(milliseconds: 60),
                  child: CustomPaint(
                    size: const Size(_size, _size),
                    painter: _DialPainter(),
                  ),
                ),
              ),
            ),
          ),
          // The mark the numbers are read against.
          const IgnorePointer(
            child: Icon(Icons.arrow_drop_down, color: kRed, size: 34),
          ),
        ],
      ),
    );
    return Focus(
      focusNode: _focus,
      onKeyEvent: _onKey,
      child: SizedBox(
        width: 560,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _rightward ? 'RIGHT' : 'LEFT',
                  key: const ValueKey('dial-way'),
                  style: kHeading.copyWith(fontSize: 22, letterSpacing: 3),
                ),
                dial,
                const SizedBox(height: 6),
                GoldButton(
                  key: const ValueKey('dial-reset'),
                  label: 'Reset the dial',
                  icon: Icons.restart_alt,
                  onPressed: _reset,
                ),
              ],
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'A brass dial, and no note of the numbers anywhere. '
                    'Drag round it, or use the arrow keys, and listen: each '
                    'tumbler clicks at its number. Turn back the other way '
                    'to set it.',
                    style: kBody,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    key: const ValueKey('dial-readout'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: kInk,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kGold, width: 2),
                    ),
                    child: Text(
                      'Dial reads  $_reading\nSet so far  $entered',
                      style: kHeading,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _message.isNotEmpty
                        ? _message
                        : _caught
                        ? '(click)'
                        : ' ',
                    key: const ValueKey('dial-status'),
                    style: kBody.copyWith(
                      color: _message.isNotEmpty
                          ? const Color(0xFFFF8A80)
                          : kCream,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final centre = s.center(Offset.zero);
    final radius = s.width / 2;
    c.drawCircle(centre, radius, fill(const Color(0xFF4A3A12)));
    c.drawCircle(centre, radius - 5, fill(const Color(0xFFD4A537)));
    for (var n = 0; n < 100; n++) {
      // Turning right brings the next number up to the mark.
      final a = -n * 2 * pi / 100 - pi / 2;
      final d = Offset(cos(a), sin(a));
      final long = n % 10 == 0;
      c.drawLine(
        centre + d * (radius - 8),
        centre + d * (radius - (long ? 20 : n % 5 == 0 ? 15 : 12)),
        stroke(kInk, long ? 2.5 : 1),
      );
      if (!long) continue;
      final text = TextPainter(
        text: TextSpan(
          text: '$n',
          style: const TextStyle(
            color: kInk,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      c.save();
      c.translate(centre.dx + d.dx * (radius - 33), centre.dy + d.dy * (radius - 33));
      c.rotate(a + pi / 2);
      text.paint(c, Offset(-text.width / 2, -text.height / 2));
      c.restore();
    }
  }

  @override
  bool shouldRepaint(_DialPainter old) => false;
}

/// Picking the strongbox: each pin binds in turn, and has to be found by
/// feel. The right pin stays up with a click; a wrong one drops them all.
class LockPickGame extends StatefulWidget {
  const LockPickGame({super.key, required this.order, required this.onDone});

  /// The pins, numbered from the left, in the order they must be set.
  final List<int> order;
  final VoidCallback onDone;

  @override
  State<LockPickGame> createState() => _LockPickGameState();
}

class _LockPickGameState extends State<LockPickGame> {
  int _set = 0;
  String _message = '';

  void _lift(int pin) {
    if (widget.order.indexOf(pin) < _set) return;
    if (widget.order[_set] != pin) {
      setState(() {
        _message = _set == 0
            ? 'That one will not bind yet. Try another.'
            : 'Too soon. The pins drop, and I begin again.';
        _set = 0;
      });
      return;
    }
    VoiceScope.maybeOf(context)?.click();
    setState(() {
      _set++;
      _message = '';
    });
    if (_set == widget.order.length) widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Four pins, and they bind one at a time. Lift them in the right '
          'order. The right one stays up with a click.',
          style: kBody,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          decoration: BoxDecoration(
            color: const Color(0xFF546E7A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kInk, width: 3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var pin = 0; pin < widget.order.length; pin++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      key: ValueKey('pin-$pin'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _lift(pin),
                      child: SizedBox(
                        width: 44,
                        height: 130,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 140),
                            width: 30,
                            height:
                                widget.order.indexOf(pin) < _set ? 118 : 64,
                            decoration: BoxDecoration(
                              color: widget.order.indexOf(pin) < _set
                                  ? const Color(0xFFD4A537)
                                  : const Color(0xFFB0BEC5),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              border: Border.all(color: kInk, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _message.isEmpty ? 'Set: $_set of ${widget.order.length}' : _message,
          key: const ValueKey('pick-status'),
          style: kBody.copyWith(
            color: _message.isEmpty ? kCream : const Color(0xFFFF8A80),
          ),
        ),
      ],
    );
  }
}
