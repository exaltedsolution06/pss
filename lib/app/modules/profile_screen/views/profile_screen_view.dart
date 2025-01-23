import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/controllers/user_controller.dart';

import '../controllers/profile_screen_controller.dart';

class ProfileScreenView extends StatelessWidget {
	final ProfileScreenController profileScreenController = Get.find();
	final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
	final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture and Edit Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userController.profilePicture.value != null && userController.profilePicture.value.isNotEmpty
					? NetworkImage(userController.profilePicture.value)
					: AssetImage(Appcontent.defaultLogo) as ImageProvider,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '@ ${userController.name.value}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
					Padding(
					  padding: const EdgeInsets.only(bottom: 16, top: 16),
					  child: Center(
						child: Obx(() {
						  return autoWidthBtn(
							text: profileScreenController.isLoading.value ? 'Loading...' : Appcontent.edit,
							width: screenWidth,
							onPress: () {
								profileScreenController.editProfile();
							},
						  );
						}),
					  ),
					),
                  /*ElevatedButton(
					  onPressed: () {},
					  style: ElevatedButton.styleFrom(
						backgroundColor: Colors.red, // Replace 'primary' with 'backgroundColor'
						shape: RoundedRectangleBorder(
						  borderRadius: BorderRadius.circular(20),
						),
					  ),
					  child: Text('EDIT'),
					),*/

                ],
              ),
            ),
            // Action Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            // Collage Section
            Padding(
			  padding: const EdgeInsets.all(16.0),
			  child: Column(
				children: [
				  Row(
					children: [
					  Expanded(
						child: _buildCategoryCard(
						  title: 'My Orders',
						  subtitle: '635 Pins',
						  imageUrls: [
							Appcontent.pss1,
							Appcontent.pss2,
							Appcontent.pss3,
							 Appcontent.pss1,
							Appcontent.pss2,
							Appcontent.pss3,
						  ],
						),
					  ),
					  SizedBox(width: 16),
					  Expanded(
						child: _buildCategoryCard(
						  title: 'Your Wish List',
						  subtitle: 'All products',
						  imageUrls: [
							Appcontent.pss1,
							Appcontent.pss2,
							Appcontent.pss3,
							 Appcontent.pss1,
							Appcontent.pss2,
							Appcontent.pss3,
						  ],
						),
					  ),
					],
				  ),
				],
			  ),
			),

          ],
        ),
      ),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 4),
    );
  }

	Widget _buildCategoryCard({
	  required String title,
	  required String subtitle,
	  required List<String> imageUrls,
	}) {
	  return Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
		  // Overlapping Images (second image under first, third image under second, and so on)
		  SizedBox(
			height: 150, // Adjust the height to match your design
			child: Stack(
			  children: imageUrls.asMap().entries.map((entry) {
				int index = entry.key;
				String url = entry.value;

				return Positioned(
				  // Shift each image slightly to the right and downward
				  left: index * 40.0,  // Adjust horizontal shift (overlap distance)
				  child: ClipRRect(
					borderRadius: BorderRadius.circular(8), // Optional rounded corners
					child: Image.asset(
					  url,
					  fit: BoxFit.cover,
					  width: 100, // Adjust width
					  height: 150, // Adjust height
					),
				  ),
				);
			  }).toList(),
			),
		  ),
		  SizedBox(height: 8),
		  // Title
		  Text(
			title,
			style: TextStyle(
			  fontSize: 16,
			  fontWeight: FontWeight.bold,
			),
		  ),
		  // Subtitle
		  Text(
			subtitle,
			style: TextStyle(
			  fontSize: 12,
			  color: Colors.grey,
			),
		  ),
		],
	  );
	}


}
