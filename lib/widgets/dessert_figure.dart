import 'dart:math';

import 'package:flutter/material.dart';

import '../data/models.dart';

Paint fill(Color c) => Paint()..color = c;

Paint stroke(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round;

/// A dessert character, drawn in code. [jailed] puts them behind bars.
class DessertFigure extends StatelessWidget {
  const DessertFigure(
    this.dessert, {
    super.key,
    this.width = 100,
    this.jailed = false,
  });

  final Dessert dessert;
  final double width;
  final bool jailed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 1.3,
      child: CustomPaint(
        painter: _DessertPainter(dessert),
        foregroundPainter: jailed ? _BarsPainter() : null,
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final bar = stroke(const Color(0xFF37474F), s.width * .06);
    for (var i = 0; i < 5; i++) {
      final x = s.width * (.1 + i * .2);
      c.drawLine(Offset(x, 0), Offset(x, s.height), bar);
    }
    c.drawLine(Offset.zero, Offset(s.width, 0), bar);
    c.drawLine(Offset(0, s.height), Offset(s.width, s.height), bar);
  }

  @override
  bool shouldRepaint(_BarsPainter old) => false;
}

class _DessertPainter extends CustomPainter {
  _DessertPainter(this.dessert);

  final Dessert dessert;

  static const _dark = Color(0xFF3B2314);

  late Canvas c;
  late double w, h;

  Offset o(double x, double y) => Offset(w * x, h * y);

  Rect r(double l, double t, double right, double b) =>
      Rect.fromLTRB(w * l, h * t, w * right, h * b);

  RRect rr(double l, double t, double right, double b, double rad) =>
      RRect.fromRectAndRadius(r(l, t, right, b), Radius.circular(w * rad));

  void eyes(double y, {double gap = .11, double size = .055}) {
    for (final sx in [-1.0, 1.0]) {
      c.drawCircle(o(.5 + sx * gap, y), w * size, fill(Colors.white));
      c.drawCircle(o(.5 + sx * gap + .012, y + .004), w * size * .5, fill(_dark));
    }
  }

  void smile(double y, {double width = .1}) {
    c.drawArc(
      Rect.fromCenter(center: o(.5, y), width: w * width * 2, height: w * width * 1.2),
      .15 * pi,
      .7 * pi,
      false,
      stroke(_dark, w * .025),
    );
  }

  void feet(double y, {double gap = .13}) {
    for (final sx in [-1.0, 1.0]) {
      c.drawOval(
        Rect.fromCenter(center: o(.5 + sx * gap, y), width: w * .2, height: h * .05),
        fill(_dark),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    c = canvas;
    w = size.width;
    h = size.height;
    c.drawOval(
      Rect.fromCenter(center: o(.5, .965), width: w * .8, height: h * .06),
      fill(Colors.black38),
    );
    switch (dessert) {
      case Dessert.churro:
        _churro();
      case Dessert.donutPink:
        _donut(const Color(0xFFF48FB1), sprinkles: true);
      case Dessert.donutGlazed:
        _donut(const Color(0xFFFFF1CC), sprinkles: false);
      case Dessert.pannaCotta:
        _pannaCotta();
      case Dessert.tart:
        _tart();
      case Dessert.tiramisu:
        _tiramisu();
      case Dessert.cannoli:
        _cannoli();
      case Dessert.cracker:
        _cracker();
    }
  }

  void _churro() {
    feet(.95, gap: .1);
    c.drawRRect(rr(.32, .2, .68, .93, .16), fill(const Color(0xFFD08A3A)));
    final ridge = stroke(const Color(0xFFA9692A), w * .025);
    for (final x in [.41, .5, .59]) {
      c.drawLine(o(x, .52), o(x, .88), ridge);
    }
    const sugar = [
      (.37, .6), (.45, .7), (.55, .62), (.63, .74), (.38, .82), (.54, .84),
      (.62, .56), (.46, .56),
    ];
    for (final (x, y) in sugar) {
      c.drawCircle(o(x, y), w * .013, fill(Colors.white));
    }
    // Deerstalker hat.
    const tweed = Color(0xFF7A5C3E);
    c.drawOval(r(.16, .2, .4, .28), fill(const Color(0xFF5E452D)));
    c.drawOval(r(.6, .2, .84, .28), fill(const Color(0xFF5E452D)));
    c.drawArc(r(.27, .06, .73, .42), pi, pi, true, fill(tweed));
    c.drawCircle(o(.5, .07), w * .03, fill(const Color(0xFF5E452D)));
    eyes(.36, gap: .09);
    smile(.44, width: .07);
    // Magnifying glass.
    c.drawLine(o(.68, .62), o(.8, .58), stroke(const Color(0xFFD08A3A), w * .05));
    c.drawLine(o(.84, .6), o(.9, .72), stroke(_dark, w * .04));
    c.drawCircle(o(.82, .52), w * .1, fill(const Color(0x66B3E5FC)));
    c.drawCircle(o(.82, .52), w * .1, stroke(const Color(0xFFFFD54F), w * .03));
  }

  void _donut(Color icing, {required bool sprinkles}) {
    feet(.95);
    final centre = o(.5, .58);
    final radius = w * .4;
    c.drawCircle(centre, radius, fill(const Color(0xFFDDA35B)));
    c.drawCircle(centre.translate(0, -radius * .06), radius * .86, fill(icing));
    // The hole doubles as a surprised mouth.
    c.drawCircle(centre.translate(0, radius * .25), radius * .2, fill(const Color(0xFF5A3A1A)));
    if (sprinkles) {
      const colours = [Color(0xFF42A5F5), Color(0xFFFFEE58), Color(0xFF66BB6A), Colors.white];
      const spots = [
        (-.6, -.1, .5), (-.4, -.55, 1.2), (.1, -.7, .2), (.5, -.45, 2.0),
        (.65, .05, .9), (-.55, .4, 1.7), (.45, .5, .4), (0.0, .62, 1.1),
      ];
      for (var i = 0; i < spots.length; i++) {
        final (x, y, angle) = spots[i];
        final p = centre.translate(radius * x, radius * y);
        final d = Offset(cos(angle), sin(angle)) * (w * .03);
        c.drawLine(p - d, p + d, stroke(colours[i % colours.length], w * .025));
      }
    }
    for (final sx in [-1.0, 1.0]) {
      final e = centre.translate(sx * radius * .3, -radius * .22);
      c.drawCircle(e, w * .055, fill(Colors.white));
      c.drawCircle(e.translate(w * .01, w * .005), w * .028, fill(_dark));
    }
    // Police cap.
    const navy = Color(0xFF1A2A5E);
    c.drawRRect(rr(.28, .1, .72, .25, .06), fill(navy));
    c.drawRRect(rr(.22, .22, .78, .28, .03), fill(const Color(0xFF0E1838)));
    c.drawCircle(o(.5, .17), w * .04, fill(const Color(0xFFFFD54F)));
  }

  void _pannaCotta() {
    c.drawOval(r(.06, .86, .94, .97), fill(const Color(0xFFECEFF1)));
    final body = Path()
      ..moveTo(w * .14, h * .92)
      ..lineTo(w * .27, h * .42)
      ..quadraticBezierTo(w * .5, h * .3, w * .73, h * .42)
      ..lineTo(w * .86, h * .92)
      ..close();
    c.drawPath(body, fill(const Color(0xFFFFF8E7)));
    final sauce = Path()
      ..moveTo(w * .26, h * .46)
      ..quadraticBezierTo(w * .5, h * .28, w * .74, h * .46)
      ..quadraticBezierTo(w * .72, h * .6, w * .66, h * .5)
      ..quadraticBezierTo(w * .58, h * .62, w * .5, h * .5)
      ..quadraticBezierTo(w * .4, h * .6, w * .36, h * .5)
      ..quadraticBezierTo(w * .28, h * .58, w * .26, h * .46)
      ..close();
    c.drawPath(sauce, fill(const Color(0xFFC62828)));
    // Housekeeper's frilled cap.
    for (var i = 0; i < 5; i++) {
      c.drawCircle(o(.34 + i * .08, .31), w * .055, fill(Colors.white));
    }
    eyes(.68);
    smile(.76);
  }

  void _tart() {
    feet(.95, gap: .16);
    // Fruit piled on top.
    const fruit = [
      (.24, .47, Color(0xFFD32F2F)), (.4, .43, Color(0xFF3949AB)),
      (.56, .44, Color(0xFFD32F2F)), (.72, .47, Color(0xFF3949AB)),
      (.32, .5, Color(0xFF7B1FA2)), (.48, .5, Color(0xFFD32F2F)),
      (.64, .5, Color(0xFF7B1FA2)),
    ];
    c.drawOval(r(.1, .44, .9, .6), fill(const Color(0xFFFFE082)));
    for (final (x, y, colour) in fruit) {
      c.drawCircle(o(x, y), w * .085, fill(colour));
      c.drawCircle(o(x - .02, y - .015), w * .02, fill(Colors.white54));
    }
    c.drawCircle(o(.52, .37), w * .03, fill(const Color(0xFF388E3C)));
    c.drawOval(r(.52, .33, .66, .39), fill(const Color(0xFF43A047)));
    final crust = Path()
      ..moveTo(w * .08, h * .52)
      ..lineTo(w * .92, h * .52)
      ..lineTo(w * .8, h * .92)
      ..lineTo(w * .2, h * .92)
      ..close();
    c.drawPath(crust, fill(const Color(0xFFD9A05B)));
    final flute = stroke(const Color(0xFFB57F3E), w * .02);
    for (var i = 0; i <= 8; i++) {
      final t = i / 8;
      c.drawLine(o(.08 + t * .84, .52), o(.2 + t * .6, .92), flute);
    }
    c.drawRRect(rr(.26, .6, .74, .86, .08), fill(const Color(0xFFD9A05B)));
    eyes(.69);
    smile(.77);
  }

  void _tiramisu() {
    feet(.95, gap: .14);
    const cream = Color(0xFFF7EBD0);
    const sponge = Color(0xFF9A6233);
    c.save();
    c.clipRRect(rr(.2, .26, .8, .93, .06));
    c.drawRect(r(.2, .26, .8, .93), fill(cream));
    c.drawRect(r(.2, .26, .8, .33), fill(const Color(0xFF4E2C14)));
    c.drawRect(r(.2, .58, .8, .66), fill(sponge));
    c.drawRect(r(.2, .8, .8, .88), fill(sponge));
    c.restore();
    // Bow.
    const pink = Color(0xFFEC407A);
    c.drawPath(
      Path()..addPolygon([o(.5, .22), o(.34, .14), o(.34, .29)], true),
      fill(pink),
    );
    c.drawPath(
      Path()..addPolygon([o(.5, .22), o(.66, .14), o(.66, .29)], true),
      fill(pink),
    );
    c.drawCircle(o(.5, .22), w * .04, fill(const Color(0xFFC2185B)));
    eyes(.43);
    final lash = stroke(_dark, w * .018);
    for (final sx in [-1.0, 1.0]) {
      c.drawLine(o(.5 + sx * .15, .4), o(.5 + sx * .2, .375), lash);
    }
    smile(.5, width: .07);
    // Pearls.
    for (var i = 0; i < 7; i++) {
      final t = (i - 3) / 3;
      c.drawCircle(o(.5 + t * .22, .74 - t * t * .05), w * .028, fill(Colors.white));
    }
  }

  void _cannoli() {
    feet(.95, gap: .1);
    // Ricotta poking out of both ends.
    for (final (x, y) in [(.4, .2), (.5, .16), (.6, .2)]) {
      c.drawCircle(o(x, y), w * .11, fill(Colors.white));
    }
    c.drawCircle(o(.44, .15), w * .018, fill(_dark));
    c.drawCircle(o(.57, .13), w * .018, fill(_dark));
    c.drawOval(r(.32, .86, .68, .95), fill(Colors.white));
    c.drawRRect(rr(.3, .2, .7, .9, .1), fill(const Color(0xFFC8843C)));
    final bubble = stroke(const Color(0xFFA5662A), w * .018);
    for (final (x, y) in [(.37, .3), (.62, .56), (.38, .8), (.6, .84), (.63, .28)]) {
      c.drawCircle(o(x, y), w * .03, bubble);
    }
    eyes(.38, gap: .09);
    c.drawCircle(o(.59, .38), w * .08, stroke(const Color(0xFFFFD54F), w * .02));
    c.drawLine(o(.65, .42), o(.68, .56), stroke(const Color(0xFFFFD54F), w * .012));
    // Moustache.
    final tache = stroke(const Color(0xFFECEFF1), w * .05);
    c.drawArc(r(.34, .43, .5, .53), 0, pi, false, tache);
    c.drawArc(r(.5, .43, .66, .53), 0, pi, false, tache);
    // Medals.
    for (final (x, colour) in [(.4, Color(0xFFD32F2F)), (.5, Color(0xFF1976D2))]) {
      c.drawRect(r(x - .025, .62, x + .025, .68), fill(colour));
      c.drawCircle(o(x, .71), w * .04, fill(const Color(0xFFFFD54F)));
    }
  }

  void _cracker() {
    feet(.95, gap: .16);
    c.drawRRect(rr(.16, .28, .84, .92, .05), fill(const Color(0xFFB98443)));
    c.drawRRect(rr(.19, .3, .81, .9, .04), fill(const Color(0xFFD8A55C)));
    c.drawLine(o(.19, .62), o(.81, .62), stroke(const Color(0xFFB98443), w * .015));
    for (final x in [.27, .5, .73]) {
      for (final y in [.35, .84]) {
        c.drawCircle(o(x, y), w * .018, fill(const Color(0xFFA06F33)));
      }
    }
    eyes(.46);
    // Stiff upper lip.
    c.drawLine(o(.44, .55), o(.56, .55), stroke(_dark, w * .025));
    // Bow tie.
    c.drawPath(
      Path()..addPolygon([o(.5, .72), o(.36, .66), o(.36, .78)], true),
      fill(_dark),
    );
    c.drawPath(
      Path()..addPolygon([o(.5, .72), o(.64, .66), o(.64, .78)], true),
      fill(_dark),
    );
    c.drawCircle(o(.5, .72), w * .03, fill(const Color(0xFF6D1B1B)));
  }

  @override
  bool shouldRepaint(_DessertPainter old) => old.dessert != dessert;
}
