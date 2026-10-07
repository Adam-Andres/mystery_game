import 'package:flutter/material.dart';

import '../data/house.dart';
import '../data/models.dart';
import '../game_state.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/ui.dart';

/// The conversation / evidence box along the bottom of the scene.
class DialoguePanel extends StatelessWidget {
  const DialoguePanel(this.g, {super.key});

  final GameState g;

  @override
  Widget build(BuildContext context) {
    final d = g.dialogue!;
    final topics = d.talk ? g.topicsFor(d.speaker.id) : const <(int, Topic)>[];
    return Plaque(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DessertFigure(d.speaker.dessert, width: 96),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.title, style: kHeading),
                if (d.talk)
                  Text(
                    d.speaker.role,
                    style: const TextStyle(color: kCream, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                const SizedBox(height: 6),
                Expanded(
                  child: SingleChildScrollView(child: Text(d.text, style: kBody)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 290,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (final (i, topic) in topics)
                        _TopicButton(
                          key: ValueKey('topic-$i'),
                          topic: topic,
                          asked: g.hasAsked(d.speaker.id, i),
                          onTap: () => g.ask(d.speaker, i),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                GoldButton(
                  key: const ValueKey('close-dialogue'),
                  label: d.talk ? 'Goodbye' : 'Continue',
                  onPressed: g.closeDialogue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicButton extends StatelessWidget {
  const _TopicButton({
    super.key,
    required this.topic,
    required this.asked,
    required this.onTap,
  });

  final Topic topic;
  final bool asked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Questions unlocked by evidence stand out until they have been asked.
    final color = asked
        ? Colors.white54
        : topic.needs != null
            ? kGold
            : kCream;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.white.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            child: Row(
              children: [
                Icon(
                  asked
                      ? Icons.check
                      : topic.needs != null
                          ? Icons.search
                          : Icons.chat_bubble_outline,
                  color: color,
                  size: 15,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(topic.question, style: TextStyle(color: color, fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Everything Churlock has found and been told so far.
class NotebookPanel extends StatelessWidget {
  const NotebookPanel(this.g, {super.key});

  final GameState g;

  @override
  Widget build(BuildContext context) {
    final evidence = g.mystery.evidence.where((e) => g.found.contains(e.id)).toList();
    final speakers = [...police, ...residents].where((p) => g.asked[p.id]?.isNotEmpty ?? false);
    return Plaque(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: kGold),
              const SizedBox(width: 8),
              const Expanded(child: Text("Churlock's Notebook", style: kHeading)),
              GoldButton(
                key: const ValueKey('close-panel'),
                label: 'Close',
                onPressed: g.closePanel,
              ),
            ],
          ),
          const Divider(color: kGold),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _column(
                    'Evidence (${evidence.length}/${g.mystery.evidence.length})',
                    evidence.isEmpty ? 'Nothing yet. Click anything that glints.' : null,
                    [
                      for (final e in evidence)
                        _entry(
                          Icon(e.icon, color: e.color, size: 20),
                          '${e.name} — ${roomById(e.room).name}',
                          e.description,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _column(
                    'Statements',
                    speakers.isEmpty ? 'Nobody questioned yet. Click a dessert to talk.' : null,
                    [
                      for (final p in speakers)
                        for (final i in g.asked[p.id]!.toList()..sort())
                          _entry(
                            DessertFigure(p.dessert, width: 20),
                            '${p.name}: “${g.mystery.topics[p.id]![i].question}”',
                            g.mystery.topics[p.id]![i].answer,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _column(String title, String? emptyText, List<Widget> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kHeading.copyWith(fontSize: 16)),
        const SizedBox(height: 6),
        Expanded(
          child: emptyText != null
              ? Text(emptyText, style: kBody.copyWith(color: Colors.white54))
              : ListView(padding: EdgeInsets.zero, children: entries),
        ),
      ],
    );
  }

  Widget _entry(Widget leading, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kBody.copyWith(color: kGold, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(body, style: kBody.copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The final accusation: one or two of the five residents.
class AccusePanel extends StatelessWidget {
  const AccusePanel(this.g, {super.key});

  final GameState g;

  @override
  Widget build(BuildContext context) {
    final full = g.accused.length >= 2;
    return Plaque(
      child: Column(
        children: [
          const Text('Who murdered Mrs. Senclair?', style: kHeading),
          const SizedBox(height: 4),
          const Text(
            'Choose one culprit, or two if they did it together. There is no '
            'second chance — an innocent dessert in jail means a killer left free.',
            style: kBody,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final p in residents)
                  _SuspectCard(
                    key: ValueKey('accuse-${p.id}'),
                    person: p,
                    selected: g.accused.contains(p.id),
                    enabled: !full || g.accused.contains(p.id),
                    onTap: () => g.toggleAccused(p.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoldButton(
                key: const ValueKey('close-panel'),
                label: 'Keep investigating',
                onPressed: g.closePanel,
              ),
              const SizedBox(width: 16),
              GoldButton(
                key: const ValueKey('arrest'),
                label: g.accused.isEmpty
                    ? 'Choose at least one suspect'
                    : 'Make the arrest (${g.accused.length})',
                icon: Icons.gavel,
                color: kRed,
                onPressed: g.canAccuse ? g.makeArrest : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuspectCard extends StatelessWidget {
  const _SuspectCard({
    super.key,
    required this.person,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final Person person;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .4,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected ? kRed.withValues(alpha: .45) : Colors.white.withValues(alpha: .06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: selected ? kGold : Colors.white24, width: selected ? 3 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DessertFigure(person.dessert, width: 104, jailed: selected),
                const SizedBox(height: 8),
                Text(
                  person.name,
                  style: kBody.copyWith(color: kGold, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  person.role,
                  style: kBody.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Icon(
                  selected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: selected ? kGold : Colors.white54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
