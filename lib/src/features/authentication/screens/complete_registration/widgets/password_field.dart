import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/complete_registration_controller.dart';

class PasswordField extends StatefulWidget {
  final CompleteRegistrationController controller;

  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller.passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: tWhiteColor),
          onChanged: widget.controller.validatePassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.fingerprint, color: tWhiteColor),
            labelText: "Password",
            hintText: "Password",
            hintStyle: const TextStyle(color: tWhiteColor),
            labelStyle: const TextStyle(color: tWhiteColor),
            floatingLabelStyle: TextStyle(
              color: widget.controller.passwordError.value.isNotEmpty
                  ? Colors.red[300]
                  : tWhiteColor,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 2,
                color: widget.controller.passwordError.value.isNotEmpty
                    ? Colors.red[300]!
                    : tWhiteColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 1,
                color: widget.controller.passwordError.value.isNotEmpty
                    ? Colors.red[300]!
                    : tWhiteColor,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword ? LineAwesomeIcons.eye_slash : LineAwesomeIcons.eye,
                color: tWhiteColor,
              ),
            ),
          ),
        ),
        if (widget.controller.passwordError.value.isNotEmpty)
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
                    widget.controller.passwordError.value,
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
    ));
  }
}