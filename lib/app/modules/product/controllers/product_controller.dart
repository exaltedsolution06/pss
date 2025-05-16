import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/product/models/product_data.dart';

class ProductController extends GetxController {
	//TODO: Implement ProductController
	final ApiService apiService;
	final String productId;  // Add a field to store postId
	
	var productData = Rx<ProductData>(ProductData(
		fetchedFiles: [],
		product_id: 0,
		category_name: '',
		artist_name: '',
		size_name: '',
		orientation: '',
		adjust_size: '',
		size_height: 0,
		size_width: 0,
		color_name: '',
		name: '',
		product_code: '',
		price: '',
		moulding_description: '',
		total_rating: '',
		total_reviews: '',
		average_rating: '',
		percentage_rating_one: 0.0,
		percentage_rating_two: 0.0,
		percentage_rating_three: 0.0,
		percentage_rating_four: 0.0,
		percentage_rating_five: 0.0,
		my_rating: 0,
		my_review: '',
	));
	ProductController(this.apiService, this.productId);  // Constructor accepting ApiService
	
	// Observable to track loading state
	RxBool isLoading = false.obs; // For loading state
	RxBool isFetchingData = false.obs;
	var selectedStars = 0.obs;

	/*@override
	void onInit() {
		super.onInit();
		int parsedProductId = int.parse(productId); // Parse productId to int
		
		print("Product fetch product view screen: $parsedProductId");
		
		fetchProductData(parsedProductId); // Fetch user profile
	}*/
	/*@override
	void onReady() {
	  super.onReady();
	  try {
		int parsedProductId = int.parse(productId); // Parse productId to int
		fetchProductData(parsedProductId); // Fetch user profile
		print("Product fetch product view screen ONREADY--222--: $parsedProductId");
	  } catch (e) {
		print("Invalid productId format: $productId. Error: $e");
		// Handle error appropriately
	  }
	}*/
	// Fetch user post data
	Future<void> fetchProductData(int productId) async {
	  if (isFetchingData.value) return; // Prevent multiple calls at the same time
	  
	  isLoading.value = true; // Start loading
	  isFetchingData(true); // Set fetching flag to true
	  print("Product ID: $productId");
	  try {
		print("Post fetch post screen1: $productId");

		// Fetch the post data from API
		final response = await apiService.productDetails(productId);
		print('API Response: $response');  // Debugging the full API response

		// Ensure response is not null and contains the 'data' key
		if (response != null && response['data'] != null && response['data'] is Map) {
		  // Parse the response data to ProductData model
		  productData.value = ProductData.fromJson(response);
		  
		  selectedStars.value = productData.value!.my_rating;
		} else {
		  // Handle unexpected response structure
		  productData.value = ProductData(category_name: ''); // Default value if data is invalid
		  
		  SnackbarHelper.showErrorSnackbar(
			title: Appcontent.snackbarTitleError,
			message: "Invalid response structure",
			position: SnackPosition.BOTTOM,
		  );
		}
	  } catch (e) {
		// Handle the error by showing a custom error snackbar
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError,
		  message: Appcontent.snackbarCatchErrorMsg, // Generic error message
		  position: SnackPosition.BOTTOM, // Show the snackbar at the bottom
		);
		print('Error fetching post data: $e'); // Log the error for debugging
	  } finally {
		// Reset fetching and loading states
		isFetchingData(false);
		isLoading.value = false; // Stop loading
	  }
	}
	//sumit a review
	Future<void> giveReview(String comment) async {
		isLoading.value = true;
		try {
			final response = await apiService.giveReview(productId, 0, comment);
			if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
					title: Appcontent.snackbarTitleSuccess, 
					message: response['message'],
					position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			// Handle the error by showing a custom error snackbar
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError,
			  message: Appcontent.snackbarCatchErrorMsg, // Generic error message
			  position: SnackPosition.BOTTOM, // Show the snackbar at the bottom
			);
			print('Error fetching post data: $e'); // Log the error for debugging
		} finally {
			// Reset loading states
			isLoading.value = false; // Stop loading
		}
	}
	//sumit a review
	Future<void> submitRating(int rating) async {
		//isLoading.value = true;
		try {
			final response = await apiService.giveReview(productId, rating, '');
			if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
					title: Appcontent.snackbarTitleSuccess, 
					message: response['message'],
					position: SnackPosition.BOTTOM, // Custom position
				);
				selectedStars.value = rating;
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			// Handle the error by showing a custom error snackbar
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError,
			  message: Appcontent.snackbarCatchErrorMsg, // Generic error message
			  position: SnackPosition.BOTTOM, // Show the snackbar at the bottom
			);
			print('Error fetching post data: $e'); // Log the error for debugging
		} finally {
			// Reset loading states
			//isLoading.value = false; // Stop loading
		}
	}
  
}
