import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/authentication/controllers/forgot_password_controller.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/widgets/forgot_password_input_field.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/widgets/send_reset_button.dart';

class ForgotPasswordInputForm extends StatelessWidget {
  const ForgotPasswordInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ForgotPasswordInputField(controller: controller),
        const SizedBox(height: 32),
        SendResetButton(controller: controller),
        const SizedBox(height: 24),
        Obx(() => controller.resetLinkSent.value
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.green[300],
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Check your email',
                      style: TextStyle(
                        color: Colors.green[300],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ve sent a password reset link to ${controller.emailController.text}',
                      style: TextStyle(
                        color: Colors.green[200],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        controller.resetForm();
                      },
                      child: Text(
                        'Send to different email',
                        style: TextStyle(
                          color: Colors.green[300],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }
}