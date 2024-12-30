import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/editpictre_screen/views/editpictre_screen_view.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import '../../../../config/app_color.dart';
import '../controllers/addcard_screen_controller.dart';

// ignore: must_be_immutable
class AddcardScreenView extends GetView<AddcardScreenController> {
  AddcardScreenView({super.key}); 
  AddcardScreenController addcardScreenController = Get.put(AddcardScreenController());

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
                child: const Icon(Icons.arrow_back, color: Colors.black,),
              ),
              title: const Text('Add Card', style: TextStyle(fontSize: 18, color: Colors.black)),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
				scrollDirection: Axis.vertical,
				  child: Column(
					children: [
					  // First Section
					  Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
						  Padding(
							padding: EdgeInsets.all(16.0),
							child: Text(
							  'BILLING DETAILS',
							  style: TextStyle(
								fontSize: 16,
								color: AppColor.BlackGreyscale, // Adjust as per AppColor
								fontFamily: 'Urbanist-semibold',
							  ),
							),
						  ),
						  Padding(
							padding: EdgeInsets.only(left: 16.0, top: 0, right: 16.0, bottom: 16.0),
							child: Text(
							  'We are fully compliant with Payment Card Industry Data Security Standards.',
							  style: TextStyle(
								fontSize: 14,
								color: AppColor.black, // Adjust as per AppColor
								fontFamily: 'Urbanist-semibold',
							  ),
							),
						  ),
						],
					  ),	
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
										Obx(() => dropdownField(
											text1: 'Country', 
											width: screenWidth,
											value: controller.selectedCountry.value,
											items: ['USA', 'Canada', 'Mexico'],
											onChanged: (value) => controller.updateCountry(value!),
										)),
										Obx(() => dropdownField(
											text1: 'State / Province', 
											width: screenWidth,
											value: controller.selectedState.value,
											items: ['California', 'Texas', 'Florida'],
											onChanged: (value) => controller.updateState(value!),
										)),
										autoWidthTextField(text: 'Enter your Address', width: screenWidth),
										autoWidthTextField(text: 'Enter your City', width: screenWidth),
										autoWidthTextField(text: 'Enter your Zip', width: screenWidth),
									]
								),
							),	
						],
					  ),					  
					  // 3rd Section
					  Column(
						children: [
						  Padding(
							padding: EdgeInsets.all(16.0),
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
									  'CARD DETAILS',
									  style: TextStyle(
										fontSize: 16,
										color: AppColor.BlackGreyscale, // Adjust as per AppColor
										fontFamily: 'Urbanist-semibold',
									  ),
									),
								],
							),
						  ),
						],
					  ),				  
					  const SizedBox(height: 10),
					  // 4th Section
					  Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							Padding(
								padding: EdgeInsets.only(left: 30.0, top: 0, right: 30.0, bottom: 0),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										autoWidthTextField(text: 'Enter your Email Address', width: screenWidth),
										autoWidthTextField(text: 'Enter your Name on the Card', width: screenWidth),
										autoWidthTextField(text: 'Enter your Card Number', width: screenWidth),
										Row(
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												autoWidthTextField(text: 'Enter your Card Expiry', width: (screenWidth/2)-35),
												const SizedBox(width: 10),
												autoWidthTextField(text: 'Enter your Card CVC', width: (screenWidth/2)-35),
											]
										),
										
									]
								),
							),
							
						],
					  ),
					  const SizedBox(height: 10),
					  // 5th Section
					  Column(
						  crossAxisAlignment: CrossAxisAlignment.center,
						  children: [
							Padding(
							  padding: EdgeInsets.all(16.0),
							  child: Column(
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
								  Row(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
									  Obx(() => Column(
										mainAxisSize: MainAxisSize.min,
										children: [
										  Checkbox(
											value: controller.isChecked.value,
											onChanged: (bool? value) {
											  controller.toggleCheckbox(value!);
											},
										  ),
										],
									  )),
									  Flexible(
										child: Text(
										  'Tick here to confirm that you are at least 18 years old and the age of majority in your place of residence',
										  style: TextStyle(fontSize: 14),
										),
									  ),
									],
								  ),
								],
							  ),
							),
						  ],
						),
						// 6th Section
						/*Positioned(
							bottom: 0,
							left: 0,
							right: 0,
							child: Container(
							  color: Colors.white, // Ensure the background color matches the app
							  padding: EdgeInsets.all(16.0),
							  child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
								  elevated(
									text: 'SUBMIT',
									onPress: () {
									  // Your onPress action here
									},
								  ),
								],
							  ),
							),
						  ),*/
						Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Container(
									width: screenWidth,
									child: Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: [
											elevated(
											text: 'Please Add a Payment Card',
											onPress: () {
												
											},
										),
										]
									),
								),
							
								
							  /*Padding(
								padding: EdgeInsets.all(16.0),
								child: Row(
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										elevated(
											text: 'Please Add a Payment Card',
											onPress: () {
												
											},
										),
									],
								),
							  ),*/
							],
						),
					  const SizedBox(height: 10),
					],
				  ),
            ),
          ),
        );
      },
    );
  }
}
