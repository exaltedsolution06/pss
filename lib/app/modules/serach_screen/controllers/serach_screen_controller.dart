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

	@override
	void onInit() {
		super.onInit();
		final arguments = Get.arguments as Map<String, dynamic>? ?? {};
		categoryId.value = arguments["categoryId"];
		artistId.value = arguments["artistId"];

		// Auto-load products if navigated from category or artist
		if (categoryId.value != null || artistId.value != null) {
		  fetchSearchResults();
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

		isFetchingData.value = true;
		try {
			var response = await apiService.productSearch(keyword.value, currentPageProduct.value, categoryId: categoryId.value, artistId: artistId.value);
			//print("response: $response");
			var newData = response['data'];	
			//print("newData: $newData");			
			if (newData.isEmpty) {
				hasMoreDataProduct.value = false;
			} else {
				//print("newData-----: $newData");			
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
