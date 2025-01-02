import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

import '../controllers/wish_list_controller.dart';

class WishListCreateView extends GetView<WishListController> {
  WishListCreateView({super.key});

  final WishListController wishListController = Get.find();
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController anniversaryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _relationshipFocusNode = FocusNode();
  final FocusNode _birthdayFocusNode = FocusNode();
  final FocusNode _anniversaryFocusNode = FocusNode();
    
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
	final double screenHeight = MediaQuery.of(context).size.height;
	
	// Method to show date picker
	Future<void> _selectBdate(BuildContext context) async {
	  final DateTime? pickedDate = await showDatePicker(
		context: context,
		initialDate: DateTime.now(),
		firstDate: DateTime(2000),
		lastDate: DateTime(2101),
		builder: (BuildContext context, Widget? child) {
		  return Theme(
			data: Theme.of(context).copyWith(
			  colorScheme: ColorScheme.light(
				primary: Colors.red, // Change the header background color (also OK button)
				onPrimary: Colors.white, // Change the text color of the header (OK button text color)
				onSurface: Colors.black, // Change the text color of the body (dates, months, year text)
			  ),
			  textButtonTheme: TextButtonThemeData(
				style: TextButton.styleFrom(
				  foregroundColor: Colors.red, // Change the color of the "Cancel" and "OK" buttons
				),
			  ),
			  dialogBackgroundColor: Colors.white, // Change the background color of the dialog
			),
			child: child!,
		  );
		},
	  );

	  if (pickedDate != null) {
		birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
	  }
	}
	Future<void> _selectAdate(BuildContext context) async {
	  final DateTime? pickedDate = await showDatePicker(
		context: context,
		initialDate: DateTime.now(),
		firstDate: DateTime(2000),
		lastDate: DateTime(2101),
		builder: (BuildContext context, Widget? child) {
		  return Theme(
			data: Theme.of(context).copyWith(
			  colorScheme: ColorScheme.light(
				primary: Colors.red, // Change the header background color (also OK button)
				onPrimary: Colors.white, // Change the text color of the header (OK button text color)
				onSurface: Colors.black, // Change the text color of the body (dates, months, year text)
			  ),
			  textButtonTheme: TextButtonThemeData(
				style: TextButton.styleFrom(
				  foregroundColor: Colors.red, // Change the color of the "Cancel" and "OK" buttons
				),
			  ),
			  dialogBackgroundColor: Colors.white, // Change the background color of the dialog
			),
			child: child!,
		  );
		},
	  );

	  if (pickedDate != null) {
		anniversaryController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
	  }
	}
	
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                      child: Text(Appcontent.wish_list_creates, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, fontFamily: 'Urbanist-bold'), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
                    ),
					Padding(
						padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
								Appcontent.relationship,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field

							  // Text Field
							  autoWidthTextField(
								text: Appcontent.placeholderRelationship,
								width: screenWidth,
								controller: relationshipController,
								focusNode: _relationshipFocusNode,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Relationship cannot be blank';
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
								Appcontent.birthdates,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
								const SizedBox(height: 8), // Space between label and text field
								autoWidthDateField(
									text: Appcontent.placeholderBirthdate,
									width: screenWidth,
									controller: birthdayController,
									onTap: () {
									  _selectBdate(context);
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
								Appcontent.anniversary,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
								const SizedBox(height: 8), // Space between label and text field
								autoWidthDateField(
									text: Appcontent.placeholderBirthdate,
									width: screenWidth,
									controller: anniversaryController,
									onTap: () {
									  _selectAdate(context);
									},
								),
							],
						),
					),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 16),
                      child: Center(
                        child: Obx(() {
                          return autoWidthBtn(
                            text: wishListController.isLoading.value ? 'Submitting...' : Appcontent.submit,
                            width: screenWidth,
                            onPress: wishListController.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      wishListController.wishListCreate(
                                        emailController.text.trim(),
                                        relationshipController.text.trim(),
                                        birthdayController.text.trim(),
                                        anniversaryController.text.trim(),
                                      );
                                    } else {
                                      if (_emailFocusNode.hasFocus) {
                                        _emailFocusNode.requestFocus();
                                      } else if (_relationshipFocusNode.hasFocus) {
                                        _relationshipFocusNode.requestFocus();
                                      } else if (_birthdayFocusNode.hasFocus) {
                                        _birthdayFocusNode.requestFocus();
                                      } else if (_anniversaryFocusNode.hasFocus) {
                                        _anniversaryFocusNode.requestFocus();
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
