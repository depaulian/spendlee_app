import 'package:expense_tracker/src/common_widgets/privacy_footer_dart.dart';
import 'package:expense_tracker/src/features/core/screens/profile_update/widgets/profile_update_back_button.dart';
import 'package:expense_tracker/src/features/core/screens/profile_update/widgets/profile_update_background_decorations.dart';
import 'package:expense_tracker/src/features/core/screens/profile_update/widgets/profile_update_header.dart';
import 'package:expense_tracker/src/features/core/screens/profile_update/widgets/profile_update_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';

class ProfileUpdateScreen extends StatelessWidget {
  const ProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const ProfileUpdateBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const ProfileUpdateBackButton(),
                    const SizedBox(height: 20),
                    const ProfileUpdateHeader(),
                    const SizedBox(height: 40),
                    const ProfileUpdateForm(),
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