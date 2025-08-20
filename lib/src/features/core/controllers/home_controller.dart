import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/models/product_category.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // Required state variables
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  Timer? voiceTimer;

  // References to the state variables in the widget
  late List<ProductCategory> categories;
  late int selectedCategoryIndex;
  late AnimationController animationController;
  late Function setState;

  // Initialize the controller with references from the widget
  void init({
    required List<ProductCategory> categories,
    required int selectedCategoryIndex,
    required AnimationController animationController,
    required Function setState,
  }) {
    this.categories = categories;
    this.selectedCategoryIndex = selectedCategoryIndex;
    this.animationController = animationController;
    this.setState = setState;
  }

  @override
  void onClose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.onClose();
  }



  void selectCategory(BuildContext context, int index) {
    if (selectedCategoryIndex == index) return;

    setState(() {
      selectedCategoryIndex = index;
    });

    // Play a small animation on select
    animationController.forward().then((_) {
      animationController.reverse();
    });

    // Show dialog to ask about new or refill
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final themeController = Get.put(ThemeController());
        final isDark = themeController.isDarkMode(dialogContext);

        return AlertDialog(
          backgroundColor: tPrimaryColor,
          content: Text(
            'Would you like to order a new ${categories[index].name} or a refill?',
            style: TextStyle(
              color: tWhiteColor,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 100, // Set your desired width here
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    side: BorderSide.none,
                    backgroundColor: tSecondaryColor // Reduced padding
                ),
                child: const Text('New', style: TextStyle(color: tWhiteColor),),
                onPressed: () {
                  messageController.text = 'I would like to order a new ${categories[index].name}';
                  Navigator.pop(dialogContext);
                },
              ),
            ),
            SizedBox(
              width: 120, // Set your desired width here
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                child: const Text('Refill'),
                onPressed: () {
                  messageController.text = 'I would like to order a refill for my ${categories[index].name}';
                  Navigator.pop(dialogContext);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void clearInput() {
    messageController.clear();
    messageFocusNode.requestFocus();
  }
}