import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart'; // Ensure this import is present for routing
import 'package:picturesourcesomerset/config/app_contents.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
	final HomeController homeController = Get.find<HomeController>();

	final ScrollController _verticalScrollController = ScrollController();

	HomeView() {
		// Vertical Scroll Listener
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels ==
				_verticalScrollController.position.maxScrollExtent) {
				// Load more data when reaching the end of the list
				homeController.loadMoreFeedData();
			}
		});
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Heading Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              Appcontent.browse,
			  textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Posts Section
          SizedBox(
            height: Get.size.height - 120,
            width: Get.width,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Obx(() {
                if (homeController.isFetchingFeedData.value &&
                    homeController.feedData.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColor.purple),
                    ),
                  );
                } else if (homeController.feedData.isNotEmpty) {
                  return buildSearchList(homeController.feedData);
                } else {
                  return const Center(
                      child: Text('No records yet')); // Handle empty state
                }
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSearchList(RxList data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        // Check if data is still being fetched
        if (homeController.isFetchingFeedData.value && data.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColor.purple), // Loader color
            ),
          );
        }

        // Check if the data is empty after loading
        if (data.isEmpty) {
          return const Center(
            child: Text(
              'No data found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Urbanist-regular',
              ),
            ),
          );
        }

        // Return the grid view with items and spacing
        return GridView.builder(
          controller: _verticalScrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns in the grid
            crossAxisSpacing: 8.0, // Horizontal spacing
            mainAxisSpacing: 8.0, // Vertical spacing
            childAspectRatio: 1 / 1.2, // Adjust for image-text alignment
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final RxMap<String, dynamic> feedData =
                RxMap<String, dynamic>.from(data[index]);
            return buildSearchItem(feedData);
          },
        );
      }),
    );
  }

  Widget buildSearchItem(RxMap<String, dynamic> feedData) {
    return GestureDetector(
      onTap: () {
        // Navigate to another page, passing the id of the clicked item
        /*Get.toNamed(Routes.DETAILS, parameters: {
          'id': feedData['id'].toString(),
        });*/
      },
      child: Stack(
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              feedData['image'],
              width: double.infinity, // Full width of the item
              height: 300, // Fixed height for the image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          // Text Section over the image
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.black.withOpacity(0.1), // Semi-transparent black background
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  feedData['name'],
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist-medium',
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // White text for visibility
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
