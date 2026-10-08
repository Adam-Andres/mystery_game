import 'dart:math';

import 'package:flutter/material.dart';

import '../data/house.dart';
import '../data/models.dart';
import 'dessert_figure.dart' show fill, stroke;

const _wood = Color(0xFF6B4226);
const _darkWood = Color(0xFF4A2C1A);
const _lightWood = Color(0xFF9C6B3F);
const _brass = Color(0xFFD4A537);

/// Paints a room's backdrop at scene size (960x540). [caseId] switches the few
/// props that differ between mysteries, such as the espresso urn.
class RoomPainter extends CustomPainter {
  RoomPainter(this.room, {required this.caseId});

  final Room room;
  final String caseId;

  late Canvas c;

  bool get _brew => caseId == 'brew';

  @override
  void paint(Canvas canvas, Size size) {
    c = canvas;
    _shell();
    switch (room.id) {
      case 'entrance':
        _entrance();
      case 'parlor':
        _parlor();
      case 'dining':
        _dining();
      case 'kitchen':
        _kitchen();
      case 'pantry':
        _pantry();
      case 'cellar':
        _cellar();
      case 'boiler':
        _boiler();
      case 'landing':
        _landing();
      case 'study':
        _study();
      case 'bedroom':
        _bedroom();
      case 'storage':
        _storage();
    }
    final bounds = Offset.zero & size;
    c.drawRect(
      bounds,
      Paint()
        ..shader = const RadialGradient(
          radius: .9,
          colors: [Colors.transparent, Colors.black54],
          stops: [.65, 1],
        ).createShader(bounds),
    );
  }

  @override
  bool shouldRepaint(RoomPainter old) =>
      old.room.id != room.id || old.caseId != caseId;

  // Shared pieces

