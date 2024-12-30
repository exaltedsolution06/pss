import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/custom_switch.dart';
import '../../../../config/bullet_list.dart';
import '../../../../config/app_color.dart';
import 'activity_screen_controller.dart';

class PrivacyScreenView extends GetView<ActivityScreenController> {
  const PrivacyScreenView({super.key});

  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
    //final ActivityScreenController controller = Get.put(ActivityScreenController());
	final ActivityScreenController activityScreenController = Get.find();
	activityScreenController.shouldFetchSettingsPrivacy = true;
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
        title: const Text('Privacy', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                'Your privacy and safety matters',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.black,
                  fontFamily: 'Urbanist-Regular',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
				padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 16.0),
				child: Column(
                    children: [
						Container(
							width: screenWidth,
							//height: 200,
							decoration: BoxDecoration(
							  color: Colors.white, // Background color of the box
							  border: Border.all(
								color: AppColor.Greyscale, // Border color
								width: 1, // Border width
							  ),
							  borderRadius: BorderRadius.circular(12), // Rounded corners
							),
							child: Column(
								children: [
									Padding(
										padding: const EdgeInsets.all(15.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Obx(() => customSwitch(
													value: activityScreenController.public_profile.value,
													onToggle: (value) => activityScreenController.toggleSwitchSettingsPrivacy(value, 'public_profile'),
													label: 'Is public account',
												)),
												const SizedBox(height: 15),
												Text(
													'Having your profile set to private means:',
													style: TextStyle(
														fontSize: 16, 
														color: AppColor.BlackGreyscale,
														fontFamily: 'Urbanist-Regular'
													),
												),
												Padding(
													padding: const EdgeInsets.only(left: 20.0, top: 15.0),
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															customBulletList(
															  items: [
																'It will be hidden for search engines and unregistered users entirely.',
																'It will also be generally hidden from suggestions and user searches on our platform.',
															  ],
															  bulletColor: AppColor.BlackGreyscale,
															  bulletSize: 10.0,
															  bulletPadding: 12.0, // Adjust this value as needed
															  bulletOffset: 7.0, // Fine-tune this value to align the bullet with the first line
															  textStyle: TextStyle(fontSize: 16, color: AppColor.BlackGreyscale, fontFamily: 'Urbanist-Regular'),
															)
														]
													),
												),
											]
										),
									),
								  
								]
							),
						),
						const SizedBox(height: 20),
						Container(
							width: screenWidth,
							//height: 200,
							decoration: BoxDecoration(
							  color: Colors.white, // Background color of the box
							  border: Border.all(
								color: AppColor.Greyscale, // Border color
								width: 1, // Border width
							  ),
							  borderRadius: BorderRadius.circular(12), // Rounded corners
							),
							child: Column(
								children: [
									Padding(
										padding: const EdgeInsets.all(15.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Obx(() => customSwitch(
													value: activityScreenController.enable_2fa.value,
													onToggle: (value) => activityScreenController.toggleSwitchSettingsPrivacy(value, 'enable_2fa'),
													label: 'Enable email 2FA',
												)),
												const SizedBox(height: 15),
												Text(
													'Having your profile set to private means:',
													style: TextStyle(
														fontSize: 16, 
														color: AppColor.BlackGreyscale,
														fontFamily: 'Urbanist-Regular'
													),
												),
											]
										),
									),
								  
								]
							),
						),
						
					]
				),
            ),
          ],
        ),
      ),
    );
  }
}
