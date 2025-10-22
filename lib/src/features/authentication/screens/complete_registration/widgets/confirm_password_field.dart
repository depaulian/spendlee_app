import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/complete_registration_controller.dart';

class ConfirmPasswordField extends StatefulWidget {
  final CompleteRegistrationController controller;

  const ConfirmPasswordField({super.key, required this.controller});

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller.confirmPasswordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: tWhiteColor),
          onChanged: widget.controller.validateConfirmPassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.fingerprint, color: tWhiteColor),
            labelText: "Confirm Password",
            hintText: "Confirm Password",
            hintStyle: const TextStyle(color: tWhiteColor),
            labelStyle: const TextStyle(color: tWhiteColor),
            floatingLabelStyle: TextStyle(
              color: widget.controller.confirmPasswordError.value.isNotEmpty
                  ? Colors.red[300]
                  : widget.controller.confirmPasswordController.text.isNotEmpty &&
                  widget.controller.confirmPasswordController.text ==
                      widget.controller.passwordController.text
                  ? Colors.green[300]
                  : tWhiteColor,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 2,
                color: widget.controller.confirmPasswordError.value.isNotEmpty
                    ? Colors.red[300]!
                    : widget.controller.confirmPasswordController.text.isNotEmpty &&
                    widget.controller.confirmPasswordController.text ==
                        widget.controller.passwordController.text
                    ? Colors.green[400]!
                    : tWhiteColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(
                width: 1,
                color: widget.controller.confirmPasswordError.value.isNotEmpty
                    ? Colors.red[300]!
                    : widget.controller.confirmPasswordController.text.isNotEmpty &&
                    widget.controller.confirmPasswordController.text ==
                        widget.controller.passwordController.text
                    ? Colors.green[400]!
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
        if (widget.controller.confirmPasswordError.value.isNotEmpty)
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
                    widget.controller.confirmPasswordError.value,
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
        if (widget.controller.confirmPasswordController.text.isNotEmpty &&
            widget.controller.confirmPasswordController.text ==
                widget.controller.passwordController.text &&
            widget.controller.confirmPasswordError.value.isEmpty)
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
                  'Passwords match',
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