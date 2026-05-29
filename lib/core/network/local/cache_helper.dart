import 'package:shared_preferences/shared_preferences.dart';

import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/services/service_locator.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = sl<SharedPreferences>();
    if (sharedPreferences.getBool('first_run') ?? true) {
      await CacheHelper.clearData();
      sharedPreferences.setString(
          'currentLanguage', AppConstant.currentLanguage);
      AppConstant.token = null;
      sharedPreferences.setBool('first_run', false);
    }
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);

    return await sharedPreferences.setDouble(key, value);
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }
}
