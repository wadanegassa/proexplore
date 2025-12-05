import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String settingsBox = 'settings';
  static const String tripsBox = 'trips';
  static const String favoritesBox = 'favorites';

  Future<void> init() async {
    await Hive.openBox(settingsBox);
    await Hive.openBox(tripsBox);
    await Hive.openBox(favoritesBox);
  }

  // Generic Get/Set
  dynamic get(String boxName, String key, {dynamic defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> put(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }
}
