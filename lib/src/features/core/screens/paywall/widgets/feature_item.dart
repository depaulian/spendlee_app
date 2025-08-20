import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final isDark = themeController.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style:  TextStyle(fontSize: 15, color: tDarkColor),
            ),
          ),
        ],
      ),
    );
  }
}