import 'dart:math';

import 'package:flutter/material.dart';

import '../data/house.dart';
import 'dessert_figure.dart' show fill, stroke;

const _gingerbread = Color(0xFF9A5B2A);
const _darkBread = Color(0xFF6E3B17);
const _icing = Color(0xFFFFF8EE);
const _gumdrops = [
  Color(0xFFE53935), Color(0xFF43A047), Color(0xFFFDD835), Color(0xFF8E24AA),
  Color(0xFFFB8C00),
];

/// The gingerbread mansion from the lane outside. [gloomy] gives the storm
/// seen on arrival; otherwise it is a clear dawn. [time] runs 0..1 over the
/// scene and drifts the clouds and chimney smoke; [lurker] fades in a figure
/// watching from the tower window.
class ExteriorPainter extends CustomPainter {
  ExteriorPainter({
    required this.gloomy,
    required this.time,
    this.lurker = 0,
    this.door = 0,
  });

  final bool gloomy;
  final double time;
  final double lurker;

  /// How far the front door stands open, from 0 to 1.
  final double door;

  late Canvas c;

  static const double ground = 400;

  @override
  void paint(Canvas canvas, Size size) {
    c = canvas;
    _sky();
    _yard();
    _mansion();
    _ground();
  }

  @override
  bool shouldRepaint(ExteriorPainter old) =>
      old.time != time ||
      old.gloomy != gloomy ||
      old.lurker != lurker ||
      old.door != door;

