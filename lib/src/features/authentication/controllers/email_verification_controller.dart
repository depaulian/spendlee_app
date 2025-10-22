import 'dart:async';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/otp_verification_screen.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  static EmailVerificationController get instance => Get.find();

  final emailController = TextEditingController();
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

    _debounce = Timer(const Duration(milliseconds: 800), () async {
      isCheckingEmail.value = true;
      emailError.value = '';

      try {
        final result = await authRepo.checkEmailAvailability(email:email);

        if (result['status']) {
          final emailData = result['data']['email'];
          emailData['available'];

          if (emailData['available']) {
            emailAvailable.value = true;
            emailError.value = '';
            isEmailValid.value = true;
          } else {
            emailAvailable.value = false;

            if (emailData['registration_method'] == 'google') {
              emailError.value = 'Email registered with Google. Please use Google Sign-In';
            } else {
              emailError.value = 'Email already registered. Please log in';
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

  Future<void> sendVerificationCode() async {
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
      final result = await authRepo.sendVerificationCode(emailController.text.trim());
      print(result);

      if (result['status']) {

        // Navigate to OTP screen
        Get.to(() => OTPVerificationScreen(
          email: emailController.text.trim(),
          expiresInMinutes: result['expires_in_minutes'] ?? 10,
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