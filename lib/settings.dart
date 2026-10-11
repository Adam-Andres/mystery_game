import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'save.dart';

/// The player's preferences, remembered between visits.
class Settings extends ChangeNotifier {
  Settings([this._store]) {
    final saved = _store?.readSettings();
    if (saved == null) return;
    try {
      final json = jsonDecode(saved) as Map<String, dynamic>;
      voices = json['voices'] as bool? ?? voices;
      // It used to be only the rain, and was called so.
      haptics = (json['haptics'] ?? json['rain']) as bool? ?? haptics;
      music = json['music'] as bool? ?? music;
      remarks = json['remarks'] as bool? ?? remarks;
      quickWalk = json['quickWalk'] as bool? ?? quickWalk;
      final size = json['textSize'] as int? ?? textSize;
      textSize = size.clamp(0, textSizes.length - 1);
    } catch (_) {
      // A settings file that cannot be read is as good as none.
    }
  }

  final SaveStore? _store;

  /// The sizes dialogue can be read at, as multiples of the usual size.
  static const textSizes = [.85, 1.0, 1.2, 1.4];
  static const textSizeNames = ['Small', 'Medium', 'Large', 'Largest'];

  /// Whether the characters speak aloud.
  bool voices = true;

  /// Whether the house can be heard: the rain, the thunder, and the hum
  /// and sputter of the basement lamps.
  bool haptics = true;

  /// Whether the title screen plays its music.
  bool music = true;

  /// Whether Watsonut pipes up when Churlock stands idle.
  bool remarks = true;

  /// Whether they hurry from room to room.
  bool quickWalk = false;

  /// Index into [textSizes].
  int textSize = 1;

  double get textScale => textSizes[textSize];

  /// Changes something by way of [change], and remembers it.
  void update(void Function(Settings s) change) {
    change(this);
    _store?.writeSettings(
      jsonEncode({
        'voices': voices,
        'haptics': haptics,
        'music': music,
        'remarks': remarks,
        'quickWalk': quickWalk,
        'textSize': textSize,
      }),
    );
    notifyListeners();
  }
}

/// Makes the [Settings] available to the screens beneath it, which rebuild
/// when they change.
class SettingsScope extends InheritedNotifier<Settings> {
  const SettingsScope({
    super.key,
    required Settings settings,
    required super.child,
  }) : super(notifier: settings);

  /// The settings in force, or the defaults where none were provided.
  static Settings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsScope>()?.notifier ??
      _defaults;

  static final _defaults = Settings();
}
