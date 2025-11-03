import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/email_change_controller.dart';

class EmailChangeContinueButton extends StatelessWidget {
  final EmailChangeController controller;

  const EmailChangeContinueButton({super.key, required this.controller});

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
              ? null
              : () {
            if (controller.isEmailValid.value &&
                !controller.isCheckingEmail.value) {
              controller.requestEmailChange();
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
            'SEND VERIFICATION CODE',
            style: const TextStyle(color: tWhiteColor),
          ),
        ),
      );
    });
  }
}