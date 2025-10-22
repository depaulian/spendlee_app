import 'package:expense_tracker/src/features/authentication/screens/login/widgets/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/constants/text_strings.dart';
import 'package:expense_tracker/src/features/authentication/controllers/login_controller.dart';
import '../../forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key,
  });

  @override
  LoginFormWidgetState createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  bool _obscureText = true; // Variable to track the password visibility

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final formKey = GlobalKey<FormState>();

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == '' || value == null) {
                    return "Enter your Username or Email";
                  } else {
                    return null;
                  }
                },
                style: const TextStyle(color: tWhiteColor),
                controller: controller.login,
                decoration: const InputDecoration(
                  prefixIcon: Icon(LineAwesomeIcons.user, color: tWhiteColor,),
                  labelText: "Username/Email", // Updated label
                  hintText: "Username/Email",   // Updated hint
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
                obscureText: _obscureText,
                controller: controller.password,
                validator: (value) {
                  if (value == '' || value == null) {
                    return "Enter your Password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  } else {
                    return null;
                  }
                },
                style: const TextStyle(color: tWhiteColor),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint, color: tWhiteColor,),
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
                        _obscureText = !_obscureText; // Toggle password visibility
                      });
                    },
                    child: Icon(
                      _obscureText ? LineAwesomeIcons.eye_slash : LineAwesomeIcons.eye,
                      color: tWhiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: tFormHeight - 20),
              /// -- FORGET PASSWORD BTN
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => ForgetPasswordScreen.buildShowModalBottomSheet(context),
                  child: const Text(tForgetPassword, style: TextStyle(color: tWhiteColor)),
                ),
              ),

              /// -- LOGIN BTN
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(tSecondaryColor),
                      side: WidgetStateProperty.all(BorderSide.none),
                    ),
                    onPressed: controller.isLoading.value
                        ? null // Disable button when loading
                        : () {
                      if (formKey.currentState!.validate()) {
                        controller.loginUser(); // Call the updated login method
                      }
                    },
                    child: controller.isLoading.value
                        ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Logging in...",
                          style: TextStyle(color: tWhiteColor),
                        ),
                      ],
                    )
                        : Text(
                      tLogin.toUpperCase(),
                      style: const TextStyle(color: tWhiteColor),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              DividerWithText(),
              const SizedBox(height: 20),

              // Google Sign-In Button (with note about limited support)
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      tGoogleLogoImage,
                      width: 24,
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(color: tDarkColor),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.loginWithGoogle(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide.none,
                      backgroundColor: tWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}