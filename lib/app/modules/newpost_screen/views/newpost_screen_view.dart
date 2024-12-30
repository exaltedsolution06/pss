import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/app/modules/editpictre_screen/views/editpictre_screen_view.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/custom_modal.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../config/app_color.dart';
import '../controllers/newpost_screen_controller.dart';

class NewpostScreenView extends StatefulWidget {
  NewpostScreenView({Key? key}) : super(key: key);

  @override
  _NewpostScreenViewState createState() => _NewpostScreenViewState();
}

class _NewpostScreenViewState extends State<NewpostScreenView> {
	final NewpostScreenController newpostScreenController = Get.put(NewpostScreenController(Get.find<ApiService>()));
	final TextEditingController messageController = TextEditingController();
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	
	// Define a GlobalKey for the modalform
	final GlobalKey<FormState> _modalFormKey = GlobalKey<FormState>();
	
	final FocusNode _messageFocusNode = FocusNode();
	List<File> selectedFiles = [];  // To hold multiple image/video files
	final picker = ImagePicker();
	final RxString hiddenPrice = ''.obs;
	final TextEditingController priceController = TextEditingController();
	final FocusNode _priceFocusNode = FocusNode();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _clearDraft() {
    setState(() {
      selectedFiles.clear(); // Clear selected files
      hiddenPrice.value = '';
      messageController.clear();
      priceController.clear();
    });
  }

  void setPrice(String price) {
    setState(() {
      hiddenPrice.value = price;
    });
  }

