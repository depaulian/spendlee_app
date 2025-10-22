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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Text(
                tSignUpConsent,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: tWhiteColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      const privacyPolicyUrl = 'https://spendlee.afyago.com/privacy';
                      final Uri uri = Uri.parse(privacyPolicyUrl);
                      if (!await launchUrl(uri)) {
                        throw Exception('Could not launch $uri');
                      }
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(color: tSecondaryColor),
                    ),
                  ),
                  const Text(
                    ' & ',
                    style: TextStyle(color: tWhiteColor),
                  ),
                  TextButton(
                    onPressed: () async {
                      const termsUrl = 'https://spendlee.afyago.com/terms';
                      final Uri uri = Uri.parse(termsUrl);
                      if (!await launchUrl(uri)) {
                        throw Exception('Could not launch $uri');
                      }
                    },
                    child: const Text(
                      'Terms of Service',
                      style: TextStyle(color: tSecondaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}