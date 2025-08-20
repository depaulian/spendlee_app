import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/common_widgets/form/minimal_form_header_widget.dart';
import 'package:expense_tracker/src/common_widgets/privacy_footer_dart.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import 'widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController()); 
    final isDark = themeController.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        appBar: AppBar(),
        // Add this property to avoid issues with the keyboard hiding the fields
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                MinimalFormHeaderWidget(
                  image: tLogo,
                  heightBetween: 20,
                ),
                const LoginFormWidget(),  // Make sure the form is scrollable

                const PrivacyFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