  Future<void> _checkPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      //Permission.storage, // Request storage permission to access videos as well
    ].request();

    //if (statuses[Permission.camera]!.isGranted && statuses[Permission.storage]!.isGranted) {
    if (statuses[Permission.camera]!.isGranted) {
      _showImagePicker(context);
    } else if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      _showPermissionPermanentlyDeniedDialog(context);
    } else if (statuses.values.any((status) => status.isDenied)) {
      _showPermissionDeniedDialog(context);
    }
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
              onPressed: () {
                Navigator.of(context).pop();
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
  
  void _showCustomModal(BuildContext context, String title, Widget content) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          title: title,
          content: content,
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
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
              title: const Text('New Post', style: TextStyle(fontSize: 18, color: Colors.black)),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    // Display selected images/videos in a grid
                    selectedFiles.isEmpty
                        ? Icon(Icons.photo_camera, size: 50, color: AppColor.purple)
                        : Padding(
							  padding: const EdgeInsets.symmetric(horizontal: 30.0),  // Adjust the value as needed
							  child: GridView.builder(
								shrinkWrap: true,
								physics: NeverScrollableScrollPhysics(),
								gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
								  crossAxisCount: 3,
								  crossAxisSpacing: 8.0,
								  mainAxisSpacing: 8.0,
								),
								itemCount: selectedFiles.length,
								itemBuilder: (context, index) {
								  final file = selectedFiles[index];
								  return Stack(
									children: [
									  ClipRRect(
										borderRadius: BorderRadius.circular(10.0),
										child: Image.file(file, height: 100.0, width: 100.0, fit: BoxFit.cover),
									  ),
									  Positioned(
										  top: 3,
										  right: 15,
										  child: GestureDetector(
											onTap: () {
											  setState(() {
												selectedFiles.removeAt(index); // Remove file from the list
											  });
											},
											child: Container(
											  padding: EdgeInsets.all(2.0), // Maintain 2px padding around the icon
											  decoration: BoxDecoration(
												color: Colors.white.withOpacity(0.8), // Slightly transparent background
												shape: BoxShape.circle, // Circular background
											  ),
											  constraints: BoxConstraints(
												minWidth: 24.0, // Reduce size of the background container
												minHeight: 24.0,
											  ),
											  child: Icon(
												Icons.close, // Cross icon
												color: Colors.red,
												size: 18.0, // Adjust icon size if necessary
											  ),
											),
										  ),
										),


									],
								  );
								},
							  ),
							),

                    // Post message field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 74, maxHeight: 150),
                            child: textAreaFieldDynamic(
                              text: 'Write a new post, drag and drop files to add attachments.',
                              width: screenWidth,
                              controller: messageController,
                              focusNode: _messageFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Message cannot be blank';
                                }
                                if (value.length < 10) {
                                  return 'Your post must contain more than 10 characters.';
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Attachments and price setting
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.attach_file, color: Colors.black),
                          GestureDetector(
                            onTap: () async {
                              await _checkPermissions(context);
                            },
                            child: const Text('Files', style: TextStyle(fontSize: 14, color: Colors.black)),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.attach_money, color: Colors.black),
                          GestureDetector(
                            onTap: () => _showCustomModal(
								  context,
								  'Set post price',
								  SingleChildScrollView(
									scrollDirection: Axis.vertical,
									child: Form( // Wrap the Column in a Form widget
									  key: _modalFormKey, // Use the modal's GlobalKey
									  child: Column(
										children: [
										  const Text(
											'Paid posts are locked for subscribers as well.',
											style: TextStyle(fontSize: 14, color: Colors.black),
										  ),
										  const SizedBox(height: 10),
										  textFieldWithIconDynamic(
											text: '',
											text1: 'Price',
											icon: Icons.payments, // Pass the desired icon here
											width: screenWidth,
											controller: priceController,
											focusNode: _priceFocusNode,
											validator: (value) {
											  if (value == null || value.isEmpty) {
												return 'Amount cannot be blank';
											  }
											  final int? amount = int.tryParse(value);
											  if (amount == null || amount <= 0) {
												return 'Please enter a valid integer value';
											  }
											  return null; // Return null if no validation errors
											},
											onChanged: (value) {
											  // You might not need this here, as validation will be checked on submit
											  if (value.isNotEmpty) {
												_modalFormKey.currentState?.validate();
											  }
											},
										  ),
										  const SizedBox(height: 15),
										  product(
											text: 'SUBMIT',
											onPress: () {
											  // Validate the modal form when the submit button is pressed
											  if (_modalFormKey.currentState?.validate() ?? false) {
												setPrice(priceController.text); // Proceed if valid
												Navigator.pop(context); // Close modal
											  } else {
												// This will print if validation fails
												print("Validation failed");
											  }
											},
										  ),
										  const SizedBox(height: 10),
										],
									  ),
									),
								  ),
								),
							child: Obx(() {
								// Assuming $hiddenPrice is an observable of type RxString
								return hiddenPrice.value.isEmpty
									? Text('Price', style: TextStyle(fontSize: 14, color: Colors.black)) // Show this if hiddenPrice is empty
									: Text('Price (\$${hiddenPrice.value})', style: TextStyle(fontSize: 14, color: Colors.black)); // Show this if hiddenPrice has a value
							}),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Submit and clear buttons
                    Padding(
						  padding: const EdgeInsets.symmetric(horizontal: 30.0),
						  child: Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
							  // Expanded Button for Submit
							  Expanded(
								child: Obx(() {
								  return autoWidthBtn(
									text: 'SUBMIT',
									width: screenWidth, // Ensure screenWidth is defined
									onPress: newpostScreenController.isLoading.value
										? null
										: () {
											if (_formKey.currentState!.validate()) {
											  // Call the submit function from the controller
											  newpostScreenController.submitPost(
												message: messageController.text,
												price: hiddenPrice.value, // Pass the price
												selectedFiles: selectedFiles, // Pass the image file
											  );
											}
										  },
								  );
								}),
							  ),
      
								const SizedBox(width: 10), // Spacer between buttons
							  
								// Expanded Button for Clear Draft
								Expanded(
								  child: textButton(
									text: 'CLEAR DRAFT',
									width: 80,
									height: 56,
									onPress: () {
									  _clearDraft(); // Handle clear draft action
									},
								  ),
								),

							],
						  ),
						),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
