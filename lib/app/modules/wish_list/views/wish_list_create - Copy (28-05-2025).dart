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
  
  final TextEditingController grandfatherEmailController = TextEditingController();
  final TextEditingController grandfatherPhoneController = TextEditingController();
  final TextEditingController grandmotherEmailController = TextEditingController();
  final TextEditingController grandmotherPhoneController = TextEditingController();
  final TextEditingController motherEmailController = TextEditingController();
  final TextEditingController motherPhoneController = TextEditingController();
  final TextEditingController fatherEmailController = TextEditingController();
  final TextEditingController fatherPhoneController = TextEditingController();
  final TextEditingController spouseEmailController = TextEditingController();
  final TextEditingController spousePhoneController = TextEditingController();
  final TextEditingController brotherEmailController = TextEditingController();
  final TextEditingController brotherPhoneController = TextEditingController();
  final TextEditingController sisterEmailController = TextEditingController();
  final TextEditingController sisterPhoneController = TextEditingController();
  final TextEditingController sonEmailController = TextEditingController();
  final TextEditingController sonPhoneController = TextEditingController();
  final TextEditingController daughterEmailController = TextEditingController();
  final TextEditingController daughterPhoneController = TextEditingController();
  final TextEditingController grandsonEmailController = TextEditingController();
  final TextEditingController grandsonPhoneController = TextEditingController();
  final TextEditingController granddaughterEmailController = TextEditingController();
  final TextEditingController granddaughterPhoneController = TextEditingController();
  final TextEditingController friendEmailController = TextEditingController();
  final TextEditingController friendPhoneController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController anniversaryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _grandfatherEmailFocusNode = FocusNode();
  final FocusNode _grandfatherPhoneFocusNode = FocusNode();
  final FocusNode _grandmotherEmailFocusNode = FocusNode();
  final FocusNode _grandmotherPhoneFocusNode = FocusNode();
  final FocusNode _motherEmailFocusNode = FocusNode();
  final FocusNode _motherPhoneFocusNode = FocusNode();
  final FocusNode _fatherEmailFocusNode = FocusNode();
  final FocusNode _fatherPhoneFocusNode = FocusNode();
  final FocusNode _spouseEmailFocusNode = FocusNode();
  final FocusNode _spousePhoneFocusNode = FocusNode();
  final FocusNode _brotherEmailFocusNode = FocusNode();
  final FocusNode _brotherPhoneFocusNode = FocusNode();
  final FocusNode _sisterEmailFocusNode = FocusNode();
  final FocusNode _sisterPhoneFocusNode = FocusNode();
  final FocusNode _sonEmailFocusNode = FocusNode();
  final FocusNode _sonPhoneFocusNode = FocusNode();
  final FocusNode _daughterEmailFocusNode = FocusNode();
  final FocusNode _daughterPhoneFocusNode = FocusNode();
  final FocusNode _grandsonEmailFocusNode = FocusNode();
  final FocusNode _grandsonPhoneFocusNode = FocusNode();
  final FocusNode _granddaughterEmailFocusNode = FocusNode();
  final FocusNode _granddaughterPhoneFocusNode = FocusNode();
  final FocusNode _friendEmailFocusNode = FocusNode();
  final FocusNode _friendPhoneFocusNode = FocusNode();
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
		//firstDate: DateTime(2000),
		firstDate: DateTime.now(),
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
	
	String? validateAtLeastOneEmail(String? value) {
	  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

	  final emails = [
		grandfatherEmailController.text.trim(),
		grandmotherEmailController.text.trim(),
		motherEmailController.text.trim(),
		fatherEmailController.text.trim(),
		spouseEmailController.text.trim(),
		sonEmailController.text.trim(),
		daughterEmailController.text.trim(),
	  ];

	  final isAnyEmailFilled = emails.any((email) => email.isNotEmpty && emailRegex.hasMatch(email));

	  // If current field is not empty but invalid, return specific message
	  if (value != null && value.isNotEmpty && !emailRegex.hasMatch(value)) {
		return 'Please enter a valid email address';
	  }

	  // If none of the fields are filled, return general error
	  if (!isAnyEmailFilled) {
		return 'At least one email address is required';
	  }

	  return null; // Valid
	}

	Future<void> _selectAdate(BuildContext context) async {
	  final DateTime? pickedDate = await showDatePicker(
		context: context,
		initialDate: DateTime.now(),
		//firstDate: DateTime(2000),
		firstDate: DateTime.now(),
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
	  resizeToAvoidBottomInset: true,
	  body: LayoutBuilder(
		builder: (context, constraints) {
		  return SafeArea(
			child: SingleChildScrollView(
			  child: ConstrainedBox(
				constraints: BoxConstraints(minHeight: constraints.maxHeight),
				child: Padding(
				  padding: const EdgeInsets.only(left: 8, right: 8),
				  child: Form(
					key: _formKey,
					child: IntrinsicHeight(
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
										/*
										// Label Above the TextField
										Text(
											Appcontent.email,
											style: TextStyle(
												fontSize: 16,
												color: AppColor.formLabelColor, // Or any color you prefer
											),
										),
										const SizedBox(height: 8), // Space between label and text field
										*/
								
										autoWidthTextField(
										  text: 'Grandfather`s Email',
										  width: screenWidth,
										  controller: grandfatherEmailController,
										  focusNode: _grandfatherEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Grandfather`s Phone',
											width: screenWidth,
											controller: grandfatherPhoneController,
											focusNode: _grandfatherPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Grandmother`s Email',
										  width: screenWidth,
										  controller: grandmotherEmailController,
										  focusNode: _grandmotherEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Grandmother`s Phone',
											width: screenWidth,
											controller: grandmotherPhoneController,
											focusNode: _grandmotherPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Mother`s Email',
										  width: screenWidth,
										  controller: motherEmailController,
										  focusNode: _motherEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Mother`s Phone',
											width: screenWidth,
											controller: motherPhoneController,
											focusNode: _motherPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Father`s Email',
										  width: screenWidth,
										  controller: fatherEmailController,
										  focusNode: _fatherEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Father`s Phone',
											width: screenWidth,
											controller: fatherPhoneController,
											focusNode: _fatherPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Spouse`s Email',
										  width: screenWidth,
										  controller: spouseEmailController,
										  focusNode: _spouseEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Spouse`s Phone',
											width: screenWidth,
											controller: spousePhoneController,
											focusNode: _spousePhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Brother`s Email',
										  width: screenWidth,
										  controller: brotherEmailController,
										  focusNode: _brotherEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Brother`s Phone',
											width: screenWidth,
											controller: brotherPhoneController,
											focusNode: _brotherPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Sister`s Email',
										  width: screenWidth,
										  controller: sisterEmailController,
										  focusNode: _sisterEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Sister`s Phone',
											width: screenWidth,
											controller: sisterPhoneController,
											focusNode: _sisterPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Son`s Email',
										  width: screenWidth,
										  controller: sonEmailController,
										  focusNode: _sonEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Son`s Phone',
											width: screenWidth,
											controller: sonPhoneController,
											focusNode: _sonPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Daughter`s Email',
										  width: screenWidth,
										  controller: daughterEmailController,
										  focusNode: _daughterEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Daughter`s Phone',
											width: screenWidth,
											controller: daughterPhoneController,
											focusNode: _daughterPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Grandson`s Email',
										  width: screenWidth,
										  controller: grandsonEmailController,
										  focusNode: _grandsonEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Grandson`s Phone',
											width: screenWidth,
											controller: grandsonPhoneController,
											focusNode: _grandsonPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Granddaughter`s Email',
										  width: screenWidth,
										  controller: granddaughterEmailController,
										  focusNode: _granddaughterEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Granddaughter`s Phone',
											width: screenWidth,
											controller: granddaughterPhoneController,
											focusNode: _granddaughterPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
										autoWidthTextField(
										  text: 'Friend`s Email',
										  width: screenWidth,
										  controller: friendEmailController,
										  focusNode: _friendEmailFocusNode,
										  validator: validateAtLeastOneEmail,
										  onChanged: (value) {
											_formKey.currentState?.validate();
										  },
										),
										autoWidthTextField(
											text: 'Friend`s Phone',
											width: screenWidth,
											controller: friendPhoneController,
											focusNode: _friendPhoneFocusNode,
											validator: null, // or just remove this line
											onChanged: (value) {
												// optional: trigger form validation if needed
											},
										),
									],
								),
							),
							/*Padding(
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
							),*/
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
												grandfatherEmailController.text.trim(),
												grandfatherPhoneController.text.trim(),
												grandmotherEmailController.text.trim(),
												grandmotherPhoneController.text.trim(),
												motherEmailController.text.trim(),
												motherPhoneController.text.trim(),
												fatherEmailController.text.trim(),
												fatherPhoneController.text.trim(),
												spouseEmailController.text.trim(),
												spousePhoneController.text.trim(),
												brotherEmailController.text.trim(),
												brotherPhoneController.text.trim(),
												sisterEmailController.text.trim(),
												sisterPhoneController.text.trim(),
												sonEmailController.text.trim(),
												sonPhoneController.text.trim(),
												daughterEmailController.text.trim(),
												daughterPhoneController.text.trim(),
												grandsonEmailController.text.trim(),
												grandsonPhoneController.text.trim(),
												granddaughterEmailController.text.trim(),
												granddaughterPhoneController.text.trim(),
												friendEmailController.text.trim(),
												friendPhoneController.text.trim(),
												//relationshipController.text.trim(),
												birthdayController.text.trim(),
												anniversaryController.text.trim(),
											  );
											} else {
											  if (_grandfatherEmailFocusNode.hasFocus) {
												_grandfatherEmailFocusNode.requestFocus();
											  } else if (_grandfatherPhoneFocusNode.hasFocus) {
												_grandfatherPhoneFocusNode.requestFocus();
											  } else if (_grandmotherEmailFocusNode.hasFocus) {
												_grandmotherEmailFocusNode.requestFocus();
											  } else if (_grandmotherPhoneFocusNode.hasFocus) {
												_grandmotherPhoneFocusNode.requestFocus();
											  } else if (_motherEmailFocusNode.hasFocus) {
												_motherEmailFocusNode.requestFocus();
											  } else if (_motherPhoneFocusNode.hasFocus) {
												_motherPhoneFocusNode.requestFocus();
											  } else if (_fatherEmailFocusNode.hasFocus) {
												_fatherEmailFocusNode.requestFocus();
											  } else if (_fatherPhoneFocusNode.hasFocus) {
												_fatherPhoneFocusNode.requestFocus();
											  } else if (_spouseEmailFocusNode.hasFocus) {
												_spouseEmailFocusNode.requestFocus();
											  } else if (_spousePhoneFocusNode.hasFocus) {
												_spousePhoneFocusNode.requestFocus();
											  } else if (_brotherEmailFocusNode.hasFocus) {
												_brotherEmailFocusNode.requestFocus();
											  } else if (_brotherPhoneFocusNode.hasFocus) {
												_brotherPhoneFocusNode.requestFocus();
											  } else if (_sisterEmailFocusNode.hasFocus) {
												_sisterEmailFocusNode.requestFocus();
											  } else if (_sisterPhoneFocusNode.hasFocus) {
												_sisterPhoneFocusNode.requestFocus();
											  } else if (_sonEmailFocusNode.hasFocus) {
												_sonEmailFocusNode.requestFocus();
											  } else if (_sonPhoneFocusNode.hasFocus) {
												_sonPhoneFocusNode.requestFocus();
											  } else if (_daughterEmailFocusNode.hasFocus) {
												_daughterEmailFocusNode.requestFocus();
											  } else if (_daughterPhoneFocusNode.hasFocus) {
												_daughterPhoneFocusNode.requestFocus();
											  } else if (_grandsonEmailFocusNode.hasFocus) {
												_grandsonEmailFocusNode.requestFocus();
											  } else if (_grandsonPhoneFocusNode.hasFocus) {
												_grandsonPhoneFocusNode.requestFocus();
											  } else if (_granddaughterEmailFocusNode.hasFocus) {
												_granddaughterEmailFocusNode.requestFocus();
											  } else if (_granddaughterPhoneFocusNode.hasFocus) {
												_granddaughterPhoneFocusNode.requestFocus();
											  } else if (_friendEmailFocusNode.hasFocus) {
												_friendEmailFocusNode.requestFocus();
											  } else if (_friendPhoneFocusNode.hasFocus) {
												_friendPhoneFocusNode.requestFocus();
											  /*} else if (_relationshipFocusNode.hasFocus) {
												_relationshipFocusNode.requestFocus();*/
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
				),
			  ),
			),
		  );
		},
	  ),
	);
  }
}
