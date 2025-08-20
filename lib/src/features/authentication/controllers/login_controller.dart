import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expense_tracker/src/features/core/screens/home/home_screen.dart';
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

  // Loader
  final isLoading = false.obs;

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

        Get.snackbar(
          "Success",
          "Login successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

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
      isLoading.value = true;

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        isLoading.value = false;
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
      isLoading.value = false;
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