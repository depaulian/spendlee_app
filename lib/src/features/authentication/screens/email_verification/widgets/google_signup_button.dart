import 'package:expense_tracker/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';

class GoogleSignUpButton extends StatelessWidget {
  const GoogleSignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: controller.isLoading.value
              ? const SizedBox(width: 24, height: 24)
              : Image.asset(
            tGoogleLogoImage,
            width: 24,
          ),
          label: controller.isLoading.value
              ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: tDarkColor,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Signing up...',
                style: TextStyle(color: tDarkColor),
              ),
            ],
          )
              : const Text(
            'Sign up with Google',
            style: TextStyle(color: tDarkColor),
          ),
          onPressed: controller.isLoading.value
              ? null
              : () {
            controller.loginWithGoogle();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide.none,
            backgroundColor: tWhiteColor,
          ),
        ),
      );
    });
  }
}