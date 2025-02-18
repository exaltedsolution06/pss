import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/profile_data.dart';

class ProfileScreenController extends GetxController {
	final ApiService apiService;
	var profileData = Rx<ProfileData>(ProfileData(
		first_name: '',
		last_name: '',
		email: '',
		avatar: '',
		default_avatar: 0,
		company_name: '',
		birthdate: '',
		address: '',
		city: '',
		state: '',
		gender_id: 0,
		zipcode: '',
		phone: '',
	));
	RxInt socialUserTotalPosts = 0.obs;
	RxInt socialUserTotalFollowers = 0.obs;
	RxInt socialUserTotalFollowing = 0.obs;
	
	ProfileScreenController(this.apiService);  // Constructor accepting ApiService
	var feedData = <dynamic>[].obs;
	// Reset the page number
	var currentPage = 1.obs;
	
	// Observable to track loading state
	var isFetchingFeedData = false.obs;
	var isLoadingFeedData = true.obs;
	// Enable loading more data
	var hasMoreFeedData = true.obs;

	int currentindex = 0;
	RxInt selected = 0.obs;
	final count = 0.obs;

	// Observable to track loading state
	var isFetchingData = false.obs;
	var isLoading = false.obs;
	
	var myOrderCount = 0.obs;
	var myWishlistCount = 0.obs;
	var myOrderImages = <String>[].obs;
	var myWishlistImages = <String>[].obs;
	
	@override
	void onInit() {
	  super.onInit();
	  fetchProfileData();
	}
  
	@override
	void onReady() {
		super.onReady();
		//fetchProfile();
		print("Profile fetch Profile screen");
		//loadInitialDataForFeed(); // Load initial feed data
	}
	void loadInitialDataForFeed() {
		if (feedData.isEmpty) loadMoreFeedData();
	}
	// Helper function to determine if more data can be loaded
	bool canLoadMoreFeed() {
		return hasMoreFeedData.value && !isFetchingFeedData.value;
	}
	Future<void> fetchProfileData() async {
		isLoading.value = true;
		try {
		  var response = await apiService.viewProfileOrderWishlistData();  // Replace with your API call
		  if (response['status'] == 200) {
			  var data = response['data'];
			  
			  // Update orders
			  myOrderCount.value = data['my_order']['count'];
			  // Adjusting the mapping logic to correctly extract the URLs
			  myOrderImages.value = List<String>.from(data['my_order']['image_url'].map((e) => e[0].toString()));

			  // Update wishlist
			  myWishlistCount.value = data['my_wishlist']['count'];
			  // Adjusting the mapping logic to correctly extract the URLs
			  myWishlistImages.value = List<String>.from(data['my_wishlist']['image_urls'].map((e) => e[0].toString()));
			}
		} catch (e) {
		  print("Error fetching profile data: $e");
		} finally {
		  isLoading.value = false;
		}
	}
	Future<void> editProfile() async {
		isLoading.value = true;
		try {
			await Future.delayed(const Duration(seconds: 1)); // Adjust the duration as needed
			Get.toNamed(Routes.EDITPROFILE_SCREEN);
		} catch (e) {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isLoading.value = false;
		}
	}
	// Load more feed data
	Future<void> loadMoreFeedData() async {
		if (!canLoadMoreFeed()) return;
		isFetchingFeedData.value = true;
		try {
			var response = await apiService.feed_user(1);
			var newFeedData = response['data']['posts'];		  
			if (newFeedData.isEmpty) {
				hasMoreFeedData.value = false;
			} else {
				feedData.addAll(newFeedData);
				currentPage.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreFeedData - profile screen controller: $e');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isFetchingFeedData.value = false;
		}
	}

  void increment() => count.value++;

  void changecatwise({int? index}) {
    currentindex = index ?? 0;
    update();
  }

  // Fetch user profile data
  Future<void> fetchProfile() async {
  print("Profile fetch Loaddddddd");
    isLoading.value = true; // Start loading
    try {
		isFetchingData(true);
		//final apiService = Get.find<ApiService>();
		final responseData = await apiService.fetchProfileDataForViewProfilePage(1, 1, 1);
		final response = responseData['data'];
		print("response: $response");
		// Ensure response['user'] is not null and is of the expected type
		if (response['user'] != null && response['user'] is Map) {
			profileData.value = ProfileData.fromJson(response['user']);
			//profileData.value = ProfileData.fromJson(response['user'] as Map<String, dynamic>);
		} else {
			profileData.value = ProfileData(first_name: ''); // Default value if data is not valid
		}
		// social count fetch
		//print('API Response Social User1: ${response['social_user']['total_post']}');
		socialUserTotalPosts.value = response['social_user']['total_post'] ?? 0;
		socialUserTotalFollowers.value = response['social_user']['total_followers'] ?? 0;
		socialUserTotalFollowing.value = response['social_user']['total_following'] ?? 0;
		
      
      //print('API Response: $response');  // Print the full API response
      //print('Profile Data: ${profileData.value}');  // Print the parsed profile data
    } catch (e) {
		print('Error fetching All fetchProfile - profile screen controller: $e');
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
	//delete a post
	Future<void> deletePost(int postId) async {
		try {
			print("postId: $postId");
			// Call your API to delete the post
			var response = await apiService.post_delete(postId);
			if (response['status'] == 200) {	
				// Remove the post from feedData
				feedData.removeWhere((post) => post['post_id'] == postId);
				feedData.refresh(); // Manually trigger an update
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
			Get.snackbar("Error", "An error occurred: $e");
			SnackbarHelper.showErrorSnackbar(
				title: Appcontent.snackbarTitleError, 
				message: Appcontent.snackbarCatchErrorMsg, 
				position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}
}
