import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/home/home_screen.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';

class AppleEmailForm extends StatelessWidget {
  final String appleEmail;
  final String? firstName;
  final String? lastName;
  final String appleId;

  const AppleEmailForm({
    super.key,
    required this.appleEmail,
    this.firstName,
    this.lastName,
    required this.appleId,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isLoading = false.obs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Obx(() {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(tSecondaryColor),
                side: WidgetStateProperty.all(BorderSide.none),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              onPressed: isLoading.value
                  ? null
                  : () async {
                await _continueWithAppleEmail(
                  isLoading,
                  appleEmail,
                  firstName ?? '',
                  lastName ?? '',
                  appleId,
                );
              },
              child: isLoading.value
                  ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: tWhiteColor,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Creating account...",
                    style: TextStyle(color: tWhiteColor),
                  ),
                ],
              )
                  : const Text(
                'CONTINUE WITH THIS EMAIL',
                style: TextStyle(color: tWhiteColor),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Use a different sign-in method',
            style: TextStyle(
              color: tWhiteColor.withValues(alpha: 0.7),
              decoration: TextDecoration.underline,
              decorationColor: tWhiteColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _continueWithAppleEmail(
      RxBool isLoading,
      String email,
      String firstName,
      String lastName,
      String appleId,
      ) async {
    try {
      isLoading.value = true;

      final authRepo = AuthRepository.instance;
      final authenticationRepo = AuthenticationRepository.instance;

      final loginResponse = await authRepo.loginWithApple(
        email: email,
        firstName: firstName,
        lastName: lastName,
        appleId: appleId,
      );

      if (loginResponse['status']) {
        await authenticationRepo.setUser();

        Get.snackbar(
          "Success",
          "Apple login successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

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
}