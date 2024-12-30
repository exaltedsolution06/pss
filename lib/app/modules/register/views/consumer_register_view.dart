import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';

import '../controllers/register_controller.dart';

// ignore: must_be_immutable
class ConsumerRegisterView extends GetView<RegisterController> {
  ConsumerRegisterView({super.key});

  final RegisterController registerController = Get.find();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordconfirmationController = TextEditingController();
  final TextEditingController companynameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordconfirmationFocusNode = FocusNode();
  final FocusNode _companynameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _zipcodeFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height, // Ensures the container stretches to fill available space
            ),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 1),
                    child: Text(Appcontent.signUpConsumerHeading,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist-bold'
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      'Please input your form register.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Urbanist-medium'
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
					Padding(
						padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.firstName,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderFirstName,
								width: screenWidth,
								controller: firstnameController,
								focusNode: _firstnameFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'First name cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),
					Padding(
						padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.lastName,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderLastName,
								width: screenWidth,
								controller: lastnameController,
								focusNode: _lastnameFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Last name cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),

                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							// Label Above the TextField
							Text(
								Appcontent.email,
								style: TextStyle(
									fontSize: 16,
									color: AppColor.formLabelColor, // Or any color you prefer
								),
							),
							const SizedBox(height: 8), // Space between label and text field
					
							autoWidthTextField(
							  text: Appcontent.placeholderEmail,
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
						],
					),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							// Label Above the TextField
							Text(
								Appcontent.passwordLbl,
								style: TextStyle(
									fontSize: 16,
									color: AppColor.formLabelColor, // Or any color you prefer
								),
							),
							const SizedBox(height: 8), // Space between label and text field
							Obx(() {
							  return autoWidthTextField(
								text: Appcontent.placeholderPassword,
								width: screenWidth,
								controller: passwordController,
								obscureText: registerController.showPassword.value,
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
									registerController.changePasswordHideAndShow();
								  },
								  child: SizedBox(
									height: 20,
									width: 20,
									child: Center(
									  child: registerController.showPassword.value
										  ? const Icon(Icons.visibility_off, color: Color(0xff94A3B8))
										  : const Icon(Icons.visibility_outlined, color: Color(0xff94A3B8)),
									),
								  ),
								),
							  );
							}),
						],
					),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							// Label Above the TextField
							Text(
								Appcontent.confirmPassword,
								style: TextStyle(
									fontSize: 16,
									color: AppColor.formLabelColor, // Or any color you prefer
								),
							),
							const SizedBox(height: 8), // Space between label and text field
							Obx(() {
							  return autoWidthTextField(
								text: Appcontent.placeholderPassword,
								width: screenWidth,
								controller: passwordconfirmationController,
								obscureText: registerController.showCPassword.value,
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
									registerController.changeCPasswordHideAndShow();
								  },
								  child: SizedBox(
									height: 20,
									width: 20,
									child: Center(
									  child: registerController.showCPassword.value
										  ? const Icon(Icons.visibility_off, color: Color(0xff94A3B8))
										  : const Icon(Icons.visibility_outlined, color: Color(0xff94A3B8)),
									),
								  ),
								),
							  );
							}),
						],
					),
                  ),
					Padding(
						padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.companyName,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholdercompanyName,
								width: screenWidth,
								controller: companynameController,
								focusNode: _companynameFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Company name cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),
					Padding(
						padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.address,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderAddress,
								width: screenWidth,
								controller: addressController,
								focusNode: _addressFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Address cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),
					Padding(
						padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.city,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderCity,
								width: screenWidth,
								controller: cityController,
								focusNode: _cityFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'City cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),
					Padding(
						padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.state,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderState,
								width: screenWidth,
								controller: stateController,
								focusNode: _stateFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'State cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),
					Padding(
						padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.zipCode,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderZipCode,
								width: screenWidth,
								controller: zipcodeController,
								focusNode: _zipcodeFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Zip code cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),
					Padding(
						padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  // Label Above the TextField
							  Text(
								Appcontent.phoneNumber,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderPhoneNumber,
								width: screenWidth,
								controller: phoneController,
								focusNode: _phoneFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Phone number cannot be blank';
								  }
								  return null;
								},
								onChanged: (value) {
								  if (value.isNotEmpty) {
									_formKey.currentState?.validate();
								  }
								},
							  ),
							],
						),
					),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    child: Center(
                      child: Obx(() {
                        return autoWidthBtn(
                          text: registerController.isLoading.value ? 'Sign Up...' : 'Sign Up',
                          width: screenWidth,
                          onPress: registerController.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    registerController.register(
                                      firstnameController.text.trim(),
                                      lastnameController.text.trim(),
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      passwordconfirmationController.text.trim(),
                                      companynameController.text.trim(),
                                      addressController.text.trim(),
                                      cityController.text.trim(),
                                      stateController.text.trim(),
                                      zipcodeController.text.trim(),
                                      phoneController.text.trim(),
                                    );
                                  }
                                },
                        );
                      }),
                    ),
                  ),
				  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Appcontent.alreadyHaveAnAccount, style: TextStyle(color: Colors.grey[500])),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.LOGIN_SCREEN);
                        },
                        child: const Text(Appcontent.loginSmall, style: TextStyle(color: AppColor.purple, fontFamily: 'Urbanist')),
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
                        child: OutlinedButton(
						  style: OutlinedButton.styleFrom(
							fixedSize: const Size(327, 56),
							shape: RoundedRectangleBorder(
							  borderRadius: BorderRadius.circular(100),
							),
							side: BorderSide.none, // Removes the border
							backgroundColor: Colors.white, // Optional: Add background color if needed
						  ),
						  onPressed: () {
							// googleSignin();
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
								"Google",
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

                      ),
                    ),
					const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
