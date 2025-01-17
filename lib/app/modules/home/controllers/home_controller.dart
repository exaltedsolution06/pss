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
	var isLoading = false.obs;  // RxBool
	HomeController(this.apiService);
	
	var categoryData = <dynamic>[].obs;	
	var artistData = <dynamic>[].obs;	
	var allCategoryData = <dynamic>[].obs;
	var allArtistData = <dynamic>[].obs;

	// Reset the page number
	var currentCategoryPage = 1.obs;  
	var currentArtistPage = 1.obs;  

	var isFetchingCategoryData = false.obs;
	var isFetchingArtistData = false.obs;	
	
	// Enable loading more data
	var hasMoreCategoryData = true.obs;
	var hasMoreArtistData = true.obs;
	
	@override
	void onInit() {
		//super.onInit();
		//loadMoreCategoryData();  // Load data for home page
		//loadMoreArtistData();  // Load data for home page
	}
	
	void loadInitialDataForCategory() {
		if (allCategoryData.isEmpty) loadMoreCategoryData();
	}
	void loadInitialDataForArtist() {
		if (allArtistData.isEmpty) loadMoreArtistData();
	}
	// Helper function to determine if more data can be loaded
	bool canLoadMoreCategory() {
		return hasMoreCategoryData.value && !isFetchingCategoryData.value;
	}
	bool canLoadMoreArtist() {
		return hasMoreArtistData.value && !isFetchingArtistData.value;
	}
	// Load more Category data
	Future<void> loadMoreCategoryData() async {
		if (!canLoadMoreCategory()) return;

		isFetchingCategoryData.value = true;
		try {
			var response = await apiService.allCategoryList(currentCategoryPage.value);
			var newFeedData = response['data'];		  
			if (newFeedData.isEmpty) {
				hasMoreCategoryData.value = false;
			} else {
				allCategoryData.addAll(newFeedData);
				currentCategoryPage.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreCategoryData - home controller: $e');
		} finally {
			isFetchingCategoryData.value = false;
		}
	}	
	// Load more artist data
	Future<void> loadMoreArtistData() async {
		if (!canLoadMoreArtist()) return;  // Ensure query is not empty

		isFetchingArtistData.value = true;
		try {
			var response = await apiService.allArtistList(currentArtistPage.value);			

			var newArtistData = response['data'];	
			//print("newArtistData: $newArtistData");			
			if (newArtistData.isEmpty) {
				hasMoreArtistData.value = false;
			} else {
				allArtistData.addAll(newArtistData);
				currentArtistPage.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreCourseUserData - home controller: $e');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isFetchingArtistData.value = false;
		}
	}
	
	// Home page category data
	Future<void> homeCategoryData() async {
		try {
			var response = await apiService.homeCategoryList();
			var newFeedData = response['data']; 
			categoryData.addAll(newFeedData);
			
			//print(categoryData);
		} catch (e) {
			print('Error fetching All homeCategoryData - home controller: $e');
		}
	}	
	// Home page artist data
	Future<void> homeArtistData() async {
		try {
			var response = await apiService.homeArtistList();
			var newFeedData = response['data']; 
			artistData.addAll(newFeedData);
		} catch (e) {
			print('Error fetching All homeArtistData - home controller: $e');
		}
	}	
	
		
	// final controller = PageController(viewportFraction: 0.8, keepPage: true);
	//var selectIndex = [];
	var selectIndex1 = [];
	int seltectitem = 0;
	final count = 0.obs;
  
  void increment() => count.value++;

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
  
	Future<void> wallPhotoOrder() async {
	  isLoading.value = true;
	  Get.toNamed(Routes.WISHLIST_CREATE);
	}
  
}
