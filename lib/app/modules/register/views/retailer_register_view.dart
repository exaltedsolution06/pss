import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

//import 'package:file_picker/file_picker.dart';

import '../controllers/register_controller.dart';
import 'package:picturesourcesomerset/app/modules/login_screen/controllers/login_screen_controller.dart';

class RetailerRegisterView extends StatefulWidget {
  RetailerRegisterView({Key? key}) : super(key: key);

  @override
  _RetailerRegisterViewState createState() => _RetailerRegisterViewState();
}

// ignore: must_be_immutable
class _RetailerRegisterViewState extends State<RetailerRegisterView> {
	final RegisterController registerController = Get.put(RegisterController(Get.find<ApiService>()));

  final LoginScreenController loginScreenController = Get.put(LoginScreenController(Get.find<ApiService>()));
  
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordconfirmationController = TextEditingController();
  final TextEditingController companynameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
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
  final FocusNode _zipcodeFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  
	List<File> selectedFiles = [];  // To hold multiple image/video files
	final picker = ImagePicker();
	
	Future<void> _checkPermissions(BuildContext context) async {
		Map<Permission, PermissionStatus> statuses = await [
          Permission.camera,
          Permission.photos,
    			Permission.photosAddOnly,
    			Permission.mediaLibrary, // Optional but sometimes needed on iOS
        ].request();

        print('Camera: ${statuses[Permission.camera]}');
			  print('Photos: ${statuses[Permission.photos]}');
			  print('PhotosAddOnly: ${statuses[Permission.photosAddOnly]}');
			  print('MediaLibrary: ${statuses[Permission.mediaLibrary]}');

			  if (statuses[Permission.camera]?.isGranted == true &&
      (statuses[Permission.photos]?.isGranted == true ||
			       statuses[Permission.photosAddOnly]?.isGranted == true)) {
			    _showImagePicker(context);
			  } else if (statuses.values.any((status) => status.isPermanentlyDenied)) {
			    _showPermissionPermanentlyDeniedDialog(context);
			  } else if (statuses.values.any((status) => status.isDenied)) {
			    _showPermissionDeniedDialog(context);
			  }
		/*if (statuses[Permission.camera]!.isGranted) {
			_showImagePicker(context);
		} else if (statuses.values.any((status) => status.isPermanentlyDenied)) {
			_showPermissionPermanentlyDeniedDialog(context);
		} else if (statuses.values.any((status) => status.isDenied)) {
			_showPermissionDeniedDialog(context);
		}*/
	}

