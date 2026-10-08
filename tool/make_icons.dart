// Draws the app icon — Churlock's face — and writes it out at every size the
// platforms ask for. Run with `flutter test tool/make_icons.dart`.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystery/data/models.dart';
import 'package:mystery/widgets/dessert_figure.dart';

const _ios = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
const _mac = 'macos/Runner/Assets.xcassets/AppIcon.appiconset';
const _android = 'android/app/src/main/res';

/// Every icon file and its size in pixels. Maskable icons keep the face
/// inside the middle of the square, since the edges may be cut away.
const _icons = <(String, int, bool)>[
  ('web/favicon.png', 32, false),
  ('web/icons/Icon-192.png', 192, false),
  ('web/icons/Icon-512.png', 512, false),
  ('web/icons/Icon-maskable-192.png', 192, true),
  ('web/icons/Icon-maskable-512.png', 512, true),
  ('$_android/mipmap-mdpi/ic_launcher.png', 48, false),
  ('$_android/mipmap-hdpi/ic_launcher.png', 72, false),
  ('$_android/mipmap-xhdpi/ic_launcher.png', 96, false),
  ('$_android/mipmap-xxhdpi/ic_launcher.png', 144, false),
  ('$_android/mipmap-xxxhdpi/ic_launcher.png', 192, false),
  ('$_ios/Icon-App-20x20@1x.png', 20, false),
  ('$_ios/Icon-App-20x20@2x.png', 40, false),
  ('$_ios/Icon-App-20x20@3x.png', 60, false),
  ('$_ios/Icon-App-29x29@1x.png', 29, false),
  ('$_ios/Icon-App-29x29@2x.png', 58, false),
  ('$_ios/Icon-App-29x29@3x.png', 87, false),
  ('$_ios/Icon-App-40x40@1x.png', 40, false),
  ('$_ios/Icon-App-40x40@2x.png', 80, false),
  ('$_ios/Icon-App-40x40@3x.png', 120, false),
  ('$_ios/Icon-App-60x60@2x.png', 120, false),
  ('$_ios/Icon-App-60x60@3x.png', 180, false),
  ('$_ios/Icon-App-76x76@1x.png', 76, false),
  ('$_ios/Icon-App-76x76@2x.png', 152, false),
  ('$_ios/Icon-App-83.5x83.5@2x.png', 167, false),
  ('$_ios/Icon-App-1024x1024@1x.png', 1024, false),
  ('$_mac/app_icon_16.png', 16, false),
  ('$_mac/app_icon_32.png', 32, false),
  ('$_mac/app_icon_64.png', 64, false),
  ('$_mac/app_icon_128.png', 128, false),
  ('$_mac/app_icon_256.png', 256, false),
  ('$_mac/app_icon_512.png', 512, false),
  ('$_mac/app_icon_1024.png', 1024, false),
];

/// The icon on a 512-pixel square: his face, hat to pipe, on the green of
/// the hall wallpaper.
Widget _icon({required bool maskable}) {
  // The figure is drawn far larger than the square, which shows only its head.
  final width = maskable ? 540.0 : 700.0;
  return SizedBox.square(
    dimension: 512,
    child: ClipRect(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: .8,
            colors: [Color(0xFF2F6B70), Color(0xFF12292C)],
          ),
        ),
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Transform.translate(
            offset: Offset(256 - width * .5, 256 - width * .385),
            child: DessertFigure(Dessert.churro, width: width),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('write the app icons', (tester) async {
    for (final maskable in [false, true]) {
      final key = GlobalKey();
      await tester.pumpWidget(
        Center(
          child: RepaintBoundary(
            key: key,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: _icon(maskable: maskable),
            ),
          ),
        ),
      );
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        for (final (path, size, masked) in _icons) {
          if (masked != maskable) continue;
          final image = await boundary.toImage(pixelRatio: size / 512);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
        }
      });
    }
  });
}
