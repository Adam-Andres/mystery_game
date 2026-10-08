import 'dart:math';

import 'package:flutter/material.dart';

import '../audio/voice.dart';
import '../data/models.dart';

Paint fill(Color c) => Paint()..color = c;

Paint stroke(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round;

/// A dessert character, drawn in code. [jailed] puts them
/// behind bars; [animate] gives them their idle animation, and with it
/// their mouth moves whenever the voice named [speaker] is talking.
class DessertFigure extends StatefulWidget {
  const DessertFigure(
    this.dessert, {
    super.key,
    this.width = 100,
    this.jailed = false,
    this.animate = false,
    this.speaker,
  });

  final Dessert dessert;
  final double width;
  final bool jailed;
  final bool animate;
  final String? speaker;

  @override
  State<DessertFigure> createState() => _DessertFigureState();
}

class _DessertFigureState extends State<DessertFigure>
    with SingleTickerProviderStateMixin {
  /// Every idle animation loops seamlessly over this many seconds.
  static const _loop = 12.0;

  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (_loop * 1000).round()),
  );

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(DessertFigure old) {
    super.didUpdateWidget(old);
    if (old.animate != widget.animate) _sync();
  }

  void _sync() {
    if (widget.animate) {
      _idle.repeat();
    } else {
      _idle.stop();
    }
  }

  @override
  void dispose() {
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Size(widget.width, widget.width * 1.3);

    final speaker = widget.speaker;
    final voice = speaker == null ? null : VoiceScope.maybeOf(context);

    Widget paint(double? time, [double talk = 0]) => CustomPaint(
      size: size,
      painter: _DessertPainter(widget.dessert, time: time, talk: talk),
      foregroundPainter: widget.jailed ? _BarsPainter() : null,
    );

    if (!widget.animate) return paint(null);
    return AnimatedBuilder(
      animation: _idle,
      builder: (context, _) {
        // Each dessert starts at a different point in the loop.
        final offset = widget.dessert.index * 1.7;
        final time = (_idle.value * _loop + offset) % _loop;
        if (voice == null || !voice.isSpeaking(speaker!)) return paint(time);
        // Syllables of uneven length, never quite shut.
        final talk =
            .15 +
            .85 *
                sin(time * 2 * pi * 3.5).abs() *
                (.65 + .35 * sin(time * 2 * pi * 1.25));
        return paint(time, talk);
      },
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
  _DessertPainter(this.dessert, {required this.time, this.talk = 0});

  final Dessert dessert;

  /// Seconds into the idle loop, or null for a still pose.
  final double? time;

  /// How far open the mouth is while speaking, from 0 to 1; 0 when silent.
  final double talk;

  static const _dark = Color(0xFF3B2314);

  late Canvas c;
  late double w, h;

  double get _t => time ?? 0;

  /// A smooth wave with the given period in seconds; flat when still.
  double _wave(double period, [double phase = 0]) =>
      time == null ? 0 : sin(2 * pi * (_t / period + phase));

  /// True for a moment every few seconds.
  bool get _blinking => time != null && (_t % 4) > 3.8;

  Paint _line(Color color, double width) => stroke(color, width);

  Offset o(double x, double y) => Offset(w * x, h * y);

  Rect r(double l, double t, double right, double b) =>
      Rect.fromLTRB(w * l, h * t, w * right, h * b);

  RRect rr(double l, double t, double right, double b, double rad) =>
      RRect.fromRectAndRadius(r(l, t, right, b), Radius.circular(w * rad));

  void eyes(double y, {double gap = .11, double size = .055}) {
    for (final sx in [-1.0, 1.0]) {
      final centre = o(.5 + sx * gap, y);
      if (_blinking) {
        c.drawLine(
          centre.translate(-w * size, 0),
          centre.translate(w * size, 0),
          _line(_dark, w * .025),
        );
      } else {
        c.drawCircle(centre, w * size, fill(Colors.white));
        c.drawCircle(
          o(.5 + sx * gap + .012, y + .004),
          w * size * .5,
          fill(_dark),
        );
      }
    }
  }

  /// An open mouth centred on [centre], [width] across at its widest.
  void _mouth(Offset centre, double width) {
    final box = Rect.fromCenter(
      center: centre,
      width: width * (.75 + .25 * talk),
      height: width * (.2 + .7 * talk),
    );
    c.drawOval(box, fill(const Color(0xFF3A1410)));
    c.drawOval(box, _line(_dark, w * .02));
  }

  void smile(double y, {double width = .1}) {
    if (talk > 0) {
      return _mouth(o(.5, y).translate(0, w * width * .42), w * width * 1.5);
    }
    c.drawArc(
      Rect.fromCenter(
        center: o(.5, y),
        width: w * width * 2,
        height: w * width * 1.2,
      ),
      .15 * pi,
      .7 * pi,
      false,
      _line(_dark, w * .025),
    );
  }

  void feet(double y, {double gap = .13}) {
    for (final sx in [-1.0, 1.0]) {
      c.drawOval(
        Rect.fromCenter(
          center: o(.5 + sx * gap, y),
          width: w * .2,
          height: h * .05,
        ),
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

    c.save();
    _pose();
    _draw();
    c.restore();
  }

  /// The idle motion of the whole body, pivoting about the feet.
  void _pose() {
    if (time == null) return;
    final breath = _wave(2);
    c.translate(w / 2, h * .95);
    switch (dessert) {
      case Dessert.pannaCotta:
        // She wobbles.
        c.skew(_wave(1.5) * .05, 0);
        c.scale(1 - breath * .01, 1 + breath * .02);
      case Dessert.donutPink || Dessert.donutGlazed || Dessert.donutChocolate:
        // The donuts rock on their heels.
        c.translate(0, -(_wave(3).abs()) * h * .02);
        c.rotate(_wave(3) * .03);
      case Dessert.cracker:
        // A butler does not fidget. He breathes, barely.
        c.scale(1, 1 + breath * .008);
      default:
        c.scale(1 - breath * .012, 1 + breath * .022);
    }
    c.translate(-w / 2, -h * .95);
  }

  void _draw() {
    switch (dessert) {
      case Dessert.churro:
        _churro();
      case Dessert.donutPink:
        _donut(const Color(0xFFF48FB1), sprinkles: true);
      case Dessert.donutGlazed:
        _donut(const Color(0xFFFFF1CC), sprinkles: false);
      case Dessert.donutChocolate:
        _donut(const Color(0xFF5D3A1A), sprinkles: false, doctor: true);
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
    const dough = Color(0xFFD08A3A);
    feet(.95, gap: .1);
    c.drawRRect(rr(.32, .2, .68, .93, .16), fill(dough));
    final ridge = _line(const Color(0xFFA9692A), w * .025);
    for (final x in [.41, .5, .59]) {
      c.drawLine(o(x, .54), o(x, .88), ridge);
    }
    const sugar = [
      (.37, .6),
      (.45, .7),
      (.55, .62),
      (.63, .74),
      (.38, .82),
      (.54, .84),
      (.62, .56),
      (.46, .58),
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

    // Pipe, clamped in the corner of his mouth, with a curl of smoke.
    const briar = Color(0xFF5D3A1A);
    c.drawLine(
      o(.43, .455),
      o(.29, .475),
      _line(const Color(0xFF2A1810), w * .03),
    );
    c.drawRRect(rr(.2, .41, .3, .5, .02), fill(briar));
    c.drawRect(r(.21, .405, .29, .425), fill(const Color(0xFFFF8F00)));
    for (var i = 0; i < 2; i++) {
      final rise = time == null ? .35 + i * .4 : (_t / 3 + i * .5) % 1;
      c.drawCircle(
        o(.25 + sin(rise * 5 + i) * .03, .39 - rise * .22),
        w * (.025 + rise * .03),
        fill(Colors.white.withValues(alpha: .7 * (1 - rise))),
      );
    }

    // Magnifying glass, gripped by the handle and held up to look through.
    final lift = _wave(3) * .012;
    final hand = o(.78, .67 + lift);
    c.drawLine(o(.66, .62), hand, _line(dough, w * .055));
    c.drawLine(
      hand,
      o(.84, .55 + lift),
      _line(const Color(0xFF2A1810), w * .045),
    );
    c.drawCircle(hand, w * .035, fill(dough));
    c.drawCircle(o(.87, .45 + lift), w * .1, fill(const Color(0x88B3E5FC)));
    c.drawCircle(
      o(.87, .45 + lift),
      w * .1,
      _line(const Color(0xFFFFD54F), w * .03),
    );
    c.drawLine(
      o(.83, .41 + lift),
      o(.86, .39 + lift),
      _line(Colors.white70, w * .02),
    );
  }

  /// A donut: one of the officers, or, with [doctor], Watsonut in his
  /// bowler hat, monocle and moustache.
  void _donut(Color icing, {required bool sprinkles, bool doctor = false}) {
    feet(.95);
    final centre = o(.5, .58);
    final radius = w * .4;
    c.drawCircle(centre, radius, fill(const Color(0xFFDDA35B)));
    c.drawCircle(centre.translate(0, -radius * .06), radius * .86, fill(icing));
    // The hole doubles as a surprised mouth.
    // It opens downward from under the moustache when he talks.
    final gape = radius * (talk > 0 ? .25 + .42 * talk : .4);
    c.drawOval(
      Rect.fromLTWH(
        centre.dx - radius * (talk > 0 ? .17 + .06 * talk : .2),
        centre.dy + radius * .05,
        radius * (talk > 0 ? .34 + .12 * talk : .4),
        gape,
      ),
      fill(const Color(0xFF5A3A1A)),
    );
    if (sprinkles) {
      const colours = [
        Color(0xFF42A5F5),
        Color(0xFFFFEE58),
        Color(0xFF66BB6A),
        Colors.white,
      ];
      const spots = [
        (-.6, -.1, .5),
        (-.4, -.55, 1.2),
        (.1, -.7, .2),
        (.5, -.45, 2.0),
        (.65, .05, .9),
        (-.55, .4, 1.7),
        (.45, .5, .4),
        (0.0, .62, 1.1),
      ];
      for (var i = 0; i < spots.length; i++) {
        final (x, y, angle) = spots[i];
        final p = centre.translate(radius * x, radius * y);
        final d = Offset(cos(angle), sin(angle)) * (w * .03);
        c.drawLine(p - d, p + d, _line(colours[i % colours.length], w * .025));
      }
    }
    for (final sx in [-1.0, 1.0]) {
      final e = centre.translate(sx * radius * .3, -radius * .22);
      if (_blinking) {
        c.drawLine(
          e.translate(-w * .05, 0),
          e.translate(w * .05, 0),
          _line(_dark, w * .025),
        );
      } else {
        c.drawCircle(e, w * .055, fill(Colors.white));
        c.drawCircle(e.translate(w * .01, w * .005), w * .028, fill(_dark));
      }
    }
    if (doctor) {
      // A doctor's moustache, a bowler hat, and a chocolate drizzle.
      final drizzle = _line(const Color(0xFF3B2314), w * .03);
      for (final x in [-.5, -.15, .2, .55]) {
        c.drawLine(
          centre.translate(radius * x, -radius * .62),
          centre.translate(radius * (x - .12), -radius * .38),
          drizzle,
        );
      }
      final tache = _line(const Color(0xFFF5E6C8), w * .045);
      c.drawArc(
        Rect.fromCenter(
          center: centre.translate(-radius * .2, radius * .02),
          width: w * .16,
          height: w * .1,
        ),
        0,
        pi,
        false,
        tache,
      );
      c.drawArc(
        Rect.fromCenter(
          center: centre.translate(radius * .2, radius * .02),
          width: w * .16,
          height: w * .1,
        ),
        0,
        pi,
        false,
        tache,
      );
      // Monocle over his right eye, on a fine chain.
      final monocle = centre.translate(radius * .3, -radius * .22);
      c.drawCircle(monocle, w * .085, _line(const Color(0xFFFFD54F), w * .022));
      c.drawLine(
        monocle.translate(w * .07, w * .05),
        centre.translate(radius * .62, radius * .5),
        _line(const Color(0xFFFFD54F), w * .012),
      );
      if (time != null && (_t % 5) > 4.6) {
        c.drawLine(
          monocle.translate(-w * .04, -w * .04),
          monocle.translate(w * .01, -w * .06),
          _line(Colors.white, w * .02),
        );
      }
      const felt = Color(0xFF1E1E22);
      c.drawArc(r(.3, .04, .7, .36), pi, pi, true, fill(felt));
      c.drawRRect(rr(.2, .19, .8, .24, .03), fill(felt));
      c.drawRect(r(.3, .16, .7, .195), fill(const Color(0xFF6D1B1B)));
      return;
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
    // Fruit piled on top, jostling a little.
    const fruit = [
      (.24, .47, Color(0xFFD32F2F)),
      (.4, .43, Color(0xFF3949AB)),
      (.56, .44, Color(0xFFD32F2F)),
      (.72, .47, Color(0xFF3949AB)),
      (.32, .5, Color(0xFF7B1FA2)),
      (.48, .5, Color(0xFFD32F2F)),
      (.64, .5, Color(0xFF7B1FA2)),
    ];
    c.drawOval(r(.1, .44, .9, .6), fill(const Color(0xFFFFE082)));
    for (var i = 0; i < fruit.length; i++) {
      final (x, y, colour) = fruit[i];
      final bob = _wave(2, i * .13) * .008;
      c.drawCircle(o(x, y + bob), w * .085, fill(colour));
      c.drawCircle(o(x - .02, y - .015 + bob), w * .02, fill(Colors.white54));
    }
    c.drawCircle(o(.52, .37), w * .03, fill(const Color(0xFF388E3C)));
    c.drawOval(
      r(.52, .33, .66, .39).shift(Offset(0, _wave(2) * h * .008)),
      fill(const Color(0xFF43A047)),
    );
    final crust = Path()
      ..moveTo(w * .08, h * .52)
      ..lineTo(w * .92, h * .52)
      ..lineTo(w * .8, h * .92)
      ..lineTo(w * .2, h * .92)
      ..close();
    c.drawPath(crust, fill(const Color(0xFFD9A05B)));
    final flute = _line(const Color(0xFFB57F3E), w * .02);
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
    // Bow, which flutters now and then.
    const pink = Color(0xFFEC407A);
    final flutter = _wave(1, .25) > .8 ? .03 : 0.0;
    c.drawPath(
      Path()..addPolygon([
        o(.5, .22),
        o(.34, .14 - flutter),
        o(.34, .29 + flutter),
      ], true),
      fill(pink),
    );
    c.drawPath(
      Path()..addPolygon([
        o(.5, .22),
        o(.66, .14 - flutter),
        o(.66, .29 + flutter),
      ], true),
      fill(pink),
    );
    c.drawCircle(o(.5, .22), w * .04, fill(const Color(0xFFC2185B)));
    eyes(.43);
    final lash = _line(_dark, w * .018);
    for (final sx in [-1.0, 1.0]) {
      c.drawLine(o(.5 + sx * .15, .4), o(.5 + sx * .2, .375), lash);
    }
    smile(.5, width: .07);
    // Pearls.
    for (var i = 0; i < 7; i++) {
      final t = (i - 3) / 3;
      c.drawCircle(
        o(.5 + t * .22, .74 - t * t * .05),
        w * .028,
        fill(Colors.white),
      );
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
    final bubble = _line(const Color(0xFFA5662A), w * .018);
    for (final (x, y) in [
      (.37, .3),
      (.62, .56),
      (.38, .8),
      (.6, .84),
      (.63, .28),
    ]) {
      c.drawCircle(o(x, y), w * .03, bubble);
    }
    eyes(.38, gap: .09);
    c.drawCircle(o(.59, .38), w * .08, _line(const Color(0xFFFFD54F), w * .02));
    c.drawLine(
      o(.65, .42),
      o(.68, .56),
      _line(const Color(0xFFFFD54F), w * .012),
    );
    // The monocle catches the light now and then.
    if (time != null && (_t % 5) > 4.6) {
      c.drawLine(o(.55, .35), o(.6, .33), _line(Colors.white, w * .02));
    }
    // Moustache, which bristles when he huffs.
    if (talk > 0) _mouth(o(.5, .455).translate(0, w * .05), w * .13);
    final huff = talk > 0 ? talk * .014 : (_wave(1.5) > .7 ? .012 : 0.0);
    final tache = _line(const Color(0xFFECEFF1), w * .05);
    c.drawArc(r(.34, .43 - huff, .5, .53 - huff), 0, pi, false, tache);
    c.drawArc(r(.5, .43 - huff, .66, .53 - huff), 0, pi, false, tache);
    // Medals.
    for (final (x, colour) in [
      (.4, Color(0xFFD32F2F)),
      (.5, Color(0xFF1976D2)),
    ]) {
      c.drawRect(r(x - .025, .62, x + .025, .68), fill(colour));
      c.drawCircle(o(x, .71), w * .04, fill(const Color(0xFFFFD54F)));
    }
  }

  void _cracker() {
    feet(.95, gap: .16);
    c.drawRRect(rr(.16, .28, .84, .92, .05), fill(const Color(0xFFB98443)));
    c.drawRRect(rr(.19, .3, .81, .9, .04), fill(const Color(0xFFD8A55C)));
    c.drawLine(
      o(.19, .62),
      o(.81, .62),
      _line(const Color(0xFFB98443), w * .015),
    );
    for (final x in [.27, .5, .73]) {
      for (final y in [.35, .84]) {
        c.drawCircle(o(x, y), w * .018, fill(const Color(0xFFA06F33)));
      }
    }
    eyes(.46);
    // Stiff upper lip.
    if (talk > .3) {
      // Which parts only as far as it must.
      _mouth(o(.5, .55), w * .11);
    } else {
      c.drawLine(o(.44, .55), o(.56, .55), _line(_dark, w * .025));
    }
    // Bow tie, straightened with a twitch from time to time.
    final twitch = time != null && (_t % 6) > 5.6 ? .02 : 0.0;
    c.drawPath(
      Path()..addPolygon([
        o(.5, .72),
        o(.36, .66 - twitch),
        o(.36, .78 - twitch),
      ], true),
      fill(_dark),
    );
    c.drawPath(
      Path()..addPolygon([
        o(.5, .72),
        o(.64, .66 + twitch),
        o(.64, .78 + twitch),
      ], true),
      fill(_dark),
    );
    c.drawCircle(o(.5, .72), w * .03, fill(const Color(0xFF6D1B1B)));
  }

  @override
  bool shouldRepaint(_DessertPainter old) =>
      old.dessert != dessert || old.time != time || old.talk != talk;
}
