import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailChangeBackButton extends StatelessWidget {
  const EmailChangeBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: tWhiteColor),
      onPressed: () => Get.back(),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}