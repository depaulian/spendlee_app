import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/otp_verification_email_change_controller.dart';

class OTPEmailChangeVerifyButton extends StatelessWidget {
  const OTPEmailChangeVerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OTPVerificationEmailChangeController.instance;

    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(tSecondaryColor),
            side: WidgetStateProperty.all(BorderSide.none),
          ),
          onPressed: controller.isLoading.value
              ? null
              : () {
            if (controller.isOtpComplete()) {
              controller.verifyEmailChange();
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
                "Verifying...",
                style: TextStyle(color: tWhiteColor),
              ),
            ],
          )
              : const Text(
            'CONFIRM EMAIL CHANGE',
            style: TextStyle(color: tWhiteColor),
          ),
        ),
      );
    });
  }
}