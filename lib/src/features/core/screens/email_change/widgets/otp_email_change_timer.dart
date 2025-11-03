import 'package:expense_tracker/src/features/core/controllers/otp_verification_email_change_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class OTPEmailChangeTimer extends StatelessWidget {
  const OTPEmailChangeTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OTPVerificationEmailChangeController.instance;

    return Obx(() {
      if (controller.timerSeconds.value > 0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: tWhiteColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tSecondaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer_outlined,
                color: tSecondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Code expires in ${controller.formattedTime}',
                style: TextStyle(
                  color: tWhiteColor.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[300],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Code expired. Request a new one',
              style: TextStyle(
                color: Colors.red[200],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }
}