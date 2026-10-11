import 'package:flutter/material.dart';

import '../data/models.dart';
import '../game_state.dart';
import '../save.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/ui.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen(this.g, {super.key});

  final GameState g;

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
            const DessertFigure(Dessert.churro, width: 230, animate: true),
            const SizedBox(width: 40),
            Expanded(
              child: Center(
                // Shrunk to fit if need be, so nothing is ever off screen.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: 570,
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
                        const SizedBox(height: 10),
                        const Text(
                          'Mrs. Senclair, the éclair of Donut County, has been murdered in '
                          'her own cellar. Five desserts were in the house. Search three '
                          'floors, gather the evidence, question the residents — and name '
                          'the killer, or killers, before somebody else gets creamed.',
                          style: kBody,
                        ),
                        const SizedBox(height: 18),
                        // Three investigations can be kept on the go at once.
                        Row(
                          children: [
                            for (var slot = 0; slot < saveSlots; slot++) ...[
                              if (slot > 0) const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _SlotCard(g, slot),
                                    const SizedBox(height: 6),
                                    // To start this file afresh.
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: ResetButton(
                                        key: ValueKey(
                                          'erase-$slot-${g.summaryOf(slot) != null}',
                                        ),
                                        buttonKey: ValueKey('erase-$slot'),
                                        label: 'Reset',
                                        enabled: g.summaryOf(slot) != null,
                                        onReset: () => g.erase(slot),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the save slots: a case in progress to go back to, or room for a
/// new one.
class _SlotCard extends StatelessWidget {
  const _SlotCard(this.g, this.slot);

  final GameState g;
  final int slot;

  @override
  Widget build(BuildContext context) {
    final saved = g.summaryOf(slot);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        // The first slot keeps the old name, so one tap still starts a game.
        key: ValueKey(slot == 0 ? 'start' : 'slot-$slot'),
        onTap: () => g.open(slot),
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: saved == null ? kInk.withValues(alpha: .6) : kGold,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kGold, width: 2),
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: saved == null ? kCream : kInk),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CASE FILE ${slot + 1}',
                  style: const TextStyle(fontSize: 11, letterSpacing: 2),
                ),
                const SizedBox(height: 2),
                Text(
                  saved == null ? 'New case' : 'Continue',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  saved == null
                      ? 'Empty'
                      : '${saved.found} of ${saved.total} clues\n${saved.room}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, height: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
