import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/category_card.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';

import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';

class AllCategoryView extends StatefulWidget {
  @override
  State<AllCategoryView> createState() => _AllCategoryViewState();
}

class _AllCategoryViewState extends State<AllCategoryView> {
	final HomeController homeController = Get.find<HomeController>();
	
	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	
	@override
	void initState() {
		super.initState();
		homeController.loadInitialDataForCategory();
	}
	_AllCategoryViewState() {
		// Vertical Scroll Listener
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				homeController.loadMoreCategoryData();  // Load more data on vertical scroll
			}
		});
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            _buildSection(
              dataList: homeController.allCategoryData,
            ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  return CategoryCard(
                    image: item['image']!,
                    label: item['name']!,
                    onTap: () {
                      //Get.to(() => SelectedCategory(title: item['name']!));
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
