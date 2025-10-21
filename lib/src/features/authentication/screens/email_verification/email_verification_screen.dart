import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/email_back_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/email_background_decorations.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/email_header.dart';
import 'package:expense_tracker/src/features/authentication/screens/email_verification/widgets/email_input_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const EmailBackButton(),
                    const SizedBox(height: 40),
                    const EmailHeader(),
                    const SizedBox(height: 40),
                    const EmailInputForm(),
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