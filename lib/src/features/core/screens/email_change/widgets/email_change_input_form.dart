import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/controllers/email_change_controller.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/email_change_input_field.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/email_change_continue_button.dart';

class EmailChangeInputForm extends StatelessWidget {
  const EmailChangeInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailChangeController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmailChangeInputField(controller: controller),
        const SizedBox(height: 32),
        EmailChangeContinueButton(controller: controller),
      ],
    );
  }
}