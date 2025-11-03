import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';

class AppleEmailHeader extends StatelessWidget {
  final String appleEmail;

  const AppleEmailHeader({super.key, required this.appleEmail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tSecondaryColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.apple,
            color: tSecondaryColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Apple Sign In',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: tWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: tWhiteColor.withValues(alpha: 0.7),
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text: 'You\'re about to create a Spendlee account using a unique, random Apple email.\n\nYour unique email: ',
              ),
              TextSpan(
                text: appleEmail,
                style: const TextStyle(
                  color: tSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(
                text: '\n\nThis is because you\'re using Apple\'s Hide My Email feature. If you decide to, you can update your email address later in your Spendlee settings.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}