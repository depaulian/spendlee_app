import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/otp_background_decorations.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/otp_back_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/otp_header.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/otp_input_fields.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/otp_timer.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/verify_button.dart';
import 'package:expense_tracker/src/features/authentication/screens/otp_verification/widgets/resend_code_button.dart';
import 'package:expense_tracker/src/features/authentication/controllers/otp_verification_controller.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final int expiresInMinutes;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    this.expiresInMinutes = 10,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late OTPVerificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OTPVerificationController());

    // Initialize controller with screen parameters
    controller.initializeWithEmail(widget.email, widget.expiresInMinutes);
  }

  @override
  void dispose() {
    Get.delete<OTPVerificationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const OTPBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const OTPBackButton(),
                    const SizedBox(height: 40),
                    OTPHeader(email: widget.email),
                    const SizedBox(height: 40),
                    const OTPInputFields(),
                    const SizedBox(height: 24),
                    const OTPTimer(),
                    const SizedBox(height: 32),
                    const VerifyButton(),
                    const SizedBox(height: 24),
                    const ResendCodeButton(),
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