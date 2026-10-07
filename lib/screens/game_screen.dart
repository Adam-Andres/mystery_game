import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/house.dart';
import '../data/models.dart';
import '../game_state.dart';
import '../widgets/dessert_figure.dart';
import '../widgets/room_painter.dart';
import '../widgets/ui.dart';
import 'panels.dart';

/// Y of the ground the characters stand on.
const double _standY = 478;

class GameScreen extends StatelessWidget {
  const GameScreen(this.g, {super.key});

  final GameState g;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      if (g.dialogue != null) {
        g.closeDialogue();
      } else if (g.panel != Panel.none) {
        g.closePanel();
      }
      return KeyEventResult.handled;
    }
    final dir = {
      LogicalKeyboardKey.arrowLeft: Dir.left,
      LogicalKeyboardKey.arrowRight: Dir.right,
      LogicalKeyboardKey.arrowUp: Dir.up,
      LogicalKeyboardKey.arrowDown: Dir.down,
    }[key];
    if (dir == null) return KeyEventResult.ignored;
    g.move(dir);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final room = g.room;
    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: RoomPainter(room, caseId: g.mystery.id)),
          ),
          for (final e in g.evidenceHere)
            Positioned(
              left: e.pos.dx - 24,
              top: e.pos.dy - 24,
              child: _EvidenceSpot(
                key: ValueKey('evidence-${e.id}'),
                evidence: e,
                found: g.found.contains(e.id),
                onTap: () => g.inspect(e),
              ),
            ),
          for (final (id, x) in placements[room.id] ?? const <(String, double)>[])
            _character(personById(id), x),
          const Positioned(
            left: 38,
            top: _standY - 143,
            child: IgnorePointer(child: DessertFigure(Dessert.churro, width: 110)),
          ),
          for (final d in Dir.values)
            if (neighbor(room, d) case final Room next) _arrow(d, next),
          Positioned(left: 14, top: 12, child: _RoomLabel(room)),
          Positioned(right: 14, top: 12, child: _Hud(g)),
          if (room.id == 'entrance')
            Positioned(
              left: 60,
              bottom: 16,
              child: GoldButton(
                key: const ValueKey('solve'),
                label: 'I solved the case',
                icon: Icons.gavel,
                color: kRed,
                onPressed: () => g.openPanel(Panel.accuse),
              ),
            ),
          if (g.dialogue != null) ...[
            Scrim(onTap: g.closeDialogue, opacity: .25),
            Positioned(left: 20, right: 20, bottom: 14, height: 236, child: DialoguePanel(g)),
          ],
          if (g.panel != Panel.none) ...[
            Scrim(onTap: g.closePanel),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: g.panel == Panel.notebook ? NotebookPanel(g) : AccusePanel(g),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _character(Person p, double x) {
    return Positioned(
      left: x - 70,
      top: _standY - 130 - 26,
      width: 140,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: ValueKey('person-${p.id}'),
          onTap: () => g.talkTo(p),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kInk.withValues(alpha: .85),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  p.name,
                  style: const TextStyle(color: kGold, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              DessertFigure(p.dessert),
            ],
          ),
        ),
      ),
    );
  }

  Widget _arrow(Dir d, Room next) {
    final (icon, alignment) = switch (d) {
      Dir.left => (Icons.arrow_back, const Alignment(-.98, -.25)),
      Dir.right => (Icons.arrow_forward, const Alignment(.98, -.25)),
      Dir.up => (Icons.arrow_upward, const Alignment(0, -.96)),
      Dir.down => (Icons.arrow_downward, const Alignment(0, .96)),
    };
    return Align(
      alignment: alignment,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: ValueKey('go-${d.name}'),
          onTap: () => g.move(d),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: kInk.withValues(alpha: .8),
                  shape: BoxShape.circle,
                  border: Border.all(color: kGold, width: 2),
                ),
                child: Icon(icon, color: kGold, size: 30),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(next.name, style: const TextStyle(color: kCream, fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomLabel extends StatelessWidget {
  const _RoomLabel(this.room);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Plaque(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(room.name, style: kHeading),
          Text(room.levelName, style: const TextStyle(color: kCream, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  const _Hud(this.g);

  final GameState g;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldButton(
          key: const ValueKey('notebook'),
          label: 'Notebook  ${g.found.length}/${g.mystery.evidence.length}',
          icon: Icons.menu_book,
          onPressed: () => g.openPanel(Panel.notebook),
        ),
        const SizedBox(width: 10),
        Plaque(
          padding: const EdgeInsets.all(7),
          child: Column(
            children: [
              for (var level = 2; level >= 0; level--)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var col = 0; col < 4; col++) _cell(level, col),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// One room on the mini-map: gold where Churlock is, cream once visited.
  Widget _cell(int level, int col) {
    Room? room;
    for (final r in rooms) {
      if (r.level == level && r.col == col) room = r;
    }
    final Color color;
    if (room == null) {
      color = Colors.transparent;
    } else if (room.id == g.roomId) {
      color = kGold;
    } else if (g.visited.contains(room.id)) {
      color = kCream.withValues(alpha: .55);
    } else {
      color = Colors.white12;
    }
    return Container(
      width: 16,
      height: 10,
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
  }
}

class _EvidenceSpot extends StatefulWidget {
  const _EvidenceSpot({
    super.key,
    required this.evidence,
    required this.found,
    required this.onTap,
  });

  final Evidence evidence;
  final bool found;
  final VoidCallback onTap;

  @override
  State<_EvidenceSpot> createState() => _EvidenceSpotState();
}

class _EvidenceSpotState extends State<_EvidenceSpot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.evidence;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: widget.found
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(e.icon, color: e.color.withValues(alpha: .45), size: 28),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.check_circle, color: Color(0xFF81C784), size: 18),
                    ),
                  ],
                )
              : AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) => DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: e.color.withValues(alpha: .25 + .35 * _pulse.value),
                          blurRadius: 10 + 10 * _pulse.value,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                  child: Icon(
                    e.icon,
                    color: e.color,
                    size: 30,
                    shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
        ),
      ),
    );
  }
}
