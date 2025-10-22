import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/features/authentication/controllers/complete_registration_controller.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/registration_background_decorations.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/registration_header.dart';
import 'package:expense_tracker/src/features/authentication/screens/complete_registration/widgets/registration_form.dart';

class CompleteRegistrationScreen extends StatefulWidget {
  final String email;
  final String verificationToken;

  const CompleteRegistrationScreen({
    super.key,
    required this.email,
    required this.verificationToken,
  });

  @override
  State<CompleteRegistrationScreen> createState() => _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState extends State<CompleteRegistrationScreen> {
  late CompleteRegistrationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CompleteRegistrationController());
    controller.initializeWithData(widget.email, widget.verificationToken);
  }

  @override
  void dispose() {
    Get.delete<CompleteRegistrationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const RegistrationBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    RegistrationHeader(email: widget.email),
                    const SizedBox(height: 40),
                    const RegistrationForm(),
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