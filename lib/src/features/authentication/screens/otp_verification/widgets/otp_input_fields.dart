import 'package:expense_tracker/src/features/authentication/controllers/otp_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/otp_digit_field.dart';

class OTPInputFields extends StatelessWidget {
  const OTPInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OTPVerificationController.instance;

    return Column(
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
            OTPDigitField(
              controller: controller.otpController1,
              focusNode: controller.focusNode1,
              nextFocusNode: controller.focusNode2,
              isFirst: true,
              onPaste: controller.handlePaste,
            ),
            OTPDigitField(
              controller: controller.otpController2,
              focusNode: controller.focusNode2,
              previousFocusNode: controller.focusNode1,
              nextFocusNode: controller.focusNode3,
            ),
            OTPDigitField(
              controller: controller.otpController3,
              focusNode: controller.focusNode3,
              previousFocusNode: controller.focusNode2,
              nextFocusNode: controller.focusNode4,
            ),
            OTPDigitField(
              controller: controller.otpController4,
              focusNode: controller.focusNode4,
              previousFocusNode: controller.focusNode3,
              nextFocusNode: controller.focusNode5,
            ),
            OTPDigitField(
              controller: controller.otpController5,
              focusNode: controller.focusNode5,
              previousFocusNode: controller.focusNode4,
              nextFocusNode: controller.focusNode6,
            ),
            OTPDigitField(
              controller: controller.otpController6,
              focusNode: controller.focusNode6,
              previousFocusNode: controller.focusNode5,
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }
}