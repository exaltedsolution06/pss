import 'dart:io';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/proflie_screen/models/profile_data.dart';

class EditprofileScreenController extends GetxController {
  //TODO: Implement EditprofileScreenController
	var isFetchingData = false.obs;
	var isSubmittingData = false.obs;
	
	var profileImageFile = Rx<File?>(null);
	var isUploadedProfileImageFile = false.obs;
	
	var backgroundImageFile = Rx<File?>(null);
	var isUploadedBackgroundImageFile = false.obs;
  
	final ApiService apiService;
	var profileData = Rx<ProfileData>(ProfileData(
		name: '',
		username: '',
		avatar: '',
		default_avatar: 0,
		cover: '',
		default_cover: 0,
		bio: '',
		birthdate: '',
		gender_pronoun: '',
		location: '',
		website: '',
		country_id: 0,
		gender_id: 0,
		user_verify: 0,
	));
  
	EditprofileScreenController(this.apiService);  // Constructor accepting ApiService
	
	// Observable to track loading state
	var isLoading = true.obs;
	
	// Declare observable lists
	var genderList = <Gender>[].obs;
	var countryList = <Country>[].obs;
	
	var selectedCountry = ''.obs;
	var selectedGender = ''.obs;

	@override
	void onReady() {
		super.onReady();
		fetchProfile();
		print("Profile fetch EDIT Profile screen");
	}
	
	// Fetch user profile data
	Future<void> fetchProfile() async {

		isLoading.value = true; // Start loading
		try {
			isFetchingData(true);
			//final apiService = Get.find<ApiService>();
			final responseData = await apiService.fetchProfileDataForEditProfilePage(1, 1, 1, 1);
			final response = responseData['data'];
			// Ensure response['user'] is not null and is of the expected type
			if (response['user'] != null && response['user'] is Map) {
				profileData.value = ProfileData.fromJson(response['user']);
			//profileData.value = ProfileData.fromJson(response['user'] as Map<String, dynamic>);
			} else {
				profileData.value = ProfileData(name: ''); // Default value if data is not valid
			}
		  
			final List<Gender> fetchedGenderList = (response['genders'] as List).map((data) => Gender.fromJson(data)).toList();
			genderList.assignAll(fetchedGenderList); // Update the observable list
			
			// Ensure selectedGender is set based on the profile data
			selectedGender.value = profileData.value.gender_id.toString();

			final List<Country> fetchedCountryList = (response['countries'] as List).map((data) => Country.fromJson(data)).toList();
			countryList.assignAll(fetchedCountryList); // Update the observable list
			// Ensure selectedCountry is set based on the profile data
			selectedCountry.value = profileData.value.country_id.toString();

			//print('Gender List2: ${genderList.map((g) => g.name).toList()}');
			//print('Country List: ${countryList.map((c) => c.name).toList()}');
			//print('API Response: $response');  // Print the full API response
			// print('Profile Data: ${profileData.value}');  // Print the parsed profile data
		} catch (e) {
			//print('Error: $e');  // Print the error if any occurs
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
	
	//submit profile data
	Future<void> profileSubmit(
	  String username, 
	  String name, 
	  String? bio, 
	  String? birthdate, 
	  int? gender_id, 
	  String? gender_pronoun, 
	  int? country_id, 
	  String? location, 
	  String? website
	) async {
		isLoading.value = true;
		/*print('username: $username');
		print('name: $name');
		print('bio: $bio');
		print('birthdate: $birthdate');
		print('gender_id: $gender_id');
		print('gender_pronoun: $gender_pronoun');
		print('country_id: $country_id');
		print('location: $location');
		print('website: $website');*/
		try {
			isSubmittingData(true);
			final response = await apiService.profile_submit(
			  username, 
			  name, 
			  bio ?? '', 
			  birthdate ?? '', 
			  gender_id ?? 0, 
			  gender_pronoun ?? '', 
			  country_id ?? 0, 
			  location ?? '', 
			  website ?? ''
			);
			//print('Status: $response');

			if (response['status'] == '200') {
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
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
	}	

	Future<void> uploadCoverImage(File image) async {
	//print("Cover image selected Controller: $image");
	  try {
		// Call your API service to upload the image
		
		var response = await apiService.profile_cover_image_upload(image);

		if (response['status']=='200') {
			isUploadedBackgroundImageFile.value = true;
			backgroundImageFile.value = image;
		  // Handle successful upload
			SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} else {
		  // Handle upload error
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError,
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	  } catch (e) {
		//print('Error: $e');
		// Handle exception
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: Appcontent.snackbarCatchErrorMsg, 
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }
	}
	
	Future<void> uploadAvatarImage(File image) async {
	//print("Cover image selected Controller: $image");
	  try {
		// Call your API service to upload the image
		
		var response = await apiService.profile_avatar_image_upload(image);

		if (response['status']=='200') {
			isUploadedProfileImageFile.value = true;
			profileImageFile.value = image;
		  // Handle successful upload
			SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		  
		} else {
		  // Handle upload error
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError,
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	  } catch (e) {
		//print('Error: $e');
		// Handle exception
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: Appcontent.snackbarCatchErrorMsg, 
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }
	}
	
	//Remove Avatar Image
	Future<void> removeAvatar() async {
		try {
			final response = await apiService.profile_avatar_image_delete();
			//print('Status: $response');

			if (response['status'] == '200') {
				// Reset the reactive variables
				profileImageFile.value = null;
				isUploadedProfileImageFile.value = false;
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			  
			  final responseData = await apiService.fetchProfileDataForEditProfilePage(1, 1, 1, 1);
				final responseF = responseData['data'];
				// Ensure responseF['user'] is not null and is of the expected type
				if (responseF['user'] != null && responseF['user'] is Map) {
					profileData.value = ProfileData.fromJson(responseF['user']);
				//profileData.value = ProfileData.fromJson(responseF['user'] as Map<String, dynamic>);
				} else {
					profileData.value = ProfileData(name: ''); // Default value if data is not valid
				}
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError,
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}
	
	//Remove Cover Image
	Future<void> removeCover() async {
		try {
			final response = await apiService.profile_cover_image_delete();
			//print('Status: $response');

			if (response['status'] == '200') {
			isUploadedBackgroundImageFile.value = false;
			backgroundImageFile.value = null;
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			  
				final responseData = await apiService.fetchProfileDataForEditProfilePage(1, 1, 1, 1);
				final responseF = responseData['data'];
				// Ensure responseF['user'] is not null and is of the expected type
				if (responseF['user'] != null && responseF['user'] is Map) {
					profileData.value = ProfileData.fromJson(responseF['user']);
				//profileData.value = ProfileData.fromJson(responseF['user'] as Map<String, dynamic>);
				} else {
					profileData.value = ProfileData(name: ''); // Default value if data is not valid
				}
			
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}






	final count = 0.obs;
	void increment() => count.value++;
  
	
	//var selectedCountry = Rxn<String>();
	//var selectedGender = Rxn<String>();

	
	// Update methods for gender and country
  void updateGender(int genderId) {
	//print('Updating gender to: $genderId');
    final selectedGenderItem = genderList.firstWhere((g) => g.id == genderId, orElse: () => Gender(id: -1, name: 'Unknown'));
    selectedGender.value = selectedGenderItem.id.toString();
  }
  
  void updateCountry(int countryId) {
	//print('Updating country to: $countryId');
    final selectedCountryItem = countryList.firstWhere((g) => g.id == countryId, orElse: () => Country(id: -1, name: 'Unknown'));
    selectedCountry.value = selectedCountryItem.id.toString();
  }

}
