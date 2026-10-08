import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// How many screen units one pixel of the game's artwork covers. The stage
/// is 960x540, so the art is drawn at 320x180.
const double pixel = 3;

/// A flat, hard-edged fill, so shapes land on whole pixels.
Paint fill(Color c) => Paint()
  ..color = c
  ..isAntiAlias = false;

/// A hard-edged line, never thinner than one art pixel.
Paint stroke(Color c, double w, {double minWidth = pixel}) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = max(w, minWidth)
  ..strokeCap = StrokeCap.square
  ..isAntiAlias = false;

/// Draws [child] as pixel art: it is rendered small, [factor] times smaller
/// than its layout, then scaled back up with no smoothing.
class Pixelate extends SingleChildRenderObjectWidget {
  const Pixelate({super.key, this.factor = pixel, super.child});

  final double factor;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderPixelate(factor);

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _RenderPixelate).factor = factor;
  }
}

class _RenderPixelate extends RenderProxyBox {
  _RenderPixelate(this._factor);

  double _factor;
  set factor(double value) {
    if (value == _factor) return;
    _factor = value;
    markNeedsPaint();
  }

  // Lets a still picture be kept rather than redrawn while others animate.
  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || size.isEmpty) return;
    if (_factor <= 1) {
      super.paint(context, offset);
      return;
    }
    // Paint the child into a layer of its own, and take a small picture of it.
    final layer = OffsetLayer();
    final childContext = PaintingContext(layer, Offset.zero & size);
    super.paint(childContext, Offset.zero);
    // ignore: invalid_use_of_protected_member
    childContext.stopRecordingIfNeeded();
    final ui.Image image = layer.toImageSync(Offset.zero & size, pixelRatio: 1 / _factor);
    layer.dispose();
    context.canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      offset & size,
      Paint()..filterQuality = FilterQuality.none,
    );
    image.dispose();
  }
}

/// An ordered-dither shadow over [area], strongest at the edge named by
/// [from] and fading out across it: the pixel artist's gradient.
void ditherShade(Canvas c, Rect area, AxisDirection from, {double strength = 1, Color color = const Color(0x40000000)}) {
  const bayer = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5];
  final paint = fill(color);
  final cols = (area.width / pixel).ceil();
  final rows = (area.height / pixel).ceil();
  for (var row = 0; row < rows; row++) {
    for (var col = 0; col < cols; col++) {
      final along = switch (from) {
        AxisDirection.up => 1 - row / rows,
        AxisDirection.down => (row + 1) / rows,
        AxisDirection.left => 1 - col / cols,
        AxisDirection.right => (col + 1) / cols,
      };
      if (along * strength * 16 > bayer[(row % 4) * 4 + col % 4] + .5) {
        c.drawRect(
          Rect.fromLTWH(area.left + col * pixel, area.top + row * pixel, pixel, pixel),
          paint,
        );
      }
    }
  }
}
