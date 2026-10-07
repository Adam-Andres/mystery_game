import 'package:flutter/material.dart';

const kGold = Color(0xFFFFD27A);
const kCream = Color(0xFFFFF3DC);
const kInk = Color(0xFF24140C);
const kRed = Color(0xFFB3261E);

const kBody = TextStyle(color: kCream, fontSize: 15, height: 1.35);
const kHeading = TextStyle(color: kGold, fontSize: 19, fontWeight: FontWeight.bold);

/// The dark, gold-edged box used for every panel and dialogue.
class Plaque extends StatelessWidget {
  const Plaque({super.key, required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: kInk.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGold, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 12)],
      ),
      child: child,
    );
  }
}

class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = kGold,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: color,
      foregroundColor: color == kGold ? kInk : Colors.white,
      disabledBackgroundColor: Colors.white12,
      disabledForegroundColor: Colors.white38,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
    if (icon == null) {
      return FilledButton(onPressed: onPressed, style: style, child: Text(label));
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}

/// Dims the scene behind a panel and swallows clicks meant for it.
class Scrim extends StatelessWidget {
  const Scrim({super.key, this.onTap, this.opacity = .55});

  final VoidCallback? onTap;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ColoredBox(color: Colors.black.withValues(alpha: opacity)),
      ),
    );
  }
}
