import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

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
            Icons.lock_outline,
            color: tSecondaryColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Forgot your password?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: tWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: tWhiteColor.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}