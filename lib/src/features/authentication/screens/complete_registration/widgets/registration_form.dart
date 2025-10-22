import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/features/authentication/controllers/complete_registration_controller.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/confirm_password_field.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/create_account_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/name_fields.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/password_field.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/username_field.dart';
class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CompleteRegistrationController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UsernameField(controller: controller),
        const SizedBox(height: tFormHeight - 20),
        NameFields(controller: controller),
        const SizedBox(height: tFormHeight - 20),
        PasswordField(controller: controller),
        const SizedBox(height: tFormHeight - 20),
        ConfirmPasswordField(controller: controller),
        const SizedBox(height: tFormHeight),
        CreateAccountButton(controller: controller),
      ],
    );
  }
}