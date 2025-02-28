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
	
	// Added: Category and Artist Filters
	var categoryId = Rxn<int>();
	var artistId = Rxn<int>();
	
	var availableColors = <Map<String, dynamic>>[].obs; // Store color with id
	var availableSizes = <Map<String, dynamic>>[].obs; // Store size with id

	var selectedColors = <int>[].obs; // Store selected color IDs
	var selectedSizes = <int>[].obs;  // Store selected size IDs

	@override
	void onInit() {
		super.onInit();
		final arguments = Get.arguments as Map<String, dynamic>? ?? {};
		categoryId.value = arguments["categoryId"];
		artistId.value = arguments["artistId"];

		fetchAvailableColors(); //For fetch color
		fetchAvailableSizes(); //For fetch size
		
		// Auto-load products if navigated from category or artist
		if (categoryId.value != null || artistId.value != null) {
		  fetchSearchResults();
		}
	}
	
	// Fetch available colors from the new API
	Future<void> fetchAvailableColors() async {
		try {
		  // Call your new API that returns colors
		  var response = await apiService.fetchAvailableColors();
			if (response['status'] == 200 && response['data'] != null) {
			  availableColors.assignAll(
				response['data'].map<Map<String, dynamic>>((item) {
				  return {
					'id': item['id'],
					'color': item['color'] ?? 'Unknown Color', // Ensure color is not null
				  };
				}).toList(),
			  );
			}
		} catch (e) {
		  SnackbarHelper.showErrorSnackbar(
			title: Appcontent.snackbarTitleError, 
			message: Appcontent.snackbarCatchErrorMsg, 
			position: SnackPosition.BOTTOM, 
		  );
		}
	}
	
	// Fetch available sizes from the new API
	Future<void> fetchAvailableSizes() async {
		try {
		  // Call your new API that returns sizes
		  var response = await apiService.fetchAvailableSizes();
		  if (response['status'] == 200 && response['data'] != null) {
			availableSizes.assignAll(
			  response['data'].map<Map<String, dynamic>>((item) => {
				'id': item['id'],
				'size': item['size'] ?? 'Unknown Size',
			  }).toList(),
			);
		  }
		  
		} catch (e) {
		  SnackbarHelper.showErrorSnackbar(
			title: Appcontent.snackbarTitleError, 
			message: Appcontent.snackbarCatchErrorMsg, 
			position: SnackPosition.BOTTOM, 
		  );
		}
	}
	
	void resetFilters() {
		selectedColors.clear();
		selectedSizes.clear();
	}
	
	void toggleColorSelection(int colorId) {
		if (selectedColors.contains(colorId)) {
		  selectedColors.remove(colorId);
		} else {
		  selectedColors.add(colorId);
		}
	}

	void toggleSizeSelection(int sizeId) {
		if (selectedSizes.contains(sizeId)) {
		  selectedSizes.remove(sizeId);
		} else {
		  selectedSizes.add(sizeId);
		}
	}
	
	// Method to update the keyword
	void onSearchQueryChanged(String newQuery, {int? categoryId, int? artistId}) {
		keyword.value = newQuery;
		
		// Reset the page number
		currentPageProduct.value = 1;
		
		// Clear the previous search data
		productData.clear();
		
		// Enable loading more data
		hasMoreDataProduct.value = true;
		
		fetchSearchResults();
	}
	
	
	/*@override
	void onInit() {
		super.onInit();
		if (productData.isEmpty) loadMoreDataProduct();
	}*/
	
	// Helper function to determine if more data can be loaded
	bool canLoadMore() {
		return hasMoreDataProduct.value && !isFetchingData.value;
	}
	
	// Load more data for each tab
	Future<void> loadMoreDataProduct() async {
		//if (!canLoadMore() || keyword.value.isEmpty) return;  // Ensure keyword is not empty
		if (!canLoadMore()) return;  // Ensure keyword is not empty
		print('frrrrrrrrrrrffffffffffffffffffffffffff: $selectedColors');
		isFetchingData.value = true;
		try {
			Map<String, dynamic> filters = {
				'keyword': keyword.value,
				'page': currentPageProduct.value,
				'categoryId': categoryId.value,
				'artistId': artistId.value,
				'colors': selectedColors.isEmpty ? '' : selectedColors.join(','),
				'sizes': selectedSizes.isEmpty ? '' : selectedSizes.join(','),
			};
			//var response = await apiService.productSearch(keyword.value, currentPageProduct.value, categoryId: categoryId.value, artistId: artistId.value);
			var response = await apiService.productSearch(filters);
			//print("response: $response");
			var newData = response['data'];	
			//print('frrrrrrrrrrrffffffffffffffffffffffffffK: $selectedColors');
			//print("newData: $newData");			
			if (newData.isEmpty) {
				hasMoreDataProduct.value = false;
			} else {
				//print("newData-----: ${jsonEncode(newData)}");	
				productData.addAll(newData); 
	  
				currentPageProduct.value++;
				
				//print("productData=======: $productData");
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
	// Fetch products based on search, category, or artist
	void fetchSearchResults() {
		keyword.value = keyword.value.trim();
		currentPageProduct.value = 1;
		productData.clear();
		hasMoreDataProduct.value = true;
		loadMoreDataProduct();
	}
	// This method will be called when the user scrolls to the bottom
	void loadMoreData() {
		loadMoreDataProduct();
	}
}
