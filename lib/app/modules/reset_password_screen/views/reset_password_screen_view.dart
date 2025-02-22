import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';

import 'package:picturesourcesomerset/services/api_service.dart';
import '../controllers/reset_password_screen_controller.dart';

class ResetPasswordScreenView extends GetView<ResetPasswordScreenController> {
	ResetPasswordScreenView({super.key, required this.email});

	final String email;
	final ResetPasswordScreenController resetPasswordScreenController = Get.find();

	final TextEditingController passwordController = TextEditingController();
	final TextEditingController passwordconfirmationController = TextEditingController();

	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

	final FocusNode _passwordFocusNode = FocusNode();
	final FocusNode _passwordconfirmationFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
	final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        //onTap: () { Navigator.pop(context); },
                        onTap: () => Get.back(),
                        child: Icon(Icons.keyboard_backspace, color: AppColor.black, size: 24.0),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 20),
                      child: Text('Reset Password', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, fontFamily: 'Urbanist-bold'), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Please reset your new password.', style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Urbanist-medium'), overflow: TextOverflow.ellipsis),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
                      child: Text('Email Address: ${email}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Obx(() {
                        return autoWidthTextField(
                          text: "Min. 6 characters...",
                          width: screenWidth,
                          controller: passwordController,
                          obscureText: resetPasswordScreenController.showPassword.value,
                          focusNode: _passwordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be blank';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _formKey.currentState?.validate();
                            }
                          },
                          suffixIcon: InkWell(
                            onTap: () {
                              resetPasswordScreenController.changePasswordHideAndShow();
                            },
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: resetPasswordScreenController.showPassword.value
                                    ? const Icon(Icons.visibility_off, color: Color(0xff94A3B8))
                                    : const Icon(Icons.visibility_outlined, color: Color(0xff94A3B8)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
					
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Obx(() {
                        return autoWidthTextField(
                          text: "Min. 6 characters...",
                          width: screenWidth,
                          controller: passwordconfirmationController,
                          obscureText: resetPasswordScreenController.showCPassword.value,
                          focusNode: _passwordconfirmationFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be blank';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _formKey.currentState?.validate();
                            }
                          },
                          suffixIcon: InkWell(
                            onTap: () {
                              resetPasswordScreenController.changeCPasswordHideAndShow();
                            },
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: resetPasswordScreenController.showCPassword.value
                                    ? const Icon(Icons.visibility_off, color: Color(0xff94A3B8))
                                    : const Icon(Icons.visibility_outlined, color: Color(0xff94A3B8)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 16),
                      child: Center(
                        child: Obx(() {
                          return autoWidthBtn(
                            text: resetPasswordScreenController.isLoading.value ? 'Reseting...' : 'Reset Password',
                            width: screenWidth,
                            onPress: resetPasswordScreenController.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      resetPasswordScreenController.resetPassword(
                                        email,
                                        passwordController.text.trim(),
                                        passwordconfirmationController.text.trim()
                                      );
                                    } else {
                                      if (_passwordFocusNode.hasFocus) {
                                        _passwordFocusNode.requestFocus();
                                      } else if (_passwordconfirmationFocusNode.hasFocus) {
                                        _passwordconfirmationFocusNode.requestFocus();
                                      }
                                    }
                                  },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
