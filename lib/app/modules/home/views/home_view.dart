import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/category_card.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/app/modules/home/views/selected_category.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            CategoryCard(
              image: Appcontent.pss1,
              label: 'Florals',
              onTap: () {
                Get.to(() => SelectedCategory(title: 'Florals'));
              },
            ),
            CategoryCard(
              image: Appcontent.pss2,
              label: 'Photography',
              onTap: () {
                Get.to(() => SelectedCategory(title: 'Photography'));
              },
            ),
            CategoryCard(
              image: Appcontent.pss3,
              label: 'Silhouettes',
              onTap: () {
                Get.to(() => SelectedCategory(title: 'Silhouettes'));
              },
            ),
            CategoryCard(
              image: Appcontent.pss4,
              label: 'Coastal',
              onTap: () {
                Get.to(() => SelectedCategory(title: 'Coastal'));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }
}