import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService({required this.plugin});
  static late SharedPreferencesService instance;
  SharedPreferences plugin;

  static Future<SharedPreferencesService> init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    instance = SharedPreferencesService(plugin: sp);
    return instance;
  }

  Future<void> removeKey({
    required String key,
  }) async {
    await plugin.remove(key);
  }

  Future<void> setInt({
    required String key,
    required int value,
  }) async {
    await plugin.setInt(key, value);
  }

  Future<void> setBool({
    required String key,
    required bool value,
  }) async {
    await plugin.setBool(key, value);
  }

  Future<void> setString({
    required String key,
    required String value,
  }) async {
    await plugin.setString(key, value);
  }

  bool? getBool(String key) {
    return plugin.getBool(key);
  }

  String? getString(String key) {
    return plugin.getString(key);
  }

  int? getInt(String key) {
    return plugin.getInt(key);
  }
}
