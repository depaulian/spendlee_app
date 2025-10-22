import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/controllers/otp_verification_controller.dart';

class OTPDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? previousFocusNode;
  final FocusNode? nextFocusNode;
  final bool isFirst;
  final bool isLast;
  final Function(String)? onPaste;

  const OTPDigitField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.previousFocusNode,
    this.nextFocusNode,
    this.isFirst = false,
    this.isLast = false,
    this.onPaste,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 6, // Allow multiple digits for paste
        style: const TextStyle(
          color: tWhiteColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: tWhiteColor.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: tWhiteColor.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: tWhiteColor.withOpacity(0.3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: tSecondaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[300]!, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[300]!, width: 2),
          ),
        ),
        onChanged: (value) {
          // Handle paste (multiple digits)
          if (value.length > 1 && onPaste != null) {
            onPaste!(value);
            return;
          }

          // Handle single digit entry
          if (value.length == 1) {
            if (nextFocusNode != null) {
              nextFocusNode!.requestFocus();
            } else if (isLast) {
              focusNode.unfocus();
              // Auto-verify when last digit is entered
              final otpController = OTPVerificationController.instance;
              if (otpController.isOTPComplete()) {
                otpController.verifyOTP();
              }
            }
          }

          // Handle backspace
          if (value.isEmpty && previousFocusNode != null) {
            previousFocusNode!.requestFocus();
          }
        },
        onTap: () {
          // Select all text when tapped for easy replacement
          if (controller.text.isNotEmpty) {
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          }
        },
      ),
    );
  }
}