import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expense_tracker/src/constants/colors.dart';

import '../constants/text_strings.dart';

class PrivacyFooterWidget extends StatelessWidget {
  const PrivacyFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.0),
        TextButton(
          onPressed: () async {
            var privacyPolicyUrl = '#';
            final Uri uri = Uri.parse(privacyPolicyUrl);
            if (!await launchUrl(uri)) {
            throw Exception('Could not launch $uri');
            }
          },
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: tSignUpConsent,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color:tWhiteColor),
            ),
            const TextSpan(text: 'Privacy Policy', style: TextStyle(color: tSecondaryColor))
          ])),
        ),
      ],
    );
  }
}