import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import '../controllers/forgot_screen_controller.dart';

class ForgotScreenView extends GetView<ForgotScreenController> {
  ForgotScreenView({super.key});
  
  final ForgotScreenController forgotScreenController = Get.find();

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.keyboard_backspace, color: AppColor.black, size: 24.0),
                    ),
                  ),
                  const Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Image(image: AssetImage(Appcontent.forgot)),
                    ),
                  ),
                  const Center(
                      child: Text('Forgot Password.', style: TextStyle(fontSize: 32, fontFamily: 'Urbanist-bold'))),
                  const Center(
                      child: Text(
                          'Enter your email account to reset\n                 your password.',
                          style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Urbanist-medium'))),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                    child: autoWidthTextField(
                      text: 'Enter your email',
                      width: screenWidth,
                      controller: emailController,
                      focusNode: _emailFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be blank';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _formKey.currentState?.validate();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Center(
                      child: Obx(() {
                        return autoWidthBtn(
                          text: forgotScreenController.isLoading.value ? 'Sending email...' : 'SEND OTP in EMAIL',
                          width: screenWidth,
                          onPress: forgotScreenController.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    forgotScreenController.forgotPassword(emailController.text.trim());
                                  } else {
                                    if (_emailFocusNode.hasFocus) {
                                      _emailFocusNode.requestFocus();
                                    }
                                  }
                                },
                        );
                      }),
                    ),
                  ),
                  const Expanded(child: SizedBox(height: 200)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Remember password ?", style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Urbanist-Light'), overflow: TextOverflow.ellipsis),
                      TextButton(
                        onPressed: () {
							Get.toNamed(Routes.LOGIN_SCREEN);
							//Get.to(LoginScreenView());
                        },
                        child: const Text('Sign In', style: TextStyle(fontSize: 14, color: AppColor.purple), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
