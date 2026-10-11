import 'package:flutter/widgets.dart';

import 'ambience_stub.dart' if (dart.library.js_interop) 'ambience_web.dart';

/// What can be heard of the house and the storm from where Churlock is
/// standing.
enum Weather {
  /// Out of doors, with nothing between him and the rain.
  outside(cutoff: 9000, volume: .5),

  /// On the ground floor: rain against windows, a wall away.
  indoors(cutoff: 1300, volume: .3),

  /// Under the attic roof, where it drums close overhead.
  attic(cutoff: 2800, volume: .45),

  /// In the basement, where no rain reaches: only the hum of the lamps.
  basement(cutoff: 380, volume: 0, hum: .16),

  /// When the rain has stopped.
  none(cutoff: 380, volume: 0);

  const Weather({required this.cutoff, required this.volume, this.hum = 0});

  /// Everything in the rain above this pitch, in hertz, is muffled away.
  final double cutoff;

  /// How loud the rain is.
  final double volume;

  /// How loud the electric lamps hum.
  final double hum;
}

/// The sounds of the house itself, which play under every scene: the rain,
/// the thunder, and the basement lamps.
abstract class Ambience {
  /// Changes how the rain sounds, smoothly.
  void set(Weather weather);

  /// A roll of thunder, heard through the same walls as the rain.
  void thunder();

  /// The sputter of a basement lamp as it flickers.
  void flicker();

  /// One of the animals speaks: `bark` or `meow`.
  void creature(String sound);

  /// Starts the title music, or lets it fade away.
  void setMusic(bool playing);

  void setMusicMuted(bool muted);

  /// Called whenever the player touches the page, since a browser will not
  /// start any sound until they have.
  void wake();

  void setMuted(bool muted);
}

/// No rain at all: for tests, and platforms that cannot play it.
class SilentAmbience implements Ambience {
  Weather? weather;
  bool muted = false;
  int rumbles = 0;

  @override
  void set(Weather weather) => this.weather = weather;

  @override
  void thunder() => rumbles++;

  int flickers = 0;

  @override
  void flicker() => flickers++;

  final creatures = <String>[];

  @override
  void creature(String sound) => creatures.add(sound);

  bool music = false;
  bool musicMuted = false;

  @override
  void setMusic(bool playing) => music = playing;

  @override
  void setMusicMuted(bool muted) => musicMuted = muted;

  @override
  void wake() {}

  @override
  void setMuted(bool muted) => this.muted = muted;
}

Ambience createAmbience() => createPlatformAmbience();

/// Makes the [Ambience] available to the scenes beneath it, so that they
/// can call for thunder when they show lightning.
class AmbienceScope extends InheritedWidget {
  const AmbienceScope({
    super.key,
    required this.ambience,
    required super.child,
  });

  final Ambience ambience;

  static Ambience? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AmbienceScope>()?.ambience;

  @override
  bool updateShouldNotify(AmbienceScope old) => old.ambience != ambience;
}
