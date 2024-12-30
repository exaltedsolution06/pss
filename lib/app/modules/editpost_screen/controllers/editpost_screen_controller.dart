import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/bottom_navigation.dart';
import 'package:picturesourcesomerset/app/modules/editpost_screen/models/post_data.dart';

class EditpostScreenController extends GetxController {
  //TODO: Implement EditpostScreenController
	final ApiService apiService;
	final String postId;  // Add a field to store postId
	var postData = Rx<PostData>(PostData(
		fetchedFiles: [],
		price: 0,
		text: ''
	));
	
	EditpostScreenController(this.apiService, this.postId);  // Constructor accepting ApiService
	
	
	// Observable to track loading state
	RxBool isLoading = false.obs; // For loading state
	var isFetchingData = false.obs;
	
	@override
	void onReady() {
	  super.onReady();
	  try {
		int parsedPostId = int.parse(postId); // Parse postId to int
		fetchPostData(parsedPostId); // Fetch user profile
		//print("Post fetch post screen: $parsedPostId");
	  } catch (e) {
		print("Invalid postId format: $postId. Error: $e");
		// Handle error appropriately
	  }
	}
	// Fetch user post data
	Future<void> fetchPostData(int postId) async {
	  isLoading.value = true; // Start loading
	  try {
		//print("Post fetch post screen1: $postId");
		isFetchingData(true); // Set fetching flag to true

		// Fetch the post data from API
		final response = await apiService.fetchPostDataForEditPostPage(postId);
		print('API Response: $response');  // Debugging the full API response

		// Ensure response is not null and contains the 'data' key
		if (response != null && response['data'] != null && response['data'] is Map) {
		  // Parse the response data to PostData model
		  postData.value = PostData.fromJson(response);
		} else {
		  // Handle unexpected response structure
		  postData.value = PostData(text: ''); // Default value if data is invalid
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


	// Function to submit the form
	Future<void> submitPost({
	  required int postId,
	  required String message,
	  String? price, // Assuming price is optional and a string
	  List<File>? selectedFiles,
	}) async {
	  // Start loading
	  isLoading.value = true;
		//print("postId: $postId");
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
		final response = await apiService.post_edit(
		  postId, 
		  message, 
		  priceValue ?? 0, // Send 0 if price is null or invalid
		);
		
		//print("Response: $response");
		// Assuming post_id can be of type int, convert it to String
		//String postId = response['post_id'].toString();  // Ensure it's a String
		//if (postId.isEmpty) {
			//throw Exception("Post ID not returned in response");
		//}
		
		//print("selectedFiles: $selectedFiles");

		// If there are images, upload them
		if (selectedFiles != null && selectedFiles.isNotEmpty) {
		  for (File imageFile in selectedFiles) {
			// apiService.post_create_file is assumed to return a Map<String, dynamic>
			//print("post-id: ${response['post_id']}");
			//print("imageFile: $imageFile");
			final imageResponse = await apiService.post_create_file(imageFile, post_id: postId.toString());
			
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
	
	Future<void> removeFileFromServer(String file_id) async {
	  try {
		int post_id = int.parse(postId); // Parse postId to int
		print("Remove file - Post ID: $post_id");
		
		final response = await apiService.post_delete_files(post_id, file_id);

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
		print(e);
		SnackbarHelper.showErrorSnackbar(
			title: Appcontent.snackbarTitleError,
			message: Appcontent.snackbarCatchErrorMsg,
			position: SnackPosition.BOTTOM, // Custom position
		);
	  }
	}

	
}
