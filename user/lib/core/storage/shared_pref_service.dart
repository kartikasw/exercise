import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  late final SharedPreferencesWithCache _prefs;

  SharedPrefService._(this._prefs);

  SharedPreferencesWithCache get prefs => _prefs;

  static Future<SharedPrefService> createInstance() async {
    final SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    return SharedPrefService._(prefsWithCache);
  }
}
