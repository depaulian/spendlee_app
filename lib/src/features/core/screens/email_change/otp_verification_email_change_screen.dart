import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_background_decorations.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_back_button.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_header.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_input_fields.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_timer.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_verify_button.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/otp_email_change_resend_button.dart';
import 'package:expense_tracker/src/features/core/controllers/otp_verification_email_change_controller.dart';

class OTPVerificationEmailChangeScreen extends StatefulWidget {
  final String newEmail;
  final int expiresInMinutes;

  const OTPVerificationEmailChangeScreen({
    super.key,
    required this.newEmail,
    this.expiresInMinutes = 10,
  });

  @override
  State<OTPVerificationEmailChangeScreen> createState() => _OTPVerificationEmailChangeScreenState();
}

class _OTPVerificationEmailChangeScreenState extends State<OTPVerificationEmailChangeScreen> {
  late OTPVerificationEmailChangeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OTPVerificationEmailChangeController());
    controller.initializeWithEmail(widget.newEmail, widget.expiresInMinutes);
  }

  @override
  void dispose() {
    Get.delete<OTPVerificationEmailChangeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const OTPEmailChangeBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const OTPEmailChangeBackButton(),
                    const SizedBox(height: 40),
                    OTPEmailChangeHeader(newEmail: widget.newEmail),
                    const SizedBox(height: 40),
                    const OTPEmailChangeInputFields(),
                    const SizedBox(height: 24),
                    const OTPEmailChangeTimer(),
                    const SizedBox(height: 32),
                    const OTPEmailChangeVerifyButton(),
                    const SizedBox(height: 24),
                    const OTPEmailChangeResendButton(),
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