import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/category_card.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/app/modules/home/views/all_category_view.dart';
import 'package:picturesourcesomerset/app/modules/home/views/all_artist_view.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.find<HomeController>();

	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	
	@override
	void initState() {
		super.initState();
		homeController.homeCategoryData();
		homeController.homeArtistData();
		homeController.loadInitialDataForCategory();
	}
	_HomeViewState() {
		// Vertical Scroll Listener
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				homeController.loadMoreCategoryData();  // Load more data on vertical scroll
			}
		});
	}
	/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Art On Your Wall',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => AllCategoryView()),
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppColor.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Non-scrollable GridView for categories
            Obx(() {
              if (homeController.categoryData.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: homeController.categoryData.length,
                itemBuilder: (context, index) {
                  final item = homeController.categoryData[index];
                  return CategoryCard(
                    image: item['image']!,
                    label: item['name']!,
                    onTap: () {
                      Get.toNamed(
                        Routes.SERACH_SCREEN,
                        arguments: {
                          'categoryId': item['id'],
                          'artistId': null,
                        },
                      );
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 24.0),

            // View All Artists Button
            Center(
              child: ElevatedButton(
                onPressed: () => Get.to(() => AllArtistView()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.purple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "View Art By Artist",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Art On Your Wall',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
			Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => AllArtistView()),
                  child: Text(
                    "View Art By Artist",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppColor.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Categories Section
            _buildSection(
              dataList: homeController.allCategoryData,
            ),
			const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildSection({
    required RxList<dynamic> dataList,
  }) {
    return Expanded(
	  child: SingleChildScrollView(
		controller: _verticalScrollController,
		child: ConstrainedBox(
		  constraints: BoxConstraints(
			minHeight: MediaQuery.of(context).size.height, // Ensures content height
		  ),
		  child: Obx(() {
			if (dataList.isEmpty) {
			  return Center(
				child: CircularProgressIndicator(
				  valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
				),
			  );
			}

			return GridView.builder(
			  shrinkWrap: true, // Important to prevent unbounded height error
			  physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
			  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
				crossAxisCount: 2,
				crossAxisSpacing: 8.0,
				mainAxisSpacing: 8.0,
			  ),
			  itemCount: dataList.length,
			  itemBuilder: (context, index) {
				final item = dataList[index];
				return CategoryCard(
				  image: item['image']!,
				  label: item['name']!,
				  onTap: () {
					Get.toNamed(
					  Routes.SERACH_SCREEN,
					  arguments: {'categoryId': item['id'], 'artistId': null},
					);
				  },
				);
			  },
			);
		  }),
		),
	  ),
	);
  }
}
