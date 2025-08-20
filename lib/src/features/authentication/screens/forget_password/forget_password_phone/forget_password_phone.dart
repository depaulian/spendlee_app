import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/authentication/controllers/otp_controller.dart';
import 'package:expense_tracker/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../common_widgets/form/form_header_widget.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Just In-case if you want to replace the Image Color for Dark Theme
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool isDark = brightness == Brightness.dark;
    final controller = Get.put(OTPController());
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
                FormHeaderWidget(
                  imageColor: isDark ? tPrimaryColor : tSecondaryColor,
                  image: isDark ? tLightLogo : tDarkLogo,
                  title: tForgetPassword,
                  subTitle: tForgetPasswordPhoneSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text(tPhoneNo),
                          hintText: tPhoneNo,
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        controller: controller.inputField,
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => OTPScreen(
                                  inputField: controller.inputField.text.trim(),
                                  recoveryMethod: "phone"
                              ));
                            },
                            child: const Text(tNext)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
