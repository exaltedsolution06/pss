import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/category_card.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
//import 'package:picturesourcesomerset/app/modules/home/views/selected_category.dart';
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

  @override
  void initState() {
    super.initState();
    homeController.homeCategoryData();
    homeController.homeArtistData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Source Somerset'),
        centerTitle: true,
		automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            _buildSection(
              title: "Categories",
              dataList: homeController.categoryData,
              onViewAll: () => Get.to(() => AllCategoryView()),
			  routeType: "0",
            ),
            const SizedBox(height: 6.0),

            // Artists Section
            _buildSection(
              title: "Artists",
              dataList: homeController.artistData,
              onViewAll: () => Get.to(() => AllArtistView()),
			  routeType: "1",
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildSection({
    required String title,
    required RxList<dynamic> dataList,
    required VoidCallback onViewAll,
	required String routeType,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading with "View All" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
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

          // Dynamic GridView
          Expanded(
            child: Obx(() {
              if (dataList.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final item = dataList[index];
				  //print(item);
                  return CategoryCard(
                    image: item['image']!,
                    label: item['name']!,
                    /*onTap: () {
					  Get.toNamed(Routes.SERACH_SCREEN);
                      //Get.to(() => productViewPage(id: item['id']!));
                    },*/
					onTap: () {
						if (routeType == "0") {
						  Get.toNamed(
							Routes.SERACH_SCREEN,
							arguments: {'categoryId': item['id'], 'artistId': null},
						  );
						} else if (routeType == "1") {
						  Get.toNamed(
							Routes.SERACH_SCREEN,
							arguments: {'categoryId': null, 'artistId': item['artist_id']},
						  );
						}
					},
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
