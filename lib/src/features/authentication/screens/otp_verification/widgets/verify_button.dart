import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/otp_verification_controller.dart';

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OTPVerificationController.instance;

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
            if (controller.isOTPComplete()) {
              controller.verifyOTP();
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
            'VERIFY CODE',
            style: TextStyle(color: tWhiteColor),
          ),
        ),
      );
    });
  }
}