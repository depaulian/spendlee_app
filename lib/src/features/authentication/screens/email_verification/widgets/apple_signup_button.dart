import 'package:expense_tracker/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class AppleSignUpButton extends StatelessWidget {
  const AppleSignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: (controller.isLoading.value || controller.isGoogleLoading.value || controller.isAppleLoading.value)
              ? null
              : () {
            controller.loginWithApple();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide.none,
            backgroundColor: tDarkColor,
          ),
          child: controller.isAppleLoading.value
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
                'Signing up...',
                style: TextStyle(color: tWhiteColor),
              ),
            ],
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.apple,
                color: tWhiteColor,
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                'Continue with Apple',
                style: TextStyle(color: tWhiteColor),
              ),
            ],
          ),
        ),
      );
    });
  }
}