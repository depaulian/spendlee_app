import 'dart:async';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final emailController = TextEditingController();
  final authRepo = AuthRepository.instance;

  final isLoading = false.obs;
  final isCheckingEmail = false.obs;
  final emailError = ''.obs;
  final isEmailValid = false.obs;
  final resetLinkSent = false.obs;

  Timer? _debounce;

  @override
  void onClose() {
    emailController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void validateEmail(String email) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (email.isEmpty) {
      emailError.value = '';
      isEmailValid.value = false;
      return;
    }

    if (!GetUtils.isEmail(email)) {
      emailError.value = 'Please enter a valid email';
      isEmailValid.value = false;
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      emailError.value = '';
      isEmailValid.value = true;
    });
  }

  Future<void> sendResetLink() async {
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
      final result = await authRepo.sendPasswordResetLink(emailController.text.trim());

      if (result['status']) {
        resetLinkSent.value = true;
        FocusManager.instance.primaryFocus?.unfocus();
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
        'Failed to send reset link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    emailController.clear();
    emailError.value = '';
    isEmailValid.value = false;
    resetLinkSent.value = false;
  }
}