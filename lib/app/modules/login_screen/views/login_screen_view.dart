import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

import '../controllers/login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenController> {
  LoginScreenView({super.key});

  final LoginScreenController loginScreenController = Get.find();  

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  GoogleSignIn signIn = GoogleSignIn();
  void googleSignin(int flag) async {
    try {
      var user = await signIn.signIn();
	  if (user != null) {
		// Serialize the user object into a Map
		Map<String, dynamic> userMap = {
		'displayName': user.displayName ?? 'Unknown',
		'email': user.email,
		'id': user.id,
		'photoUrl': user.photoUrl,
		'userType': flag,
		};

		// Pass the entire serialized user object to the controller
		loginScreenController.googleLogin(userMap);
	  }else{
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: "Sign-in cancelled by user",
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }
    } catch(error) {
      SnackbarHelper.showErrorSnackbar(
		title: Appcontent.snackbarTitleError, 
		message: "$error",
		position: SnackPosition.BOTTOM, // Custom position
	  );
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
	final double screenHeight = MediaQuery.of(context).size.height;
	// Load saved credentials
    loginScreenController.loadSavedCredentials(usernameController, passwordController);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
			child: SingleChildScrollView(
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
                      child: Text(Appcontent.loginSmall, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, fontFamily: 'Urbanist-bold'), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Please sign in using your account details.', style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Urbanist-medium'), overflow: TextOverflow.ellipsis),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
                      child: autoWidthTextField(
                        text: 'Enter your username',
                        width: screenWidth,
                        controller: usernameController,
                        focusNode: _usernameFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username or Email cannot be blank';
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Obx(() {
                        return autoWidthTextField(
                          text: Appcontent.placeholderPassword,
                          width: screenWidth,
                          controller: passwordController,
                          obscureText: loginScreenController.showPassword.value,
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
                              loginScreenController.changePasswordHideAndShow();
                            },
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: loginScreenController.showPassword.value
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
					  child: Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Row(
								children: [
								  Obx(() {
									return Checkbox(
									  value: loginScreenController.rememberMe.value,
									  onChanged: (value) {
										loginScreenController.rememberMe.value = value ?? false;
									  },
									  activeColor: AppColor.purple,
									);
								  }),
								  const Text(
									"Remember Me",
									style: TextStyle(
									  fontSize: 14,
									  color: Colors.grey,
									  fontFamily: 'Urbanist-medium',
									),
								  ),
								],
							),
							TextButton(
								onPressed: () {
									Get.toNamed(Routes.FORGOT_SCREEN);
								},
								child: const Text('Forgot Password?', style: TextStyle(fontSize: 14, color: AppColor.purple, fontFamily: 'Urbanist-semibold'), overflow: TextOverflow.ellipsis),
							),							
						],
					  ),
					),

                    /*Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextButton(
						onPressed: () {
							Get.toNamed(Routes.FORGOT_SCREEN);
						},
                        child: const Text('Forgot Password?', style: TextStyle(fontSize: 14, color: AppColor.purple, fontFamily: 'Urbanist-semibold'), overflow: TextOverflow.ellipsis),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 16),
                      child: Center(
                        child: Obx(() {
                          return autoWidthBtn(
                            text: loginScreenController.isLoading.value ? 'Signing In...' : Appcontent.loginSmall,
                            width: screenWidth,
                            onPress: loginScreenController.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      loginScreenController.login(
                                        usernameController.text.trim(),
                                        passwordController.text.trim()
                                      );
                                    } else {
                                      if (_usernameFocusNode.hasFocus) {
                                        _usernameFocusNode.requestFocus();
                                      } else if (_passwordFocusNode.hasFocus) {
                                        _passwordFocusNode.requestFocus();
                                      }
                                    }
                                  },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
					
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don’t have an account ? ', style: TextStyle(color: Colors.grey[500], fontFamily: 'Urbanist-medium')),
                        TextButton(
                          onPressed: () {
							Get.toNamed(Routes.CONSUMER_REGISTER);
                          },
                          child: Text(Appcontent.signUpConsumer, style: TextStyle(color: AppColor.purple, fontFamily: 'Urbanist-semibold')),
                        ),
                      ],
                    ),
					const SizedBox(height: 10),
					Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don’t have an account ? ', style: TextStyle(color: Colors.grey[500], fontFamily: 'Urbanist-medium')),
                        TextButton(
                          onPressed: () {
							Get.toNamed(Routes.RETAILER_REGISTER);
                          },
                          child: Text(Appcontent.signUpRetailer, style: TextStyle(color: AppColor.purple, fontFamily: 'Urbanist-semibold')),
                        ),
                      ],
                    ),
					 const SizedBox(height: 20),
					Row(
						children: [
							Expanded(
							  flex: 1,
							  child: Divider(thickness: 1, color: Color(0xffE2E8F0)),
							),
							Expanded(
							  flex: 1,
							  child: Center(child: Text(Appcontent.signUpWith, style: TextStyle(fontSize: 14, fontFamily: 'Urbanist', color: Colors.grey))),
							),
							Expanded(
							  flex: 1,
							  child: Divider(thickness: 1, color: Color(0xffE2E8F0)),
							),
						],
					),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Center(
						child: Column(
						  children: [
						  
							// Consumer Google Sign-In Button
							OutlinedButton(
							  style: OutlinedButton.styleFrom(
								fixedSize: const Size(327, 56),
								shape: RoundedRectangleBorder(
								  borderRadius: BorderRadius.circular(100),
								),
								side: BorderSide.none, // Removes the border
								backgroundColor: Colors.white, // Optional: Add background color if needed
							  ),
							  onPressed: () {
								googleSignin(1); // Passing flag 1 for Consumer
							  },
							  child: const Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
								  SizedBox(
									height: 24,
									width: 24,
									child: Image(image: AssetImage(Appcontent.google)),
								  ),
								  SizedBox(width: 10),
								  Text(
									"Consumer Google",
									style: TextStyle(
									  fontSize: 16,
									  color: Colors.black,
									  fontFamily: 'Urbanist-semibold',
									),
									overflow: TextOverflow.ellipsis,
								  ),
								],
							  ),
							),
							const SizedBox(height: 20),
							
							// Retailer Google Sign-In Button
							OutlinedButton(
							  style: OutlinedButton.styleFrom(
								fixedSize: const Size(327, 56),
								shape: RoundedRectangleBorder(
								  borderRadius: BorderRadius.circular(100),
								),
								side: BorderSide.none, // Removes the border
								backgroundColor: Colors.white, // Optional: Add background color if needed
							  ),
							  onPressed: () {
								googleSignin(2); // Passing flag 2 for Retailer
							  },
							  child: const Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
								  SizedBox(
									height: 24,
									width: 24,
									child: Image(image: AssetImage(Appcontent.google)),
								  ),
								  SizedBox(width: 10),
								  Text(
									"Retailer Google",
									style: TextStyle(
									  fontSize: 16,
									  color: Colors.black,
									  fontFamily: 'Urbanist-semibold',
									),
									overflow: TextOverflow.ellipsis,
								  ),
								],
							  ),
							),
							
						  ],
						),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }
}
