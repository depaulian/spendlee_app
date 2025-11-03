import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Support'),
        ListTile(
          leading: Icon(Icons.contact_support, color: tPrimaryColor),
          title: Text('Contact Support', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            _openContactSupportEmail();
          },
        ),
      ],
    );
  }

  void _openContactSupportEmail() {
    final String subject = 'Support Request';
    final String body = '''Hi Support Team,

I need assistance with:

[Please describe your issue here]

Thank you for your help!''';

    // Manually construct the mailto URL to avoid encoding issues
    final String mailtoUrl = 'mailto:nyumav@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    final Uri emailUri = Uri.parse(mailtoUrl);
    
    launchUrl(emailUri);
  }
}
