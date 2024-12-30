import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class SerachScreenController extends GetxController {
	final ApiService apiService;
	SerachScreenController(this.apiService);  // Constructor accepting ApiService
	
	//search keyword
	var query = ''.obs;  // Observable for the search query
	
	var selected = 0.obs;  // To track the selected tab
	
	var currentPageTop = 1.obs;
	var currentPageLatest = 1.obs;
	var currentPagePeople = 1.obs;
	var currentPagePhotos = 1.obs;
	var currentPageVideos = 1.obs;

	var isFetchingData = false.obs;
	var hasMoreDataTop = true.obs;
	var hasMoreDataLatest = true.obs;
	var hasMoreDataPeople = true.obs;
	var hasMoreDataPhotos = true.obs;
	var hasMoreDataVideos = true.obs;

	var topData = <dynamic>[].obs;
	var latestData = <dynamic>[].obs;
	var peopleData = <dynamic>[].obs;
	var photosData = <dynamic>[].obs;
	var videosData = <dynamic>[].obs;
	
	// Method to update the query
	void onSearchQueryChanged(String newQuery) {
		query.value = newQuery;
		
		// Reset the page number
		currentPageTop.value = 1;  
		currentPageLatest.value = 1;
		currentPagePeople.value = 1;
		currentPagePhotos.value = 1;
		currentPageVideos.value = 1;
		
		// Clear the previous search data
		topData.clear();
		latestData.clear();
		peopleData.clear();
		photosData.clear();
		videosData.clear();
		
		// Enable loading more data
		hasMoreDataTop.value = true;
		hasMoreDataLatest.value = true;
		hasMoreDataPeople.value = true;
		hasMoreDataPhotos.value = true;
		hasMoreDataVideos.value = true;
	}
	
	
	@override
	void onInit() {
		super.onInit();
		loadInitialDataForTab(0);  // Load 'Top' tab by default
	}

	void onTabChange(int index) {
		selected.value = index;
		loadInitialDataForTab(index);
	}
	
	void loadInitialDataForTab(int index) {
		switch (index) {
		  case 0:
			if (topData.isEmpty) loadMoreDataTop();
			break;
		  case 1:
			if (latestData.isEmpty) loadMoreDataLatest();
			break;
		  case 2:
			if (peopleData.isEmpty) loadMoreDataPeople();
			break;
		  case 3:
			if (photosData.isEmpty) loadMoreDataPhotos();
			break;
		  case 4:
			if (videosData.isEmpty) loadMoreDataVideos();
			break;
		}
	}
	
	// Helper function to determine if more data can be loaded
	bool canLoadMore(int index) {
		switch (index) {
		  case 0:
			return hasMoreDataTop.value && !isFetchingData.value;
		  case 1:
			return hasMoreDataLatest.value && !isFetchingData.value;
		  case 2:
			return hasMoreDataPeople.value && !isFetchingData.value;
		  case 3:
			return hasMoreDataPhotos.value && !isFetchingData.value;
		  case 4:
			return hasMoreDataVideos.value && !isFetchingData.value;
		  default:
			return false;
		}
	}
	
	// Load more data for each tab
	Future<void> loadMoreDataTop() async {
		if (!canLoadMore(0) || query.value.isEmpty) return;  // Ensure query is not empty

		isFetchingData.value = true;
		try {
		  var response = await apiService.search(query.value, 1, 0, 0, 0, 0, currentPageTop.value);
		  print("response: $response");
		  var newData = response['data']['top'];
		  if (newData.isEmpty) {
			hasMoreDataTop.value = false;
		  } else {
			topData.addAll(newData);
			currentPageTop.value++;
		  }
		} catch (e) {
			//print('Error fetching All search: $e');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData.value = false;
		}
	}
	// Load more data for each tab
	Future<void> loadMoreDataLatest() async {
		if (!canLoadMore(0) || query.value.isEmpty) return;  // Ensure query is not empty

		isFetchingData.value = true;
		try {
		  var response = await apiService.search(query.value, 0, 1, 0, 0, 0, currentPageLatest.value);
		  var newData = response['data']['latest'];
		  if (newData.isEmpty) {
			hasMoreDataLatest.value = false;
		  } else {
			latestData.addAll(newData);
			currentPageLatest.value++;
		  }
		} catch (e) {
		  print('Error fetching All loadMoreDataLatest - search screen controller: $e');
		} finally {
		  isFetchingData.value = false;
		}
	}
	// Load more data for each tab
	Future<void> loadMoreDataPeople() async {
		if (!canLoadMore(0) || query.value.isEmpty) return;  // Ensure query is not empty

		isFetchingData.value = true;
		try {
		  var response = await apiService.search(query.value, 0, 0, 1, 0, 0, currentPagePeople.value);
		  var newData = response['data']['people'];
		  if (newData.isEmpty) {
			hasMoreDataPeople.value = false;
		  } else {
			peopleData.addAll(newData);
			currentPagePeople.value++;
		  }
		} catch (e) {
		  print('Error fetching All loadMoreDataPeople - search screen controller: $e');
		} finally {
		  isFetchingData.value = false;
		}
	}
	// Load more data for each tab
	Future<void> loadMoreDataPhotos() async {
		if (!canLoadMore(0) || query.value.isEmpty) return;  // Ensure query is not empty

		isFetchingData.value = true;
		try {
		  var response = await apiService.search(query.value, 0, 0, 0, 1, 0, currentPagePhotos.value);
		  var newData = response['data']['photos'];
		  if (newData.isEmpty) {
			hasMoreDataPhotos.value = false;
		  } else {
			photosData.addAll(newData);
			currentPagePhotos.value++;
		  }
		} catch (e) {
		  print('Error fetching All loadMoreDataPhotos - search screen controller: $e');
		} finally {
		  isFetchingData.value = false;
		}
	}
	// Load more data for each tab
	Future<void> loadMoreDataVideos() async {
		if (!canLoadMore(0) || query.value.isEmpty) return;  // Ensure query is not empty

		isFetchingData.value = true;
		try {
		  var response = await apiService.search(query.value, 0, 0, 0, 0, 1, currentPageVideos.value);
		  var newData = response['data']['videos'];
		  if (newData.isEmpty) {
			hasMoreDataVideos.value = false;
		  } else {
			videosData.addAll(newData);
			currentPageVideos.value++;
		  }
		} catch (e) {
		  print('Error fetching All loadMoreDataVideos - search screen controller: $e');
		} finally {
		  isFetchingData.value = false;
		}
	}
	// This method will be called when the user scrolls to the bottom
	void loadMoreData() {
		if (selected.value == 0) {
		  loadMoreDataTop();
		} else if (selected.value == 1) {
		  loadMoreDataLatest();
		} else if (selected.value == 2) {
		  loadMoreDataPeople();
		} else if (selected.value == 3) {
		  loadMoreDataPhotos();
		} else if (selected.value == 4) {
		  loadMoreDataVideos();
		}
	}
	
	////////////////////////
  
  //var selectIndex = [];
  var selectIndex1 = [];
  int seltectitem = 0;
  final count = 0.obs;

  //RxInt selected = 0.obs;
  int currentIndex = 0;

  void increment() => count.value++;

  /*changeValue({int ? value}) {
    if(selectIndex.contains(value)){
      selectIndex.remove(value);
    } else {
      selectIndex.add(value);
    }
    update();
  }*/

  changeCatWiseIndex({int ? index}) {
    currentIndex = index ?? 0;
    update();
  }
  
  //top tab
  changeValue1({int ? value}) {
    if(selectIndex1.contains(value)) {
      selectIndex1.remove(value);
    }
    else {
      selectIndex1.add(value);
    }
    update();
  }
  
  
  //send a tip modal
	var selectedCountry = 'USA'.obs;
	var selectedState = 'California'.obs;

	void updateCountry(String value) {
		//selectedCountry.value = value;
	}

	void updateState(String value) {
		selectedState.value = value;
	}
	
	var isChecked = false.obs;
  
	//add card
	void toggleCheckbox(bool value) {
		isChecked.value = value;
	}
}
