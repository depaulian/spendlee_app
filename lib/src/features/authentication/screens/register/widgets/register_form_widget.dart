import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/constants/text_strings.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  RegisterFormWidgetState createState() => RegisterFormWidgetState();
}

class RegisterFormWidgetState extends State<RegisterFormWidget> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _firstNameController,
              style: const TextStyle(color: tWhiteColor),
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user, color: tWhiteColor),
                labelText: "First Name (Optional)",
                hintText: "First Name",
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
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _lastNameController,
              style: const TextStyle(color: tWhiteColor),
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user, color: tWhiteColor),
                labelText: "Last Name (Optional)",
                hintText: "Last Name",
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
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your username";
                } else if (value.length < 3) {
                  return "Username must be at least 3 characters";
                }
                return null;
              },
              style: const TextStyle(color: tWhiteColor),
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user_circle, color: tWhiteColor),
                labelText: "Username",
                hintText: "Username",
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
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your email";
                } else if (!GetUtils.isEmail(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
              style: const TextStyle(color: tWhiteColor),
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.envelope, color: tWhiteColor),
                labelText: tEmail,
                hintText: tEmail,
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
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your password";
                } else if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
              style: const TextStyle(color: tWhiteColor),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint, color: tWhiteColor),
                labelText: tPassword,
                hintText: tPassword,
                hintStyle: const TextStyle(color: tWhiteColor),
                labelStyle: const TextStyle(color: tWhiteColor),
                floatingLabelStyle: const TextStyle(color: tWhiteColor),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(width: 2, color: tWhiteColor),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(width: 1, color: tWhiteColor),
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
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Confirm your password";
                } else if (value != _passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },
              style: const TextStyle(color: tWhiteColor),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint, color: tWhiteColor),
                labelText: "Confirm Password",
                hintText: "Confirm Password",
                hintStyle: const TextStyle(color: tWhiteColor),
                labelStyle: const TextStyle(color: tWhiteColor),
                floatingLabelStyle: const TextStyle(color: tWhiteColor),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(width: 2, color: tWhiteColor),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide(width: 1, color: tWhiteColor),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  child: Icon(
                    _obscureConfirmPassword ? LineAwesomeIcons.eye_slash : LineAwesomeIcons.eye,
                    color: tWhiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: tFormHeight),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(tSecondaryColor),
                  side: WidgetStateProperty.all(BorderSide.none),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement registration logic
                    Get.snackbar(
                      "Success",
                      "Registration form is valid!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: tSecondaryColor,
                      colorText: tWhiteColor,
                    );
                  }
                },
                child: Text(
                  tCreateAccount.toUpperCase(),
                  style: const TextStyle(color: tWhiteColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'OR',
                style: TextStyle(color: tWhiteColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Image.asset(
                  tGoogleLogoImage,
                  width: 24,
                ),
                label: const Text(
                  'Sign up with Google',
                  style: TextStyle(color: tDarkColor),
                ),
                onPressed: () {
                  // TODO: Implement Google sign up
                  Get.snackbar(
                    "Info",
                    "Google sign up not implemented yet",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: tSecondaryColor,
                    colorText: tWhiteColor,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide.none,
                  backgroundColor: tWhiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}