import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/profile_update_controller.dart';

class ProfileUpdateNameFields extends StatelessWidget {
  final ProfileUpdateController controller;

  const ProfileUpdateNameFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller.firstNameController,
          style: const TextStyle(color: tWhiteColor),
          decoration: const InputDecoration(
            prefixIcon: Icon(
              LineAwesomeIcons.user,
              color: tWhiteColor,
            ),
            labelText: "First Name",
            hintText: "Enter your first name",
            hintStyle: TextStyle(color: tWhiteColor),
            labelStyle: TextStyle(color: tWhiteColor),
            floatingLabelStyle: TextStyle(color: tWhiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(width: 2, color: tWhiteColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(width: 1, color: tWhiteColor),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: controller.lastNameController,
          style: const TextStyle(color: tWhiteColor),
          decoration: const InputDecoration(
            prefixIcon: Icon(
              LineAwesomeIcons.user,
              color: tWhiteColor,
            ),
            labelText: "Last Name",
            hintText: "Enter your last name",
            hintStyle: TextStyle(color: tWhiteColor),
            labelStyle: TextStyle(color: tWhiteColor),
            floatingLabelStyle: TextStyle(color: tWhiteColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(width: 2, color: tWhiteColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(width: 1, color: tWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}