import 'package:expense_tracker/src/features/authentication/screens/forget_password/widgets/forgot_password_back_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/widgets/email_background_decorations.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/widgets/forgot_password_header.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/widgets/forgot_password_input_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const EmailBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    ForgotPasswordBackButton(),
                    SizedBox(height: 40),
                    ForgotPasswordHeader(),
                    SizedBox(height: 40),
                    ForgotPasswordInputForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
