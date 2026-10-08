# The Senclair Affair — A Churlock Mystery

A point-and-click murder mystery built with Flutter, starring desserts.

Mrs. Senclair, the éclair of Donut County, has been murdered in her own cellar.
The Donut County Police have called in Detective Churlock, a churro, to search
her three-floor house and work out which of the five residents did it — one of
them alone, or two of them together.

## How to play

- **Move** between rooms with the on-screen arrows or the arrow keys.
- **Click** glowing objects to collect evidence, and click desserts to question
  them. Churlock walks over to whatever you click.
- **Search the furniture.** Closets, trunks, drawers and sacks can be opened,
  and some evidence is only found inside them. The study desk is locked; its
  combination is somewhere in the house.
- **Follow up.** Evidence unlocks new questions, and so does testimony: when one
  dessert tells you something, you can put it to the others.
- **Ask for things.** Some characters will hand over documents. Not all of
  them are genuine: a guilty dessert may give you a forgery, and each forgery
  has a flaw in it if you read closely.
- **Get your hands dirty.** Borrow the police fingerprint chart, then dust the
  murder weapon and match the prints. Shade the butler's notepad with a pencil
  to raise what was written on the missing page. Piece torn letters together.
- **Ask Watsonut.** Churlock's partner, a chocolate donut, trails after him
  and pipes up if you stand idle. While examining any evidence you can ask
  what he makes of it, and on the accusation screen he will give up to four
  hints, one at a time. The first hint of a game asks you to confirm.
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

## Voices

Every character, and the narrator of the opening and closing scenes, has their
own voice. The clips in `assets/voice/` were generated offline with
[Piper](https://github.com/rhasspy/piper), a free neural text-to-speech engine,
so the game needs no API key and makes no network calls to speak.

Voices play in the browser build. On Linux and macOS desktop builds they play
if a command-line audio player is installed (`mpv`, `ffplay`, `mpg123`,
`gst-play-1.0`, `cvlc`, or macOS's built-in `afplay`); otherwise the game is
silent, with subtitles. The speaker button mutes them.

After changing any dialogue, regenerate the clips (only new lines are made):

```sh
flutter test tool/voice_lines.dart
PIPER=/path/to/piper MODELS=/path/to/voice/models python3 tool/make_voices.py
```

The voice chosen for each character is the `VOICES` table at the top of
`tool/make_voices.py`.

## Layout

- `lib/data/` — the house, the residents, the three cases, and their shared red herrings
- `lib/audio/` — the spoken lines and the clip player
- `lib/game_state.dart` — game logic and the verdict
- `lib/screens/` — title, opening and closing scenes, game, panels, and verdict
- `lib/widgets/` — the painted rooms and characters
