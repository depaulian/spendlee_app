import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/profile_update_controller.dart';

class ProfileUpdateUsernameField extends StatelessWidget {
  final ProfileUpdateController controller;

  const ProfileUpdateUsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.usernameController,
          style: const TextStyle(color: tWhiteColor),
          onChanged: controller.checkUsernameAvailability,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              LineAwesomeIcons.user_circle,
              color: tWhiteColor,
            ),
            labelText: "Username",
            hintText: "Choose a username",
            hintStyle: const TextStyle(color: tWhiteColor),
            labelStyle: const TextStyle(color: tWhiteColor),
            floatingLabelStyle: TextStyle(
              color: controller.usernameError.value.isNotEmpty
                  ? Colors.red[300]
                  : controller.isUsernameValid.value
                  ? Colors.green[300]
                  : tWhiteColor,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 2,
                color: controller.usernameError.value.isNotEmpty
                    ? Colors.red[300]!
                    : controller.isUsernameValid.value
                    ? Colors.green[400]!
                    : tWhiteColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 1,
                color: controller.usernameError.value.isNotEmpty
                    ? Colors.red[300]!
                    : controller.isUsernameValid.value
                    ? Colors.green[400]!
                    : tWhiteColor,
              ),
            ),
            suffixIcon: _buildStatusIcon(),
          ),
        ),
        if (controller.usernameError.value.isNotEmpty)
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
                    controller.usernameError.value,
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

        // Show suggestions when username is taken
        if (!controller.usernameAvailable.value &&
            controller.usernameSuggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Try these instead:',
                  style: TextStyle(
                    color: tWhiteColor.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.usernameSuggestions.map((suggestion) {
                    return GestureDetector(
                      onTap: () => controller.selectSuggestion(suggestion),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: tWhiteColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: tSecondaryColor.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: tSecondaryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              suggestion,
                              style: const TextStyle(
                                color: tWhiteColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        if (controller.isUsernameValid.value &&
            controller.usernameAvailable.value &&
            controller.usernameError.value.isEmpty)
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
                  'Username is available',
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

  Widget _buildStatusIcon() {
    return Obx(() {
      if (controller.isCheckingUsername.value) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(tSecondaryColor),
            ),
          ),
        );
      }

      if (controller.usernameError.value.isNotEmpty) {
        return Icon(
          Icons.error,
          color: Colors.red[300],
          size: 24,
        );
      }

      if (controller.isUsernameValid.value && controller.usernameAvailable.value) {
        return Icon(
          Icons.check_circle,
          color: Colors.green[400],
          size: 24,
        );
      }

      return const SizedBox.shrink();
    });
  }
}