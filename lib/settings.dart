import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
      final bound = json['keys'];
      if (bound is Map) {
        for (final action in keys.keys.toList()) {
          final id = bound[action];
          if (id is int) keys[action] = id;
        }
      }
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

  /// The actions that have a key, in the order the settings list them.
  static const actions = {
    'menu': 'Settings',
    'notebook': 'Notebook',
    'map': 'Map',
  };

  /// Action -> the id of the key that performs it. They can be changed.
  final keys = <String, int>{
    'menu': LogicalKeyboardKey.escape.keyId,
    'notebook': LogicalKeyboardKey.keyN.keyId,
    'map': LogicalKeyboardKey.keyM.keyId,
  };

  /// The action [key] is bound to, if any.
  String? actionFor(LogicalKeyboardKey key) {
    for (final entry in keys.entries) {
      if (entry.value == key.keyId) return entry.key;
    }
    return null;
  }

  /// What to call the key for [action] on screen.
  String keyName(String action) {
    final key = LogicalKeyboardKey.findKeyByKeyId(keys[action]!);
    if (key == LogicalKeyboardKey.escape) return 'Esc';
    if (key == LogicalKeyboardKey.space) return 'Space';
    final label = key?.keyLabel ?? '?';
    return label.isEmpty ? '?' : label;
  }

  /// Gives [action] a new key. A key already doing something else swaps
  /// with it, so that no two actions ever share one.
  void bind(String action, LogicalKeyboardKey key) => update((s) {
    final other = s.actionFor(key);
    if (other != null && other != action) s.keys[other] = s.keys[action]!;
    s.keys[action] = key.keyId;
  });

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
        'keys': keys,
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

/// Whether the player is likely to have a keyboard: not on a phone or a
/// tablet. Keyboard shortcuts are shown and offered only where they are.
bool get hasKeyboard =>
    defaultTargetPlatform != TargetPlatform.android &&
    defaultTargetPlatform != TargetPlatform.iOS;
