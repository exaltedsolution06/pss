import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/view_proflie_screen/models/profile_data.dart';

class ViewProflieScreenController extends GetxController {
	final ApiService apiService;
	final String userId;  // Add a field to store userId
	var profileData = Rx<ProfileData>(ProfileData(
		id: 0,
		name: '',
		username: '',
		avatar: '',
		default_avatar: 0,
		cover: '',
		default_cover: 0,
		user_verify: 0,
		is_follow: 0,
		is_paid_profile: 0,
		has_active_sub: 0,
		monthly_subscription_text: '',
		monthly_subscription_price: 0,
		monthly_subscription_duration: '',
	));
	RxInt socialUserTotalPosts = 0.obs;
	RxInt socialUserTotalFollowers = 0.obs;
	RxInt socialUserTotalFollowing = 0.obs;
	var subscription_bundle_single = <String, dynamic>{}.obs;
	var subscription_bundle = <String, dynamic>{}.obs;


	String toCamelCase(String text) {
	  return text.split(' ')
		  .map((word) => word.isNotEmpty
			  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
			  : '')
		  .join(' ');
	}			
	
	ViewProflieScreenController(this.apiService, this.userId);  // Constructor accepting ApiService
	var feedData = <dynamic>[].obs;
	// Reset the page number
	var currentPage = 1.obs;
	
	// Observable to track loading state
	var isFetchingData = false.obs;
	var isFetchingFeedData = false.obs;
	var isLoading = true.obs;
	// Enable loading more data
	var hasMoreFeedData = true.obs;
	
	var isFollowing = false.obs;
	
	@override
	void onReady() {
		super.onReady();
		try {
			int parsedUserId = int.parse(userId); // Parse userId to int
			fetchUserProfile(parsedUserId); // Fetch user profile
			loadInitialDataForFeed(parsedUserId); // Load initial feed data
			print("Profile fetch Profile screen: $parsedUserId");
			isFollowing.value = profileData.value.is_follow == 1;
		} catch (e) {
			print("Invalid userId format: $userId. Error: $e");
			// Handle error appropriately
		}
	}

	
	void loadInitialDataForFeed(userId) {
		if (feedData.isEmpty) loadMoreFeedData(userId);
	}
	// Helper function to determine if more data can be loaded
	bool canLoadMoreFeed() {
		return hasMoreFeedData.value && !isFetchingFeedData.value;
	}
	// Load more feed data
	Future<void> loadMoreFeedData(int userId) async {
		if (!canLoadMoreFeed()) return;
		isFetchingFeedData.value = true;
		try {
			print("Fetching user ID for posts: $userId");
			var response = await apiService.feeds_individual(userId, 1);
			var newFeedData = response['data']['posts'];		  
			if (newFeedData.isEmpty) {
				hasMoreFeedData.value = false;
			} else {
				feedData.addAll(newFeedData);
				currentPage.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreFeedData - view profile screen controller: $e');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isFetchingFeedData.value = false;
		}
	}
	
	// Fetch user profile data
	 Future<void> fetchUserProfile(int userId) async {
		print("Fetching user profile for ID: $userId");
		
		isLoading.value = true; // Start loading
		try {
			isFetchingData(true);
			final responseData = await apiService.feeds_individual(userId, 1);
			final response = responseData['data'];
			// Ensure response['user'] is not null and is of the expected type
			if (response['user'] != null && response['user'] is Map) {
				profileData.value = ProfileData.fromJson(response['user']);
			} else {
				profileData.value = ProfileData(name: ''); // Default value if data is not valid
			}
			if(response['user']['is_follow']==1) {
				isFollowing.value = true;
			}
			// social count fetch
			print('API Response Social User1: ${response['social_user']['total_post']}');
			socialUserTotalPosts.value = response['social_user']['total_post'] ?? 0;
			socialUserTotalFollowers.value = response['social_user']['total_followers'] ?? 0;
			socialUserTotalFollowing.value = response['social_user']['total_following'] ?? 0;
			
			// Ensure the list has at least one element
			if (subscription_bundle_single.isEmpty && response['user']['is_paid_profile'] == 1 && response['user']['has_active_sub'] == 0) {
				subscription_bundle_single.assignAll({
					'title': response['user']['monthly_subscription_duration'] + ' Subscription',
					'name': response['user']['name'],
					'username': response['user']['username'],
					'avatar': response['user']['avatar'],
					'created_at': response['user']['created_at'],
					'subscription_text': response['user']['monthly_subscription_text'],
					'subscription_price': response['user']['monthly_subscription_price'],
					'subscription_duration': response['user']['monthly_subscription_duration']
				});
			}

			//if (response['subscription_bundle'] != null) {
			if (response['subscription_bundle'].isNotEmpty) {
			  // Populate subscription_bundle with data from response
			  // Assuming subscription_bundle is a Map<String, dynamic> and response['subscription_bundle'] is also a Map
			  subscription_bundle.assignAll(Map<String, dynamic>.from(response['subscription_bundle']));

			  // Add common user data to each subscription entry
			  response['subscription_bundle'].forEach((key, value) {
				// Ensure value is a Map<String, dynamic>
				if (value is Map<String, dynamic>) {
					value['name'] = response['user']['name']; // Add name for each subscription entry
					value['title'] = '${response['user']['monthly_subscription_duration']} Subscription';
					value['username'] = response['user']['username'];
					value['avatar'] = response['user']['avatar'];
					value['created_at'] = response['user']['created_at'];
				}
			  });			  
			}
		  print('API Response: $subscription_bundle');  // Print the full API response
		  //print('Profile Data: ${profileData.value}');  // Print the parsed profile data
		} catch (e, stacktrace) {
			print('Error: $e');
			print('Stack Trace: $stacktrace');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isFetchingData(false);
			isLoading.value = false; // Stop loading
		}
	}
	
	Future<void> toggleFollowStatus(int profileId, int isFollow) async {
		print("profileId: $profileId");
		print("isFollow: $isFollow");
		try {
			final response = await apiService.follow_creator(profileId, isFollow);
			print("Response: $response");
			// Handle response (e.g., update the `is_follow` status in your state)
			if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
					title: Appcontent.snackbarTitleSuccess, 
					message: response['message'],
					position: SnackPosition.BOTTOM, // Custom position
				);
				isFollowing.value = !isFollowing.value; // Toggle the status
			} else {
				SnackbarHelper.showErrorSnackbar(
					title: Appcontent.snackbarTitleError,
					message: response['message'],
					position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e, stacktrace) {
			print('Error: $e');
			print('Stack Trace: $stacktrace');
			SnackbarHelper.showErrorSnackbar(
				title: Appcontent.snackbarTitleError, 
				message: Appcontent.snackbarCatchErrorMsg, 
				position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}

	
	//TODO: Implement ViewProflieScreenController
	var selectIndex = [];
	var selectIndex1 = [];

	int currentindex = 0;
	RxInt selected = 0.obs;
	final count = 0.obs;

	void increment() => count.value++;

	changecatwise({int? index}) {
		currentindex = index ?? 0;
		update();
	}
	
	changeValue({int ? value}) {
    if(selectIndex.contains(value)) {
      selectIndex.remove(value);
    }
    else {
      selectIndex.add(value);
    }
    update();
  }

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
  var emojiShowing = false.obs;
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
  }
  
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

  void toggleCCValue() {
    isChecked.value = !isChecked.value;
  }
  
  //add card

	
void toggleCheckbox(bool value) {
    isChecked.value = value;
  }
}
