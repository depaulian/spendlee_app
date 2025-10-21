import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/src/features/core/models/currency_model.dart';
import 'package:expense_tracker/src/features/authentication/models/user.dart';

class UserPreferences {
  static UserPreferences? _instance;
  static SharedPreferences? _preferences;

  static const String _keyUser = 'user';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _currencyKey = 'app_currency';

  UserPreferences._();

  static UserPreferences get instance {
    _instance ??= UserPreferences._();
    return _instance!;
  }

  factory UserPreferences() => instance;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // User operations (Updated for Spendlee API)
  Future<void> saveUser(User user) async {
    if (_preferences == null) await init();
    final userJson = jsonEncode(user.toJson());
    await _preferences!.setString(_keyUser, userJson);
    await _preferences!.setBool(_keyIsLoggedIn, true);
  }

  Future<User?> getUser() async {
    if (_preferences == null) await init();
    final userJson = _preferences!.getString(_keyUser);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Access Token operations
  Future<void> saveAccessToken(String token) async {
    if (_preferences == null) await init();
    await _preferences!.setString(_keyAccessToken, token);
  }

  Future<String?> getAccessToken() async {
    if (_preferences == null) await init();
    return _preferences!.getString(_keyAccessToken);
  }

  // Refresh Token operations
  Future<void> saveRefreshToken(String token) async {
    if (_preferences == null) await init();
    await _preferences!.setString(_keyRefreshToken, token);
  }

  Future<String?> getRefreshToken() async {
    if (_preferences == null) await init();
    return _preferences!.getString(_keyRefreshToken);
  }

  // Login status
  Future<bool> isLoggedIn() async {
    if (_preferences == null) await init();
    return _preferences!.getBool(_keyIsLoggedIn) ?? false;
  }

  // Check if tokens exist
  Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  // Clear all data
  Future<void> clearAll() async {
    if (_preferences == null) await init();
    await _preferences!.remove(_keyUser);
    await _preferences!.remove(_keyAccessToken);
    await _preferences!.remove(_keyRefreshToken);
    await _preferences!.setBool(_keyIsLoggedIn, false);
  }

  // Currency operations
  Future<String> getCurrencyCode() async {
    if (_preferences == null) await init();
    
    // First check if user has a stored preference
    String? storedCurrency = _preferences!.getString(_currencyKey);
    if (storedCurrency != null) {
      return storedCurrency;
    }
    
    // If no stored preference, get user's default currency
    final user = await getUser();
    if (user != null) {
      return user.defaultCurrency;
    }
    
    // Fallback to USD if no user or default currency
    return 'USD';
  }

  Future<Currency> getCurrency() async {
    final code = await getCurrencyCode();
    return AppCurrencies.findByCode(code) ?? AppCurrencies.getDefault();
  }

  Future<bool> setCurrency(String currencyCode) async {
    if (_preferences == null) await init();
    return await _preferences!.setString(_currencyKey, currencyCode);
  }
}