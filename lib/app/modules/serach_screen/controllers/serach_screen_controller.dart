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

	var isFetchingData = false.obs;
	var hasMoreDataTop = true.obs;

	//var topData = <dynamic>[].obs;
	var topData = <RxMap<String, dynamic>>[].obs;

	
	// Method to update the query
	void onSearchQueryChanged(String newQuery) {
		query.value = newQuery;
		
		// Reset the page number
		currentPageTop.value = 1;
		
		// Clear the previous search data
		topData.clear();
		
		// Enable loading more data
		hasMoreDataTop.value = true;
	}
	
	
	@override
	void onInit() {
		super.onInit();
		if (topData.isEmpty) loadMoreDataTop();
	}
	
	// Helper function to determine if more data can be loaded
	bool canLoadMore() {
		return hasMoreDataTop.value && !isFetchingData.value;
	}
	
	// Load more data for each tab
	Future<void> loadMoreDataTop() async {
		if (!canLoadMore() || query.value.isEmpty) return;  // Ensure query is not empty

		isFetchingData.value = true;
		try {
		  //var response = await apiService.search(query.value, 1, 0, 0, 0, 0, currentPageTop.value);
			final response = {
			  'data': [
					{'name': 'Cityscapes', 'image': Appcontent.pss1, 'selected': false},
					{'name': 'Coastal', 'image': Appcontent.pss2, 'selected': false},
					{'name': 'Figurative', 'image': Appcontent.pss3, 'selected': false},
					{'name': 'Florals', 'image': Appcontent.pss4, 'selected': false},
					{'name': 'Landscape', 'image': Appcontent.pss5, 'selected': false},
					{'name': 'Lodge & Farmhouse', 'image': Appcontent.pss6, 'selected': false},
					{'name': 'Photography', 'image': Appcontent.pss7, 'selected': false},
					{'name': 'Somerset Classics', 'image': Appcontent.pss8, 'selected': false},
				],
			};
			print("response: $response");
			var newData = response?['data'] ?? [];
			if (newData.isEmpty) {
				hasMoreDataTop.value = false;
			} else {
				//topData.addAll(newData);
				
				topData.addAll(newData.map((item) {
					return RxMap<String, dynamic>.from({
					  'name': item['name'],
					  'image': item['image'],
					  'selected': (item['selected'] ?? false).obs,  // Reactive selected field
					});
				}).toList());
	  
	  
				currentPageTop.value++;
				
				print("topData: $topData");
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
	// This method will be called when the user scrolls to the bottom
	void loadMoreData() {
		loadMoreDataTop();
	}
}
