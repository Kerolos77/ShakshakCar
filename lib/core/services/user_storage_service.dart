import 'dart:convert';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/shared/authentication/data/models/profile_model.dart';

class UserStorageService {
  static const String _userKey = 'cached_user_data';

  /// حفظ بيانات المستخدم بالكامل كـ JSON
  static Future<bool> saveUser(UserData user) async {
    final String userJson = jsonEncode(user.toJson());
    return await CacheHelper.saveData(key: _userKey, value: userJson);
  }

  /// استرجاع بيانات المستخدم
  static UserData? getUser() {
    final dynamic data = CacheHelper.getData(key: _userKey);
    if (data != null && data is String && data.isNotEmpty) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(data);
        return UserData.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// حذف بيانات المستخدم (تسجيل خروج)
  static Future<bool> removeUser() async {
    return await CacheHelper.removeData(key: _userKey);
  }

  /// هل المستخدم مسجل دخول؟
  static bool isLoggedIn() {
    return getUser() != null;
  }
}
