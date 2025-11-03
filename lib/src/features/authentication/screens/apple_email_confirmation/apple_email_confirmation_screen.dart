import 'package:expense_tracker/src/common_widgets/privacy_footer_dart.dart';
import 'package:expense_tracker/src/features/authentication/screens/apple_email_confirmation/widgets/apple_email_back_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/apple_email_confirmation/widgets/apple_email_background_decorations.dart';
import 'package:expense_tracker/src/features/authentication/screens/apple_email_confirmation/widgets/apple_email_header.dart';
import 'package:expense_tracker/src/features/authentication/screens/apple_email_confirmation/widgets/apple_email_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';

class AppleEmailConfirmationScreen extends StatelessWidget {
  final String appleEmail;
  final String? firstName;
  final String? lastName;
  final String appleId;

  const AppleEmailConfirmationScreen({
    super.key,
    required this.appleEmail,
    this.firstName,
    this.lastName,
    required this.appleId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const AppleEmailBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const AppleEmailBackButton(),
                    const SizedBox(height: 20),
                    AppleEmailHeader(appleEmail: appleEmail),
                    const SizedBox(height: 40),
                    AppleEmailForm(
                      appleEmail: appleEmail,
                      firstName: firstName,
                      lastName: lastName,
                      appleId: appleId,
                    ),
                    const SizedBox(height: 40),
                    const PrivacyFooterWidget(),
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