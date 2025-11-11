import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static late SharedPreferences _prefs;

  // 🔑 Keys
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userRoleKey = 'userRole';
  static const String _tokenKey = 'authToken';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';
  static const String _userMobileKey = 'userMobile';
  static const String _factoryIdKey = 'factoryId';

  /// 🏁 Must call once before runApp()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ───────────────────────────────
  // LOGIN STATUS
  // ───────────────────────────────
  static void setLoggedIn(bool value) {
    _prefs.setBool(_isLoggedInKey, value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // ───────────────────────────────
  // USER DETAILS
  // ───────────────────────────────
  static void setUserDetails({
    required String id,
    required String name,
    required String mobile,
    required String role,
    required String token,
    required String factoryId,
  }) {
    _prefs.setBool(_isLoggedInKey, true);
    _prefs.setString(_userIdKey, id);
    _prefs.setString(_userNameKey, name);
    _prefs.setString(_userMobileKey, mobile);
    _prefs.setString(_userRoleKey, role);
    _prefs.setString(_tokenKey, token);
    _prefs.setString(_factoryIdKey, factoryId);
  }

  static String getUserId() => _prefs.getString(_userIdKey) ?? '';
  static String getUserName() => _prefs.getString(_userNameKey) ?? '';
  static String getUserMobile() => _prefs.getString(_userMobileKey) ?? '';
  static String getUserRole() => _prefs.getString(_userRoleKey) ?? '';
  static String getToken() => _prefs.getString(_tokenKey) ?? '';
  static String getFactoryId() => _prefs.getString(_factoryIdKey) ?? '';

  // ───────────────────────────────
  // LOGOUT / CLEAR
  // ───────────────────────────────
  static void logout() {
    _prefs.setBool(_isLoggedInKey, false);
    _prefs.remove(_userIdKey);
    _prefs.remove(_userNameKey);
    _prefs.remove(_userMobileKey);
    _prefs.remove(_userRoleKey);
    _prefs.remove(_tokenKey);
  }

  static void clearPrefs() {
    _prefs.clear();
  }
}
