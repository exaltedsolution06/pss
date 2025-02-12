import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/controllers/user_controller.dart';
import '../controllers/editprofile_screen_controller.dart';

class EditprofileScreenView extends StatefulWidget {
  EditprofileScreenView({Key? key}) : super(key: key);

  @override
  _EditprofileScreenViewState createState() => _EditprofileScreenViewState();
}

class _EditprofileScreenViewState extends State<EditprofileScreenView> {
  File? profileImageFile; 
  
  final picker = ImagePicker();
  
  final EditprofileScreenController editprofileScreenController = Get.put(EditprofileScreenController(Get.find<ApiService>()));
  
  final userController = Get.find<UserController>();
  
  
  
  //editprofileScreenController.fetchProfile();
  
	void onAvatarImageSelected(File image) {	
		// Start the upload process
		editprofileScreenController.uploadAvatarImage(image);
    }
	final TextEditingController firstnameController = TextEditingController();
	final TextEditingController lastnameController = TextEditingController();
	final TextEditingController emailController = TextEditingController();
	final TextEditingController dobController = TextEditingController();
	final TextEditingController companynameController = TextEditingController();
	final TextEditingController addressController = TextEditingController();
	//final TextEditingController cityController = TextEditingController();
	//final TextEditingController stateController = TextEditingController();
	final TextEditingController latitudeController = TextEditingController();
	final TextEditingController longitudeController = TextEditingController();
	final TextEditingController zipcodeController = TextEditingController();
	final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _companynameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  //final FocusNode _cityFocusNode = FocusNode();
  //final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _latitudeFocusNode = FocusNode();
  final FocusNode _longitudeFocusNode = FocusNode();
  final FocusNode _zipcodeFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose of the controllers and focus nodes when the widget is removed from the widget tree
    firstnameController.dispose();
    _firstnameFocusNode.dispose();
	lastnameController.dispose();
    _lastnameFocusNode.dispose();
    emailController.dispose();
    _emailFocusNode.dispose();
    dobController.dispose();
    companynameController.dispose();
	_companynameFocusNode.dispose();
    addressController.dispose();
	_addressFocusNode.dispose();
    //cityController.dispose();
	//_cityFocusNode.dispose();
    //stateController.dispose();
	//_stateFocusNode.dispose();
    latitudeController.dispose();
	_latitudeFocusNode.dispose();
    longitudeController.dispose();
	_longitudeFocusNode.dispose();
    zipcodeController.dispose();
	_zipcodeFocusNode.dispose();
    phoneController.dispose();
	_phoneFocusNode.dispose();
    super.dispose();
  }

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
		dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
	  }
	}

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
			Get.delete<EditprofileScreenController>(); // Deletes the controller
			Get.toNamed(Routes.PROFILE_SCREEN);
            //Navigator.pop(context, true);
          },
		  //onTap: ()  => Get.toNamed(Routes.PROFILE_SCREEN),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Edit Profile', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
        actions: [
          SizedBox(
            height: 24,
            width: 24,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityScreenView(),
                      ));
                },
                child: const Icon(Icons.settings, color: Colors.black)),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Obx(() {
        if (editprofileScreenController.isFetchingData.value) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
        } else {
          //final profileData = editprofileScreenController.profileData.value;

          // Ensure that the controller is only set once
          if (firstnameController.text.isEmpty && userController.firstName.value != null) {
            firstnameController.text = userController.firstName.value!;
          } if (lastnameController.text.isEmpty && userController.lastName.value != null) {
            lastnameController.text = userController.lastName.value!;
          }
          if (emailController.text.isEmpty && userController.email.value != null) {
            emailController.text = userController.email.value!;
          }
          if (dobController.text.isEmpty && userController.dob.value != null) {
            dobController.text = userController.dob.value!;
          }
          if (companynameController.text.isEmpty && userController.companyName.value != null) {
            companynameController.text = userController.companyName.value!;
          }
          if (addressController.text.isEmpty && userController.address.value != null) {
            addressController.text = userController.address.value!;
          }
          /*if (cityController.text.isEmpty && userController.city.value != null) {
            cityController.text = userController.city.value!;
          }
          if (stateController.text.isEmpty && profileData.state != null) {
            stateController.text = profileData.state!;
          }*/
          if (latitudeController.text.isEmpty && userController.latitude.value != null) {
            latitudeController.text = userController.latitude.value!;
          }
          if (longitudeController.text.isEmpty && userController.longitude.value != null) {
            longitudeController.text = userController.longitude.value!;
          }
          if (zipcodeController.text.isEmpty && userController.zipcode.value != null) {
            zipcodeController.text = userController.zipcode.value!;
          }
          if (phoneController.text.isEmpty && userController.phoneNumber.value != null) {
            phoneController.text = userController.phoneNumber.value!;
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
				  alignment: Alignment.center,
				  children: [
					// Profile image container (blue circle)
					Container(
					  height: 120,
					  width: 120,
					  decoration: BoxDecoration(
						color: Colors.indigo.shade300,
                              border: Border.all(color: Colors.white, width: 5),
                              shape: BoxShape.circle,
					  ),
					  child: profileImageFile == null || (userController.profilePicture.value == null && userController.profilePicture.value.isEmpty)
						  ? ClipRRect(
								borderRadius: BorderRadius.circular(50.0),
							  child: Stack(
								children: [
								  // Conditional Network Image
								  if (userController.profilePicture.value != null && userController.profilePicture.value.isNotEmpty)
									Image.network(
									  userController.profilePicture.value,
									  width: 110,
									  height: 110,
									  fit: BoxFit.cover,
									),
								  // Fallback Icon
								  if (userController.profilePicture.value == null || userController.profilePicture.value.isEmpty)
									Image.asset(Appcontent.defaultLogo)
									//Icon(Icons.account_circle, size: 90, color: Colors.white),
								],
							  ),
							)
						  : ClipRRect(
								borderRadius: BorderRadius.circular(50.0),
							  child: Image.file(
								profileImageFile!,
								height: 110,
								width: 110,
								fit: BoxFit.cover,
							  ),
							),
					),

					// Camera icon positioned at the top-right of the blue circle
					Positioned(
					  top: 10,
					  right: (Get.size.width / 2) - 80,
					  child: GestureDetector(
						behavior: HitTestBehavior.opaque, // Ensures tap is detected
						onTap: () async {
						  if (userController.profilePicture.value != null && userController.profilePicture.value.isNotEmpty &&
								  (editprofileScreenController.isUploadedProfileImageFile.value || !editprofileScreenController.isUploadedProfileImageFile.value)) {
							print("Removing avatar...");
							editprofileScreenController.removeAvatar();
						  } else {
							await _checkPermissions(context, "avatar");
						  }
						},
						child: Container(
						  height: 30,
						  width: 30,
						  decoration: BoxDecoration(
							borderRadius: BorderRadius.circular(50),
							color: Colors.grey.withOpacity(0.9),
							border: Border.all(color: Colors.white, width: 2),
						  ),
						  child: Center(
							child: Icon(
							  userController.profilePicture.value != null && userController.profilePicture.value.isNotEmpty &&
								  (editprofileScreenController.isUploadedProfileImageFile.value || !editprofileScreenController.isUploadedProfileImageFile.value)
								  ? Icons.delete
								  : Icons.photo_camera,
							  size: 18,
							  color: userController.profilePicture.value != null && userController.profilePicture.value.isNotEmpty &&
								  (editprofileScreenController.isUploadedProfileImageFile.value || !editprofileScreenController.isUploadedProfileImageFile.value)
								  ? Colors.red
								  : Colors.white,
							),
						  ),
						),
					  ),
					),
				  ],
				),

                const SizedBox(height: 60),
                Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const SizedBox(height: 10),
										
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
											controller: dobController,
											onTap: () {
											  _selectBdate(context);
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
								  String? currentCValue;

								  if (userController.country.value != null && userController.country.value != 0) {
									currentCValue = userController.country.value.toString();
								  } else if (editprofileScreenController.selectedCountry.value != null &&
									  editprofileScreenController.selectedCountry.value!.isNotEmpty) {
									currentCValue = editprofileScreenController.selectedCountry.value;
								  }

								  // Convert country list to a map for quick lookup
								  final countryMap = {
									for (var country in editprofileScreenController.countryList)
									  country.id.toString(): country.name
								  };

								  return dropdownFieldFinal(
									text1: Appcontent.placeholderCountry,
									width: screenWidth,
									value: currentCValue ?? '0',
									items: countryMap.entries
										.map<DropdownMenuItem<String>>(
										  (entry) => DropdownMenuItem<String>(
											value: entry.key,
											child: Text(entry.value),
										  ),
										)
										.toList(),
									validator: (value) {
									  if (value == null || value.isEmpty) {
										return 'Please choose a country';
									  }
									  return null;
									},
									onChanged: (newCountry) {
										if (newCountry != null && newCountry.isNotEmpty) {
											editprofileScreenController.selectedCountry.value = newCountry;
											final selectedCountryId = int.parse(newCountry);
												editprofileScreenController.selectedState.value = null;
												editprofileScreenController.stateList.clear();
												
												editprofileScreenController.cityList.clear();
												editprofileScreenController.selectedCity.value = null;
												
											editprofileScreenController.fetchStateList(selectedCountryId).then((_) {
												_formKey.currentState?.validate();
											});
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
								  // Use userController.state.value for the initial value
								
									String? currentSValue;
									if(userController.state.value != null && userController.state.value != 0 && editprofileScreenController.selectedCountry.value == null) {
										currentSValue = userController.state.value.toString();
									} else if (editprofileScreenController.selectedState.value != null &&
										  editprofileScreenController.selectedState.value!.isNotEmpty) {
										currentSValue = editprofileScreenController.selectedState.value;
									} else {
										currentSValue = null;
									}

									  // Check if the current value exists in the latest state list
									  bool isValidSValue = editprofileScreenController.stateList
										  .any((state) => state.id.toString() == currentSValue);

									  if (!isValidSValue) {
										currentSValue = null; // Reset to null if the value is invalid
									  }

									  // Generate the dropdown items
									  final dropdownItems = editprofileScreenController.loadingState.value
										? [
											DropdownMenuItem<String>(
											  value: '',
											  child: Text(Appcontent.loadingStates),
											)
										  ]
										: editprofileScreenController.stateList
										  .map<DropdownMenuItem<String>>((state) => DropdownMenuItem<String>(
												value: state.id.toString(),
												child: Text(state.name),
											  ))
										  .toList();

									  // Add a default "Select State" option
									  if (!dropdownItems.any((item) => item.value == '0')) {
										dropdownItems.insert(0, DropdownMenuItem<String>(
										  value: '0',
										  child: Text('Select State'),
										));
									  }

									  return dropdownFieldFinal(
										text1: editprofileScreenController.loadingState.value
											? Appcontent.loadingStates // Hint text while loading
											: Appcontent.placeholderState, // Default hint text
										width: screenWidth,
										value: currentSValue ?? '0', // Provide a fallback value
										items: dropdownItems,
										isEnabled: !editprofileScreenController.loadingState.value,
										validator: (value) {
										  if (value == null || value.isEmpty || value == '0') {
											return 'Please choose a state';
										  }
										  return null;
										},
										onChanged: (newState) {
											if (newState != null && newState.isNotEmpty) {
												editprofileScreenController.selectedState.value = newState;

												editprofileScreenController.selectedCity.value = null;
												editprofileScreenController.cityList.clear(); // Clear all cities
													
												// Parse the new state ID
												final selectedStateId = int.parse(newState);
												// Reset selectedCity if it's invalid
												editprofileScreenController.selectedCity.value = null;
												editprofileScreenController.cityList.clear(); // Clear all cities
												// Fetch the city list for the selected state
												editprofileScreenController.fetchCityList(selectedStateId).then((_) {
													// Trigger form validation
													_formKey.currentState?.validate();
												});
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
										  Obx(() {
												String? currentCTValue;
												if(userController.city.value != null && userController.city.value != 0 && editprofileScreenController.selectedState.value == null) {
													currentCTValue = userController.city.value.toString();
												} else if (editprofileScreenController.selectedCity.value != null &&
													  editprofileScreenController.selectedCity.value!.isNotEmpty) {
													currentCTValue = editprofileScreenController.selectedCity.value;
												} else {
													currentCTValue = null;
												}

											  // Check if the current value exists in the latest city list
											  bool isValidCTValue = editprofileScreenController.cityList
												  .any((city) => city.id.toString() == currentCTValue);

											  if (!isValidCTValue) {
												currentCTValue = null; // Reset to null if the value is invalid
											  }

											  // Generate the dropdown items
											  final dropdownItems = editprofileScreenController.loadingCity.value
												? [
													DropdownMenuItem<String>(
													  value: '',
													  child: Text(Appcontent.loadingCities),
													)
												  ]
												: editprofileScreenController.cityList
												  .map<DropdownMenuItem<String>>((city) => DropdownMenuItem<String>(
														value: city.id.toString(),
														child: Text(city.name),
													  ))
												  .toList();

											  // Add a default "Select city" option
											  if (!dropdownItems.any((item) => item.value == '0')) {
												dropdownItems.insert(0, DropdownMenuItem<String>(
												  value: '0',
												  child: Text('Select city'),
												));
											  }

											  return dropdownFieldFinal(
												text1: editprofileScreenController.loadingCity.value
													? Appcontent.loadingCities // Hint text while loading
													: Appcontent.placeholderCity, // Default hint text
												width: screenWidth,
												value: currentCTValue ?? '0', // Provide a fallback value
												items: dropdownItems,
												isEnabled: !editprofileScreenController.loadingCity.value,
												onChanged: (newCity) {
												  if (newCity != null && newCity.isNotEmpty) {
													editprofileScreenController.selectedCity.value = newCity;
												  }
												},
											  );
											}),
										// Text Field
										/*autoWidthTextField(
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
										),*/
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
										if (userController.userType.value == 2) ...[
										// Label Above the TextField
										Text(
											Appcontent.latitude,
											style: TextStyle(
											  fontSize: 16,
											  color: AppColor.formLabelColor, // Or any color you prefer
											),
										),
										const SizedBox(height: 8), // Space between label and text field
										// Text Field
										autoWidthTextField(
											text: Appcontent.placeholderLatitude,
											width: screenWidth,
											controller: latitudeController,
											focusNode: _latitudeFocusNode,
											validator: (value) {
											  if (value == null || value.isEmpty) {
												return 'Latitude cannot be blank';
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
											Appcontent.longitude,
											style: TextStyle(
											  fontSize: 16,
											  color: AppColor.formLabelColor, // Or any color you prefer
											),
										),
										const SizedBox(height: 8), // Space between label and text field
										// Text Field
										autoWidthTextField(
											text: Appcontent.placeholderLongitude,
											width: screenWidth,
											controller: longitudeController,
											focusNode: _longitudeFocusNode,
											validator: (value) {
											  if (value == null || value.isEmpty) {
												return 'Longitude cannot be blank';
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
										
										
										Obx(() {
											// Ensure the selected value is valid and matches one of the DropdownMenuItem values
											String? currentGValue;
											if (userController.genderId.value != null && userController.genderId.value != 0) {
												currentGValue = userController.genderId.value.toString(); // Convert to String
											} else {
												currentGValue = null;
											}

											// Check if the current value exists in the list
											bool isValidValue = editprofileScreenController.genderList
											.any((gender) => gender.id.toString() == currentGValue);

											if (!isValidValue) {
												currentGValue = null; // Reset to null if the value is not valid
											}
										  return dropdownFieldFinal(
											text1: 'Gender',
											width: screenWidth,
											value: currentGValue ?? '',  // Provide a fallback value if currentGValue is null
											items: editprofileScreenController.genderList
												.map<DropdownMenuItem<String>>((gender) => DropdownMenuItem<String>(
													  value: gender.id.toString(), // Use ID as the value
													  child: Text(gender.name),    // Display name
													))
												.toList(),
											onChanged: (value) {
												if (value != null) {
													// Update selected gender in the controller
													editprofileScreenController.selectedGender.value = value;
													
													// Optionally, update the gender ID in profileData if needed
													//final selectedGenderId = int.parse(value);
													//editprofileScreenController.updateGender(selectedGenderId);
												}
											},
										  );
										}),
										const SizedBox(height: 10),
                                        Obx(() {
											// Determine the current values for gender and country, defaulting to null if not set
											final selectedGenderValue = editprofileScreenController.selectedGender.value;
											final selectedCountryValue = editprofileScreenController.selectedCountry.value;
											final selectedStateValue = editprofileScreenController.selectedState.value;
											final selectedCityValue = editprofileScreenController.selectedCity.value;

											// Handle potential parsing issues
											final countryId = selectedCountryValue?.isNotEmpty ?? false
											? int.tryParse(selectedCountryValue ?? '') // Handle null case
											: userController.country.value;

											final stateId = selectedStateValue?.isNotEmpty ?? false
											  ? int.tryParse(selectedStateValue ?? '')
											  : userController.state.value;
											  
											final cityId = selectedCityValue?.isNotEmpty ?? false
											  ? int.tryParse(selectedCityValue ?? '')
											  : userController.city.value;
											  
											// Handle potential parsing issues
											final genderId = selectedGenderValue?.isNotEmpty ?? false
											  ? int.tryParse(selectedGenderValue ?? '')
											  : userController.genderId.value;

										  return autoWidthBtn(
											text: editprofileScreenController.isLoading.value ? 'UPDATING...' : 'UPDATE YOUR DETAILS',
											width: screenWidth,
											onPress: editprofileScreenController.isLoading.value
												? null
												: () {
													if (_formKey.currentState!.validate()) {
													  // Extract values
													  final first_name = firstnameController.text.trim();
													  final last_name = lastnameController.text.trim();
													  final email = emailController.text.trim();
													  final dob = dobController.text.trim();
													  final company_name = companynameController.text.trim();
													  final address = addressController.text.trim();
													  //final city = cityController.text.trim();
													  //final state = stateController.text.trim();
													  final latitude = latitudeController.text.trim();
													  final longitude = longitudeController.text.trim();
													  final zipcode = zipcodeController.text.trim();
													  final phone = phoneController.text.trim();

													  // Call the submit function with optional parameters
													  editprofileScreenController.profileSubmit(
														first_name,
														last_name,
														email,
														company_name,
														dob,
														countryId,
														stateId,
														cityId,
														address,
														latitude,
														longitude,
														zipcode,
														phone,
														genderId,
													  );
													} else {
													  // Focus on the first invalid field if validation fails
													  if (_emailFocusNode.hasFocus || emailController.text.trim().isEmpty) {
														_emailFocusNode.requestFocus();
													  } else if (_firstnameFocusNode.hasFocus || firstnameController.text.trim().isEmpty) {
														_firstnameFocusNode.requestFocus();
													  }
													}
												  },
										  );
										}), 
										
										
										
                                        const SizedBox(height: 20),
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),
              ],
            ),
          );
        }
      }),
    );
  }

Future<void> _requestPermissions(BuildContext context, String imageType) async {
  Map<Permission, PermissionStatus> statuses = await [
   // Permission.storage,
    Permission.camera,
  ].request();

  statuses.forEach((permission, status) {
    print('$permission: $status');
  });

  bool allGranted = statuses.values.every((status) => status.isGranted);
  bool anyPermanentlyDenied = statuses.values.any((status) => status.isPermanentlyDenied);
  bool anyDenied = statuses.values.any((status) => status.isDenied);

  if (allGranted) {
    showImagePicker(context, imageType);
  } else if (anyPermanentlyDenied) {
    _showPermissionPermanentlyDeniedDialog(context, imageType);
  } else if (anyDenied) {
    _showPermissionDeniedDialog(context, imageType);
  }
}

void _showPermissionDeniedDialog(BuildContext context, String imageType) {
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
              _requestPermissions(context, imageType);
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

void _showPermissionPermanentlyDeniedDialog(BuildContext context, String imageType) {
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
Future<void> _checkPermissions(BuildContext context, String type) async {
  //PermissionStatus storageStatus = await Permission.storage.status;
  PermissionStatus cameraStatus = await Permission.camera.status;

  //print('Storage permission: $storageStatus');
  //print('Camera permission: $cameraStatus');

  //if (storageStatus.isGranted && cameraStatus.isGranted) {
  if (cameraStatus.isGranted) {
    showImagePicker(context, type);
  } else {
    _requestPermissions(context, type);
  }
}
  
  void showImagePicker(BuildContext context, String imageType) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: const [
                        Icon(Icons.image, size: 60.0),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (imageType == "avatar") {
                        _imgFromGallery("avatar");
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: const [
                        Icon(Icons.camera_alt, size: 60.0),
                        SizedBox(height: 12.0),
                        Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (imageType == "avatar") {
                        _imgFromCamera("avatar");
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Future<void> _imgFromGallery(String imageType) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path), imageType);
    }
  }

  Future<void> _imgFromCamera(String imageType) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path), imageType);
    }
  }
  
  Future<void> _cropImage(File imgFile, String imageType) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        ),
      ],
    );
	if (croppedFile != null) {
		  setState(() {
			if (imageType == "avatar") {
			  profileImageFile = File(croppedFile.path);
			}
		  });

		  if (imageType == "avatar") {
			onAvatarImageSelected(profileImageFile!);
		  }
		}
  }
}