  void _rect(double x, double y, double w, double h, Color col, [double r = 0]) {
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r)),
      fill(col),
    );
  }

  void _sky() {
    const sky = Rect.fromLTWH(0, 0, sceneW, ground + 10);
    c.drawRect(
      sky,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gloomy
              ? const [Color(0xFF17131F), Color(0xFF4B4257)]
              : const [Color(0xFF3A4668), Color(0xFFF0AE6E)],
        ).createShader(sky),
    );
    if (!gloomy) {
      c.drawCircle(const Offset(210, ground), 120, fill(const Color(0x33FFE9B0)));
      c.drawCircle(const Offset(210, ground), 62, fill(const Color(0xFFFFE9B0)));
    }
    final cloud = fill(gloomy ? const Color(0xE6262130) : const Color(0x99F6C9B8));
    final drift = time * 50;
    final clouds = gloomy
        ? const [(80.0, 60.0, 1.3), (300.0, 40.0, 1.6), (560.0, 70.0, 1.2), (800.0, 45.0, 1.5), (960.0, 90.0, 1.0)]
        : const [(120.0, 80.0, 1.0), (760.0, 60.0, 1.1)];
    for (final (x, y, s) in clouds) {
      final cx = (x + drift) % (sceneW + 200) - 100;
      for (final (dx, dy, r) in const [(-60.0, 8.0, 38.0), (-20.0, -10.0, 50.0), (30.0, 0.0, 44.0), (70.0, 10.0, 32.0)]) {
        c.drawCircle(Offset(cx + dx * s, y + dy * s), r * s, cloud);
      }
    }
    // Far hills.
    final hills = Path()..moveTo(0, ground);
    for (var x = 0.0; x <= sceneW; x += 40) {
      hills.lineTo(x, ground - 40 - 26 * sin(x / 130) - 14 * sin(x / 47));
    }
    hills
      ..lineTo(sceneW, ground)
      ..close();
    c.drawPath(hills, fill(gloomy ? const Color(0xFF231F2B) : const Color(0xFF5A5F73)));
  }

  void _window(double x, double y, double w, double h) {
    if (gloomy) {
      c.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x - 8, y - 8, w + 16, h + 16), const Radius.circular(12)),
        fill(const Color(0x33FFD98A)),
      );
    }
    _rect(x, y, w, h, gloomy ? const Color(0xFFFFD98A) : const Color(0xFFBFD9E8), 6);
    final frame = stroke(_icing, 4);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), const Radius.circular(6)), frame);
    c.drawLine(Offset(x + w / 2, y), Offset(x + w / 2, y + h), frame);
    c.drawLine(Offset(x, y + h / 2), Offset(x + w, y + h / 2), frame);
  }

  /// White icing piped along a roof edge, with gumdrops stuck into it.
  void _icedEdge(Offset a, Offset b, int drops, int colourOffset) {
    c.drawLine(a, b, stroke(_icing, 13));
    for (var i = 0; i <= drops; i++) {
      final p = Offset.lerp(a, b, i / drops)!;
      c.drawCircle(p.translate(0, 8), 6, fill(_icing));
      if (i.isOdd) {
        c.drawCircle(p.translate(0, -6), 8, fill(_gumdrops[(i + colourOffset) % _gumdrops.length]));
      }
    }
  }

  /// Where Pupcake looks over the fence, when he has something to be
  /// pleased about: the top of the fence, and the middle of the gap he uses.
  static const fenceTop = 352.0;
  static const fenceGap = 292.0;

  /// The back yard, glimpsed round the side of the house: the greenhouse,
  /// the kennel roof, and the wafer fence.
  void _yard() {
    final dim = gloomy ? .6 : 1.0;
    final frame = stroke(_icing.withValues(alpha: .8 * dim), 3);
    const panes = [Offset(196, 330), Offset(236, 300), Offset(276, 330), Offset(276, ground), Offset(196, ground)];
    c.drawPath(Path()..addPolygon(panes, true), fill(const Color(0x4490CAF9)));
    c.drawPath(Path()..addPolygon(panes, true), frame);
    c.drawLine(const Offset(236, 300), const Offset(236, ground), frame);
    c.drawLine(const Offset(196, 330), const Offset(276, 330), frame);
    // Kennel roof.
    c.drawPath(
      Path()..addPolygon(const [Offset(340, 362), Offset(374, 328), Offset(408, 362)], true),
      fill(Color.lerp(Colors.black, const Color(0xFF6E4520), dim)!),
    );
    c.drawLine(const Offset(340, 362), const Offset(374, 328), stroke(_icing.withValues(alpha: dim), 4));
    c.drawLine(const Offset(408, 362), const Offset(374, 328), stroke(_icing.withValues(alpha: dim), 4));
    c.drawCircle(const Offset(374, 328), 5, fill(const Color(0xFFD32F2F)));
    // Wafer fence.
    final wafer = fill(Color.lerp(Colors.black, const Color(0xFFB98443), dim)!);
    for (var x = 186.0; x < 440; x += 18) {
      c.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, fenceTop, 15, ground - fenceTop), const Radius.circular(3)),
        wafer,
      );
    }
    _rect(182, 366, 260, 5, Color.lerp(Colors.black, const Color(0xFF6B4226), dim)!);
  }

  void _mansion() {
    // Chimney and smoke.
    _rect(770, 128, 32, 70, _darkBread);
    _rect(764, 120, 44, 12, _icing, 5);
    for (var i = 0; i < 4; i++) {
      final rise = (time * 3 + i / 4) % 1;
      c.drawCircle(
        Offset(786 + 24 * rise + 8 * sin(rise * 6), 112 - rise * 90),
        8 + rise * 16,
        fill(Colors.white.withValues(alpha: .22 * (1 - rise))),
      );
    }

    // Tower.
    _rect(440, 172, 92, ground - 172, const Color(0xFF8A4F22));
    c.drawPath(
      Path()..addPolygon(const [Offset(428, 176), Offset(544, 176), Offset(486, 84)], true),
      fill(_darkBread),
    );
    _icedEdge(const Offset(428, 176), const Offset(486, 84), 4, 0);
    _icedEdge(const Offset(544, 176), const Offset(486, 84), 4, 2);
    c.drawCircle(const Offset(486, 80), 11, fill(const Color(0xFFE53935)));
    c.drawCircle(const Offset(486, 80), 5, fill(_icing));
    _window(465, 214, 42, 58);
    if (lurker > 0) {
      // Somebody is still at home.
      final shade = fill(Colors.black.withValues(alpha: .85 * lurker));
      c.drawOval(const Rect.fromLTWH(472, 232, 28, 40), shade);
      for (final x in [480.0, 492.0]) {
        c.drawCircle(Offset(x, 246), 2.6, fill(const Color(0xFFFF1744).withValues(alpha: lurker)));
      }
    }
    _window(465, 310, 42, 50);

    // Main house.
    _rect(520, 222, 322, ground - 222, _gingerbread);
    for (var x = 528.0; x < 842; x += 18) {
      c.drawCircle(Offset(x, 226), 9, fill(_icing));
    }
    c.drawPath(
      Path()..addPolygon(const [Offset(500, 228), Offset(862, 228), Offset(681, 108)], true),
      fill(_darkBread),
    );
    _icedEdge(const Offset(500, 228), const Offset(681, 108), 8, 1);
    _icedEdge(const Offset(862, 228), const Offset(681, 108), 8, 3);

    // Peppermint window in the gable.
    c.drawCircle(const Offset(681, 180), 24, fill(_icing));
    for (var i = 0; i < 6; i++) {
      c.drawArc(
        Rect.fromCircle(center: const Offset(681, 180), radius: 21),
        i * pi / 3,
        pi / 6,
        true,
        fill(const Color(0xFFE53935)),
      );
    }

    _window(560, 252, 52, 62);
    _window(750, 252, 52, 62);
    _window(560, 338, 52, 48);
    _window(750, 338, 52, 48);

    // Front door between candy-cane pillars.
    // It swings inward on its left-hand hinges, letting out the hall light.
    final leaf = 62 * (1 - .78 * door);
    if (door > 0) {
      _rect(650, 312, 62, ground - 312, const Color(0xFF2A1408), 8);
      _rect(650 + leaf, 322, 62 - leaf, ground - 322, const Color(0xFFFFC56B).withValues(alpha: .85));
    }
    _rect(650, 312, leaf, ground - 312, Color.lerp(const Color(0xFF7B1F1F), const Color(0xFF5A1414), door)!, 8);
    c.drawArc(const Rect.fromLTWH(644, 298, 74, 60), pi, pi, false, stroke(_icing, 7));
    c.drawCircle(Offset(650 + leaf - 12, 362), 4, fill(const Color(0xFFFFD54F)));
    for (final x in [632.0, 720.0]) {
      _rect(x, 300, 11, ground - 300, _icing, 4);
      for (var y = 306.0; y < ground - 6; y += 16) {
        c.drawLine(Offset(x + 1, y + 8), Offset(x + 10, y), stroke(const Color(0xFFE53935), 4));
      }
    }

    // Lollipop trees.
    for (final (x, r, colour) in const [(900.0, 26.0, Color(0xFFE91E63)), (392.0, 22.0, Color(0xFF29B6F6))]) {
      c.drawLine(Offset(x, ground), Offset(x, ground - 80), stroke(_icing, 5));
      c.drawCircle(Offset(x, ground - 96), r, fill(colour));
      c.drawArc(Rect.fromCircle(center: Offset(x, ground - 96), radius: r * .6), 0, 4.2, false, stroke(_icing, 4));
    }
  }

  void _ground() {
    _rect(0, ground, sceneW, sceneH - ground, gloomy ? const Color(0xFF26281F) : const Color(0xFF4F6A3C));
    // Gumdrop hedge.
    for (var x = 12.0; x < sceneW; x += 34) {
      if (x > 610 && x < 750) continue;
      c.drawArc(
        Rect.fromCircle(center: Offset(x, ground + 6), radius: 14),
        pi,
        pi,
        true,
        fill(_gumdrops[(x ~/ 34) % _gumdrops.length].withValues(alpha: gloomy ? .55 : .9)),
      );
    }
    // Biscuit path from the door down to the lane.
    c.drawPath(
      Path()..addPolygon(const [Offset(652, ground), Offset(710, ground), Offset(760, 446), Offset(600, 446)], true),
      fill(gloomy ? const Color(0xFF6B5335) : const Color(0xFFC79A5B)),
    );
    // The lane.
    _rect(0, 446, sceneW, 80, gloomy ? const Color(0xFF1D1D24) : const Color(0xFF3C3C46));
    for (var x = 20.0; x < sceneW; x += 90) {
      _rect(x, 483, 44, 5, Colors.white24, 2);
    }
    _rect(0, 526, sceneW, 14, gloomy ? const Color(0xFF22231C) : const Color(0xFF45603A));
    if (gloomy) {
      // Fizzing soda puddles.
      for (final (x, y, w) in const [(250.0, 508.0, 120.0), (520.0, 470.0, 90.0), (820.0, 510.0, 140.0)]) {
        c.drawOval(Rect.fromCenter(center: Offset(x, y), width: w, height: w * .16), fill(const Color(0x55D9963A)));
      }
    }
  }
}

