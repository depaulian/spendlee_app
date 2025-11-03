import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/email_change_controller.dart';
import 'package:expense_tracker/src/features/core/screens/email_change/widgets/email_change_status_icon.dart';

class EmailChangeInputField extends StatelessWidget {
  final EmailChangeController controller;

  const EmailChangeInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: tWhiteColor),
          onChanged: controller.checkEmailAvailability,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              LineAwesomeIcons.envelope,
              color: tWhiteColor,
            ),
            labelText: "New Email",
            hintText: "your.new@email.com",
            hintStyle: const TextStyle(color: tWhiteColor),
            labelStyle: const TextStyle(color: tWhiteColor),
            floatingLabelStyle: TextStyle(
              color: controller.emailError.value.isNotEmpty
                  ? Colors.red[300]
                  : controller.isEmailValid.value
                  ? Colors.green[300]
                  : tWhiteColor,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 2,
                color: controller.emailError.value.isNotEmpty
                    ? Colors.red[300]!
                    : controller.isEmailValid.value
                    ? Colors.green[400]!
                    : tWhiteColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 1,
                color: controller.emailError.value.isNotEmpty
                    ? Colors.red[300]!
                    : controller.isEmailValid.value
                    ? Colors.green[400]!
                    : tWhiteColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(width: 1, color: Colors.red[300]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(width: 2, color: Colors.red[300]!),
            ),
            suffixIcon: EmailChangeStatusIcon(controller: controller),
            errorText: null,
          ),
        ),
        if (controller.emailError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Colors.red[300],
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    controller.emailError.value,
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (controller.isEmailValid.value &&
            controller.emailAvailable.value &&
            controller.emailError.value.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Colors.green[300],
                ),
                const SizedBox(width: 6),
                Text(
                  'Email is available',
                  style: TextStyle(
                    color: Colors.green[300],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    ));
  }
}