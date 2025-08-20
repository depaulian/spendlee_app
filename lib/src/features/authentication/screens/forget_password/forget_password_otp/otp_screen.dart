import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../controllers/otp_controller.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    required this.inputField,
    required this.recoveryMethod
  }) : super(key: key);

  final String inputField;
  final String recoveryMethod;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otp = '';
  int _counter = 60;
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _counter = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  void resendOTP() {
    // Implement your OTP resend logic here
    print('Resending OTP...');
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tOtpTitle,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0, color: tPrimaryColor),
            ),
            Text(tOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40.0),
            Text("$tOtpMessage ${widget.inputField}", textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            OtpTextField(
              mainAxisAlignment: MainAxisAlignment.center,
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                otp = code;
                OTPController.instance.verifyOTP(otp);
              },
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  OTPController.instance.verifyOTP(otp);
                },
                child: const Text(tNext),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_canResend ? "Didn't receive the OTP? " : "Resend OTP in $_counter seconds"),
                if (_canResend)
                  TextButton(
                    onPressed: resendOTP,
                    child: const Text("Resend", style: TextStyle(color: tPrimaryColor),),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}