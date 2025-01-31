import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import this for TapGestureRecognizer
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/common_quickalert.dart';
import 'package:picturesourcesomerset/config/app_color.dart';

import 'activity_screen_controller.dart';

class AccountScreenView extends GetView<ActivityScreenController> {
  AccountScreenView({super.key});
  
  final ActivityScreenController activityScreenController = Get.find();
  //final ActivityScreenController activityScreenController = Get.put(ActivityScreenController(Get.find<ApiService>()));

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _newpasswordFocusNode = FocusNode();
  final FocusNode _confirmpasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Account', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
		child: Form(
			key: _formKey,
			child: Column(
			  crossAxisAlignment: CrossAxisAlignment.stretch,
			  children: [
				Column(
				  children: [
					Padding(
					  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
					  child: Text(
						'Manage your account settings',
						style: TextStyle(
						  fontSize: 14,
						  color: AppColor.black, // Adjust as per AppColor
						  fontFamily: 'Urbanist-Regular',
						),
					  ),
					),
				  ],
				),
				/*Column(
				  crossAxisAlignment: CrossAxisAlignment.center,
				  children: [
					Padding(
					  padding: EdgeInsets.only(left: 30.0, top: 0, right: 30.0, bottom: 0),
					  child: WarningMessage(),
					),
				  ],
				),*/
				const SizedBox(height: 10),
				// Second Section
				Column(
				  crossAxisAlignment: CrossAxisAlignment.center,
				  children: [
					Padding(
					  padding: EdgeInsets.only(left: 30.0, top: 0, right: 30.0, bottom: 0),
					  child: Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
						  //autoWidthTextField(text1: 'Password', text: 'Enter your Password', width: screenWidth),
						  Obx(() {
							return autoWidthTextField(
							  text: "Min. 8 characters...",
							  width: screenWidth,
							  controller: passwordController,
							  obscureText: activityScreenController.showPassword.value,
							  focusNode: _passwordFocusNode,
							  validator: (value) {
								if (value == null || value.isEmpty) {
								  return 'Password cannot be blank';
								}
								if (value.length < 8) {
								  return 'Password must be at least 8 characters';
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
								  activityScreenController.changePasswordHideAndShow();
								},
								child: SizedBox(
								  height: 20,
								  width: 20,
								  child: Center(
									child: activityScreenController.showPassword.value
										? const Icon(Icons.visibility_off, color: Color(0xff94A3B8))
										: const Icon(Icons.visibility_outlined, color: Color(0xff94A3B8)),
								  ),
								),
							  ),
							);
						}),
						const SizedBox(height: 10),
						Obx(() {
							return autoWidthTextField(
							  text: "Min. 8 characters...",
							  width: screenWidth,
							  controller: newpasswordController,
							  obscureText: activityScreenController.showNPassword.value,
							  focusNode: _newpasswordFocusNode,
							  validator: (value) {
								if (value == null || value.isEmpty) {
								  return 'New Password cannot be blank';
								}
								if (value.length < 8) {
								  return 'New password must be at least 8 characters';
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
								  activityScreenController.changeNPasswordHideAndShow();
								},
								child: SizedBox(
								  height: 20,
								  width: 20,
								  child: Center(
									child: activityScreenController.showNPassword.value
										? const Icon(Icons.visibility_off, color: Color(0xff94A3B8))
										: const Icon(Icons.visibility_outlined, color: Color(0xff94A3B8)),
								  ),
								),
							  ),
							);
						}),
						const SizedBox(height: 10),
						Obx(() {
							return autoWidthTextField(
							  text: "Min. 8 characters...",
							  width: screenWidth,
							  controller: confirmpasswordController,
							  obscureText: activityScreenController.showCPassword.value,
							  focusNode: _confirmpasswordFocusNode,
							  validator: (value) {
								if (value == null || value.isEmpty) {
								  return 'Confirm Password cannot be blank';
								}
								if (value.length < 8) {
								  return 'Confirm Password must be at least 8 characters';
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
								  activityScreenController.changeCPasswordHideAndShow();
								},
								child: SizedBox(
								  height: 20,
								  width: 20,
								  child: Center(
									child: activityScreenController.showCPassword.value
										? const Icon(Icons.visibility_off, color: Color(0xff94A3B8))
										: const Icon(Icons.visibility_outlined, color: Color(0xff94A3B8)),
								  ),
								),
							  ),
							);
						  }),
						  
						  //autoWidthTextField(text1: 'New Password', text: 'Enter your New Password', width: screenWidth),
						  //autoWidthTextField(text1: 'Confirm Password', text: 'Enter your Confirm Password', width: screenWidth),
							const SizedBox(height: 10),
							Obx(() {
							  return autoWidthBtn(
								text: activityScreenController.isLoading.value ? 'Submitting...' : 'Submit',
								width: screenWidth,
								onPress: activityScreenController.isLoading.value
									? null
									: () {
										if (_formKey.currentState!.validate()) {
										  activityScreenController.accountSubmit(
											passwordController.text.trim(),
											newpasswordController.text.trim(),
											confirmpasswordController.text.trim()
										  );
										} else {
											if (_passwordFocusNode.hasFocus) {
												_passwordFocusNode.requestFocus();
											} else if (_newpasswordFocusNode.hasFocus) {
												_newpasswordFocusNode.requestFocus();
											} else if (_confirmpasswordFocusNode.hasFocus) {
												_confirmpasswordFocusNode.requestFocus();
										  }
										}
									},
								);
							}),
							/*autoWidthBtn(
								text: 'SUBMIT',
								width: screenWidth,
								onPress: () {
								  // Your onPress action here
									CustomAlertWidget.showSuccess(
									  context: context,
									  title: 'Success!',
									  text: 'Operation completed successfully',
									);
									  
								},
							),*/
							const SizedBox(height: 10),
						],
					  ),
					),
				  ],
				),
			  ],
			),
		),		
      ),
    );
  }
}

class WarningMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          //colors: [Colors.purple, Colors.pink],
		  colors: [AppColor.purple, AppColor.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Warning!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "You have not confirmed your email address yet. Click on ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: "this link",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle the link tap
                            print("Link tapped");
                          },
                      ),
                      TextSpan(
                        text: " to resend the confirmation email.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Handle close button press
              print("Close button pressed");
            },
          ),
        ],
      ),
    );
  }
}
