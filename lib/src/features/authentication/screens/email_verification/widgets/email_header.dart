import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart' show LineAwesomeIcons;

class EmailHeader extends StatelessWidget {
  const EmailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tSecondaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LineAwesomeIcons.envelope,
            color: tSecondaryColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Enter your email',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: tWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We\'ll send you a verification code to confirm it\'s really you',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: tWhiteColor.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}