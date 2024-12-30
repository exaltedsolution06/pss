import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/models/tip_data.dart';

class PostController extends GetxController {
	final ApiService apiService;
	PostController(this.apiService);  // Constructor accepting ApiService
	
	var isLoading = true.obs;
	var isSubmittingData = false.obs;
	var subtotal = 0.0.obs; // Observable value for subtotal
	var taxes = 0.0.obs; // Observable value for taxes
	var total = 0.0.obs; // Observable value for total
	var selectPostIndex = <int>[].obs;

	Future<void> toggleLikePost({
	  required int index,
	  required int post_id,
	  required RxMap<String, dynamic> feedData,  // Use RxMap here
	}) async {
	  print("index: $index");
	  print("post_id: $post_id");

	  // Store the initial like count and like status
	  int initialLikeCount = feedData['likesCount'];
	  bool isLikedInitially = selectPostIndex.contains(index);

	  // Toggle the UI state
	  if (isLikedInitially) {
		selectPostIndex.remove(index);
		feedData['likesCount']--;  // Decrement like count in feedData if unliked
		feedData['own_like'] = false;
	  } else {
		selectPostIndex.add(index);
		feedData['likesCount']++;  // Increment like count in feedData if liked
		feedData['own_like'] = true;
	  }
	  print("own_like: ${feedData['own_like']}");
	  update(); // Update the UI immediately
	  
	  try {
		var response = await apiService.feeds_post_like(post_id);

		// Handle the API response
		if (response['status'] == 200) {
		  SnackbarHelper.showSuccessSnackbar(
			title: Appcontent.snackbarTitleSuccess,
			message: response['message'],
			position: SnackPosition.BOTTOM, // Custom position
		  );
		} else {
		  // API failure, revert the like count and UI state
		  revertLikeState(isLikedInitially, index, feedData);
		  SnackbarHelper.showErrorSnackbar(
			title: Appcontent.snackbarTitleError,
			message: response['message'],
			position: SnackPosition.BOTTOM, // Custom position
		  );
		}
	  } catch (e) {
		// Handle error, revert the like count and UI state
		print('Error toggling comment like/unlike: $e');
		revertLikeState(isLikedInitially, index, feedData);
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError,
		  message: Appcontent.snackbarCatchErrorMsg,
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }
	}

	// Helper function to revert UI state in case of error
	void revertLikeState(bool isLikedInitially, int index, Map<String, dynamic> feedData) {
	  if (isLikedInitially) {
		// If it was initially liked, revert to liked state
		selectPostIndex.add(index);
		feedData['likesCount']++;
		feedData['own_like'] = true;
	  } else {
		// If it was initially unliked, revert to unliked state
		selectPostIndex.remove(index);
		feedData['likesCount']--;
		feedData['own_like'] = false;
	  }
	  
	  update(); // Update the UI
	}
	
	// List of options for the dropdown
	var countryList = <Country>[].obs;
	// Reactive Country variable
	var selectedCountry = ''.obs;
	// Method to update the selected country
	void updateCountry(int countryId) {
		//print('Updating country to: $countryId');
		final selectedCountryItem = countryList.firstWhere((g) => g.id == countryId, orElse: () => Country(id: -1, name: 'Unknown'));
		selectedCountry.value = selectedCountryItem.id.toString();
	}
	var isChecked = false.obs;
	var checkboxError = ''.obs; // Add this line for checkbox error tracking
	void toggleCCValue() {
		isChecked.value = !isChecked.value;
		checkboxError.value = isChecked.value ? '' : 'Please select your payment method.'; // Set error message
	}
	
	var isCheckedSubcription = false.obs;
	var checkboxSubcriptionError = ''.obs; // Add this line for checkbox error tracking
	void toggleSubcriptionValue() {
		isCheckedSubcription.value = !isCheckedSubcription.value;
		checkboxSubcriptionError.value = isCheckedSubcription.value ? '' : 'Please select your payment method.'; // Set error message
	}
  
	// Initialize with an empty TipData instance
	var tipData = Rx<TipData>(TipData(
		available_credit: 0,
		first_name: '',
		last_name: '',
		country_id: 0,
		city: '',
		state: '',
		postcode: '',
		address: '',
	));
	