/// A repeatable pseudo-random number in 0..1 for drop [i], so that rain is
/// scattered evenly but looks the same from one frame to the next.
double scatter(int i, int salt) {
  final v = sin(i * 12.9898 + salt * 78.233) * 43758.5453;
  return v - v.floorToDouble();
}

/// Soda rain and lightning, painted over everything else in the scene.
class RainPainter extends CustomPainter {
  RainPainter({required this.cycle, required this.flash, this.heavy = false});

  /// Loops 0..1; every drop falls a whole number of screens per loop.
  final double cycle;
  final double flash;
  final bool heavy;

  static const _soda = [
    Color(0x88F2D6A0), Color(0x88D9963A), Color(0x88B8E986), Color(0x88F2D6A0),
    Color(0x88FF9EBB),
  ];

  @override
  void paint(Canvas c, Size size) {
    const span = sceneH + 60;
    final count = heavy ? 230 : 150;
    for (var i = 0; i < count; i++) {
      final x = scatter(i, 1) * (sceneW + 120) - 20;
      final y = (scatter(i, 2) * span + cycle * span * (1 + i % 2)) % span - 30;
      c.drawLine(Offset(x, y), Offset(x - 7, y + 24), stroke(_soda[i % _soda.length], i % 4 == 0 ? 2.4 : 1.4));
    }
    // Fizz where the drops land on the lane.
    for (var i = 0; i < 26; i++) {
      final life = (cycle * 2 + i * .37) % 1;
      final centre = Offset((i * 173.9) % sceneW, 452 + (i * 29.3) % 70);
      c.drawOval(
        Rect.fromCenter(center: centre, width: 6 + life * 22, height: 2 + life * 6),
        stroke(Colors.white.withValues(alpha: .5 * (1 - life)), 1.4),
      );
      c.drawCircle(centre.translate(0, -4 - life * 14), 1.8, fill(Colors.white.withValues(alpha: .6 * (1 - life))));
    }
    if (flash > 0) {
      c.drawRect(Offset.zero & size, fill(Colors.white.withValues(alpha: .7 * flash)));
    }
  }

