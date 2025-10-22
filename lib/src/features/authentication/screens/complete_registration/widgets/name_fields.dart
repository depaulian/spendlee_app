import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/complete_registration_controller.dart';

class NameFields extends StatelessWidget {
  final CompleteRegistrationController controller;

  const NameFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        // First Name Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.firstNameController,
              style: const TextStyle(color: tWhiteColor),
              onChanged: controller.validateFirstName,
              decoration: InputDecoration(
                prefixIcon: const Icon(LineAwesomeIcons.user, color: tWhiteColor),
                labelText: "First Name",
                hintText: "First Name",
                hintStyle: const TextStyle(color: tWhiteColor),
                labelStyle: const TextStyle(color: tWhiteColor),
                floatingLabelStyle: TextStyle(
                  color: controller.firstNameError.value.isNotEmpty
                      ? Colors.red[300]
                      : tWhiteColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(
                    width: 2,
                    color: controller.firstNameError.value.isNotEmpty
                        ? Colors.red[300]!
                        : tWhiteColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(
                    width: 1,
                    color: controller.firstNameError.value.isNotEmpty
                        ? Colors.red[300]!
                        : tWhiteColor,
                  ),
                ),
              ),
            ),
            if (controller.firstNameError.value.isNotEmpty)
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
                        controller.firstNameError.value,
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
          ],
        ),
        const SizedBox(height: 20),
        // Last Name Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.lastNameController,
              style: const TextStyle(color: tWhiteColor),
              onChanged: controller.validateLastName,
              decoration: InputDecoration(
                prefixIcon: const Icon(LineAwesomeIcons.user, color: tWhiteColor),
                labelText: "Last Name",
                hintText: "Last Name",
                hintStyle: const TextStyle(color: tWhiteColor),
                labelStyle: const TextStyle(color: tWhiteColor),
                floatingLabelStyle: TextStyle(
                  color: controller.lastNameError.value.isNotEmpty
                      ? Colors.red[300]
                      : tWhiteColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(
                    width: 2,
                    color: controller.lastNameError.value.isNotEmpty
                        ? Colors.red[300]!
                        : tWhiteColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(
                    width: 1,
                    color: controller.lastNameError.value.isNotEmpty
                        ? Colors.red[300]!
                        : tWhiteColor,
                  ),
                ),
              ),
            ),
            if (controller.lastNameError.value.isNotEmpty)
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
                        controller.lastNameError.value,
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
          ],
        ),
      ],
    ));
  }
}