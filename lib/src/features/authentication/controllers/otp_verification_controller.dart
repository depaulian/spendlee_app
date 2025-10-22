import 'dart:async';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPVerificationController extends GetxController {
  static OTPVerificationController get instance => Get.find();

  final authRepo = AuthRepository.instance;

  // Text editing controllers for each OTP digit
  final otpController1 = TextEditingController();
  final otpController2 = TextEditingController();
  final otpController3 = TextEditingController();
  final otpController4 = TextEditingController();
  final otpController5 = TextEditingController();
  final otpController6 = TextEditingController();

  // Focus nodes for each field
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();

  final isLoading = false.obs;
  final isResending = false.obs;
  final canResend = false.obs;
  final canResendCode = false.obs; // Separate flag for resend button (60s)
  final remainingSeconds = 0.obs; // For code expiry timer
  final resendRemainingSeconds = 0.obs; // For resend button timer (60s)

  String email = '';
  Timer? _expiryTimer;
  Timer? _resendTimer;

  // Initialize with email and expiry time from screen parameters
  void initializeWithEmail(String userEmail, int expiresInMinutes) {
    email = userEmail;
    startExpiryTimer(expiresInMinutes * 60);
    startResendTimer(60); // 60 seconds for resend button
  }

  @override
  void onClose() {
    _expiryTimer?.cancel();
    _resendTimer?.cancel();
    otpController1.dispose();
    otpController2.dispose();
    otpController3.dispose();
    otpController4.dispose();
    otpController5.dispose();
    otpController6.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    super.onClose();
  }

  void startExpiryTimer(int seconds) {
    remainingSeconds.value = seconds;
    canResend.value = false;

    _expiryTimer?.cancel();
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void startResendTimer(int seconds) {
    resendRemainingSeconds.value = seconds;
    canResendCode.value = false;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendRemainingSeconds.value > 0) {
        resendRemainingSeconds.value--;
      } else {
        canResendCode.value = true;
        timer.cancel();
      }
    });
  }

  String get timerText {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get resendTimerText {
    final seconds = resendRemainingSeconds.value;
    return '${seconds}s';
  }

  String getOTP() {
    return otpController1.text +
        otpController2.text +
        otpController3.text +
        otpController4.text +
        otpController5.text +
        otpController6.text;
  }

  bool isOTPComplete() {
    return otpController1.text.isNotEmpty &&
        otpController2.text.isNotEmpty &&
        otpController3.text.isNotEmpty &&
        otpController4.text.isNotEmpty &&
        otpController5.text.isNotEmpty &&
        otpController6.text.isNotEmpty;
  }

  void clearOTP() {
    otpController1.clear();
    otpController2.clear();
    otpController3.clear();
    otpController4.clear();
    otpController5.clear();
    otpController6.clear();
    focusNode1.requestFocus();
  }

  Future<void> verifyOTP() async {
    if (!isOTPComplete()) {
      Get.snackbar(
        'Error',
        'Please enter the complete verification code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final otp = getOTP();
      final result = await authRepo.verifyEmailCode(email, otp);

      if (result['status']) {
        // Navigate to complete registration screen
        await Future.delayed(const Duration(milliseconds: 500));

        // TODO: Navigate to CompleteRegistrationScreen with verification token
        // Get.off(() => CompleteRegistrationScreen(
        //   email: email,
        //   verificationToken: result['verification_token'],
        // ));

        print('Verification token: ${result['verification_token']}');
        print('Email: $email');
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        clearOTP();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify code. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      clearOTP();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (!canResendCode.value || isResending.value) return;

    isResending.value = true;

    try {
      final result = await authRepo.resendVerificationCode(email);

      if (result['status']) {

        clearOTP();

        // Restart both timers
        final expiresInMinutes = result['expires_in_minutes'] ?? 10;
        startExpiryTimer(expiresInMinutes * 60);
        startResendTimer(60); // Reset 60s resend timer
      } else {
        final retryAfter = result['retry_after'];
        if (retryAfter != null) {
          // Use the retry_after value for resend timer
          startResendTimer(int.parse(retryAfter));
          Get.snackbar(
            'Too Many Attempts',
            'Please wait before requesting another code',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
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

  void handlePaste(String text) {
    // Remove any non-digit characters
    final digits = text.replaceAll(RegExp(r'\D'), '');

    if (digits.length >= 6) {
      otpController1.text = digits[0];
      otpController2.text = digits[1];
      otpController3.text = digits[2];
      otpController4.text = digits[3];
      otpController5.text = digits[4];
      otpController6.text = digits[5];
      focusNode6.requestFocus();

      // Auto-verify if all digits are filled
      if (isOTPComplete()) {
        verifyOTP();
      }
    }
  }
}