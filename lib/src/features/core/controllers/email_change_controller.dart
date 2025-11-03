import 'dart:async';
import 'package:expense_tracker/src/features/core/screens/email_change/otp_verification_email_change_screen.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailChangeController extends GetxController {
  static EmailChangeController get instance => Get.find();

  final emailController = TextEditingController();
  final authenticationRepo = AuthenticationRepository.instance;
  final authRepo = AuthRepository.instance;

  final isLoading = false.obs;
  final isCheckingEmail = false.obs;
  final emailAvailable = true.obs;
  final emailError = ''.obs;
  final isEmailValid = false.obs;

  Timer? _debounce;

  @override
  void onClose() {
    emailController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void checkEmailAvailability(String email) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (email.isEmpty) {
      emailError.value = '';
      isEmailValid.value = false;
      emailAvailable.value = true;
      return;
    }

    if (!GetUtils.isEmail(email)) {
      emailError.value = 'Please enter a valid email';
      isEmailValid.value = false;
      emailAvailable.value = true;
      return;
    }

    // Check if it's the same as current email
    if (email.toLowerCase().trim() == authenticationRepo.getUserEmail.toLowerCase()) {
      emailError.value = 'This is your current email';
      isEmailValid.value = false;
      emailAvailable.value = false;
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 800), () async {
      isCheckingEmail.value = true;
      emailError.value = '';

      try {
        final result = await authRepo.checkEmailAvailability(email: email);

        if (result['status']) {
          final emailData = result['data']['email'];
          
          if (emailData['available']) {
            emailAvailable.value = true;
            emailError.value = '';
            isEmailValid.value = true;
          } else {
            emailAvailable.value = false;

            if (emailData['registration_method'] == 'google') {
              emailError.value = 'Email registered with Google. Cannot use this email';
            } else if (emailData['registration_method'] == 'apple') {
              emailError.value = 'Email registered with Apple. Cannot use this email';
            } else {
              emailError.value = 'Email already registered. Cannot use this email';
            }
            isEmailValid.value = false;
          }
        } else {
          emailError.value = 'Could not verify email';
          isEmailValid.value = false;
        }
      } catch (e) {
        emailError.value = 'Network error';
        isEmailValid.value = false;
      } finally {
        isCheckingEmail.value = false;
      }
    });
  }

  Future<void> requestEmailChange() async {
    if (!isEmailValid.value) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await authRepo.requestEmailChange(emailController.text.trim());

      if (result['status']) {
        // Navigate to OTP screen for email change
        Get.to(() => OTPVerificationEmailChangeScreen(
          newEmail: emailController.text.trim(),
          expiresInMinutes: result['data']['expires_in_minutes'] ?? 10,
        ));
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
        'Failed to send verification code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}