import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/authentication/controllers/email_verification_controller.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/email_input_field.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/continue_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/divider_with_text.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/google_signup_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/apple_signup_button.dart';

class EmailInputForm extends StatelessWidget {
  const EmailInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailVerificationController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmailInputField(controller: controller),
        const SizedBox(height: 32),
        ContinueButton(controller: controller),
        const SizedBox(height: 24),
        const DividerWithText(),
        const SizedBox(height: 24),
        const GoogleSignUpButton(),
        const SizedBox(height: 15),
        const AppleSignUpButton(),
      ],
    );
  }
}