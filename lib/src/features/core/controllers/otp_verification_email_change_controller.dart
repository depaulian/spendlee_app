import 'dart:async';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPVerificationEmailChangeController extends GetxController {
  static OTPVerificationEmailChangeController get instance => Get.find();

  final authenticationRepo = AuthenticationRepository.instance;
  final authRepo = AuthRepository.instance;

  final List<TextEditingController> otpControllers = 
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;
  final otpError = ''.obs;
  final isResending = false.obs;
  final timerSeconds = 60.obs;
  final canResend = false.obs;

  late String newEmail;
  Timer? _timer;

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }

  void initializeWithEmail(String email, int expiresInMinutes) {
    newEmail = email;
    startTimer(expiresInMinutes * 60);
  }

  void startTimer(int seconds) {
    timerSeconds.value = seconds;
    canResend.value = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onOtpChanged(String value, int index) {
    otpError.value = '';

    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    }
  }

  void onOtpBackspace(int index) {
    if (index > 0) {
      otpControllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
    }
  }

  String getOtpCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  bool isOtpComplete() {
    return getOtpCode().length == 6;
  }

  Future<void> verifyEmailChange() async {
    if (!isOtpComplete()) {
      otpError.value = 'Please enter the complete verification code';
      return;
    }

    isLoading.value = true;
    otpError.value = '';

    try {
      final result = await authRepo.confirmEmailChange(getOtpCode());

      if (result['status']) {
        // Update the user data in AuthenticationRepository
        await authenticationRepo.initializeApp();
        
        Get.snackbar(
          'Success',
          'Email changed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate back to settings
        Get.back(); // Go back to OTP screen
        Get.back(); // Go back to email change screen
        Get.back(); // Go back to settings
      } else {
        otpError.value = result['message'];
      }
    } catch (e) {
      otpError.value = 'Failed to verify code. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (!canResend.value || isResending.value) return;

    isResending.value = true;

    try {
      final result = await authRepo.requestEmailChange(newEmail);

      if (result['status']) {
        // Clear current OTP
        for (var controller in otpControllers) {
          controller.clear();
        }
        
        // Reset focus to first field
        focusNodes[0].requestFocus();
        
        // Restart timer
        final expiresInMinutes = result['data']['expires_in_minutes'] ?? 10;
        startTimer(expiresInMinutes * 60);

        Get.snackbar(
          'Code Sent',
          'A new verification code has been sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
        'Failed to resend code. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isResending.value = false;
    }
  }

  String get formattedTime {
    final minutes = timerSeconds.value ~/ 60;
    final seconds = timerSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}