import 'package:expense_tracker/src/features/core/controllers/otp_verification_email_change_controller.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_digit_field.dart';
import 'package:get/get.dart';

class OTPEmailChangeInputFields extends StatelessWidget {
  const OTPEmailChangeInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OTPVerificationEmailChangeController.instance;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter verification code',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: tWhiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 6; i++)
              OTPEmailChangeDigitField(
                index: i,
                controller: controller.otpControllers[i],
                focusNode: controller.focusNodes[i],
              ),
          ],
        ),
        if (controller.otpError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Colors.red[300],
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    controller.otpError.value,
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ));
  }
}