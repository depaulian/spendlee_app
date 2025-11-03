import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class AppleEmailBackgroundDecorations extends StatelessWidget {
  const AppleEmailBackgroundDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tSecondaryColor.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tSecondaryColor.withValues(alpha: 0.05),
            ),
          ),
        ),
      ],
    );
  }
}