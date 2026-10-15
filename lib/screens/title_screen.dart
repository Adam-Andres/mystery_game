import 'package:flutter/material.dart';

import '../data/house.dart';
import '../data/models.dart';
import '../game_state.dart';
import '../save.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/ui.dart';
import 'panels.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen(this.g, {super.key});

  final GameState g;

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  GameState get g => widget.g;

  bool _settings = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _menu(context),
        if (_settings) ...[
          Scrim(onTap: () => setState(() => _settings = false)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: MenuPanel(
              g,
              onClose: () => setState(() => _settings = false),
            ),
          ),
        ],
      ],
    );
  }

  /// Which way the last change of place went: 1 to the right, -1 back.
  double _heading = 1;

  /// The place [step] along from this one, if there is one.
  World? _neighbour(int step) {
    final at = worlds.indexOf(world) + step;
    return at >= 0 && at < worlds.length ? worlds[at] : null;
  }

  /// An arrow, with the name of the place it leads to.
  Widget _travel(World to, {required bool back}) {
    final label = Text(
      to.title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
    final arrow = Icon(back ? Icons.arrow_back : Icons.arrow_forward, size: 20);
    return TextButton(
      key: ValueKey(back ? 'world-back' : 'world-next'),
      onPressed: () {
        setState(() => _heading = back ? -1 : 1);
        g.switchWorld(to);
      },
      style: TextButton.styleFrom(
        foregroundColor: kGold,
        backgroundColor: kInk.withValues(alpha: .7),
        side: const BorderSide(color: kGold),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: back
            ? [arrow, const SizedBox(width: 8), label]
            : [label, const SizedBox(width: 8), arrow],
      ),
    );
  }

  Widget _menu(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      decoration: BoxDecoration(
        gradient: RadialGradient(radius: .9, colors: world.titleColors),
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 650),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  // The new place slides in from the side it was asked for
                  // on, and the old one slides off the other way.
                  transitionBuilder: (child, animation) {
                    final incoming = child.key == ValueKey(world.id);
                    final from = (incoming ? 1.0 : -1.0) * _heading;
                    return SlideTransition(
                      position: Tween(
                        begin: Offset(from, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: FittedBox(
                    key: ValueKey(world.id),
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
                          Text(
                            world.title,
                            style: const TextStyle(
                              color: kGold,
                              fontSize: 58,
                              fontWeight: FontWeight.bold,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(world.blurb, style: kBody),
                          const SizedBox(height: 10),
                          // The way to the other places with mysteries in.
                          Row(
                            children: [
                              if (_neighbour(-1) case final World before)
                                _travel(before, back: true),
                              const Spacer(),
                              if (_neighbour(1) case final World after)
                                _travel(after, back: false),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Three investigations can be kept on the go at once.
                          Row(
                            // Level with one another along the top, whatever hangs
                            // beneath each.
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      // The settings, under the middle file.
                                      if (slot == saveSlots ~/ 2) ...[
                                        const SizedBox(height: 6),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: TextButton(
                                            key: const ValueKey(
                                              'title-settings',
                                            ),
                                            onPressed: () => setState(
                                              () => _settings = true,
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor: kGold,
                                              backgroundColor: kInk.withValues(
                                                alpha: .9,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            child: const Text('Settings'),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Click to look and talk  •  Arrows (or arrow keys) to move',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
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
