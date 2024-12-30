import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import '../../../../config/app_color.dart';
import '../../../../config/common_button.dart';
import 'activity_screen_controller.dart';

class VerifyScreenView extends GetView<ActivityScreenController> {
  const VerifyScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    //final ActivityScreenController controller = Get.put(ActivityScreenController());
	final ActivityScreenController activityScreenController = Get.find();
	activityScreenController.shouldFetchSettingsVerify = true;
	final double screenWidth = MediaQuery.of(context).size.width;
	
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        title: const Text('Verify', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (activityScreenController.isLoading.value) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
        } else {
          return Stack(
			children: [
			  SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: Padding(
				  padding: const EdgeInsets.all(16.0),
				  child: Form(
                    key: _formKey,
					  child: Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
						  Text(
							'Get verified and start earning now',
							textAlign: TextAlign.left,
							style: TextStyle(
							  fontSize: 14,
							  color: AppColor.black,
							  fontFamily: 'Urbanist-Regular',
							),
						  ),
						  const SizedBox(height: 10),
						  Padding(
							padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10.0),
							child: Text(
							  'In order to get verified and receive your badge, please take care of the following steps:',
							  textAlign: TextAlign.left,
							  style: TextStyle(
								fontSize: 16,
								color: AppColor.BlackGreyscale,
								fontFamily: 'Urbanist-Regular',
							  ),
							),
						  ),
						  Padding(
							padding: const EdgeInsets.only(left: 30.0, bottom: 16.0),
							child: Column(
							  crossAxisAlignment: CrossAxisAlignment.start,
							  children: [
								_buildIconTextRow(
									activityScreenController.email_verified_status.value == '1' ? Icons.check_circle : Icons.cancel, 
									activityScreenController.email_verified_message.value, 
									activityScreenController.email_verified_status.value == '1' ? AppColor.LightGreen : AppColor.Red
								),
								_buildIconTextRow(
									activityScreenController.birthdate_set_status.value == '1' ? Icons.check_circle : Icons.cancel, 
									activityScreenController.birthdate_set_message.value, 
									activityScreenController.birthdate_set_status.value == '1' ? AppColor.LightGreen : AppColor.Red
								),
								_buildIconTextRow(
									activityScreenController.identity_verification_status.value == '1' 
										? Icons.check_circle 
										: activityScreenController.identity_verification_status.value == '2' 
											? Icons.schedule 
											: Icons.cancel, 
									activityScreenController.identity_verification_message.value, 
									activityScreenController.identity_verification_status.value == '1' ? AppColor.LightGreen : AppColor.Red
								),
							  ],
							),
						  ),
						  Obx(() {
							  if (activityScreenController.identity_verification_status.value == '0') {
								return Column(
								  crossAxisAlignment: CrossAxisAlignment.center,
								  children: [
									Padding(
									  padding: const EdgeInsets.only(top: 16.0),
									  child: Align(
										alignment: Alignment.centerLeft,
										child: Text(
										  'Complete your verification',
										  style: TextStyle(
											fontSize: 18,
											color: AppColor.BlackGreyscale,
											fontFamily: 'Urbanist-Regular',
										  ),
										),
									  ),
									),
									Padding(
									  padding: const EdgeInsets.only(top: 10.0),
									  child: Align(
										alignment: Alignment.centerLeft,
										child: Text(
										  'Please attach clear photos of your ID card showing both back and front sides.',
										  style: TextStyle(
											fontSize: 16,
											color: AppColor.BlackGreyscale,
											fontFamily: 'Urbanist-Regular',
										  ),
										),
									  ),
									),
									Padding(
									  padding: const EdgeInsets.only(top: 20.0),
									  child: Align(
										alignment: Alignment.centerLeft,
										child: Text(
										  'Upload multiple files',
										  style: TextStyle(
											fontSize: 18,
											color: AppColor.BlackGreyscale,
											fontFamily: 'Urbanist-Regular',
										  ),
										),
									  ),
									),
									const SizedBox(height: 10),
									autoWidthBtn(
									  text: 'Select Files',
									  width: screenWidth / 2,
									  onPress: () async {
										controller.isLoading.value = true; // Start showing the loader
										await Future.delayed(Duration(milliseconds: 500)); // Add a delay to allow loader to show
										await controller.pickFiles();
									  },
									),
									const SizedBox(height: 10),
									Obx(() {
									  return Wrap(
										spacing: 10,
										runSpacing: 10,
										children: controller.selectedFiles.map((file) {
										  return _buildFilePreview(file);
										}).toList(),
									  );
									}),
									Padding(
									  padding: const EdgeInsets.only(top: 20.0),
									  child: Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
										  const SizedBox(height: 10),
										  autoWidthBtn(
											text: 'SUBMIT',
											width: screenWidth,
											onPress: () {
											  // Ensure a file is selected before submitting
											  if (controller.selectedFiles.isEmpty) {
												Get.snackbar("Error", "Please select a file before submitting.", backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
											  } else {
												// Start the upload process
												controller.uploadVerifyImage();
											  }
											},
										  ),
										  const SizedBox(height: 10),
										],
									  ),
									),
								  ],
								);
							  } else {
								return SizedBox.shrink(); // Return an empty widget if the condition is not met
							  }
							}),

						  
						],
					  ),
					),
				),
			  ),
			  Obx(() {
				return controller.isLoading.value
					? Container(
						color: Colors.black.withOpacity(0.5), // Semi-transparent background
						child: Center(
						  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),),
						),
					  )
					: SizedBox.shrink();
			  }),
			],
		);
	  }
	  }),
    );
  }

  Widget _buildFilePreview(PlatformFile file) {
    return GestureDetector(
      onTap: () => _viewFile(file),
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: _getFileIcon(file),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                Get.find<ActivityScreenController>().removeFile(file);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFileIcon(PlatformFile file) {
    if (file.extension == 'jpg' || file.extension == 'jpeg' || file.extension == 'png') {
      return Image.file(
        File(file.path!),
        fit: BoxFit.cover,
      );
    } else if (file.extension == 'pdf') {
      return Icon(Icons.picture_as_pdf, size: 50, color: Colors.red);
    } else if (file.extension == 'xls' || file.extension == 'xlsx') {
      return Icon(Icons.grid_on, size: 50, color: Colors.green);
    } else {
      return Center(
        child: Text(
          file.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      );
    }
  }

  void _viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

	Widget _buildIconTextRow(IconData icon, String text, Color iconColor) {
	  return Padding(
		padding: const EdgeInsets.only(top: 15.0),
		child: Row(
		  crossAxisAlignment: CrossAxisAlignment.center,
		  children: [
			Icon(icon, size: 20.0, color: iconColor),
			const SizedBox(width: 12.0),
			Flexible(  // Wrap the Text in Flexible to allow wrapping
			  child: Text(
				text,
				style: TextStyle(
				  fontSize: 15, 
				  fontFamily: 'Urbanist-Regular', 
				  color: AppColor.BlackGreyscale,
				),
				overflow: TextOverflow.visible,  // Allow the text to wrap if it's too long
			  ),
			),
		  ],
		),
	  );
	}

}
