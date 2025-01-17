import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class SerachScreenController extends GetxController {
	final ApiService apiService;
	SerachScreenController(this.apiService);  // Constructor accepting ApiService
	
	//search keyword
	var keyword = ''.obs;  // Observable for the search query
	
	var selected = 0.obs;  // To track the selected tab
	
	var currentPageProduct = 1.obs;

	var isFetchingData = false.obs;
	var hasMoreDataProduct = true.obs;

	var productData = <dynamic>[].obs;
	//var productData = <RxMap<String, dynamic>>[].obs;

	
	// Method to update the keyword
	void onSearchQueryChanged(String newQuery) {
		keyword.value = newQuery;
		
		// Reset the page number
		currentPageProduct.value = 1;
		
		// Clear the previous search data
		productData.clear();
		
		// Enable loading more data
		hasMoreDataProduct.value = true;
	}
	
	
	@override
	void onInit() {
		super.onInit();
		if (productData.isEmpty) loadMoreDataProduct();
	}
	
	// Helper function to determine if more data can be loaded
	bool canLoadMore() {
		return hasMoreDataProduct.value && !isFetchingData.value;
	}
	
	// Load more data for each tab
	Future<void> loadMoreDataProduct() async {
		if (!canLoadMore() || keyword.value.isEmpty) return;  // Ensure keyword is not empty

		isFetchingData.value = true;
		try {
			var response = await apiService.productSearch(keyword.value, currentPageProduct.value);
			/*final response = {
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
			};*/
			//print("response: $response");
			//var newData = response?['data'] ?? [];
			var newData = response['data'];	
			//print("newData: $newData");			
			if (newData.isEmpty) {
				hasMoreDataProduct.value = false;
			} else {
				//print("newData-----: $newData");			
				productData.addAll(newData);
				
				/*productData.addAll(newData.map((item) {
					return RxMap<String, dynamic>.from({
					  'name': item['name'],
					  'image': item['image'],
					  //'selected': (item['selected'] ?? false).obs,  // Reactive selected field
					});
				}).toList());*/
	  
	  
				currentPageProduct.value++;
				
				print("productData=======: $productData");
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
		loadMoreDataProduct();
	}
}