  @override
  bool shouldRepaint(RainPainter old) => old.cycle != cycle || old.flash != flash;
}

/// Churlock's motor car, facing right. [roll] turns the wheels.
class CarPainter extends CustomPainter {
  CarPainter({required this.roll, required this.lights});

  final double roll;
  final bool lights;

  @override
  void paint(Canvas c, Size s) {
    const body = Color(0xFF1F2A44);
    if (lights) {
      c.drawPath(
        Path()..addPolygon(const [Offset(212, 58), Offset(430, 20), Offset(430, 112)], true),
        fill(const Color(0x33FFF3B0)),
      );
    }
    c.drawOval(const Rect.fromLTWH(14, 98, 200, 14), fill(Colors.black38));
    // Cabin.
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(62, 8, 98, 60), const Radius.circular(14)), fill(body));
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(72, 17, 36, 30), const Radius.circular(6)), fill(const Color(0xAAB3E5FC)));
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(114, 17, 36, 30), const Radius.circular(6)), fill(const Color(0xAAB3E5FC)));
    // Body, bonnet and running board.
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(10, 46, 206, 42), const Radius.circular(12)), fill(body));
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(158, 38, 54, 20), const Radius.circular(8)), fill(const Color(0xFF2B3A5E)));
    c.drawRect(const Rect.fromLTWH(34, 84, 160, 6), fill(const Color(0xFF8D6E1F)));
    c.drawCircle(const Offset(210, 60), 8, fill(lights ? const Color(0xFFFFF3B0) : const Color(0xFFB0A070)));
    c.drawRect(const Rect.fromLTWH(4, 62, 10, 8), fill(const Color(0xFFB71C1C)));
    // Wheels.
    for (final x in [56.0, 172.0]) {
      c.drawArc(Rect.fromCircle(center: Offset(x, 88), radius: 27), pi, pi, true, fill(body));
      c.drawCircle(Offset(x, 90), 20, fill(const Color(0xFF111111)));
      c.drawCircle(Offset(x, 90), 11, fill(const Color(0xFFCFD8DC)));
      for (var i = 0; i < 4; i++) {
        final a = roll + i * pi / 4;
        final d = Offset(cos(a), sin(a)) * 11;
        c.drawLine(Offset(x, 90) - d, Offset(x, 90) + d, stroke(const Color(0xFF546E7A), 2));
      }
    }
  }

  @override
  bool shouldRepaint(CarPainter old) => old.roll != roll || old.lights != lights;
}

