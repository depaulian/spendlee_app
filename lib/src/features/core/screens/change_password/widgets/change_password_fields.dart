import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/controllers/change_password_controller.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class ChangePasswordFields extends StatelessWidget {
  final ChangePasswordController controller;

  const ChangePasswordFields({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Current Password Field
        Obx(() => TextFormField(
          controller: controller.currentPasswordController,
          focusNode: controller.currentPasswordFocusNode,
          obscureText: !controller.currentPasswordVisible.value,
          validator: controller.validateCurrentPassword,
          style: const TextStyle(color: tWhiteColor),
          decoration: InputDecoration(
            labelText: 'Current Password',
            labelStyle: const TextStyle(color: tWhiteColor),
            prefixIcon: const Icon(Icons.lock_outline, color: tSecondaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                controller.currentPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: tWhiteColor.withOpacity(0.7),
              ),
              onPressed: controller.toggleCurrentPasswordVisibility,
            ),
            filled: true,
            fillColor: tWhiteColor.withOpacity(0.1),
            floatingLabelStyle: TextStyle(color: tWhiteColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: tWhiteColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: tSecondaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            errorStyle: const TextStyle(color: Colors.red),
          ),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(controller.newPasswordFocusNode);
          },
        )),
        const SizedBox(height: 20),

        // New Password Field
        Obx(() => TextFormField(
          controller: controller.newPasswordController,
          focusNode: controller.newPasswordFocusNode,
          obscureText: !controller.newPasswordVisible.value,
          validator: controller.validateNewPassword,
          style: const TextStyle(color: tWhiteColor),
          decoration: InputDecoration(
            labelText: 'New Password',
            labelStyle: const TextStyle(color: tWhiteColor),
            prefixIcon: const Icon(Icons.lock, color: tSecondaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                controller.newPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: tWhiteColor.withOpacity(0.7),
              ),
              onPressed: controller.toggleNewPasswordVisibility,
            ),
            filled: true,
            fillColor: tWhiteColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: tWhiteColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: tSecondaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            errorStyle: const TextStyle(color: Colors.red),
            helperText: 'At least 6 characters',
            helperStyle: TextStyle(color: tWhiteColor.withOpacity(0.5), fontSize: 12),
          ),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(controller.confirmPasswordFocusNode);
          },
        )),
        const SizedBox(height: 20),

        // Confirm Password Field
        Obx(() => TextFormField(
          controller: controller.confirmPasswordController,
          focusNode: controller.confirmPasswordFocusNode,
          obscureText: !controller.confirmPasswordVisible.value,
          validator: controller.validateConfirmPassword,
          style: const TextStyle(color: tWhiteColor),
          decoration: InputDecoration(
            labelText: 'Confirm New Password',
            labelStyle: const TextStyle(color: tWhiteColor),
            prefixIcon: const Icon(Icons.lock_clock, color: tSecondaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                controller.confirmPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: tWhiteColor.withOpacity(0.7),
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            filled: true,
            fillColor: tWhiteColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: tWhiteColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: tSecondaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            errorStyle: const TextStyle(color: Colors.red),
          ),
          onFieldSubmitted: (_) {
            controller.changePassword();
          },
        )),
      ],
    );
  }
}