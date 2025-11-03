import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:expense_tracker/src/features/core/screens/home/home_screen.dart';
import 'package:expense_tracker/src/features/authentication/screens/apple_email_confirmation/apple_email_confirmation_screen.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Repositories
  final authRepo = AuthRepository.instance;
  final authenticationRepo = AuthenticationRepository.instance;

  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // TextField Controllers
  final login = TextEditingController();
  final password = TextEditingController();

  // Loaders
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isAppleLoading = false.obs;

  // Email & Password Login (Updated for Spendlee API)
  Future<void> loginUser() async {
    final username = login.text.trim();
    final userPassword = password.text.trim();

    if (username.isEmpty || userPassword.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter both username and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isLoading.value = true;
      final loginResponse = await authRepo.loginUser(username, userPassword);

      if (loginResponse['status']) {
        // Set user in authentication repository if needed
        await authenticationRepo.setUser();
        // Navigate to home screen
        Get.offAll(() => const HomeScreenPage());
      } else {
        Get.snackbar(
          "Login Failed",
          loginResponse['data'] ?? 'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign-In (Updated for Spendlee API)
  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        isGoogleLoading.value = false;
        return;
      }

      // Google handles token verification automatically
      // We just extract the verified user information
      final String email = googleUser.email;
      final String? displayName = googleUser.displayName;
      final String googleId = googleUser.id;

      // Parse name
      final names = _splitName(displayName ?? '');

      // Login with Google using Spendlee API
      final loginResponse = await authRepo.loginWithGoogle(
        email: email,
        firstName: names['firstName'] ?? '',
        lastName: names['lastName'] ?? '',
        googleId: googleId,
      );
      print("login response: $loginResponse");
      if (loginResponse['status']) {
        // Set user in authentication repository
        await authenticationRepo.setUser();

        Get.snackbar(
          "Success",
          "Google login successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home screen
        Get.offAll(() => const HomeScreenPage());
      } else {
        Get.snackbar(
          "Google Login Failed",
          loginResponse['data'] ?? 'Google authentication failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        // Sign out from Google on failure
        await _googleSignIn.signOut();
      }

    } catch (e) {
      Get.snackbar(
        "Google Sign-In Failed",
        "An error occurred during Google sign-in: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Sign out from Google on error
      await _googleSignIn.signOut();
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // Apple Sign-In
  Future<void> loginWithApple() async {
    try {
      isAppleLoading.value = true;

      // Check if running on iOS
      if (defaultTargetPlatform != TargetPlatform.iOS) {
        Get.snackbar(
          "Apple Sign-In Unavailable",
          "Apple Sign-In is only available on iOS devices",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        isAppleLoading.value = false;
        return;
      }

      // Check if Apple Sign In is available
      if (!await SignInWithApple.isAvailable()) {
        Get.snackbar(
          "Apple Sign-In Unavailable",
          "Apple Sign-In is not available on this device",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        isAppleLoading.value = false;
        return;
      }

      // Sign in with Apple
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Extract user information
      final String email = credential.email ?? '';
      final String? givenName = credential.givenName;
      final String? familyName = credential.familyName;
      final String appleId = credential.userIdentifier ?? '';

      // Handle case where email might be empty (returning users)
      if (email.isEmpty) {
        Get.snackbar(
          "Apple Sign-In Error",
          "Unable to retrieve email from Apple. Please try again or use a different sign-in method.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        isAppleLoading.value = false;
        return;
      }

      // Check if this is a Hide My Email address (contains @privaterelay.appleid.com)
      if (email.contains('@privaterelay.appleid.com')) {
        // Navigate to Apple email confirmation screen
        isAppleLoading.value = false;
        Get.to(() => AppleEmailConfirmationScreen(
          appleEmail: email,
          firstName: givenName,
          lastName: familyName,
          appleId: appleId,
        ));
        return;
      }

      // Login with Apple using Spendlee API
      final loginResponse = await authRepo.loginWithApple(
        email: email,
        firstName: givenName ?? '',
        lastName: familyName ?? '',
        appleId: appleId,
      );

      if (loginResponse['status']) {
        // Set user in authentication repository
        await authenticationRepo.setUser();

        Get.snackbar(
          "Success",
          "Apple login successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home screen
        Get.offAll(() => const HomeScreenPage());
      } else {
        Get.snackbar(
          "Apple Login Failed",
          loginResponse['data'] ?? 'Apple authentication failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }

    } catch (e) {
      // Check if the error is due to user cancellation
      if (e.toString().contains('UserCancel') || e.toString().contains('canceled')) {
        // User cancelled - don't show error toast
        return;
      }
      
      Get.snackbar(
        "Apple Sign-In Failed",
        "An error occurred during Apple sign-in",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isAppleLoading.value = false;
    }
  }

  // Helper method to split full name into first and last names
  Map<String, String> _splitName(String fullName) {
    final names = fullName.split(' ');
    if (names.isEmpty) return {'firstName': '', 'lastName': ''};
    if (names.length == 1) return {'firstName': names[0], 'lastName': ''};

    return {
      'firstName': names.first,
      'lastName': names.sublist(1).join(' '),
    };
  }

  @override
  void onClose() {
    login.dispose();
    password.dispose();
    super.onClose();
  }
}