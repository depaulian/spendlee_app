import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/email_verification_controller.dart';

class ContinueButton extends StatelessWidget {
  final EmailVerificationController controller;

  const ContinueButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(tSecondaryColor),
            side: WidgetStateProperty.all(BorderSide.none),
          ),
          onPressed: controller.isLoading.value
              ? null // Disable button when loading
              : () {
            if (controller.isEmailValid.value &&
                !controller.isCheckingEmail.value) {
              controller.sendVerificationCode();
            }
          },
          child: controller.isLoading.value
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
                "Sending code...",
                style: TextStyle(color: tWhiteColor),
              ),
            ],
          )
              : Text(
            'CONTINUE',
            style: const TextStyle(color: tWhiteColor),
          ),
        ),
      );
    });
  }
}