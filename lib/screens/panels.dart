import 'package:flutter/material.dart';

import '../data/house.dart';
import '../data/models.dart';
import '../game_state.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/ui.dart';
import 'minigames.dart';

/// The conversation / evidence box along the bottom of the scene.
class DialoguePanel extends StatelessWidget {
  const DialoguePanel(this.g, {super.key});

  final GameState g;

  @override
  Widget build(BuildContext context) {
    final d = g.dialogue!;
    final available = d.talk ? g.topicsFor(d.speaker.id) : const <Topic>[];
    // Questions not yet asked come first, so new follow-ups are easy to spot.
    final topics = [
      ...available.where((t) => !g.hasAsked(d.speaker.id, t)),
      ...available.where((t) => g.hasAsked(d.speaker.id, t)),
    ];
    return Plaque(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DessertFigure(
            d.speaker.dessert,
            width: 96,
            animate: true,
            speaker: d.speaker.id,
            stiff: d.lying,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.title, style: kHeading),
                if (d.talk)
                  Text(
                    d.speaker.role,
                    style: const TextStyle(
                      color: kCream,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 6),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(d.text, style: kBody),
                  ),
                ),
                if (d.note != null)
                  Text(
                    d.note!,
                    key: const ValueKey('dialogue-note'),
                    style: kBody.copyWith(
                      color: kGold,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
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
                      for (final topic in topics)
                        _TopicButton(
                          key: ValueKey('topic-${topic.id}'),
                          topic: topic,
                          asked: g.hasAsked(d.speaker.id, topic),
                          onTap: () => g.ask(d.speaker, topic),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                if (d.evidence != null) ...[
                  GoldButton(
                    key: const ValueKey('ask-watsonut'),
                    label: 'Ask Watsonut',
                    icon: Icons.lightbulb,
                    color: const Color(0xFF5D3A1A),
                    onPressed: () => g.askHint(about: d.evidence),
                  ),
                  const SizedBox(height: 6),
                ],
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
    // Follow-up questions stand out until they have been asked.
    final color = asked
        ? Colors.white54
        : topic.isFollowUp
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
                      : topic.needs.isNotEmpty
                      ? Icons.search
                      : topic.heard.isNotEmpty
                      ? Icons.forum
                      : Icons.chat_bubble_outline,
                  color: color,
                  size: 15,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    topic.question,
                    style: TextStyle(color: color, fontSize: 13),
                  ),
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
    final evidence = g.evidence.where((e) => g.found.contains(e.id)).toList();
    final speakers = [
      ...police,
      ...residents,
    ].where((p) => g.statementsOf(p.id).isNotEmpty);
    return Plaque(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: kGold),
              const SizedBox(width: 8),
              const Text("Churlock's Notebook", style: kHeading),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Click an entry to read and hear it again.',
                  style: kBody.copyWith(fontSize: 12, color: Colors.white54),
                ),
              ),
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
                    'Evidence (${evidence.length}/${g.evidence.length})',
                    evidence.isEmpty
                        ? 'Nothing yet. Click anything that glints.'
                        : null,
                    [
                      for (final e in evidence)
                        _entry(
                          'note-${e.id}',
                          Icon(e.icon, color: e.color, size: 20),
                          '${e.name} — ${_whereFound(e)}',
                          e.description,
                          () => g.review(e),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _column(
                    'Statements',
                    speakers.isEmpty
                        ? 'Nobody questioned yet. Click a dessert to talk.'
                        : null,
                    [
                      for (final p in speakers)
                        for (final t in g.statementsOf(p.id))
                          _entry(
                            'note-${GameState.keyOf(p.id, t)}',
                            DessertFigure(p.dessert, width: 20),
                            '${p.name}: “${t.question}”',
                            t.answer,
                            () => g.replay(p, t),
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

  static String _whereFound(Evidence e) {
    final giver = e.from;
    if (giver == churlock.id) return 'raised by dusting';
    if (giver != null) return 'given by ${personById(giver).name}';
    final room = roomById(e.room).name;
    return e.inside == null ? room : '${nookById(e.inside!).name}, $room';
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

  /// One line of the notebook. Clicking it brings the evidence or the
  /// statement back up, spoken again in its owner's voice.
  Widget _entry(
    String key,
    Widget leading,
    String title,
    String body,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey(key),
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.white10,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leading,
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: kBody.copyWith(
                          color: kGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(body, style: kBody.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.volume_up, color: Colors.white38, size: 16),
              ],
            ),
          ),
        ),
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
          // The sergeant's list of everyone in the house. Its right-hand
          // edge has been torn away, in every mystery.
          Expanded(
            child: ClipPath(
              key: ValueKey(g.sheetAttached ? 'list-whole' : 'list-torn'),
              clipper: g.sheetAttached ? null : const _TornEdge(),
              child: Container(
                padding: EdgeInsets.fromLTRB(8, 6, g.sheetAttached ? 8 : 34, 6),
                decoration: BoxDecoration(
                  color: kCream.withValues(alpha: .09),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final p in g.suspects) ...[
                      // The seam where the strip was put back.
                      if (p.id == watsonut.id)
                        const SizedBox(
                          width: 6,
                          child: CustomPaint(
                            size: Size(6, double.infinity),
                            painter: _SeamPainter(),
                          ),
                        ),
                      // Six cards are a squeeze, so each shrinks to fit.
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _SuspectCard(
                            key: ValueKey('accuse-${p.id}'),
                            person: p,
                            selected: g.accused.contains(p.id),
                            enabled: !full || g.accused.contains(p.id),
                            onTap: () => g.toggleAccused(p.id),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const _IdleScrollbar(),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 8,
            children: [
              GoldButton(
                key: const ValueKey('close-panel'),
                label: 'Keep investigating',
                onPressed: g.closePanel,
              ),
              if (g.canAttachSheet)
                GoldButton(
                  key: const ValueKey('attach-sheet'),
                  label: 'Fit the torn strip back on',
                  icon: Icons.content_cut,
                  color: const Color(0xFF8D4B2B),
                  onPressed: g.attachSheet,
                ),
              GoldButton(
                key: const ValueKey('accuse-hint'),
                label: g.moreAccuseHints
                    ? 'Ask Watsonut (${g.accuseHintsGiven}/${g.mystery.accuseHints.length})'
                    : 'Watsonut has said his piece',
                icon: Icons.lightbulb,
                color: const Color(0xFF5D3A1A),
                onPressed: g.moreAccuseHints ? g.askHint : null,
              ),
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

/// Cuts a ragged right-hand edge, as of paper torn off in a hurry.
class _TornEdge extends CustomClipper<Path> {
  const _TornEdge();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 14, 0);
    const teeth = 22;
    for (var i = 1; i <= teeth; i++) {
      // Uneven, but the same every time.
      final jag = ((i * 37) % 11) + (i.isEven ? 12 : 0);
      path.lineTo(size.width - jag.toDouble(), size.height * i / teeth);
    }
    return path
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_TornEdge old) => false;
}

/// The join where the torn strip has been fitted back.
class _SeamPainter extends CustomPainter {
  const _SeamPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(3, 0);
    const teeth = 22;
    for (var i = 1; i <= teeth; i++) {
      path.lineTo(i.isEven ? 1 : 5, size.height * i / teeth);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = kCream.withValues(alpha: .6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_SeamPainter old) => false;
}

/// A scroll bar under the list of suspects. It slides, and scrolls nothing:
/// the list was once wider than it is.
class _IdleScrollbar extends StatefulWidget {
  const _IdleScrollbar();

  @override
  State<_IdleScrollbar> createState() => _IdleScrollbarState();
}

class _IdleScrollbarState extends State<_IdleScrollbar> {
  double _at = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final thumb = box.maxWidth * .82;
        final travel = box.maxWidth - thumb;
        return GestureDetector(
          key: const ValueKey('idle-scrollbar'),
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (d) =>
              setState(() => _at = (_at + d.delta.dx).clamp(0, travel)),
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: thumb,
              height: 10,
              margin: EdgeInsets.only(left: _at),
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: .55),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        );
      },
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
              color: selected
                  ? kRed.withValues(alpha: .45)
                  : Colors.white.withValues(alpha: .06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? kGold : Colors.white24,
                width: selected ? 3 : 1,
              ),
            ),
            // Shrinks to fit if the buttons below take a second row.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 134,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DessertFigure(person.dessert, width: 104, jailed: selected),
                    const SizedBox(height: 8),
                    Text(
                      person.name,
                      style: kBody.copyWith(
                        color: kGold,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      person.role,
                      style: kBody.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      selected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: selected ? kGold : Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The inside of a closet, trunk or drawer: evidence and odds and ends alike.
class NookPanel extends StatelessWidget {
  const NookPanel(this.g, {super.key});

  final GameState g;

  @override
  Widget build(BuildContext context) {
    final nook = g.nook!;
    return Plaque(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(nook.icon, color: kGold),
              const SizedBox(width: 8),
              Expanded(child: Text(nook.name, style: kHeading)),
              GoldButton(
                key: const ValueKey('close-panel'),
                label: 'Close',
                onPressed: g.closePanel,
              ),
            ],
          ),
          Text(nook.blurb, style: kBody.copyWith(fontStyle: FontStyle.italic)),
          const Divider(color: kGold),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: _contents(nook)),
                if (nook.locked && g.isOpen(nook))
                  Positioned(right: 0, bottom: 0, child: _corner(nook)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The bottom right-hand corner of the desk drawer, where the lining
  /// does not sit quite flat. Lifted, it may have something behind it.
  Widget _corner(Nook nook) {
    if (!g.cornerLifted) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: const ValueKey('loose-corner'),
          behavior: HitTestBehavior.opaque,
          onTap: () => g.liftCorner(nook),
          child: const CustomPaint(
            size: Size(46, 40),
            painter: _CornerPainter(lifted: false),
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CustomPaint(
          size: Size(70, 60),
          painter: _CornerPainter(lifted: true),
        ),
        // Her jewellery, as a rule. Once, something else.
        if (g.hiddenIn(nook).isEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 4),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                key: const ValueKey('hidden-jewels'),
                onTap: () => g.remark(looseCorner),
                child: const Icon(
                  Icons.diamond,
                  color: Color(0xFFE57373),
                  size: 24,
                  shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                ),
              ),
            ),
          ),
        for (final e in g.hiddenIn(nook))
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 6),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                key: ValueKey('evidence-${e.id}'),
                onTap: () => g.inspect(e),
                child: Transform.rotate(
                  angle: -.2,
                  child: Container(
                    width: 30,
                    height: 20,
                    decoration: BoxDecoration(
                      color: g.found.contains(e.id)
                          ? const Color(0xFFBFB59A)
                          : const Color(0xFFF7EFD9),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black54, blurRadius: 3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _contents(Nook nook) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: g.isOpen(nook)
                ? SingleChildScrollView(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final e in g.evidenceIn(nook))
                          _ItemTile(
                            key: ValueKey('evidence-${e.id}'),
                            icon: g.canDust(e) ? Icons.fingerprint : e.icon,
                            color: e.color,
                            label: e.name,
                            done: g.found.contains(e.id) && !g.canDust(e),
                            onTap: () => g.inspect(e),
                          ),
                        for (final junk in nook.junk)
                          _ItemTile(
                            key: ValueKey('junk-${junk.name}'),
                            icon: junk.icon,
                            color: kCream,
                            label: junk.name,
                            done: false,
                            onTap: () => g.remark(junk),
                          ),
                      ],
                    ),
                  )
                : FittedBox(fit: BoxFit.scaleDown, child: _barrier(nook)),
          ),
        ),
      ],
    );
  }
}

extension on NookPanel {
  /// Whatever stands between Churlock and the inside of [nook].
  Widget _barrier(Nook nook) {
    if (nook.locked) {
      return DialLock(
        combination: g.combination,
        onTry: (code) => g.tryCode(nook, code),
      );
    }
    final tool = itemById(nook.needs!);
    if (g.canOpen(nook) && nook.pick) {
      return LockPickGame(order: g.pinOrder, onDone: () => g.forceOpen(nook));
    }
    return SizedBox(
      width: 520,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            g.canOpen(nook) ? tool.icon : Icons.block,
            color: g.canOpen(nook) ? tool.color : kCream,
            size: 44,
          ),
          const SizedBox(height: 10),
          Text(
            g.canOpen(nook)
                ? 'I have the ${tool.name.toLowerCase()}.'
                : nook.barred,
            key: const ValueKey('barred'),
            style: kBody,
            textAlign: TextAlign.center,
          ),
          if (g.canOpen(nook)) ...[
            const SizedBox(height: 12),
            GoldButton(
              key: const ValueKey('use-item'),
              label: nook.action,
              icon: tool.icon,
              onPressed: () => g.forceOpen(nook),
            ),
          ],
        ],
      ),
    );
  }
}

/// The loose corner of a drawer lining: a slight curl, or folded right back.
class _CornerPainter extends CustomPainter {
  const _CornerPainter({required this.lifted});

