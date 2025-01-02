import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import '../controllers/editprofile_screen_controller.dart';

class EditprofileScreenView extends StatefulWidget {
  EditprofileScreenView({Key? key}) : super(key: key);

  @override
  _EditprofileScreenViewState createState() => _EditprofileScreenViewState();
}

class _EditprofileScreenViewState extends State<EditprofileScreenView> {
  File? profileImageFile; 
  File? backgroundImageFile;
  
  final picker = ImagePicker();
  
  final EditprofileScreenController editprofileScreenController = Get.put(EditprofileScreenController(Get.find<ApiService>()));
  
  //editprofileScreenController.fetchProfile();
  
	void onCoverImageSelected(File image) {
		// Start the upload process
      editprofileScreenController.uploadCoverImage(image);
    }
	void onAvatarImageSelected(File image) {	
		// Start the upload process
		editprofileScreenController.uploadAvatarImage(image);
    }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController pronounController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose of the controllers and focus nodes when the widget is removed from the widget tree
    usernameController.dispose();
    _usernameFocusNode.dispose();
    nameController.dispose();
    _nameFocusNode.dispose();
    bioController.dispose();
    dobController.dispose();
    pronounController.dispose();
    locationController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Method to show date picker
	Future<void> _selectDate(BuildContext context) async {
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

    /*Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      }
    }*/

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
			Get.delete<EditprofileScreenController>(); // Deletes the controller
			Get.toNamed(Routes.PROFLIE_SCREEN);
            //Navigator.pop(context, true);
          },
		  //onTap: ()  => Get.toNamed(Routes.PROFLIE_SCREEN),
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
          final profileData = editprofileScreenController.profileData.value;

