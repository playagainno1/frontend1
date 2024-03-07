import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  final Map<String, String> _cache = {};

  Future<SharedPreferences> _getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<String> get(String key) async {
    if (_cache.containsKey(key)) {
      return _cache[key] ?? "";
    }

    var sharedPreferences = await _getSharedPreferences();
    var value = sharedPreferences.getString(key) ?? "";
    _cache[key] = value;
    return value;
  }

  Future<void> set(String key, String value) async {
    var sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.setString(key, value);
    _cache[key] = value;
  }

  Future<void> remove(String key) async {
    _cache.remove(key);
    var sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.remove(key);
  }
}