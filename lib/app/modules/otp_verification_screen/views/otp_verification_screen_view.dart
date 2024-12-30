import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import '../controllers/otp_verification_screen_controller.dart';

class OtpVerificationScreenView extends GetView<OtpVerificationScreenController> {
	final String email;
	final String context;
	OtpVerificationScreenView({super.key, required this.email, required this.context});
  
	final OtpVerificationScreenController otpVerificationScreenController = Get.find();
	final TextEditingController otpController = TextEditingController();
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  'OTP Verification',
                  style: TextStyle(fontSize: 32, fontFamily: 'Urbanist-bold'),
                ),
              ),
              const Text(
                'Enter the verification code we just\n     sent on your email address.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Urbanist-medium',
                  color: Color(0xff64748B),
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 50,
                  fieldStyle: FieldStyle.box,
                  textFieldAlignment: MainAxisAlignment.spaceEvenly,
                  onChanged: (value) {
                    otpController.text = value;
                  },
                  onCompleted: (value) {
                    otpController.text = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 16, top: 30),
                child: Obx(() {
                  return autoWidthBtn(
                    text: otpVerificationScreenController.isLoading.value
                        ? 'Verifying...'
                        : 'Verify',
                    width: screenWidth,
                    onPress: otpVerificationScreenController.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              otpVerificationScreenController.verifyOtp(
                                email: email,
                                otp: otpController.text.trim(),
								context: this.context
                              );
                            }
                          },
                  );
                }),
              ),
			  
				Padding(
					padding: const EdgeInsets.only(left: 8, bottom: 16, top: 30),
					child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: "Didn't receive the code? Check your email spam.\n", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          TextSpan(text: "                 Use another email address?", style: TextStyle(fontSize: 14, color: AppColor.purple)),
                        ],
                    )),
                ),
				
            ],
          ),
        ),
      ),
    );
  }
}
