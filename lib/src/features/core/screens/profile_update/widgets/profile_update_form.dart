import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/controllers/profile_update_controller.dart';
import 'package:expense_tracker/src/features/core/screens/profile_update/widgets/profile_update_username_field.dart';
import 'package:expense_tracker/src/features/core/screens/profile_update/widgets/profile_update_name_fields.dart';
import 'package:expense_tracker/src/features/core/screens/profile_update/widgets/profile_update_save_button.dart';

class ProfileUpdateForm extends StatelessWidget {
  const ProfileUpdateForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileUpdateController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileUpdateUsernameField(controller: controller),
        const SizedBox(height: 20),
        ProfileUpdateNameFields(controller: controller),
        const SizedBox(height: 32),
        ProfileUpdateSaveButton(controller: controller),
      ],
    );
  }
}