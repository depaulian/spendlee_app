import 'package:expense_tracker/src/constants/external_endpoints.dart';
import 'package:expense_tracker/src/features/core/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/authentication/models/user.dart';
import 'package:expense_tracker/src/features/authentication/screens/login/login_screen.dart';
import 'package:expense_tracker/src/features/core/screens/home/home_screen.dart';
import 'package:expense_tracker/src/repository/preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  late final Rx<User?> _user = Rx<User?>(null);
  final Rx<Currency> _currentCurrency = AppCurrencies.getDefault().obs;
  final UserPreferences userPreferences = UserPreferences();

  // Getters
  User? get appUser => _user.value;
  int get getUserID => _user.value?.id ?? 0;
  String get getUserEmail => _user.value?.email ?? "";
  String get getUsername => _user.value?.username ?? "";
  String get getUserFullName => _user.value?.fullName ?? "";
  bool get isPremiumUser => _user.value?.isPremium ?? false;
  bool get isUserActive => _user.value?.isActive ?? false;

  Currency get currentCurrency => _currentCurrency.value;
  List<Currency> get availableCurrencies => AppCurrencies.all;

  @override
  void onReady() {
    super.onReady();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      await UserPreferences.init();

      final results = await Future.wait([
        _loadUserData(),
        _loadCurrency(),
      ]);

      final user = results[0] as User?;
      final currency = results[1] as Currency;

      _user.value = user;
      _currentCurrency.value = currency;

      // Identify user in RevenueCat if already logged in
      if (user != null) {
        try {
          await Purchases.logIn(user.id.toString());
          print('RevenueCat user identified on app init: ${user.id}');
        } catch (e) {
          print('Error identifying user in RevenueCat during init: $e');
        }
      }

      await _setInitialScreen(user);
      FlutterNativeSplash.remove();
    } catch (error) {
      print('Initialization error: $error');
      _currentCurrency.value = AppCurrencies.getDefault();
      _user.value = null;

      // Navigate to login screen on error
      Get.offAll(() => const LoginScreen());
      FlutterNativeSplash.remove();

      Get.snackbar(
        "Error",
        "Could not initialize app. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<User?> _loadUserData() async {
    try {
      return await userPreferences.getUser();
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  Future<Currency> _loadCurrency() async {
    try {
      return await userPreferences.getCurrency();
    } catch (e) {
      print('Error loading currency: $e');
      return AppCurrencies.getDefault();
    }
  }

  Future<void> setCurrency(String currencyCode) async {
    try {
      final currency = AppCurrencies.findByCode(currencyCode);
      if (currency != null) {
        await userPreferences.setCurrency(currencyCode);
        _currentCurrency.value = currency;

        Get.snackbar(
          "Success",
          "Currency updated to ${currency.name}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Currency not found');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not update currency. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String formatAmount(double amount) {
    return '${_currentCurrency.value.symbol}${amount.toStringAsFixed(2)}';
  }

  String formatAmountWithoutSymbol(double amount) {
    return amount.toStringAsFixed(2);
  }

  Future<void> setUser([User? user]) async {
    try {
      final userData = user ?? await userPreferences.getUser();
      _user.value = userData;
      
      // Identify user in RevenueCat when user data is set
      if (userData != null) {
        try {
          await Purchases.logIn(userData.id.toString());
          print('RevenueCat user identified: ${userData.id}');
        } catch (e) {
          print('Error identifying user in RevenueCat: $e');
          // Don't throw error as this shouldn't block user login
        }
      }
    } catch (e) {
      print('Error setting user: $e');
      _user.value = null;
      Get.snackbar(
        "Error",
        "Could not load user data. Please try logging in again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _setInitialScreen(User? user) async {
    // Check if user is logged in and has valid tokens
    final isLoggedIn = await userPreferences.isLoggedIn();
    final hasTokens = await userPreferences.hasValidTokens();

    if (user != null && isLoggedIn && hasTokens) {
      // User is logged in with valid data and tokens
      Get.offAll(() => const HomeScreenPage());
    } else {
      // User is not logged in or data is invalid
      Get.offAll(() => const LoginScreen());
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final user = await userPreferences.getUser();
      final hasTokens = await userPreferences.hasValidTokens();
      final isLoggedIn = await userPreferences.isLoggedIn();

      return user != null && hasTokens && isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final accessToken = await UserPreferences().getAccessToken();

      if (accessToken != null) {
        try {
          await http.post(
            Uri.parse(tLogoutUrl),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );
        } catch (e) {
          // Continue with local logout even if API call fails
          print('Logout API call failed: $e');
        }
      }

      // Log out from RevenueCat
      try {
        await Purchases.logOut();
        print('RevenueCat user logged out');
      } catch (e) {
        print('Error logging out from RevenueCat: $e');
      }

      // Clear all stored data
      await userPreferences.clearAll();

      // Reset reactive variables
      _user.value = null;
      _currentCurrency.value = AppCurrencies.getDefault();

      // Navigate to login screen
      Get.offAll(() => const LoginScreen());

    } catch (e) {
      print('Error during logout: $e');
      // Force logout even if there's an error
      Get.offAll(() => const LoginScreen());
    }
  }

  // Helper method to refresh user data from preferences
  Future<void> refreshUserData() async {
    await setUser();
  }

  // Helper method to check if user has premium features
  bool hasFeature(String feature) {
    switch (feature) {
      case 'unlimited_scans':
        return isPremiumUser;
      case 'advanced_reports':
        return isPremiumUser;
      case 'export_data':
        return isPremiumUser;
      default:
        return true; // Basic features are always available
    }
  }

  // Helper method to get remaining free scans for non-premium users
  int getRemainingFreeScans() {
    if (isPremiumUser) return -1; // Unlimited for premium users

    final monthlyScansUsed = _user.value?.monthlyScansUsed ?? 0;
    const freeScansLimit = 5; // Adjust based on your business logic

    return (freeScansLimit - monthlyScansUsed).clamp(0, freeScansLimit);
  }
}