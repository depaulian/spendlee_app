import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/screens/login/login_screen.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'About'),
        ListTile(
          leading: Icon(Icons.info_outline, color: tPrimaryColor),
          title: Text('About App', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle about tap
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip, color: tPrimaryColor),
          title: Text('Privacy Policy', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle privacy policy tap
          },
        ),
        ListTile(
          leading: Icon(Icons.description, color: tPrimaryColor),
          title: Text('Terms of Service', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle terms of service tap
          },
        ),
        ListTile(
          leading: Icon(Icons.logout, color: tPrimaryColor),
          title: Text('Log Out', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Get.off(()=> const LoginScreen());
          },
        ),
      ],
    );
  }
}