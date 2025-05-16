import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
//import 'package:picturesourcesomerset/app/modules/filter_screen/views/filter_screen_view.dart';
//import 'package:picturesourcesomerset/app/modules/view_profile_screen/views/view_profile_screen_view.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import '../controllers/serach_screen_controller.dart';

class SerachScreenView extends StatefulWidget {
  @override
  _SerachScreenViewState createState() => _SerachScreenViewState();
}

// ignore: must_be_immutable
//class SerachScreenView extends StatelessWidget {
class _SerachScreenViewState extends State<SerachScreenView> with WidgetsBindingObserver {
	// Initialize the SerachScreenController
	//final SerachScreenController serachScreenController = Get.find<SerachScreenController>();
	final SerachScreenController serachScreenController = Get.put(SerachScreenController(Get.find<ApiService>()));
  
	final ScrollController _scrollController = ScrollController();
	
	final TextEditingController searchController = TextEditingController();
	
	int? categoryId;
    int? artistId;
	
	@override
	void initState() {
		super.initState();

		// Retrieve arguments from GetX
		final arguments = Get.arguments as Map<String, dynamic>? ?? {};
		categoryId = arguments["categoryId"];
		artistId = arguments["artistId"];
		
		serachScreenController.resetFilters();
		
		_scrollController.addListener(() {
		  if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
			serachScreenController.loadMoreData();
		  }
		});

		// 🔹 Automatically trigger search if coming from a category or artist
		if (categoryId != null) {
		  serachScreenController.onSearchQueryChanged("", categoryId: categoryId);
		} else if (artistId != null) {
		  serachScreenController.onSearchQueryChanged("", artistId: artistId);
		}

		// Fetch initial data
		serachScreenController.loadMoreDataProduct();
	}
  
	/*@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    serachScreenController.loadMoreDataProduct(); // Call API or reload data
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      serachScreenController.loadMoreDataProduct();
    }
  }*/
  
	SerachScreenView() {
		_scrollController.addListener(() {
			if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
				serachScreenController.loadMoreData();  // Load more data when user scrolls
			}
		});
	}

  @override
  Widget build(BuildContext context) {
  
	final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 5,  // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          //backgroundColor: Colors.white,
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
												icon: null, // Pass the desired icon here
												width: screenWidth,
												controller: searchController,
											),
											
										],
									),
								),
								const SizedBox(width: 15),
								/*autoWidthSearchBtn(
									text: '',
									width: 110,
									onPress: () {
										// Pass the search query to the controller and trigger search
										serachScreenController.onSearchQueryChanged(searchController.text, categoryId: categoryId, artistId: artistId,);
										serachScreenController.loadMoreDataProduct();  // Trigger the top data search
									},
								),*/
								Container(
								  height: 40,
								  decoration: BoxDecoration(
									color: AppColor.purple, // Set your desired background color here
									borderRadius: BorderRadius.circular(8), // Optional: Set rounded corners
								  ),
								  child: IconButton(
									icon: Icon(Icons.search, color: Colors.white), // Search icon color
									onPressed: () {
									  // Trigger search logic
									  serachScreenController.onSearchQueryChanged(
										searchController.text,
										categoryId: categoryId,
										artistId: artistId,
									  );
									  serachScreenController.loadMoreDataProduct();  // Trigger the top data search
									},
									splashColor: Colors.blue, // Optional: Set splash color
									padding: EdgeInsets.all(5), // Adjust padding if needed
								  ),
								),
								const SizedBox(width: 10),
								
								IconButton(
									icon: Icon(Icons.filter_list, color: AppColor.purple),
									onPressed: () {
									  openFilterBottomSheet(context);
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
          if (serachScreenController.isFetchingData.value && serachScreenController.productData.isEmpty) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
          }
          /*return Column(
            children: [
              buildSearchList(serachScreenController.productData),
            ],
          );*/
		  return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding on both sides
			child: Column(
			  children: [
				buildSearchList(serachScreenController.productData),
			  ],
			),
		  );
        }),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 1),
      ),
    );
  }

Widget buildSearchList(RxList data) {
  return Expanded(
    child: SingleChildScrollView(
	  controller: _scrollController,
      child: ConstrainedBox(
		constraints: BoxConstraints(
			minHeight: MediaQuery.of(context).size.height, // Ensures content height
		),
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
			  shrinkWrap: true, // Important to prevent unbounded height error
			  physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
			  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
				crossAxisCount: 2, // Two images per row
				mainAxisSpacing: 16.0,
				crossAxisSpacing: 16.0,
				childAspectRatio: 3 / 2, // Adjust for the image aspect ratio
			  ),
			  itemCount: data.length,
			  itemBuilder: (context, index) {
				// Each item in the list is an observable map
				final RxMap<String, dynamic> feedData = RxMap<String, dynamic>.from(data[index]);

				return buildSearchItem(feedData, index, context);
			  },
			);
		}),
	  ),
    ),
  );
}

Widget buildSearchItem(RxMap<String, dynamic> feedData, int index, BuildContext context) {
	return Obx(() {
		return GestureDetector(
			onTap: () {
			  print('Product clicked');
			  final productId = feedData['product_id']?.toString() ?? '1';
			  print('Navigating with Product ID: $productId');
			  Get.toNamed(
				Routes.PRODUCTVIEW_SCREEN,
				arguments: {'productId': productId},
			  );
			},


      child: Stack(
        children: [
          // Image container
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(
                image: NetworkImage(feedData['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay for selected state
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.black.withOpacity(0.4),
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
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  });
}
void openFilterBottomSheet(BuildContext context) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Color Selection Chips (No Checkmark)
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Select Color:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Obx(() => Wrap(
            spacing: 8.0,
            children: serachScreenController.availableColors.map((color) {
              bool isSelected = serachScreenController.selectedColors.contains(color['id']);
              return RawChip(
                label: Text(color['color']),
                selected: isSelected,
                onSelected: (selected) {
                  serachScreenController.toggleColorSelection(color['id']);
                },
                selectedColor: Colors.green,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? Colors.green : Colors.grey),
                ),
                showCheckmark: false,
              );
            }).toList(),
          )),

          const SizedBox(height: 15),

		  /*
          // Size Selection Chips (No Checkmark)
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Select Size:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Obx(() => Wrap(
            spacing: 8.0,
            children: serachScreenController.availableSizes.map((size) {
              bool isSelected = serachScreenController.selectedSizes.contains(size['id']);
              return RawChip(
                label: Text(size['size']),
                selected: isSelected,
                onSelected: (selected) {
                  serachScreenController.toggleSizeSelection(size['id']);
                },
                selectedColor: Colors.green,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? Colors.green : Colors.grey),
                ),
                showCheckmark: false,
              );
            }).toList(),
          )),*/

          const SizedBox(height: 20),

          // 🔹 Apply Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.purple,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
            ),
            onPressed: () {
              Get.back(); // Close bottom sheet
              serachScreenController.onSearchQueryChanged(
                searchController.text,
                categoryId: categoryId,
                artistId: artistId,
              );
              serachScreenController.loadMoreDataProduct();
            },
            child: Text("Apply Filters", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}


}