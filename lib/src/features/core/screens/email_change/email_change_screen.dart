import 'package:expense_tracker/src/common_widgets/privacy_footer_dart.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/email_change_back_button.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/email_change_background_decorations.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/email_change_header.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/email_change_input_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';

class EmailChangeScreen extends StatelessWidget {
  const EmailChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            const EmailChangeBackgroundDecorations(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const EmailChangeBackButton(),
                    const SizedBox(height: 20),
                    const EmailChangeHeader(),
                    const SizedBox(height: 40),
                    const EmailChangeInputForm(),
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