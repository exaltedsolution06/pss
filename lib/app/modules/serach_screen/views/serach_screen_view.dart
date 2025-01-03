import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
//import 'package:picturesourcesomerset/app/modules/filter_screen/views/filter_screen_view.dart';
//import 'package:picturesourcesomerset/app/modules/view_proflie_screen/views/view_proflie_screen_view.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import '../controllers/serach_screen_controller.dart';



// ignore: must_be_immutable
class SerachScreenView extends StatelessWidget {
	// Initialize the SerachScreenController
	final SerachScreenController serachScreenController = Get.find<SerachScreenController>();
	//final SerachScreenController serachScreenController = Get.put(SearchScreenController());
  
	final ScrollController _scrollController = ScrollController();

	SerachScreenView() {
		_scrollController.addListener(() {
			if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
				serachScreenController.loadMoreData();  // Load more data when user scrolls
			}
		});
	}

  @override
  Widget build(BuildContext context) {
	final TextEditingController searchController = TextEditingController();
  
	final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 5,  // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          centerTitle: true,
          title: const Text('Search', style: TextStyle(fontSize: 18, color: Colors.black)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Column(
				children: [
					Padding(
						padding: const EdgeInsets.all(10),
						//child: General(text: 'Search...'),
						child: Row(
							children: [
								Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											textFieldWithIconDynamic(
												text: 'Search...',
												icon: Icons.search, // Pass the desired icon here
												width: screenWidth,
												controller: searchController,
											),
											
										],
									),
								),
								const SizedBox(width: 15),
								autoWidthSearchBtn(
									text: 'SEARCH',
									width: 110,
									onPress: () {
										// Pass the search query to the controller and trigger search
										serachScreenController.onSearchQueryChanged(searchController.text);
										serachScreenController.loadMoreDataTop();  // Trigger the top data search
									},
								),
							],
						),
					),
				],
			),
          ),
        ),
        body: Obx(() {
          if (serachScreenController.isFetchingData.value && serachScreenController.topData.isEmpty) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
          }
          return Column(
            children: [
              buildSearchList(serachScreenController.topData),
            ],
          );
        }),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 1),
      ),
    );
  }

Widget buildSearchList(RxList<RxMap<String, dynamic>> data) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Obx(() {
        // Check if data is still being fetched
        if (serachScreenController.isFetchingData.value && data.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
            ),
          );
        }

        // Check if the data is empty after loading
        if (data.isEmpty) {
          return Center(
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

        // Display grid of images
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two images per row
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 3 / 2, // Adjust for the image aspect ratio
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            // Each item in the list is an observable map
            final RxMap<String, dynamic> feedData = data[index];

            return buildSearchItem(feedData, context);
          },
        );
      }),
    ),
  );
}

Widget buildSearchItem(RxMap<String, dynamic> feedData, BuildContext context) {
  return Obx(() {
    final isSelected = feedData['selected']?.value ?? false; // Get the reactive value of selected

    return GestureDetector(
      onTap: () {
        feedData['selected']?.value = !(feedData['selected']?.value ?? false); // Toggle selection
        feedData.refresh(); // Refresh this specific RxMap instance
        serachScreenController.topData.refresh(); // Refresh the parent RxList if needed

        print("Item selected: ${feedData['selected']?.value}");
      },

      child: Stack(
        children: [
          // Image container
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(
                image: AssetImage(feedData['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay for selected state
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          // Tick icon
          if (isSelected)
            Positioned(
              top: 8,
              left: 8,
              child: Icon(
                Icons.check_circle,
                color: Colors.black,
                size: 24,
              ),
            ),
          // Category name
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              feedData['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4.0,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  });
}









  



}