  void _rect(double x, double y, double w, double h, Color col, [double r = 0]) {
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r)),
      fill(col),
    );
  }

  void _shell() {
    c.drawRect(const Rect.fromLTWH(0, 0, sceneW, floorY), fill(room.wall));
    switch (room.level) {
      case 0:
        // Stone blocks.
        final mortar = stroke(Colors.black26, 2);
        var row = 0;
        for (var y = 0.0; y < floorY; y += 50) {
          c.drawLine(Offset(0, y), Offset(sceneW, y), mortar);
          for (var x = row.isEven ? 0.0 : 60.0; x < sceneW; x += 120) {
            c.drawLine(Offset(x, y), Offset(x, y + 50), mortar);
          }
          row++;
        }
      case 1:
        // Striped wallpaper.
        for (var x = 0.0; x < sceneW; x += 48) {
          c.drawRect(Rect.fromLTWH(x, 0, 24, floorY), fill(Colors.white.withValues(alpha: .05)));
        }
        _rect(0, 0, sceneW, 14, Colors.black26);
      case 2:
        // Planked walls under a sloping roof.
        final gap = stroke(Colors.black12, 2);
        for (var y = 44.0; y < floorY; y += 44) {
          c.drawLine(Offset(0, y), Offset(sceneW, y), gap);
        }
        const roof = Color(0xFF3A2A1C);
        c.drawPath(
          Path()..addPolygon(const [Offset.zero, Offset(220, 0), Offset(0, 170)], true),
          fill(roof),
        );
        c.drawPath(
          Path()
            ..addPolygon(
              const [Offset(sceneW, 0), Offset(sceneW - 220, 0), Offset(sceneW, 170)],
              true,
            ),
          fill(roof),
        );
        final rafter = stroke(const Color(0xFF2A1D12), 10);
        c.drawLine(const Offset(220, 0), const Offset(0, 170), rafter);
        c.drawLine(const Offset(sceneW - 220, 0), const Offset(sceneW, 170), rafter);
    }
    c.drawRect(const Rect.fromLTWH(0, floorY, sceneW, sceneH - floorY), fill(room.floor));
    final board = stroke(Colors.black12, 2);
    for (var i = -12; i <= 12; i++) {
      c.drawLine(Offset(480 + i * 60, floorY), Offset(480 + i * 115, sceneH), board);
    }
    _rect(0, floorY - 12, sceneW, 12, Colors.black38);
  }

  void _window(double x, double y, double w, double h) {
    _rect(x - 8, y - 8, w + 16, h + 16, _darkWood, 4);
    _rect(x, y, w, h, const Color(0xFF9FD3F0));
    c.drawCircle(Offset(x + w * .3, y + h * .35), h * .12, fill(Colors.white70));
    c.drawCircle(Offset(x + w * .42, y + h * .32), h * .15, fill(Colors.white70));
    final bar = stroke(_darkWood, 5);
    c.drawLine(Offset(x + w / 2, y), Offset(x + w / 2, y + h), bar);
    c.drawLine(Offset(x, y + h / 2), Offset(x + w, y + h / 2), bar);
    _rect(x - 14, y + h + 6, w + 28, 8, _wood, 2);
  }

  void _picture(double x, double y, double w, double h, Color col) {
    _rect(x - 6, y - 6, w + 12, h + 12, _brass, 2);
    _rect(x, y, w, h, col);
  }

  void _table(double x, double top, double w, double bottom, [Color col = _wood]) {
    _rect(x + 8, top + 10, 10, bottom - top - 10, _darkWood);
    _rect(x + w - 18, top + 10, 10, bottom - top - 10, _darkWood);
    _rect(x, top, w, 14, col, 3);
  }

  void _shelves(double x, double y, double w, double h, int rows) {
    _rect(x, y, w, h, _darkWood, 3);
    const jars = [
      Color(0xFFE57373), Color(0xFFFFD54F), Color(0xFF81C784), Color(0xFFBA68C8),
      Color(0xFFFFB74D), Color(0xFF90CAF9),
    ];
    final rowH = h / rows;
    var n = 0;
    for (var i = 0; i < rows; i++) {
      final base = y + (i + 1) * rowH - 6;
      _rect(x, base, w, 6, _lightWood);
      for (var jx = x + 12; jx < x + w - 26; jx += 34) {
        final jarH = rowH * (.45 + (n % 3) * .1);
        _rect(jx, base - jarH, 24, jarH, jars[n % jars.length], 4);
        _rect(jx + 3, base - jarH - 4, 18, 5, Colors.white70, 2);
        n++;
      }
    }
  }

  void _books(double x, double y, double w, double h, int rows) {
    _rect(x, y, w, h, _darkWood, 3);
    const spines = [
      Color(0xFF8D2B2B), Color(0xFF2B5D8D), Color(0xFF3E7B4A), Color(0xFF8D6B2B),
      Color(0xFF5B3E7B),
    ];
    final rowH = h / rows;
    var n = 0;
    for (var i = 0; i < rows; i++) {
      final base = y + (i + 1) * rowH - 6;
      _rect(x, base, w, 6, _lightWood);
      for (var bx = x + 8; bx < x + w - 16; bx += 15) {
        final bookH = rowH * (.6 + (n % 4) * .07);
        _rect(bx, base - bookH, 12, bookH, spines[n % spines.length], 1);
        n++;
      }
    }
  }

  void _barrel(double cx, double cy, double r) {
    c.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: r * 1.7, height: r * 2), fill(_lightWood));
    final hoop = stroke(const Color(0xFF424242), 5);
    c.drawLine(Offset(cx - r * .8, cy - r * .45), Offset(cx + r * .8, cy - r * .45), hoop);
    c.drawLine(Offset(cx - r * .8, cy + r * .45), Offset(cx + r * .8, cy + r * .45), hoop);
  }

  void _crate(double x, double y, double size) {
    _rect(x, y, size, size, _lightWood, 2);
    final slat = stroke(_wood, 4);
    c.drawRect(Rect.fromLTWH(x + 4, y + 4, size - 8, size - 8), slat);
    c.drawLine(Offset(x + 4, y + 4), Offset(x + size - 4, y + size - 4), slat);
  }

  void _trunk(double x, double y, double w, double h, Color col) {
    _rect(x, y, w, h, col, 10);
    _rect(x, y + h * .35, w, 6, _brass);
    _rect(x + w / 2 - 9, y + h * .3, 18, 20, _brass, 3);
  }

  void _hangingLamp(double x, double len) {
    c.drawLine(Offset(x, 0), Offset(x, len), stroke(Colors.black54, 3));
    c.drawCircle(Offset(x, len + 30), 70, fill(const Color(0x22FFE082)));
    c.drawPath(
      Path()..addPolygon([Offset(x - 26, len + 22), Offset(x + 26, len + 22), Offset(x + 12, len), Offset(x - 12, len)], true),
      fill(const Color(0xFF37474F)),
    );
    c.drawCircle(Offset(x, len + 26), 9, fill(const Color(0xFFFFE082)));
  }

  /// A flight of steps starting at [x0] and climbing in direction [dir].
  void _stairs(double x0, int dir) {
    const base = floorY + 30;
    for (var i = 0; i < 8; i++) {
      final x = dir > 0 ? x0 + i * 40 : x0 - (i + 1) * 40;
      final height = (i + 1) * 44.0;
      _rect(x, base - height, 40, height, i.isEven ? _wood : _lightWood);
      _rect(x, base - height, 40, 6, _darkWood);
    }
    final x1 = dir > 0 ? x0 : x0 - 40;
    final x2 = x0 + dir * 320;
    c.drawLine(Offset(x1, base - 110), Offset(x2, base - 110 - 352), stroke(_darkWood, 8));
  }

  void _urn(double cx, double cy) {
    final handle = stroke(_brass, 6);
    c.drawCircle(Offset(cx - 34, cy), 12, handle);
    c.drawCircle(Offset(cx + 34, cy), 12, handle);
    c.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 60, height: 84), fill(_brass));
    c.drawOval(Rect.fromCenter(center: Offset(cx - 10, cy - 10), width: 14, height: 40), fill(Colors.white30));
    _rect(cx - 22, cy - 50, 44, 10, const Color(0xFFB8892B), 4);
    c.drawCircle(Offset(cx, cy - 54), 6, fill(_brass));
    _rect(cx - 4, cy + 26, 8, 16, const Color(0xFF8D6E1F));
  }

  void _eclair(double cx, double cy, double w) {
    _rect(cx - w / 2, cy - w * .16, w, w * .32, const Color(0xFFE2B66E), w * .16);
    _rect(cx - w / 2, cy - w * .2, w, w * .18, const Color(0xFF4E2C14), w * .09);
    _rect(cx - w * .46, cy - w * .01, w * .92, w * .05, const Color(0xFFFFF3C4), 2);
  }

  // Ground floor

  void _entrance() {
    _picture(110, 100, 120, 90, const Color(0xFF5B3A4A));
    _eclair(170, 150, 80);
    // Front door.
    _rect(380, 96, 200, 254, _darkWood, 6);
    _rect(392, 108, 84, 242, _wood, 3);
    _rect(484, 108, 84, 242, _wood, 3);
    for (final x in [404.0, 496.0]) {
      _rect(x, 122, 60, 90, _darkWood, 2);
      _rect(x, 228, 60, 100, _darkWood, 2);
    }
    c.drawCircle(const Offset(470, 240), 6, fill(_brass));
    c.drawCircle(const Offset(490, 240), 6, fill(_brass));
    // Coat stand.
    c.drawLine(const Offset(290, 150), const Offset(290, 400), stroke(_darkWood, 8));
    c.drawLine(const Offset(265, 400), const Offset(315, 400), stroke(_darkWood, 8));
    c.drawLine(const Offset(270, 172), const Offset(310, 172), stroke(_darkWood, 6));
    _rect(296, 172, 30, 90, const Color(0xFF37474F), 8);
    _stairs(640, 1);
    // Doormat and the hatch down to the cellar.
    _rect(395, 410, 170, 34, const Color(0xFF7A6A4A), 4);
    c.drawPath(
      Path()..addPolygon(const [Offset(400, 478), Offset(560, 478), Offset(590, 540), Offset(370, 540)], true),
      fill(Colors.black87),
    );
    final step = stroke(Colors.white12, 3);
    c.drawLine(const Offset(395, 498), const Offset(565, 498), step);
    c.drawLine(const Offset(385, 518), const Offset(575, 518), step);
  }

  void _parlor() {
    _window(90, 90, 150, 150);
    _picture(430, 50, 100, 76, const Color(0xFF2E4A3A));
    c.drawCircle(const Offset(480, 88), 20, fill(const Color(0xFFD7CCC8)));
    // Fireplace.
    _rect(360, 170, 240, 180, const Color(0xFF8D8D8D), 4);
    _rect(410, 225, 140, 125, const Color(0xFF1B1B1B));
    c.drawCircle(const Offset(480, 330), 34, fill(const Color(0xFFE65100)));
    c.drawCircle(const Offset(462, 320), 22, fill(const Color(0xFFFF9800)));
    c.drawCircle(const Offset(495, 326), 18, fill(const Color(0xFFFFEB3B)));
    _rect(345, 158, 270, 16, _darkWood, 3);
    _books(800, 100, 130, 250, 4);
    // The Colonel's armchair.
    const green = Color(0xFF2E5D3A);
    _rect(200, 290, 100, 130, green, 16);
    _rect(186, 370, 128, 56, const Color(0xFF3C7A4C), 12);
    // Chess table.
    _table(400, 362, 110, 440);
    for (var i = 0; i < 6; i++) {
      for (var j = 0; j < 2; j++) {
        _rect(419 + i * 12, 348 + j * 7, 12, 7, (i + j).isEven ? Colors.white : Colors.black87);
      }
    }
    c.drawOval(const Rect.fromLTWH(330, 440, 300, 60), fill(const Color(0x55B71C1C)));
  }

  void _dining() {
    _window(760, 90, 140, 150);
    // Chandelier.
    c.drawLine(const Offset(480, 0), const Offset(480, 70), stroke(_brass, 4));
    c.drawArc(const Rect.fromLTWH(420, 40, 120, 70), 0, pi, false, stroke(_brass, 5));
    for (final x in [420.0, 480.0, 540.0]) {
      _rect(x - 4, 60, 8, 20, Colors.white);
      c.drawCircle(Offset(x, 54), 6, fill(const Color(0xFFFFE082)));
    }
    // Silver cabinet.
    _rect(110, 120, 130, 230, _darkWood, 4);
    _rect(120, 132, 110, 150, const Color(0x66B3E5FC), 2);
    for (final y in [180.0, 228.0, 276.0]) {
      _rect(120, y, 110, 5, _lightWood);
      for (var x = 132.0; x < 220; x += 26) {
        c.drawOval(Rect.fromLTWH(x, y - 26, 18, 26), fill(const Color(0xFFCFD8DC)));
      }
    }
    // Chairs behind the table.
    for (final x in [320.0, 420.0, 520.0, 610.0]) {
      _rect(x, 250, 46, 90, _wood, 6);
    }
    // Table with cloth.
    _rect(300, 346, 12, 90, _darkWood);
    _rect(648, 346, 12, 90, _darkWood);
    _rect(280, 344, 400, 50, const Color(0xFFEDE6D6));
    _rect(270, 328, 420, 18, Colors.white, 3);
    for (final x in [340.0, 540.0, 620.0]) {
      c.drawOval(Rect.fromLTWH(x, 322, 40, 10), fill(const Color(0xFFCFD8DC)));
    }
  }

  void _kitchen() {
    _window(540, 60, 130, 110);
    _shelves(740, 90, 180, 130, 2);
    // Stove.
    _rect(80, 140, 150, 20, const Color(0xFF616161), 4);
    _rect(90, 215, 130, 135, const Color(0xFF424242), 6);
    _rect(105, 250, 100, 70, const Color(0xFF1B1B1B), 4);
    // The oven is unlit in the case where nothing was baked.
    _rect(112, 258, 86, 54, caseId == 'cake' ? const Color(0xFF2B2B2B) : const Color(0xFFBF5B17), 3);
    c.drawCircle(const Offset(125, 228), 8, fill(const Color(0xFF9E9E9E)));
    c.drawCircle(const Offset(185, 228), 8, fill(const Color(0xFF9E9E9E)));
    // Counter.
    _rect(250, 254, 470, 96, _lightWood);
    for (var x = 262.0; x < 700; x += 114) {
      _rect(x, 270, 100, 70, _wood, 4);
      c.drawCircle(Offset(x + 50, 282), 4, fill(_brass));
    }
    _rect(240, 240, 490, 16, const Color(0xFFE0E0E0), 3);
    // Rolling pin rack. One hook is empty when a pin was the weapon.
    _rect(290, 120, 180, 8, const Color(0xFF757575), 3);
    for (var i = 0; i < 6; i++) {
      final x = 305.0 + i * 30;
      c.drawLine(Offset(x, 128), Offset(x, 138), stroke(const Color(0xFF757575), 3));
      if (i == 3 && caseId == 'flat') continue;
      final marble = i == 3;
      _rect(x - 2, 138, 4, 54, marble ? const Color(0xFFB0BEC5) : _wood);
      _rect(x - 6, 146, 12, 38, marble ? const Color(0xFFECEFF1) : const Color(0xFFD9A05B), 5);
    }
    // The soufflé.
    _rect(538, 226, 44, 16, Colors.white, 3);
    c.drawOval(const Rect.fromLTWH(536, 206, 48, 30), fill(const Color(0xFFD9A05B)));
  }

  // Basement

  void _pantry() {
    _shelves(60, 70, 210, 280, 4);
    _shelves(560, 70, 340, 280, 4);
    _hangingLamp(430, 60);
    // Urn stand.
    _table(290, 334, 80, 410, _lightWood);
    if (_brew) {
      c.drawOval(const Rect.fromLTWH(360, 420, 220, 50), fill(Colors.white70));
      for (var i = 0; i < 5; i++) {
        c.drawCircle(Offset(390 + i * 40, 438), 6, fill(const Color(0xFF5D4037)));
        _rect(402 + i * 40, 448, 12, 12, const Color(0xFFBCAAA4));
      }
    } else {
      _urn(330, 290);
    }
    // Flour sacks.
    c.drawOval(const Rect.fromLTWH(420, 300, 70, 90), fill(const Color(0xFFD7CCC8)));
    c.drawOval(const Rect.fromLTWH(470, 320, 70, 80), fill(const Color(0xFFBCAAA4)));
  }

  void _cellar() {
    _stairs(300, -1);
    _hangingLamp(480, 70);
    _barrel(380, 295, 50);
    _barrel(480, 295, 50);
    _barrel(430, 215, 46);
    // Wine rack.
    _rect(700, 110, 210, 240, _darkWood, 4);
    for (var y = 135.0; y < 340; y += 44) {
      for (var x = 725.0; x < 900; x += 42) {
        c.drawCircle(Offset(x, y), 13, fill(const Color(0xFF1B3B2B)));
        c.drawCircle(Offset(x, y), 5, fill(const Color(0xFF8D2B2B)));
      }
    }
    // What is left of Mrs. Senclair.
    const outline = Rect.fromLTWH(250, 420, 290, 64);
    if (_brew) {
      c.drawOval(outline.inflate(34), fill(const Color(0x993E2723)));
      c.save();
      c.translate(565, 425);
      c.rotate(pi / 2.3);
      _urn(0, 0);
      c.restore();
    } else {
      for (final (x, y, r) in [(300.0, 440.0, 18.0), (470.0, 470.0, 22.0), (520.0, 432.0, 12.0), (350.0, 480.0, 14.0)]) {
        c.drawCircle(Offset(x, y), r, fill(const Color(0xAAFFE082)));
      }
      for (var i = 0; i < 4; i++) {
        c.drawCircle(Offset(236 - i * 22, 474 + i * 3), 6, fill(Colors.white));
      }
    }
    c.drawRRect(
      RRect.fromRectAndRadius(outline, const Radius.circular(32)),
      stroke(Colors.white, 5),
    );
    // Police evidence markers.
    for (final x in [270.0, 520.0]) {
      c.drawPath(
        Path()..addPolygon([Offset(x - 10, 505), Offset(x + 10, 505), Offset(x, 482)], true),
        fill(const Color(0xFFFDD835)),
      );
    }
  }

  void _boiler() {
    final pipe = stroke(const Color(0xFF78909C), 16);
    c.drawLine(const Offset(380, 0), const Offset(380, 120), pipe);
    c.drawLine(const Offset(470, 180), const Offset(900, 180), pipe);
    c.drawLine(const Offset(900, 0), const Offset(900, 180), pipe);
    // The boiler.
    _rect(280, 110, 200, 240, const Color(0xFF6D4C41), 30);
    _rect(280, 170, 200, 8, const Color(0xFF4E342E));
    for (var x = 300.0; x < 470; x += 32) {
      c.drawCircle(Offset(x, 174), 4, fill(const Color(0xFFBCAAA4)));
    }
    c.drawCircle(const Offset(430, 140), 18, fill(Colors.white));
    c.drawLine(const Offset(430, 140), const Offset(440, 130), stroke(Colors.red, 3));
    c.drawCircle(const Offset(382, 300), 80, fill(const Color(0x33FF6D00)));
    _rect(330, 262, 104, 72, const Color(0xFF212121), 8);
    _rect(342, 274, 80, 48, const Color(0xFFFF6D00), 4);
    for (var x = 352.0; x < 420; x += 14) {
      c.drawLine(Offset(x, 274), Offset(x, 322), stroke(const Color(0xFF212121), 4));
    }
    // Coal.
    for (final (x, y, r) in [(560.0, 370.0, 22.0), (600.0, 360.0, 26.0), (640.0, 374.0, 20.0), (585.0, 392.0, 18.0), (625.0, 396.0, 16.0)]) {
      c.drawCircle(Offset(x, y), r, fill(const Color(0xFF1B1B1B)));
    }
    c.drawLine(const Offset(530, 200), const Offset(560, 380), stroke(_wood, 6));
    // Barry's seedlings.
    _rect(850, 300, 60, 50, const Color(0xFFBF5B17), 4);
    for (final dx in [-16.0, 0.0, 16.0]) {
      c.drawOval(Rect.fromCenter(center: Offset(880 + dx, 280), width: 20, height: 46), fill(const Color(0xFF43A047)));
    }
  }

  // Attic

  void _landing() {
    c.drawCircle(const Offset(480, 140), 68, fill(_darkWood));
    c.drawCircle(const Offset(480, 140), 58, fill(const Color(0xFF9FD3F0)));
    c.drawLine(const Offset(422, 140), const Offset(538, 140), stroke(_darkWood, 5));
    c.drawLine(const Offset(480, 82), const Offset(480, 198), stroke(_darkWood, 5));
    _picture(250, 150, 80, 100, const Color(0xFF3E5C76));
    // Telephone table.
    _table(595, 322, 90, 420);
    _rect(620, 300, 40, 22, Colors.black87, 4);
    c.drawArc(const Rect.fromLTWH(612, 282, 56, 30), pi, pi, false, stroke(Colors.black87, 7));
    _trunk(780, 330, 110, 70, const Color(0xFF5D4037));
    // Banister around the stairwell.
    c.drawPath(
      Path()..addPolygon(const [Offset(390, 470), Offset(570, 470), Offset(600, 540), Offset(360, 540)], true),
      fill(Colors.black87),
    );
    final rail = stroke(_darkWood, 6);
    for (var x = 380.0; x <= 580; x += 40) {
      c.drawLine(Offset(x, 420), Offset(x, 470), rail);
    }
    c.drawLine(const Offset(372, 420), const Offset(588, 420), stroke(_darkWood, 9));
  }

  void _study() {
    _books(230, 110, 90, 240, 4);
    _books(100, 180, 120, 170, 3);
    _window(700, 100, 130, 130);
    _picture(430, 90, 110, 80, const Color(0xFF5B3A4A));
    _eclair(485, 134, 76);
    // Chair and desk.
    _rect(450, 230, 90, 120, const Color(0xFF6D1B1B), 14);
    _rect(370, 330, 240, 96, _darkWood, 4);
    for (final x in [384.0, 506.0]) {
      _rect(x, 344, 90, 30, _wood, 3);
      c.drawCircle(Offset(x + 45, 359), 4, fill(_brass));
    }
    _rect(355, 316, 270, 16, _wood, 3);
    // Banker's lamp.
    _rect(574, 286, 6, 30, _brass);
    _rect(552, 276, 50, 14, const Color(0xFF2E7D32), 7);
    c.drawCircle(const Offset(577, 300), 34, fill(const Color(0x22FFE082)));
    // Globe.
    c.drawLine(const Offset(880, 330), const Offset(880, 420), stroke(_darkWood, 6));
    c.drawCircle(const Offset(880, 300), 36, fill(const Color(0xFF4A90B8)));
    c.drawOval(const Rect.fromLTWH(862, 280, 30, 22), fill(const Color(0xFF6BA36B)));
  }

  void _bedroom() {
    _window(130, 110, 110, 120);
    // Vanity mirror.
    c.drawOval(const Rect.fromLTWH(810, 150, 90, 130), fill(_brass));
    c.drawOval(const Rect.fromLTWH(818, 158, 74, 114), fill(const Color(0xFFCFE8F5)));
    _table(790, 300, 130, 420, const Color(0xFFE8D5D5));
    // Nightstand with lamp.
    _rect(235, 326, 70, 94, _wood, 4);
    _rect(243, 346, 54, 26, _lightWood, 3);
    c.drawCircle(const Offset(270, 359), 4, fill(_brass));
    _rect(286, 296, 5, 30, _brass);
    c.drawPath(
      Path()..addPolygon(const [Offset(272, 300), Offset(305, 300), Offset(298, 272), Offset(279, 272)], true),
      fill(const Color(0xFFF8BBD0)),
    );
    // Bed.
    _rect(350, 240, 18, 190, _darkWood, 4);
    _rect(640, 320, 14, 110, _darkWood, 4);
    _rect(366, 392, 276, 22, _wood);
    _rect(366, 356, 276, 40, Colors.white, 8);
    _rect(374, 334, 70, 30, Colors.white, 12);
    _rect(450, 350, 192, 50, const Color(0xFFEC407A), 8);
    _rect(450, 350, 192, 12, const Color(0xFFF8BBD0), 6);
  }

  void _storage() {
    // Bare bulb.
    c.drawLine(const Offset(480, 0), const Offset(480, 70), stroke(Colors.black54, 2));
    c.drawCircle(const Offset(480, 80), 60, fill(const Color(0x22FFE082)));
    c.drawCircle(const Offset(480, 80), 10, fill(const Color(0xFFFFE082)));
    // Cobwebs.
    final web = stroke(Colors.white30, 1.5);
    for (final (ox, sx) in [(230.0, 1.0), (730.0, -1.0)]) {
      for (var i = 1; i <= 3; i++) {
        c.drawArc(Rect.fromCircle(center: Offset(ox, 4), radius: i * 22.0), sx > 0 ? 0 : pi / 2, pi / 2, false, web);
      }
      c.drawLine(Offset(ox, 4), Offset(ox + sx * 50, 50), web);
    }
    _crate(130, 250, 100);
    _crate(240, 280, 70);
    _crate(160, 180, 70);
    // Leaning canvases.
    c.drawPath(
      Path()..addPolygon(const [Offset(620, 220), Offset(700, 235), Offset(690, 350), Offset(600, 350)], true),
      fill(const Color(0xFF8D6B2B)),
    );
    c.drawPath(
      Path()..addPolygon(const [Offset(628, 232), Offset(690, 244), Offset(682, 338), Offset(612, 338)], true),
      fill(const Color(0xFF3E5C76)),
    );
    // Dress form.
    c.drawLine(const Offset(800, 300), const Offset(800, 430), stroke(_darkWood, 6));
    c.drawLine(const Offset(775, 430), const Offset(825, 430), stroke(_darkWood, 6));
    c.drawOval(const Rect.fromLTWH(768, 190, 64, 120), fill(const Color(0xFFD7CCC8)));
    // Trunks.
    _trunk(560, 380, 110, 60, const Color(0xFF4E342E));
    _trunk(410, 350, 150, 90, const Color(0xFF2E5D3A));
  }
}
