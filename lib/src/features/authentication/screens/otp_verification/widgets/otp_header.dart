import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class OTPHeader extends StatelessWidget {
  final String email;

  const OTPHeader({super.key, required this.email});

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
            Icons.mark_email_read_outlined,
            color: tSecondaryColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Check your email',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: tWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: tWhiteColor.withOpacity(0.7),
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'We sent a verification code to\n'),
              TextSpan(
                text: email,
                style: const TextStyle(
                  color: tSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}