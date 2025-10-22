import 'dart:async';
import 'package:expense_tracker/src/features/core/screens/home/home_screen.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/features/authentication/screens/login/login_screen.dart';

class CompleteRegistrationController extends GetxController {
  static CompleteRegistrationController get instance => Get.find();

  final authRepo = AuthRepository.instance;
  final authenticationRepo = AuthenticationRepository.instance;

  // Text controllers
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  final isLoading = false.obs;
  final isCheckingUsername = false.obs;
  final usernameAvailable = true.obs;
  final usernameError = ''.obs;
  final isUsernameValid = false.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final usernameSuggestions = <String>[].obs;
  final firstNameError = ''.obs;
  final lastNameError = ''.obs;

  String email = '';
  String verificationToken = '';
  Timer? _debounce;

  void initializeWithData(String userEmail, String token) {
    email = userEmail;
    verificationToken = token;
  }

  @override
  void onClose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void checkUsernameAvailability(String username) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    usernameSuggestions.clear();

    if (username.isEmpty) {
      usernameError.value = '';
      isUsernameValid.value = false;
      usernameAvailable.value = true;
      return;
    }

    if (username.length < 3) {
      usernameError.value = 'Username must be at least 3 characters';
      isUsernameValid.value = false;
      usernameAvailable.value = true;
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      usernameError.value = 'Only letters, numbers and underscore allowed';
      isUsernameValid.value = false;
      usernameAvailable.value = true;
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 800), () async {
      isCheckingUsername.value = true;
      usernameError.value = '';

      try {
        final result = await authRepo.checkEmailAvailability(username: username);

        if (result['status']) {
          final usernameData = result['data']['username'];

          if (usernameData['available']) {
            usernameAvailable.value = true;
            usernameError.value = '';
            isUsernameValid.value = true;
            usernameSuggestions.clear();
          } else {
            usernameAvailable.value = false;
            usernameError.value = 'Username already taken';
            isUsernameValid.value = false;

            if (usernameData['suggestions'] != null) {
              usernameSuggestions.value = List<String>.from(usernameData['suggestions']);
            }
          }
        } else {
          usernameError.value = 'Could not verify username';
          isUsernameValid.value = false;
        }
      } catch (e) {
        usernameError.value = 'Network error';
        isUsernameValid.value = false;
      } finally {
        isCheckingUsername.value = false;
      }
    });
  }

  void selectSuggestion(String suggestion) {
    usernameController.text = suggestion;
    usernameSuggestions.clear();
    checkUsernameAvailability(suggestion);
  }

  void validateFirstName(String firstName) {
    if (firstName.trim().isEmpty) {
      firstNameError.value = 'First name is required';
    } else {
      firstNameError.value = '';
    }
  }

  void validateLastName(String lastName) {
    if (lastName.trim().isEmpty) {
      lastNameError.value = 'Last name is required';
    } else {
      lastNameError.value = '';
    }
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      passwordError.value = '';
      return;
    }

    if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }

    if (confirmPasswordController.text.isNotEmpty) {
      validateConfirmPassword(confirmPasswordController.text);
    }
  }

  void validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = '';
      return;
    }

    if (confirmPassword != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  bool isFormValid() {
    return isUsernameValid.value &&
        usernameAvailable.value &&
        firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        passwordController.text.length >= 6 &&
        confirmPasswordController.text == passwordController.text &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        firstNameError.value.isEmpty &&
        lastNameError.value.isEmpty;
  }

  Future<void> completeRegistration() async {
    validateFirstName(firstNameController.text);
    validateLastName(lastNameController.text);
    validatePassword(passwordController.text);
    validateConfirmPassword(confirmPasswordController.text);

    if (!isFormValid()) {
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await authRepo.completeRegistration(
        verificationToken: verificationToken,
        username: usernameController.text.trim(),
        password: passwordController.text,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      if (result['status']) {
        // Set user in authentication repository if needed
        await authenticationRepo.setUser();
        // Navigate to home screen
        Get.offAll(() => const HomeScreenPage());
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete registration. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}