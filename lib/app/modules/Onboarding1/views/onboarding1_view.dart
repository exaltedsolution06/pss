import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import '../controllers/onboarding1_controller.dart';

class Onboarding1View extends GetView<Onboarding1Controller> {
  Onboarding1View({super.key});

  final List<String> images = [
	Appcontent.pss1,
	Appcontent.pss2,
	Appcontent.pss3,
	Appcontent.pss4,
	Appcontent.pss5,
	Appcontent.pss6,
	Appcontent.pss7,
	Appcontent.pss8,
	Appcontent.pss9,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GetBuilder<Onboarding1Controller>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildMasonryGridWithBottomSection()),
                    _buildBottomSection(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
	
	Widget _buildMasonryGridWithBottomSection() {
  return Stack(
    children: [
      // Masonry Grid
      _buildMasonryGrid(),

      // Bottom Section
      Positioned(
        bottom: 90,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(40.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), // Semi-transparent background
          ),
        ),
      ),
	  // Image below the bottom section
      Positioned(
        bottom: 0, // Positioned directly below the bottom section
        left: 0,
        right: 0,
        child: Image.asset(
          Appcontent.maillonglogo, // Provide the path to your image
          fit: BoxFit.cover, // Adjust the image size and aspect ratio
        ),
      ),
    ],
  );
}



  /// Builds the Masonry Grid
  Widget _buildMasonryGrid() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Width of each item based on crossAxisCount
        double itemWidth = (constraints.maxWidth - 24) / 3; // 24 = 2 * crossAxisSpacing
        
        // Background container wrapping the MasonryGridView
        return Container(
          //padding: const EdgeInsets.all(16), // Padding inside the background container
		  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
          child: MasonryGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: images.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              double height = 0;
              if (index == 0) height = 157;
              if (index == 1) height = 155;
              if (index == 2) height = 157;
              if (index == 3) height = 160;
              if (index == 4) height = 160;
              if (index == 5) height = 160;
              if (index == 6) height = 128;
              if (index == 7) height = 128;
              if (index == 8) height = 110;

              // Conditional padding for the second image
              return Padding(
                padding: EdgeInsets.only(top: index == 1 ? 20.0 : 0.0),
                child: Container(
                  width: itemWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
					/*child: Image.network(
						images[index],
						fit: BoxFit.cover,
					),*/
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}


  /// Builds the Bottom Section
  Widget _buildBottomSection() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(
            child: elevated(
              text: Appcontent.signUpConsumer,
              onPress: () {
                Get.toNamed(Routes.CONSUMER_REGISTER);
              },
            ),
          ),
          const SizedBox(height: 20),
		  Center(
			child: whiteBgBlackBorderBtn(
              text: Appcontent.signUpRetailer,
              onPress: () {
                Get.toNamed(Routes.RETAILER_REGISTER);
              },
            ),
          ),
		  const SizedBox(height: 20),
		  Center(
			child: textButton(
              text: Appcontent.login,
			  width: 327,
			  height: 56,
              onPress: () {
                Get.toNamed(Routes.LOGIN_SCREEN);
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}

}
