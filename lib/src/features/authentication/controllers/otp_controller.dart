import 'package:flutter/material.dart';
import 'package:get/get.dart';
class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  final inputField = TextEditingController();

  void verifyOTP(String otp) async {
    // var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    // isVerified ? Get.offAll(const WelcomeScreen()) : Get.back();
  }

}