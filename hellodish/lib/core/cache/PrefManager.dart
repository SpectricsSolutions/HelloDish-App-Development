import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  static final PrefManager _instance = PrefManager._internal();
  factory PrefManager() => _instance;
  PrefManager._internal();

  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserName  = 'user_name';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserCountryCode = 'user_country_code';
  static const String _keyUserId    = 'user_id';

  // ─── Auth Token ───────────────────────────────────────────────

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken);
  }

  Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken);
  }

  // ─── User Info ────────────────────────────────────────────────

  Future<void> saveUserInfo({
    required String userId,
    required String firstName,
    required String lastName,
    required String phone,
    required String countryCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, '$firstName $lastName'.trim());
    await prefs.setString(_keyUserPhone, phone);
    await prefs.setString(_keyUserCountryCode, countryCode);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  Future<String?> getUserCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserCountryCode);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // ─── Clear All ────────────────────────────────────────────────

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}