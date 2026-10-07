import 'package:flutter/material.dart';

import '../data/models.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/ui.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: .9,
          colors: [Color(0xFF4A2A3A), Color(0xFF140A10)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 24),
        child: Row(
          children: [
            const DessertFigure(Dessert.churro, width: 230),
            const SizedBox(width: 40),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A CHURLOCK MYSTERY',
                        style: TextStyle(
                          color: kCream,
                          fontSize: 16,
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'The Senclair Affair',
                        style: TextStyle(
                          color: kGold,
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Mrs. Senclair, the éclair of Donut County, has been murdered in '
                        'her own cellar. Five desserts were in the house. Search three '
                        'floors, gather the evidence, question the residents — and name '
                        'the killer, or killers, before somebody else gets creamed.',
                        style: kBody,
                      ),
                      const SizedBox(height: 26),
                      GoldButton(
                        key: const ValueKey('start'),
                        label: 'Begin the investigation',
                        icon: Icons.search,
                        onPressed: onStart,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Click to look and talk  •  Arrows (or arrow keys) to move',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
