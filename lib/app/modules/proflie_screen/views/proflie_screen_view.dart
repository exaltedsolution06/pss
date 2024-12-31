import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:picturesourcesomerset/app/modules/home/views/showimage_view.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/custom_modal.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/video_player_widget.dart';


import '../controllers/proflie_screen_controller.dart';


// ignore: must_be_immutable
class ProflieScreenView extends StatelessWidget {
	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	final ProflieScreenController proflieScreenController = Get.find();
	ProflieScreenView() {
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				proflieScreenController.loadMoreFeedData(); // Load more data on vertical scroll
			}
		});
	}
  
	final actionTextStyle =
  TextStyle(fontSize: 14, color: AppColor.purple, fontFamily: 'Urbanist-medium', fontWeight: FontWeight.w500);
  
	@override
	Widget build(BuildContext context) {
		final double screenWidth = MediaQuery.of(context).size.width;
		final double screenHeight = MediaQuery.of(context).size.height;
		
  
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              centerTitle: true,
              title: const Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Urbanist-semibold',
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
              actions: [
                const SizedBox(width: 20),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: InkWell(
                      onTap: () {
						Get.toNamed(Routes.ACTIVITY_SCREEN);
                      },
					  child: const Icon(Icons.settings, color: Colors.black)),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            body: Obx(() {
				if (proflieScreenController.isFetchingData.value) {
					return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
				} else {
			
					final profileData = proflieScreenController.profileData.value;
					return SingleChildScrollView(
					  scrollDirection: Axis.vertical,
						child: Column(
						  children: [
							// Profile Banner, Pic and Name
							Container(
								height: 350,
								width: screenWidth,
								child: Stack(
									children: [
									  // Banner Image
									  Container(
										height: 173,
										width: screenWidth,
										decoration: BoxDecoration(
										  image: DecorationImage(
											//image: AssetImage('assets/Banner.png'),
											image: profileData.cover != null && profileData.cover.isNotEmpty
											  ? NetworkImage(profileData.cover) as ImageProvider
											  : AssetImage('assets/Banner.png'),
												fit: BoxFit.fill,
										  ),
										  borderRadius: BorderRadius.only(
											bottomLeft: Radius.circular(20),
											bottomRight: Radius.circular(20),
										  ),
										),
									  ),
									  // New Section Below Banner Image
									  Positioned(
										bottom: 10,
										left: 0,
										right: 0,
										child: InkWell(
										  onTap: () {
											//Get.toNamed(Routes.FOLLOW_SCREEN);
										  },
										  child: Container(
											height: 77,
											width: screenWidth,
											//color: AppColor.BlackGreyscale[200],
											child: Padding(
											  padding: const EdgeInsets.symmetric(horizontal: 20),
											  child: Container(
												height: 77,
												width: double.infinity,
												decoration: BoxDecoration(
												  borderRadius: BorderRadius.circular(15),
												  color: Colors.white,
												  border: Border.all(
													width: 1,
													color: const Color(0xffE2E8F0),
												  ),
												),
											  ),
											),
										  ),
										),
									  ),
									  // Positioned Avatar and Details
									  Positioned(
										top: 150,
										left: 20,
										right: 0,
										child: Row(
										  children: [
											Stack(
											  children: [
												Container(
												  height: 100,
												  width: 100,
												  decoration: BoxDecoration(
													color: Colors.indigo.shade300,
													border: Border.all(color: Colors.white, width: 5),
													shape: BoxShape.circle,
													image: DecorationImage(
													  image: profileData.avatar != null && profileData.avatar.isNotEmpty
														  ? NetworkImage(profileData.avatar) as ImageProvider
														  : AssetImage('assets/avatar.png'),
													  //fit: BoxFit.cover, // Optional: to ensure the image covers the entire circle
													),
												  ),
												),
												Positioned(
												  right: 0,
												  bottom: 0,
												  child: Container(
													height: 32,
													width: 32,
													decoration: BoxDecoration(
													  borderRadius: BorderRadius.circular(30),
													  border: Border.all(color: Colors.white, width: 3),
													   color: 	profileData.user_verify == 1 ? Colors.green : 
																Colors.red, // Set icon color based on condition
													),
													child: Icon(
														profileData.user_verify == 1 ? Icons.check : 
														Icons.gpp_bad, // Default icon if user_verify is not 1
														color: Colors.white,
													  size: 20, // Adjust the size of the icon
													),
												  ),
												),
											  ],
											),
											const SizedBox(width: 1),
											Expanded(
											  child: Padding(
												padding: const EdgeInsets.only(top: 16.0),
												child: ListTile(
												  title: Text(
													'${profileData.name}',
													overflow: TextOverflow.ellipsis,
													style: TextStyle(
													  fontSize: 18,
													  fontFamily: 'Urbanist-semibold',
													),
												  ),
												  subtitle: Text(
													'@${profileData.username}',
													overflow: TextOverflow.ellipsis,
													style: TextStyle(
													  fontSize: 12,
													  fontFamily: 'Urbanist-regular',
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
							),
							// Edit Profile and floating button
							Padding(
							  padding: const EdgeInsets.only(top: 30),
							  child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
								  elevated1(
									text: 'Edit Profile',
									onPress: () {
										Get.delete<ProflieScreenController>(); // Deletes the controller
										Get.toNamed(Routes.EDITPROFILE_SCREEN);
									},
								  ),
								],
							  ),
							),
						   const SizedBox(height: 10),
							Text(
								'Feeds',
								style: TextStyle(
									fontSize: 16,
									color: Colors.black,
									fontFamily: 'Urbanist-regular'
								),
								overflow: TextOverflow.ellipsis,
							),
							const SizedBox(height: 10),



						  ],
					   // ),
					  ),
					);	
				}			
			}),
          );
        },
      ),
    );
  }
  

}
  Widget _buildStatColumn(String number, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Urbanist-semibold',
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff64748B),
              fontFamily: 'Urbanist-medium',
            ),
          ),
        ],
      ),
    );
  }

Widget _benefitRow(IconData icon, String text) {
  return Row(
    children: [
      Icon(
        icon,
        size: 20.0,
        color: Colors.green,
      ),
      const SizedBox(width: 8.0),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Urbanist-semibold',
          ),
        ),
      ),
    ],
  );
}