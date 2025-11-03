import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/controllers/change_password_controller.dart';
import 'package:expense_tracker/src/features/core/screens/change_password/widgets/change_password_fields.dart';
import 'package:expense_tracker/src/features/core/screens/change_password/widgets/change_password_submit_button.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChangePasswordFields(controller: controller),
          const SizedBox(height: 32),
          ChangePasswordSubmitButton(controller: controller),
        ],
      ),
    );
  }
}