/// The Donut County police wagon, facing right, with a barred window for its
/// passengers. [blink] alternates the roof lamp.
class WagonPainter extends CustomPainter {
  WagonPainter({required this.roll, required this.blink});

  final double roll;
  final bool blink;

  /// Where the prisoners show through, within the wagon's 250x130 box.
  static const window = Rect.fromLTWH(34, 28, 124, 52);

  @override
  void paint(Canvas c, Size s) {
    const navy = Color(0xFF1A2A5E);
    c.drawOval(const Rect.fromLTWH(14, 116, 226, 14), fill(Colors.black38));
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(14, 14, 168, 92), const Radius.circular(10)), fill(navy));
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(178, 44, 62, 62), const Radius.circular(10)), fill(navy));
    c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(190, 52, 40, 26), const Radius.circular(5)), fill(const Color(0xAAB3E5FC)));
    c.drawRect(const Rect.fromLTWH(14, 88, 226, 6), fill(const Color(0xFFFFD54F)));
    c.drawRRect(RRect.fromRectAndRadius(window, const Radius.circular(4)), fill(const Color(0xFF0C1330)));
    c.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(88, 4, 22, 12), const Radius.circular(4)),
      fill(blink ? const Color(0xFFFF1744) : const Color(0xFF2979FF)),
    );
    c.drawCircle(const Offset(99, 10), 22, fill((blink ? const Color(0xFFFF1744) : const Color(0xFF2979FF)).withValues(alpha: .18)));
    for (final x in [58.0, 200.0]) {
      c.drawCircle(Offset(x, 108), 20, fill(const Color(0xFF111111)));
      c.drawCircle(Offset(x, 108), 10, fill(const Color(0xFFCFD8DC)));
      for (var i = 0; i < 4; i++) {
        final a = roll + i * pi / 4;
        final d = Offset(cos(a), sin(a)) * 10;
        c.drawLine(Offset(x, 108) - d, Offset(x, 108) + d, stroke(const Color(0xFF546E7A), 2));
      }
    }
  }

  @override
  bool shouldRepaint(WagonPainter old) => old.roll != roll || old.blink != blink;
}
