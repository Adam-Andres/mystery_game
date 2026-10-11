import 'package:shared_preferences/shared_preferences.dart';

/// How many investigations can be kept at once.
const saveSlots = 3;

/// Where games in progress, and the player's settings, are kept between
/// visits.
abstract class SaveStore {
  String? read(int slot);
  void write(int slot, String save);
  void clear(int slot);

  String? readSettings();
  void writeSettings(String settings);
}

/// Keeps everything on the device: in the browser's local storage on the
/// web, and in the app's own preferences elsewhere. It survives the page
/// being reloaded and the app being closed.
class DeviceStore implements SaveStore {
  DeviceStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<DeviceStore> open() async =>
      DeviceStore(await SharedPreferences.getInstance());

  static String _key(int slot) => 'senclair.save.$slot';
  static const _settings = 'senclair.settings';

  @override
  String? read(int slot) => _prefs.getString(_key(slot));

  @override
  void write(int slot, String save) => _prefs.setString(_key(slot), save);

  @override
  void clear(int slot) => _prefs.remove(_key(slot));

  @override
  String? readSettings() => _prefs.getString(_settings);

  @override
  void writeSettings(String settings) => _prefs.setString(_settings, settings);
}

/// Keeps everything only as long as the program runs: for tests.
class MemoryStore implements SaveStore {
  final slots = <int, String>{};

  /// What is in the first slot.
  String? get saved => slots[0];
  set saved(String? save) =>
      save == null ? slots.remove(0) : slots[0] = save;
  String? settings;

  @override
  String? read(int slot) => slots[slot];

  @override
  void write(int slot, String save) => slots[slot] = save;

  @override
  void clear(int slot) => slots.remove(slot);

  @override
  String? readSettings() => settings;

  @override
  void writeSettings(String settings) => this.settings = settings;
}
