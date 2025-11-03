import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/profile_update_controller.dart';

class ProfileUpdateSaveButton extends StatelessWidget {
  final ProfileUpdateController controller;

  const ProfileUpdateSaveButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(tSecondaryColor),
            side: WidgetStateProperty.all(BorderSide.none),
          ),
          onPressed: controller.isLoading.value
              ? null
              : () {
            controller.updateProfile();
          },
          child: controller.isLoading.value
              ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: tWhiteColor,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "Updating...",
                style: TextStyle(color: tWhiteColor),
              ),
            ],
          )
              : const Text(
            'SAVE CHANGES',
            style: TextStyle(color: tWhiteColor),
          ),
        ),
      );
    });
  }
}