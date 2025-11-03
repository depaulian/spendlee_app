import 'package:expense_tracker/src/common_widgets/privacy_footer_dart.dart';
import 'package:expense_tracker/src/features/core/screens/change_password/widgets/change_password_back_button.dart';
import 'package:expense_tracker/src/features/core/screens/change_password/widgets/change_password_background_decorations.dart';
import 'package:expense_tracker/src/features/core/screens/change_password/widgets/change_password_header.dart';
import 'package:expense_tracker/src/features/core/screens/change_password/widgets/change_password_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const ChangePasswordBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const ChangePasswordBackButton(),
                    const SizedBox(height: 20),
                    const ChangePasswordHeader(),
                    const SizedBox(height: 40),
                    const ChangePasswordForm(),
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