          // Ensure that the controller is only set once
          if (usernameController.text.isEmpty && profileData.username != null) {
            usernameController.text = profileData.username!;
          }
          if (nameController.text.isEmpty && profileData.name != null) {
            nameController.text = profileData.name!;
          }
          if (bioController.text.isEmpty && profileData.bio != null) {
            bioController.text = profileData.bio!;
          }
          if (dobController.text.isEmpty && profileData.birthdate != null) {
            dobController.text = profileData.birthdate!;
          }
          if (pronounController.text.isEmpty && profileData.gender_pronoun != null) {
            pronounController.text = profileData.gender_pronoun!;
          }
          if (locationController.text.isEmpty && profileData.location != null) {
            locationController.text = profileData.location!;
          }
          if (websiteController.text.isEmpty && profileData.website != null) {
            websiteController.text = profileData.website!;
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 173,
                      width: Get.size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
					  
                      child: backgroundImageFile == null || editprofileScreenController.backgroundImageFile.value == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image(
                                image: profileData.cover != null && profileData.cover.isNotEmpty
                                    ? NetworkImage(profileData.cover) as ImageProvider
                                    : AssetImage('assets/Banner.png'),
                                height: Get.size.height,
                                width: Get.size.width,
                                fit: BoxFit.fill,
                              ),
                            )
                          : ClipRRect(
                             // borderRadius: BorderRadius.circular(50.0),
                              child: Image.file(backgroundImageFile!, height: Get.size.height, width: Get.size.width, fit: BoxFit.fill),
                            ),
                    ),
                    Positioned(
                      right: 10,
                      top: 15,
                      child: SizedBox(
                        height: 40,
                        width: 186,
                        child: InkWell(
							onTap: () async {
							print("backgroundImageFile: $backgroundImageFile");
					  print("backgroundImageFile Controller: ${editprofileScreenController.backgroundImageFile.value}");
								if (((profileData.default_cover == 0 || profileData.default_cover == 1) && editprofileScreenController.isUploadedBackgroundImageFile.value) || (profileData.default_cover == 0 && editprofileScreenController.isUploadedBackgroundImageFile.value == false)) {
										editprofileScreenController.removeCover();
									} else {
										await _checkPermissions(context, "background");
									}
							},
                          child: Container(
                            height: 40,
                            width: 186,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Icon(
									((profileData.default_cover == 0 || profileData.default_cover == 1) && editprofileScreenController.isUploadedBackgroundImageFile.value) || (profileData.default_cover == 0 && editprofileScreenController.isUploadedBackgroundImageFile.value == false)
									  ? Icons.delete
									  : Icons.photo_camera,
									color: ((profileData.default_cover == 0 || profileData.default_cover == 1) && editprofileScreenController.isUploadedBackgroundImageFile.value) || (profileData.default_cover == 0 && editprofileScreenController.isUploadedBackgroundImageFile.value == false)
									  ? Colors.red
									  : Colors.white,
								),
                                const SizedBox(width: 5),
                                 Text(
                                  ((profileData.default_cover == 0 || profileData.default_cover == 1) && editprofileScreenController.isUploadedBackgroundImageFile.value) || (profileData.default_cover == 0 && editprofileScreenController.isUploadedBackgroundImageFile.value == false)
								  ? 'Remove Background' 
								  : 'Change Background',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ((profileData.default_cover == 0 || profileData.default_cover == 1) && editprofileScreenController.isUploadedBackgroundImageFile.value) || (profileData.default_cover == 0 && editprofileScreenController.isUploadedBackgroundImageFile.value == false)
									  ? Colors.red
									  : Colors.white,
                                    fontFamily: 'Urbanist-semibold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      bottom: -50,
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade300,
                              border: Border.all(color: Colors.white, width: 5),
                              shape: BoxShape.circle,
                            ),
                            child: profileImageFile == null || editprofileScreenController.profileImageFile.value == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Stack(
                                      children: [
                                        // Conditional Network Image
                                        if (profileData.avatar != null && profileData.avatar.isNotEmpty)
                                          ClipOval(
                                            child: Image.network(
                                              profileData.avatar,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        // Fallback Icon
                                        if (profileData.avatar == null || profileData.avatar.isEmpty)
                                          Icon(Icons.account_circle, size: 90, color: Colors.white),
                                      ],
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.file(profileImageFile!, height: 100.0, width: 100.0, fit: BoxFit.fill),
                                  ),
                          ),
							Positioned(
							  right: 0,
							  bottom: 50,
							  child: GestureDetector(
								onTap: () async {
									//print("profileImageFile uploaded: ${editprofileScreenController.isUploadedProfileImageFile.value}");
									//print("profileImageFile: ${profileData.default_avatar}");
									
									if (((profileData.default_avatar == 0 || profileData.default_avatar == 1) && editprofileScreenController.isUploadedProfileImageFile.value) || (profileData.default_avatar == 0 && editprofileScreenController.isUploadedProfileImageFile.value == false)) {
										editprofileScreenController.removeAvatar();
									} else {
										await _checkPermissions(context, "avatar");
									}
								},
								
								child: Container(
								  height: 32,
								  width: 32,
								  decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(30),
									color: Colors.grey.withOpacity(0.9),
									border: Border.all(color: Colors.white, width: 3),
								  ),
								  child: Center(
									child: Icon(
									  ((profileData.default_avatar == 0 || profileData.default_avatar == 1) && editprofileScreenController.isUploadedProfileImageFile.value) || (profileData.default_avatar == 0 && editprofileScreenController.isUploadedProfileImageFile.value == false)
										  ? Icons.delete
										  : Icons.photo_camera,
									  size: 20,
									  color: ((profileData.default_avatar == 0 || profileData.default_avatar == 1) && editprofileScreenController.isUploadedProfileImageFile.value) || (profileData.default_avatar == 0 && editprofileScreenController.isUploadedProfileImageFile.value == false)
										  ? Colors.red
										  : Colors.white,
									),
								  ),
								),
							  ),
							),

                          
                        ],
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
                                        autoWidthTextField(
											text: 'Enter your Username',
											width: screenWidth,
											controller: usernameController,
											focusNode: _usernameFocusNode,
											validator: (value) {
												if (value == null || value.isEmpty) {
													return 'Username cannot be blank';
												}
												return null;
											},
											onChanged: (value) {
											  if (value.isNotEmpty) {
												_formKey.currentState?.validate();
											  }
											},
										),
										autoWidthTextField(
											text: 'Enter your Full name',
											width: screenWidth,
											controller: nameController,
											focusNode: _nameFocusNode,
											validator: (value) {
												if (value == null || value.isEmpty) {
													return 'Name cannot be blank';
												}
												return null;
											},
											onChanged: (value) {
											  if (value.isNotEmpty) {
												_formKey.currentState?.validate();
											  }
											},
										),
										autoWidthTextField(
											text: 'Enter your Bio',
											width: screenWidth,
											controller: bioController,
										),
										autoWidthDateField(
											text: 'Date of Birth',
											width: screenWidth,
											controller: dobController,
											onTap: () {
											  _selectDate(context);
											},
										),
										Obx(() {
										  // Ensure the selected value is valid and matches one of the DropdownMenuItem values
										  String? currentGValue = editprofileScreenController.selectedGender.value.isNotEmpty
											  ? editprofileScreenController.selectedGender.value
											  : profileData.gender_id != 0 ? profileData.gender_id.toString() : null;

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
													final selectedGenderId = int.parse(value);
													editprofileScreenController.updateGender(selectedGenderId);
												}
											},
										  );
										}),
										autoWidthTextField(
											text: 'Enter your Gender pronoun',
											width: screenWidth,
											controller: pronounController,
										),
										Obx(() {
										  // Ensure the selected value is valid and matches one of the DropdownMenuItem values
										  String? currentCValue = editprofileScreenController.selectedCountry.value.isNotEmpty
											  ? editprofileScreenController.selectedCountry.value
											  : profileData.country_id != 0 ? profileData.country_id.toString() : null;

										  // Check if the current value exists in the list
										  bool isValidValue = editprofileScreenController.countryList
											  .any((country) => country.id.toString() == currentCValue);

										  if (!isValidValue) {
											currentCValue = null; // Reset to null if the value is not valid
										  }

										  return dropdownFieldFinal(
											text1: 'Country',
											width: screenWidth,
											value: currentCValue ?? '',  // Provide a fallback value if currentCValue is null
											items: editprofileScreenController.countryList
												.map<DropdownMenuItem<String>>((country) => DropdownMenuItem<String>(
													  value: country.id.toString(), // Use ID as the value
													  child: Text(country.name),    // Display name
													))
												.toList(),
											onChanged: (value) {
												if (value != null) {
													// Update selected country in the controller
													editprofileScreenController.selectedCountry.value = value;
													
													// Optionally, update the country ID in profileData if needed
													final selectedCountryId = int.parse(value);
													editprofileScreenController.updateCountry(selectedCountryId);
												}
											},
										  );
										}),
										autoWidthTextField(
											text: 'Enter your Location',
											width: screenWidth,
											controller: locationController,
										),
										autoWidthTextField(
										  text: 'Enter your Website URL',
										  width: screenWidth,
										  controller: websiteController,
										  validator: (value) {
											if (value != null && value.isNotEmpty) {
											  // URL validation regex pattern
											  final urlPattern = r"^(https?:\/\/)?([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,6})([\/\w .-]*)*\/?$";
											  final regex = RegExp(urlPattern);

											  if (!regex.hasMatch(value)) {
												return 'Please enter a valid URL';
											  }
											}
											// Return null if the field is empty or valid
											return null;
										  },
										  onChanged: (value) {
											if (value.isNotEmpty) {
											  _formKey.currentState?.validate();
											}
										  },
										),
										const SizedBox(height: 10),
                                        Obx(() {
										  // Determine the current values for gender and country, defaulting to null if not set
										  final selectedGenderValue = editprofileScreenController.selectedGender.value;
										  final selectedCountryValue = editprofileScreenController.selectedCountry.value;

										  // Handle potential parsing issues
										  final genderId = selectedGenderValue.isNotEmpty
											  ? int.tryParse(selectedGenderValue)
											  : null;
										  final countryId = selectedCountryValue.isNotEmpty
											  ? int.tryParse(selectedCountryValue)
											  : null;

										  return autoWidthBtn(
											text: editprofileScreenController.isLoading.value ? 'UPDATING...' : 'UPDATE YOUR DETAILS',
											width: screenWidth,
											onPress: editprofileScreenController.isLoading.value
												? null
												: () {
													if (_formKey.currentState!.validate()) {
													  // Extract values
													  final username = usernameController.text.trim();
													  final name = nameController.text.trim();
													  final bio = bioController.text.trim();
													  final dob = dobController.text.trim();
													  final pronoun = pronounController.text.trim();
													  final location = locationController.text.trim();
													  final website = websiteController.text.trim();

													  // Call the submit function with optional parameters
													  editprofileScreenController.profileSubmit(
														username,
														name,
														bio,
														dob,
														genderId, // Pass null if not selected
														pronoun,
														countryId, // Pass null if not selected
														location,
														website
													  );
													} else {
													  // Focus on the first invalid field if validation fails
													  if (_usernameFocusNode.hasFocus || usernameController.text.trim().isEmpty) {
														_usernameFocusNode.requestFocus();
													  } else if (_nameFocusNode.hasFocus || nameController.text.trim().isEmpty) {
														_nameFocusNode.requestFocus();
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
                      } else {
                        _imgFromGallery("background");
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
                      } else {
                        _imgFromCamera("background");
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
			} else if (imageType == "background") {
			  backgroundImageFile = File(croppedFile.path);
			}
		  });

		  if (imageType == "avatar") {
			onAvatarImageSelected(profileImageFile!);
		  } else if (imageType == "background") {
			onCoverImageSelected(backgroundImageFile!);
		  }
		}
  }
}