	void _showPermissionDeniedDialog(BuildContext context) {
		showDialog(
		  context: context,
		  builder: (BuildContext context) {
			return AlertDialog(
			  title: const Text('Permissions Denied'),
			  content: const Text('Please enable storage and camera permissions to proceed.'),
			  actions: [
				TextButton(
				  child: const Text('Retry'),
				  onPressed: () {
					Navigator.of(context).pop();
					_checkPermissions(context);
				  },
				),
				TextButton(
				  child: const Text('Cancel'),
				  onPressed: () {
					Navigator.of(context).pop();
				  },
				),
			  ],
			);
		  },
		);
	}
	void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
		showDialog(
		  context: context,
		  builder: (BuildContext context) {
			return AlertDialog(
			  title: const Text('Permissions Permanently Denied'),
			  content: const Text('Please enable storage and camera permissions in your device settings.'),
			  actions: [
				TextButton(
				  child: const Text('Settings',
					style: const TextStyle(
						color: AppColor.purple,
					),
				),
				  onPressed: () {
					openAppSettings();
					Navigator.of(context).pop();
				  },
				),
				TextButton(
				  child: const Text('Cancel',
					style: const TextStyle(
						color: AppColor.purple,
					),
				),
				  onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog first (optional order)
              await openAppSettings();     // Await the settings opening
            },
				),
			  ],
			);
		  },
		);
	}
	Future<void> _showImagePicker(BuildContext context) async {
		final List<XFile>? pickedFiles = await picker.pickMultiImage(); // For picking multiple images
		if (pickedFiles != null) {
		  for (var pickedFile in pickedFiles) {
			File file = File(pickedFile.path);
			setState(() {
			  selectedFiles.add(file);  // Add each file to the list
			});
		  }
		}
		// For videos, you can use a different picker logic
		final pickedVideo = await picker.pickVideo(source: ImageSource.gallery); // Picking videos
		if (pickedVideo != null) {
		  setState(() {
			selectedFiles.add(File(pickedVideo.path));  // Add video file to the list
		  });
		}
	}
	
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
	// Fetch the country list when the view loads
    //registerController.fetchCountryList();

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
                    child: Text(Appcontent.signUpRetailerHeading,
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
							  
							  // Label Above the TextField
							  Text(
								Appcontent.country,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field
							Obx(() {
							  return dropdownFieldFinal(
								text1: Appcontent.placeholderCountry,
								width: screenWidth,
								value: registerController.selectedCountry.value ?? '',  // Provide a fallback value if currentCValue is null
								items: registerController.countryList
								.map<DropdownMenuItem<String>>((country) => DropdownMenuItem<String>(
									  value: country.id.toString(), // Use ID as the value
									  child: Text(country.name),    // Display name
									))
								.toList(),
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Please choose country';
								  }
								  return null;
								},
								onChanged: (newCountry) {
									if (newCountry != null && newCountry.isNotEmpty) {
										registerController.selectedCountry.value = newCountry;
										// Reset the city dropdown
										//registerController.cityList.clear(); // Clear all cities
										//registerController.selectedCity.value = null;
										final selectedCountryId = int.parse(newCountry);
										registerController.fetchStateList(selectedCountryId);
										registerController.selectedState.value = null;
										registerController.stateList.clear(); // Clear all states if needed
										_formKey.currentState?.validate();  // Trigger form validation
									} else {
										_formKey.currentState?.validate();  // Trigger form validation
									}
								},
							  );
							}),
							
							// Label Above the TextField
							  Text(
								Appcontent.state,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field
							Obx(() {
							  return dropdownFieldFinal(
								text1: registerController.loadingState.value
									? Appcontent.loadingStates // Hint text while loading
									: Appcontent.placeholderState, // Default hint text
								width: screenWidth,
								value: registerController.selectedState.value ?? '',  // Provide a fallback value if currentCValue is null
								items: registerController.loadingState.value
									? [
										DropdownMenuItem<String>(
										  value: '',
										  child: Text(Appcontent.loadingStates),
										)
									  ]
									: registerController.stateList
									.map<DropdownMenuItem<String>>((state) => DropdownMenuItem<String>(
									  value: state.id.toString(), // Use ID as the value
									  child: Text(state.name),    // Display name
									))
								.toList(),
								isEnabled: !registerController.loadingState.value,
								validator: (value) {
								  if (value == null || value.isEmpty) {
									return 'Please choose state';
								  }
								  return null;
								},
								onChanged: (newState) {
									if (newState != null && newState.isNotEmpty) {
										registerController.selectedState.value = newState;
										final selectedStateId = int.parse(newState);
										//registerController.fetchCityList(selectedStateId);
										//registerController.cityList.clear(); // Clear all cities
										//registerController.selectedCity.value = null;
										_formKey.currentState?.validate();  // Trigger form validation
									} else {
										_formKey.currentState?.validate();  // Trigger form validation
									}
								},
							  );
							}),
							  // Label Above the TextField
							  Text(
								Appcontent.city,
								style: TextStyle(
								  fontSize: 16,
								  color: AppColor.formLabelColor, // Or any color you prefer
								),
							  ),
							  const SizedBox(height: 8), // Space between label and text field
							/*Obx(() {
								return dropdownFieldFinal(
									text1: registerController.loadingCity.value
										? Appcontent.loadingCities // Hint text while loading
										: Appcontent.placeholderCity, // Default hint text
									width: screenWidth,
									value: registerController.selectedCity.value ?? '',  // Provide a fallback value if currentCValue is null
									items: registerController.loadingCity.value
										? [
											DropdownMenuItem<String>(
											  value: '',
											  child: Text(Appcontent.loadingCities),
											)
										  ]
										: registerController.cityList
										.map<DropdownMenuItem<String>>((city) => DropdownMenuItem<String>(
										  value: city.id.toString(), // Use ID as the value
										  child: Text(city.name),    // Display name
										))
									.toList(),
									isEnabled: !registerController.loadingCity.value,
									validator: (value) {
									  if (value == null || value.isEmpty) {
										return 'Please choose city';
									  }
									  return null;
									},
									onChanged: (newCity) {
										if (newCity != null) {
											registerController.selectedCity.value = newCity;
											_formKey.currentState?.validate();  // Trigger form validation
										} else {
											_formKey.currentState?.validate();  // Trigger form validation
										}
									},
								);
							}),*/
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
					Padding(
					  padding: const EdgeInsets.only(top: 20),
					  child: GestureDetector(
						//onTap: registerController.pickFile,
						 onTap: () async {
                            await _checkPermissions(context);
                         },
						child: Container(
						  width: double.infinity, // Make the container full width
						  padding: const EdgeInsets.symmetric(vertical: 16),
						  decoration: BoxDecoration(
							border: Border.all(color: Colors.grey),
							borderRadius: BorderRadius.circular(8),
						  ),
						  child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: const [
							  Icon(Icons.upload_file, color: Colors.grey, size: 36),
							  SizedBox(height: 8),
							  Text('Upload Tax License', style: TextStyle(color: Colors.grey)),
							],
						  ),
						),
					  ),
					),
					if (selectedFiles.isNotEmpty)
					  Padding(
						padding: const EdgeInsets.only(top: 10),
						child: Text(
						  "${selectedFiles.length} file(s) selected",
						  style: TextStyle(
							color: Colors.green.shade700,
							fontSize: 14,
							fontWeight: FontWeight.w500,
						  ),
						),
					  ),


                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    child: Center(
                      child: Obx(() {
						final selectedCountryValue = registerController.selectedCountry.value;
						final selectedStateValue = registerController.selectedState.value;
						//final selectedCityValue = registerController.selectedCity.value;

						// Handle potential parsing issues
						final countryId = selectedCountryValue?.isNotEmpty ?? false
						? int.tryParse(selectedCountryValue ?? '') // Handle null case
						: null;

						final stateId = selectedStateValue?.isNotEmpty ?? false
						  ? int.tryParse(selectedStateValue ?? '')
						  : null;
						  
						/*final cityId = selectedCityValue?.isNotEmpty ?? false
						  ? int.tryParse(selectedCityValue ?? '')
						  : null;*/
						  
                        return autoWidthBtn(
                          text: registerController.isLoading.value ? 'Sign Up...' : 'Sign Up',
                          width: screenWidth,
                          onPress: registerController.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
									final firstname = firstnameController.text.trim();
									final lastname = lastnameController.text.trim();
									final email = emailController.text.trim();
									final password = passwordController.text.trim();
									final passwordconfirmation = passwordconfirmationController.text.trim();
									final companyname = companynameController.text.trim();
									final address = addressController.text.trim();
									final city = cityController.text.trim();
									final zipcode = zipcodeController.text.trim();
									final phone = phoneController.text.trim();
									
                                    registerController.store_retailer(
										selectedFiles: selectedFiles, // Pass the image file
										first_name: firstname,
										last_name: lastname,
										email: email,
										password: password,
										confirmed_password: passwordconfirmation,
										company_name: companyname,
										address: address,
										city: city,
										state: stateId ?? 0,
										country: countryId ?? 0,
										zipcode: zipcode,
										phone_number: phone,
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
