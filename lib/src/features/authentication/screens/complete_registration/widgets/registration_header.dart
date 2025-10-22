import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class RegistrationHeader extends StatelessWidget {
  final String email;

  const RegistrationHeader({super.key, required this.email});

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
            Icons.person_add_rounded,
            color: tSecondaryColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Complete your profile',
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
              const TextSpan(text: 'Creating account for\n'),
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