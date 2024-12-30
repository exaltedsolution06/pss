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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GetBuilder<Onboarding1Controller>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    Expanded(child: _buildMasonryGrid()),
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

  /// Builds the Masonry Grid
  Widget _buildMasonryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: images.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
			// Calculate the number of rows (3 items per row)
			int totalRows = (images.length / 3).ceil();  // Using ceil to round up to the nearest integer
  
			// Check if the current index corresponds to the last row
			bool isLastRow = index >= (totalRows - 1) * 3;
			print(isLastRow);
			double? height; // No default height for masonry effect
				if (isLastRow) {
				  height = 130; // Adjust height for the last row only
				}
			return Container(
				
				height: height, // Adjust height for the last row if needed
				decoration: BoxDecoration(
				  color: Colors.grey.withOpacity(0.1),
				  borderRadius: BorderRadius.circular(8),
				),
				child: ClipRRect(
				  borderRadius: BorderRadius.circular(8),
				  child: Image.asset(
					images[index],
					fit: BoxFit.cover,
					errorBuilder: (context, error, stackTrace) {
					  return Container(
						color: Colors.grey.shade200,
						child: const Icon(Icons.image, color: Colors.grey),
					  );
					},
				  ),
				  /*child: Image.network(
					  images[index],
					  fit: BoxFit.cover,
					),*/
				),				
			);
        },
      ),
    );
  }

  /// Builds the Bottom Section
  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(
            child: elevated(
              text: 'Register',
              onPress: () {
                Get.toNamed(Routes.REGISTER);
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'I have an account? ',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontFamily: 'Urbanist-medium',
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.LOGIN_SCREEN);
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppColor.purple,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
