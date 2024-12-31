import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:picturesourcesomerset/config/bottom_navigation.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class HomeController extends GetxController {
	//TODO: Implement HomeController
	final ApiService apiService;
	HomeController(this.apiService);
	
	var feedData = <dynamic>[].obs;	
	// Reset the page number
	var currentPage = 1.obs;  
	
	var isFetchingFeedData = false.obs;
	
	// Enable loading more data
	var hasMoreFeedData = true.obs;
	
	@override
	void onInit() {
		super.onInit();
		loadInitialDataForFeed();  // Load data for user
	}
	void loadInitialDataForFeed() {
		if (feedData.isEmpty) loadMoreFeedData();
	}
	// Helper function to determine if more data can be loaded
	bool canLoadMoreFeed() {
		return hasMoreFeedData.value && !isFetchingFeedData.value;
	}
	// Load more feed data
	Future<void> loadMoreFeedData() async {
		if (!canLoadMoreFeed()) return;

		isFetchingFeedData.value = true;
		
		
				
				
		try {
			//var response = await apiService.feed_all_user(currentPage.value);
			final response = {
			  'data': [
				  {'image': Appcontent.pss1, 'name': 'Florals'},
				  {'image': Appcontent.pss2, 'name': 'Photography'},
				  {'image': Appcontent.pss3, 'name': 'Cityscapes'},
				  {'image': Appcontent.pss4, 'name': 'Coastal'},
				],
			};
			var newFeedData = response?['data'] ?? [];  
			if (newFeedData.isEmpty) {
				hasMoreFeedData.value = false;
			} else {
				feedData.addAll(newFeedData);
				currentPage.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreFeedData - home controller: $e');
		} finally {
			isFetchingFeedData.value = false;
		}
	}	
	
		
	// final controller = PageController(viewportFraction: 0.8, keepPage: true);
	//var selectIndex = [];
	var selectIndex1 = [];
	int seltectitem = 0;
	final count = 0.obs;
  
  void increment() => count.value++;

  /*changeValue({int ? value}) {
    if(selectIndex.contains(value)) {
      selectIndex.remove(value);
    }
    else {
      selectIndex.add(value);
    }
    update();
  }*/

  changeValue1({int ? value}) {
    if(selectIndex1.contains(value)) {
      selectIndex1.remove(value);
    }
    else {
      selectIndex1.add(value);
    }
    update();
  }

  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
  //add card

	var isChecked = false.obs;
	void toggleCheckbox(bool value) {
		isChecked.value = value;
	}
  
  
  
}
