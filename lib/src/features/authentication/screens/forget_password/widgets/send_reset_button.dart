import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/forgot_password_controller.dart';

class SendResetButton extends StatelessWidget {
  final ForgotPasswordController controller;

  const SendResetButton({super.key, required this.controller});

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
          onPressed: controller.isLoading.value || controller.resetLinkSent.value
              ? null
              : () {
            if (controller.isEmailValid.value) {
              controller.sendResetLink();
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
                "Sending reset link...",
                style: TextStyle(color: tWhiteColor),
              ),
            ],
          )
              : controller.resetLinkSent.value
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: tWhiteColor),
                    SizedBox(width: 8),
                    Text(
                      'RESET LINK SENT!',
                      style: TextStyle(color: tWhiteColor),
                    ),
                  ],
                )
              : const Text(
                  'SEND RESET LINK',
                  style: TextStyle(color: tWhiteColor),
                ),
        ),
      );
    });
  }
}