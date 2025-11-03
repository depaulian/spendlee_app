import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/controllers/change_password_controller.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class ChangePasswordSubmitButton extends StatelessWidget {
  final ChangePasswordController controller;

  const ChangePasswordSubmitButton({
    super.key,
    required this.controller,
  });

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
          onPressed: controller.isLoading.value ? null : controller.changePassword,
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
                      "Changing password...",
                      style: TextStyle(color: tWhiteColor),
                    ),
                  ],
                )
              : const Text(
                  'CHANGE PASSWORD',
                  style: TextStyle(color: tWhiteColor),
                ),
        ),
      );
    });
  }
}