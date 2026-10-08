import 'dart:math';

import 'package:flutter/material.dart';

import '../data/house.dart';
import '../game_state.dart';
import '../widgets/ui.dart';

const _paperColor = Color(0xFFF7EFD9);

// The minigames are drawn smooth, unlike the pixel-art scenes.
Paint fill(Color c) => Paint()..color = c;

Paint stroke(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round;

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

/// A four-digit combination lock.
class CodeLock extends StatefulWidget {
  const CodeLock({super.key, required this.onTry});

  /// Returns whether the combination opened the lock.
  final bool Function(String code) onTry;

  @override
  State<CodeLock> createState() => _CodeLockState();
}

class _CodeLockState extends State<CodeLock> {
  final _digits = [0, 0, 0, 0];
  bool _refused = false;

  void _turn(int wheel, int by) {
    setState(() {
      _digits[wheel] = (_digits[wheel] + by) % 10;
      _refused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'A brass lock with four wheels. Engraved beneath it: '
          '“The year it all began.”',
          style: kBody,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    IconButton(
                      key: ValueKey('wheel-up-$i'),
                      onPressed: () => _turn(i, 1),
                      icon: const Icon(Icons.keyboard_arrow_up, color: kGold),
                    ),
                    Container(
                      width: 54,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A537),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kInk, width: 3),
                      ),
                      child: Text(
                        '${_digits[i]}',
                        style: const TextStyle(color: kInk, fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      key: ValueKey('wheel-down-$i'),
                      onPressed: () => _turn(i, 9),
                      icon: const Icon(Icons.keyboard_arrow_down, color: kGold),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GoldButton(
          key: const ValueKey('try-lock'),
          label: 'Try the lock',
          icon: Icons.lock_open,
          onPressed: () {
            final opened = widget.onTry(_digits.join());
            if (!opened) setState(() => _refused = true);
          },
        ),
        const SizedBox(height: 6),
        Text(
          _refused ? 'It does not budge.' : ' ',
          style: kBody.copyWith(color: const Color(0xFFFF8A80)),
        ),
      ],
    );
  }
}
