import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/otp_verification_email_change_controller.dart';

class OTPEmailChangeResendButton extends StatelessWidget {
  const OTPEmailChangeResendButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OTPVerificationEmailChangeController.instance;

    return Obx(() {
      final canResend = controller.canResend.value && !controller.isResending.value;

      return Center(
        child: Column(
          children: [
            if (!controller.canResend.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Resend in ${controller.formattedTime}',
                  style: TextStyle(
                    color: tWhiteColor.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ),
            TextButton(
              onPressed: canResend ? controller.resendCode : null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: controller.isResending.value
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(tWhiteColor),
                ),
              )
                  : Text(
                'Didn\'t receive code? Resend',
                style: TextStyle(
                  color: canResend ? tWhiteColor : tWhiteColor.withOpacity(0.4),
                  fontSize: 14,
                  fontWeight: canResend ? FontWeight.w900 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}