import 'package:flutter/material.dart';

import '../audio/lines.dart';
import '../audio/voice.dart';
import '../data/house.dart';
import '../game_state.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/ui.dart';

String _names(Iterable<String> ids) => ids.map((id) => personById(id).name).join(' and ');

class EndingScreen extends StatefulWidget {
  const EndingScreen(this.g, {super.key, required this.voice});

  final GameState g;
  final Voice voice;

  @override
  State<EndingScreen> createState() => _EndingScreenState();
}

class _EndingScreenState extends State<EndingScreen> {
  GameState get g => widget.g;

  @override
  void initState() {
    super.initState();
    // The narrator explains what really happened.
    widget.voice.say((voice: narrator, text: g.mystery.solution));
  }

  @override
  void dispose() {
    widget.voice.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final won = g.won;
    final culprits = g.mystery.culprits;
    final String headline;
    final String story;
    if (won) {
      headline = 'CASE CLOSED';
      story = '${_names(culprits)} ${culprits.length == 1 ? 'is' : 'are'} behind bars, '
          'and Donut County can sleep soundly again. Elementary, my dear Watsonut.';
    } else {
      final innocents = g.jailedInnocents;
      final free = g.freeKillers;
      final victim = g.nextVictim;
      final parts = <String>[
        if (innocents.isNotEmpty)
          'You put ${_names(innocents)} behind bars — and '
              '${innocents.length == 1 ? 'that dessert was' : 'those desserts were'} innocent.',
        if (victim != null)
          'With ${_names(free)} still free in the house, it did not take long. '
              'By morning ${victim.name} had been murdered too, silenced before '
              'the truth could come out.'
        else
          'The real killer happens to be in the next cell, but an innocent '
              'dessert is paying for your guesswork.',
      ];
      headline = victim != null ? 'THE KILLER STRIKES AGAIN' : 'A HALF-BAKED VERDICT';
      story = parts.join(' ');
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: .9,
          colors: won
              ? const [Color(0xFF2E5D3A), Color(0xFF0C1A10)]
              : const [Color(0xFF5D1F1F), Color(0xFF140808)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 22),
        child: Column(
          children: [
            Text(
              headline,
              style: TextStyle(
                color: won ? kGold : const Color(0xFFFF8A80),
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            Text(
              'Case file: “${g.mystery.title}”',
              style: kBody.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final id in g.accused) ...[
                  _mugshot(id, jailed: true, tag: culprits.contains(id) ? 'GUILTY' : 'INNOCENT'),
                  const SizedBox(width: 18),
                ],
                if (g.nextVictim case final victim?)
                  _mugshot(victim.id, jailed: false, tag: 'NEXT VICTIM'),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(story, style: kBody, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Plaque(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'What really happened — ${_names(culprits)} did it',
                            style: kHeading.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            g.mystery.solution,
                            style: kBody.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MuteButton(widget.voice),
                const SizedBox(width: 10),
                GoldButton(
                  key: const ValueKey('again'),
                  label: 'Take another case',
                  icon: Icons.replay,
                  onPressed: g.newGame,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _mugshot(String id, {required bool jailed, required String tag}) {
    final p = personById(id);
    final good = tag == 'GUILTY';
    return Column(
      children: [
        DessertFigure(p.dessert, width: 84, jailed: jailed),
        const SizedBox(height: 4),
        Text(p.name, style: kBody.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          decoration: BoxDecoration(
            color: good ? const Color(0xFF2E7D32) : kRed,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
