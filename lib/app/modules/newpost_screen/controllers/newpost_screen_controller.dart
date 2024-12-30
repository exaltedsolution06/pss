import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/bottom_navigation.dart';

class NewpostScreenController extends GetxController {
  //TODO: Implement NewpostScreenController
	final ApiService apiService;
	NewpostScreenController(this.apiService);  // Constructor accepting ApiService
	
	// Observable to track loading state
	RxBool isLoading = false.obs; // For loading state
	// Function to submit the form
	Future<void> submitPost({
	  required String message,
	  String? price, // Assuming price is optional and a string
	  List<File>? selectedFiles,
	}) async {
	  // Start loading
	  isLoading.value = true;
		//print("message: $message");
		//print("price: $price");
		//print("selectedFiles: $selectedFiles");
	  try {
		
		// Convert price to an integer if necessary
		int? priceValue;
		if (price != null && price.isNotEmpty) {
		  priceValue = int.tryParse(price); // Attempt to parse the price to an int
		  if (priceValue == null) {
			throw Exception("Invalid price format");
		  }
		}

		// Submit the post data to the API
		final response = await apiService.post_create(
		  message, 
		  priceValue ?? 0, // Send 0 if price is null or invalid
		);
		
		//print("Response: $response");
		// Extract post_id from the response
		// Extract post_id from the response
		// Assuming post_id can be of type int, convert it to String
		String postId = response['post_id'].toString();  // Ensure it's a String
		if (postId.isEmpty) {
			throw Exception("Post ID not returned in response");
		}
		
		//print("selectedFiles: $selectedFiles");

		// If there are images, upload them
		if (selectedFiles != null && selectedFiles.isNotEmpty) {
		  for (File imageFile in selectedFiles) {
			// apiService.post_create_file is assumed to return a Map<String, dynamic>
			//print("post-id: ${response['post_id']}");
			//print("imageFile: $imageFile");
			final imageResponse = await apiService.post_create_file(imageFile, post_id: postId);
			
			//print("imageResponse: $imageResponse");
		  }
		}

		// Check if the response is successful
		if (response['status'] == 200) {
		  // Show success message
		  SnackbarHelper.showSuccessSnackbar(
			title: Appcontent.snackbarTitleSuccess,
			message: response['message'],
			position: SnackPosition.BOTTOM, // Custom position
		  );
		  // Optionally navigate to another page after success
		  Get.offAll(Bottom());
		} else {
		  SnackbarHelper.showErrorSnackbar(
			title: Appcontent.snackbarTitleError,
			message: response['message'],
			position: SnackPosition.BOTTOM, // Custom position
		  );
		}
	  } catch (e) {
	  print(e);
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError,
		  message: Appcontent.snackbarCatchErrorMsg,
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  } finally {
		// Stop loading
		isLoading.value = false;
	  }
	}



	
	/*int currentindex = 0;
	RxInt selected = 0.obs;
	final count = 0.obs;

	void increment() => count.value++;

	changecatwise({int? index}) {
	currentindex = index ?? 0;
	update();
	}*/
	
  //final count = 0.obs;

  //void increment() => count.value++;
}