  final bool lifted;

  @override
  void paint(Canvas canvas, Size s) {
    final lining = Paint()
      ..color = kCream.withValues(alpha: lifted ? .16 : .07);
    final edge = Paint()
      ..color = kCream.withValues(alpha: lifted ? .5 : .22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final fold = lifted ? .0 : .45;
    final path = Path()
      ..moveTo(s.width, s.height * fold)
      ..lineTo(s.width, s.height)
      ..lineTo(s.width * fold, s.height)
      ..close();
    if (lifted) {
      // The wood beneath, and the lining turned back over itself.
      canvas.drawPath(path, Paint()..color = const Color(0xFF3A2414));
      canvas.drawPath(
        Path()
          ..moveTo(s.width, 0)
          ..lineTo(0, s.height)
          ..lineTo(s.width * .3, s.height * .3)
          ..close(),
        lining,
      );
    } else {
      canvas.drawPath(path, lining);
    }
    canvas.drawLine(
      Offset(s.width, s.height * fold),
      Offset(s.width * fold, s.height),
      edge,
    );
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.lifted != lifted;
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.done,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          height: 130,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: color, size: 46),
                  if (done)
                    const Positioned(
                      right: -8,
                      bottom: -4,
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xFF81C784),
                        size: 20,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: kBody.copyWith(fontSize: 13),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown before the first hint of a game, in case it was asked for by
/// accident.
class HintPrompt extends StatelessWidget {
  const HintPrompt(this.g, {super.key});

  final GameState g;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        child: Plaque(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const DessertFigure(
                    Dessert.donutChocolate,
                    width: 72,
                    animate: true,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ask Watsonut for a hint?', style: kHeading),
                        const SizedBox(height: 6),
                        Text(
                          'You have not used any hints yet. Are you sure you '
                          'want one? He will not ask again.',
                          style: kBody.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 14,
                runSpacing: 8,
                children: [
                  GoldButton(
                    key: const ValueKey('hint-no'),
                    label: 'No, I can manage',
                    onPressed: () => g.answerHintPrompt(wanted: false),
                  ),
                  GoldButton(
                    key: const ValueKey('hint-yes'),
                    label: 'Yes, give me the hint',
                    icon: Icons.lightbulb,
                    color: const Color(0xFF5D3A1A),
                    onPressed: () => g.answerHintPrompt(wanted: true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
