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
	var feedCourseUserData = <dynamic>[].obs;
	
	// Reset the page number
	var currentPage = 1.obs;  
	var currentCourseUserPage = 1.obs;  
	
	var isFetchingFeedData = false.obs;
	var isFetchingCourseUserData = false.obs;
	
	// Enable loading more data
	var hasMoreFeedData = true.obs;
	var hasMoreCourseUserData = true.obs;
	
	/*@override
	void onInit() {
		super.onInit();
		loadInitialDataForCourseUser();  // Load data for user
		loadInitialDataForFeed();  // Load data for user
	}*/
	void loadInitialDataForCourseUser() {
		if (feedCourseUserData.isEmpty) loadMoreCourseUserData();
	}
	void loadInitialDataForFeed() {
		if (feedData.isEmpty) loadMoreFeedData();
	}
	// Helper function to determine if more data can be loaded
	bool canLoadMoreCourseUser() {
		return hasMoreCourseUserData.value && !isFetchingCourseUserData.value;
	}
	bool canLoadMoreFeed() {
		return hasMoreFeedData.value && !isFetchingFeedData.value;
	}
	// Load more feed data
	Future<void> loadMoreFeedData() async {
		if (!canLoadMoreFeed()) return;

		isFetchingFeedData.value = true;
		try {
			var response = await apiService.feed_all_user(currentPage.value, currentCourseUserPage.value);
			var newFeedData = response['data']['posts'];		  
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
	// Load more course user data
	Future<void> loadMoreCourseUserData() async {
		if (!canLoadMoreCourseUser()) return;  // Ensure query is not empty

		isFetchingCourseUserData.value = true;
		try {
			var response = await apiService.feed_all_user(currentPage.value, currentCourseUserPage.value);
			

			var newCourseUserData = response['data']['courses_user_page'];	
			//print("newCourseUserData: $newCourseUserData");			
			if (newCourseUserData.isEmpty) {
				hasMoreCourseUserData.value = false;
			} else {
				feedCourseUserData.addAll(newCourseUserData);
				currentCourseUserPage.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreCourseUserData - home controller: $e');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isFetchingCourseUserData.value = false;
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
  
  //for home view emoji in comments
 /* var emojiShowing = false.obs;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void toggleEmojiPicker() {
    emojiShowing.value = !emojiShowing.value;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }*/
  
  //send a tip modal
	var selectedCountry = 'USA'.obs;
	var selectedState = 'California'.obs;

	void updateCountry(String value) {
		selectedCountry.value = value;
	}

	void updateState(String value) {
		selectedState.value = value;
	}
	
	var isChecked = false.obs;

 /* void toggleCCValue() {
    isChecked.value = !isChecked.value;
  }*/
  
  //add card

	
void toggleCheckbox(bool value) {
    isChecked.value = value;
  }
  
  
  
}
