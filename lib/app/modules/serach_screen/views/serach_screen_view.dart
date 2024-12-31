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
      ),
    );
  }

  Widget buildSearchList(RxList data) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Obx(() {
      // Check if data is still being fetched
      if (serachScreenController.isFetchingData.value && data.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple), // Set your desired color here
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
              color: Colors.grey, // Customize the color if needed
              fontFamily: 'Urbanist-regular',
            ),
          ),
        );
      }

      return ListView.separated(
        controller: _scrollController,
        itemCount: data.length + 1,  // Add 1 to display loading indicator at the end
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == data.length) {
            // Show loading indicator at the end of the list if more data is being fetched
            return serachScreenController.isFetchingData.value
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),))
                : const SizedBox.shrink();
          }

          // Cast each item in the list to an observable map
          final RxMap<String, dynamic> feedData = RxMap<String, dynamic>.from(data[index]);

          return buildSearchItem(feedData, index, context);
        },
      );
    }),
  );
}


  // Method to build a single search item
  Widget buildSearchItem(RxMap<String, dynamic> feedData, int index, BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ListTile layout for search item
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 28, // 56px height/width
            backgroundImage: NetworkImage(feedData['image']),
            //backgroundImage: AssetImage(feedData['image']),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  feedData['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist-medium',
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    ),
  );
}



}