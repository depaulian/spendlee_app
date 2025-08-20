import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/section_header.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Support'),
        ListTile(
          leading: Icon(Icons.help_outline, color: tPrimaryColor,),
          title: Text('Help Center', style: TextStyle(color: tDarkColor),),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle help center tap
          },
        ),
        ListTile(
          leading: Icon(Icons.contact_support, color: tPrimaryColor),
          title: Text('Contact Support', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle contact support tap
          },
        ),
      ],
    );
  }
}
