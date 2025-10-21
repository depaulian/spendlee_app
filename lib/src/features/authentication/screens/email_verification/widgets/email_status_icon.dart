import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/email_verification_controller.dart';

class EmailStatusIcon extends StatelessWidget {
  final EmailVerificationController controller;

  const EmailStatusIcon({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCheckingEmail.value) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(tSecondaryColor),
            ),
          ),
        );
      }

      if (controller.emailError.value.isNotEmpty) {
        return Icon(
          Icons.error,
          color: Colors.red[300],
          size: 24,
        );
      }

      if (controller.isEmailValid.value && controller.emailAvailable.value) {
        return Icon(
          Icons.check_circle,
          color: Colors.green[400],
          size: 24,
        );
      }

      return const SizedBox.shrink();
    });
  }
}