	Future<void> fetchTipsData() async {
		try {
			isLoading(true);
			subtotal = 0.0.obs; // Observable value for subtotal
			taxes = 0.0.obs; // Observable value for taxes
			total = 0.0.obs; // Observable value for total
			
			// Simulate API call
			var responseData = await apiService.billing_address();
			final response = responseData['data'];

			// Check if response['user'] is not null
			if (response['user'] != null) {
				// Print the response to see the structure
				print("response: ${response['user']}");
			  
				// Check if the response is a Map (not a List)
				if (response['user'] is Map<String, dynamic>) {
					// Parse the Map into TipData
					tipData.value = TipData.fromJson(response['user']);
				} else {
					// Handle case where response['user'] is not the expected format
					print("Error: Response is not a valid Map.");
					tipData.value = TipData(first_name: ''); // Default or empty data
				}
			} else {
				print("Error: Response data is null.");
				tipData.value = TipData(first_name: ''); // Handle null case
			}
			// Print the final TipData object to check if parsing was successful
			print('Tip Data: ${tipData.value}');

			final List<Country> fetchedCountryList = (response['countries'] as List).map((data) => Country.fromJson(data)).toList();
			countryList.assignAll(fetchedCountryList); // Update the observable list

		} catch (e) {
			// Handle error
			print("Error fetching tips: $e");
			SnackbarHelper.showErrorSnackbar(
				title: Appcontent.snackbarTitleError,
				message: Appcontent.snackbarCatchErrorMsg,
				position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isLoading(false);
		}
	}
	//submit send a tip data
	Future<bool> sendAtipSubmit(
		int post_id,
		int amount,
		String first_name,
		String? last_name,
		String? state,
		String? city,
		String? postcode,
		int? country,
		String? billing_address,
		RxMap<String, dynamic> feedData,  // Use RxMap here
	) async {
		isLoading.value = false;
		print('post_id: $post_id');
		print('amount: $amount');
		print('first_name: $first_name');
		print('last_name: $last_name');
		print('state: $state');
		print('city: $city');
		print('postcode: $postcode');
		print('country: $country');
		print('billing_address: $billing_address');
		try {
			isSubmittingData(true);
			final response = await apiService.tips_submit(
				post_id, 
				amount ?? 0, 
				first_name ?? '', 
				last_name ?? '',
				city ?? '', 	
				state ?? '',				
				postcode ?? '', 
				country ?? 0, 
				billing_address ?? ''
			);
			//print('Status: $response');
			  
			// Store the initial like count and like status
			if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
				// Increment the tips count on success
				feedData['tipsCount']++;  // Increment tips count
				// Let the Snackbar display before returning
				await Future.delayed(Duration(milliseconds: 500)); 
				return true; // Return true on success
			} else {
			  SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError,
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
				// Let the Snackbar display before returning
				await Future.delayed(Duration(milliseconds: 500)); 
				return false; // Return false on error
			}
		} catch (e) {
			// Handle error
			print("Error submitting tips: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
			// Let the Snackbar display before returning
			await Future.delayed(Duration(milliseconds: 500)); 
			return false; // Return false on error
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
		update(); // Update the UI immediately
	}
	//submit subscribe data
	Future<bool> subscriptionSubmit(
		int amount,
		String first_name,
		String? last_name,
		String? state,
		String? city,
		String? postcode,
		int? country,
		String? billing_address,
		RxMap<String, dynamic> feedData,  // Use RxMap here
	) async {
		isLoading.value = false;
		print('amount: $amount');
		print('first_name: $first_name');
		print('last_name: $last_name');
		print('state: $state');
		print('city: $city');
		print('postcode: $postcode');
		print('country: $country');
		print('billing_address: $billing_address');
		try {
			isSubmittingData(true);
			/*final response = await apiService.subscription_submit(
				post_id, 
				amount ?? 0, 
				first_name ?? '', 
				last_name ?? '',
				city ?? '', 	
				state ?? '',				
				postcode ?? '', 
				country ?? 0, 
				billing_address ?? ''
			);*/
			//print('Status: $response');
			  
			// Store the initial like count and like status
			/*if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
					message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
				// Let the Snackbar display before returning
				await Future.delayed(Duration(milliseconds: 500)); 
				return true; // Return true on success
			} else {
			  SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError,
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
				// Let the Snackbar display before returning
				await Future.delayed(Duration(milliseconds: 500)); 
				return false; // Return false on error
			}*/
			return true;
		} catch (e) {
			// Handle error
			print("Error submitting tips: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
			// Let the Snackbar display before returning
			await Future.delayed(Duration(milliseconds: 500)); 
			return false; // Return false on error
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
		update(); // Update the UI immediately
	}

}




