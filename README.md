# The Senclair Affair — A Churlock Mystery

A point-and-click murder mystery built with Flutter, starring desserts.

Mrs. Senclair, the éclair of Donut County, has been murdered in her own cellar.
The Donut County Police have called in Detective Churlock, a churro, to search
her three-floor house and work out which of the five residents did it — one of
them alone, or two of them together.

## How to play

- **Move** between rooms with the on-screen arrows or the arrow keys.
- **Click** glowing objects to collect evidence, and click desserts to question
  them.
- **Follow up.** Evidence unlocks new questions, and so does testimony: when one
  dessert tells you something, you can put it to the others.
- **Check the notebook** for everything found and said so far.
- When you are sure, return to the **Entrance Hall**, press
  **I solved the case**, and accuse one or two residents.

Get it right and the case is closed. Get it wrong and an innocent dessert goes
to jail while the killer strikes again.

Everybody has a motive and nobody confesses. Most of what you find is a red
herring with an innocent explanation, so the case is solved by checking every
alibi against the evidence and against the other residents.

There are three mysteries, chosen at random. Each game also draws its evidence
at random from that mystery's pool — key clues turn up in different forms and
places, and a different set of red herrings is scattered about — so replaying
a case is not the same hunt twice.

## Running

```sh
flutter run -d linux   # or: -d chrome, -d windows, -d macos
flutter test
```

All artwork is drawn in code, so there are no image assets.

## Layout

- `lib/data/` — the house, the residents, the three cases, and their shared red herrings
- `lib/game_state.dart` — game logic and the verdict
- `lib/screens/` — title, game, panels, and ending
- `lib/widgets/` — the painted rooms and characters
