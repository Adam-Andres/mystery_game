import 'ambience_stub.dart' if (dart.library.js_interop) 'ambience_web.dart';

/// How the rain sounds from where Churlock is standing.
enum Weather {
  /// Out of doors, with nothing between him and it.
  outside(cutoff: 9000, volume: .5),

  /// On the ground floor: rain against windows, a wall away.
  indoors(cutoff: 1300, volume: .3),

  /// Under the attic roof, where it drums close overhead.
  attic(cutoff: 2800, volume: .45),

  /// In the basement, where it is only a murmur through the stone.
  basement(cutoff: 380, volume: .22),

  /// When the rain has stopped.
  none(cutoff: 380, volume: 0);

  const Weather({required this.cutoff, required this.volume});

  /// Everything above this pitch, in hertz, is muffled away.
  final double cutoff;
  final double volume;
}

/// A loop of rain that plays under every scene.
abstract class Ambience {
  /// Changes how the rain sounds, smoothly.
  void set(Weather weather);

  /// Called whenever the player touches the page, since a browser will not
  /// start any sound until they have.
  void wake();

  void setMuted(bool muted);
}

/// No rain at all: for tests, and platforms that cannot play it.
class SilentAmbience implements Ambience {
  Weather? weather;

  @override
  void set(Weather weather) => this.weather = weather;

  @override
  void wake() {}

  @override
  void setMuted(bool muted) {}
}

Ambience createAmbience() => createPlatformAmbience();
