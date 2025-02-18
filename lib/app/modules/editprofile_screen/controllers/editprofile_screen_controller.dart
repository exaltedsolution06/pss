import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/profile_data.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/country.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/state.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/city.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/gender.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/controllers/user_controller.dart';

class EditprofileScreenController extends GetxController {
  //TODO: Implement EditprofileScreenController
	var isFetchingData = false.obs;
	var isSubmittingData = false.obs;
	
	var profileImageFile = Rx<File?>(null);
	var isUploadedProfileImageFile = false.obs;
  
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
		latitude: '',
		longitude: '',
		zipcode: '',
		phone: '',
	));
	final userController = Get.find<UserController>();
	EditprofileScreenController(this.apiService);  // Constructor accepting ApiService
	
	// Observable to track loading state
	var isLoading = false.obs;
	var isFetchingStates = false.obs; // To track state list fetching
	var isFetchingCities = false.obs; // To track city list fetching
	
	// Declare observable lists
	var genderList = <Gender>[].obs;
	var selectedGender = Rxn<String>();
	
	// Declare observable lists
	var countryList = <Country>[].obs; // Observable for the country list
	var selectedCountry = Rxn<String>();
	
	var stateList = <StateModel>[].obs; // Observable for the state list
	var selectedState = Rxn<String>();
	var loadingState = false.obs; // New observable for loading country
	var cityList = <CityModel>[].obs; // Observable for the city list
	var selectedCity = Rxn<String>();
	var loadingCity = false.obs; // New observable for loading state
	
	//var selectedCountry = 0.obs; // Reactive country value
	//var selectedState = 0.obs;   // Reactive state value

	@override
	void onInit() {
		super.onInit();
		//fetchProfile();
		// Fetch the gender list when the view loads
		fetchGenderList();
		// Fetch the country list when the view loads
		fetchCountryList();
		fetchStateList(userController.country.value);
		fetchCityList(userController.state.value);
		
		print("Country Id: ${userController.country.value}");
		print("State Id: ${userController.state.value}");
	}
	//fetch gender lists
	Future<void> fetchGenderList() async {
		try {
			final response = await apiService.genderList();
			print('Response: $response');
			if (response['status'] == 200) {						
				final List<Gender> fetchedGenderList = 
					(response['data'] as List)
						.map((data) => Gender.fromJson(data))
						.toList();

				genderList.assignAll(fetchedGenderList); // This will now work
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
	//fetch country lists
	Future<void> fetchCountryList() async {
		try {
			final response = await apiService.countryList();
			print('Response: $response');
			if (response['status'] == 200) {						
				final List<Country> fetchedCountryList = 
					(response['data'] as List)
						.map((data) => Country.fromJson(data))
						.toList();

				countryList.assignAll(fetchedCountryList); // This will now work
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
	// Fetch the state list based on the selected country
	Future<void> fetchStateList(int countryId) async {
	
		if (isFetchingStates.value) return; // Avoid duplicate fetching
		isFetchingStates.value = true;
	
		try {
			loadingState.value = true; // Set loading to true
			print("Load fetchStateList from editcontroller: $countryId");
			
			final response = await apiService.stateList(countryId);

			if (response['status'] == 200) {
				//stateList = <StateModel>[].obs; // Observable for the state list
				final List<StateModel> fetchedStateList = (response['data'] as List)
					.map((data) => StateModel.fromJson(data))
					.toList();
				stateList.assignAll(fetchedStateList);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError,
				  message: response['message'],
				  position: SnackPosition.BOTTOM,
				);
			}
		} catch (e) {
			SnackbarHelper.showErrorSnackbar(
				title: Appcontent.snackbarTitleError,
				message: Appcontent.snackbarCatchErrorMsg,
				position: SnackPosition.BOTTOM,
			);
		} finally {
			loadingState.value = false; // Set loading to false
			isFetchingStates.value = false;
		}
	}
	// Fetch the city list based on the selected state
	Future<void> fetchCityList(int stateId) async {
		if (isFetchingCities.value) return; // Avoid duplicate fetching
		isFetchingCities.value = true;
		try {
			loadingCity.value = true; // Set loading to true
			final response = await apiService.cityList(stateId);

			if (response['status'] == 200) {
				final List<CityModel> fetchedCityList = (response['data'] as List)
					.map((data) => CityModel.fromJson(data))
					.toList();
				cityList.assignAll(fetchedCityList);
			} else {
				SnackbarHelper.showErrorSnackbar(
					title: Appcontent.snackbarTitleError,
					message: response['message'],
					position: SnackPosition.BOTTOM,
				);
			}
		} catch (e) {
			SnackbarHelper.showErrorSnackbar(
				title: Appcontent.snackbarTitleError,
				message: Appcontent.snackbarCatchErrorMsg,
				position: SnackPosition.BOTTOM,
			);
		} finally {
			loadingCity.value = false; // Set loading to false
			isFetchingCities.value = false;
		}
	}
	
	//submit profile data
	Future<void> profileSubmit(
		String first_name, 
		String last_name, 
		String email, 
		String? company_name, 
		String? dob,  
		int? country, 
		int? state,  
		int? city,
		String? address, 
		String? latitude, 
		String? longitude, 
		String? zipcode, 
		String? phone,
		int? gender_id
	) async {
		isLoading.value = true;
		/*print('first_name: $first_name');
		print('last_name: $last_name');
		print('email: $email');
		print('company_name: $company_name');
		print('dob: $dob');
		print('address: $address');
		print('city: $city');
		print('state: $state');
		print('country: $country');
		print('gender_id: $gender_id');
		print('zipcode: $zipcode');
		print('phone: $phone');*/
		try {
			isSubmittingData(true);
			final response;
			if(userController.userType.value == 1)
			{
				response = await apiService.customer_profile_submit(
					first_name ?? '', 
					last_name ?? '', 
					email ?? '', 
					company_name ?? '', 
					dob ?? '',
					country ?? 0,
					state ?? 0,   
					city ?? 0,
					address ?? '', 
					latitude ?? '', 
					longitude ?? '', 
					zipcode ?? '', 
					phone ?? '',
					gender_id ?? 0, 			 
				);
			}
			else
			{
				response = await apiService.retailer_profile_submit(
					first_name ?? '', 
					last_name ?? '', 
					email ?? '', 
					company_name ?? '', 
					dob ?? '',
					country ?? 0,
					state ?? 0,   
					city ?? 0,
					address ?? '', 
					latitude ?? '', 
					longitude ?? '', 
					zipcode ?? '', 
					phone ?? '',
					gender_id ?? 0, 			 
				);
			}
			//print('Status: $response');

			if (response['status'] == 200) {
				// Update user data
				await updateUserData({
					"name": "$first_name $last_name",
					"first_name": first_name,
					"last_name": last_name,
					"email": email,
					"company_name": company_name,
					"address": address,
					"city": city,
					"country": country,
					"state": state,
					"latitude": latitude,
					"longitude": longitude,
					"zipcode": zipcode,
					"phone_number": phone,
					"dob": dob,
					"gender_id": gender_id
				});
				
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  //message: response['message'],
				  message: 'success',
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
			  SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError,
				  //message: response['message'],
				  message: 'error',
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			print('Error occurred: $e'); // Print the error if any occurs
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
	
	Future<void> updateUserData(Map<String, dynamic> userData) async {
		print('User Data: $userData'); // Debugging

		final prefs = await SharedPreferences.getInstance();

		await prefs.setString('name', userData['name'] ?? '');
		await prefs.setString('firstName', userData['first_name'] ?? '');
		await prefs.setString('lastName', userData['last_name'] ?? '');
		await prefs.setString('email', userData['email'] ?? '');
		await prefs.setString('companyName', userData['company_name'] ?? '');

		// Ensure country, state, city are integers before saving
		await prefs.setInt('country', (userData['country'] as int?) ?? 0);
		await prefs.setInt('state', (userData['state'] as int?) ?? 0);
		await prefs.setInt('city', (userData['city'] as int?) ?? 0);

		await prefs.setString('address', userData['address'] ?? '');
		await prefs.setString('latitude', userData['latitude'] ?? '');
		await prefs.setString('longitude', userData['longitude'] ?? '');
		await prefs.setString('zipcode', userData['zipcode'] ?? '');
		await prefs.setString('phoneNumber', userData['phone_number'] ?? '');
		await prefs.setString('dob', userData['dob'] ?? '');

		// Ensure gender_id is an integer before saving
		await prefs.setInt('genderId', (userData['gender_id'] as int?) ?? 0);

		// Update UserController
		userController.setEditUserData(userData);
	}
	Future<void> updateProfilePictureData(Map<String, dynamic> userData) async {
		print('User Data: $userData'); // Debugging

		final prefs = await SharedPreferences.getInstance();
		await prefs.setString('profilePicture', userData['profile_image'] ?? '');

		// Update UserController
		userController.setEditUserProfilePictureData(userData);
	}


	
	Future<void> uploadAvatarImage(File image) async {
		print("Profile image selected Controller: $image");
	  try {
		// Call your API service to upload the image
		isUploadedProfileImageFile.value = true;
		profileImageFile.value = image;
		var response = await apiService.profile_avatar_image_upload(image);
print('image upload response are : $response');
		if (response['status']==200) {
			isUploadedProfileImageFile.value = true;
			profileImageFile.value = image;
			// Update user data
			await updateProfilePictureData({
				"profile_image": response['image']
			});
				
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
		print('Error: $e');
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
			profileImageFile.value = null;
			isUploadedProfileImageFile.value = false;
				
			final response = await apiService.profile_avatar_image_delete();
			print('Status: $response');

			if (response['status'] == 200) {
				// Reset the reactive variables
				profileImageFile.value = null;
				isUploadedProfileImageFile.value = false;
				
				// Update user data
				await updateProfilePictureData({
					"profile_image": ""
				});
				
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			  
			  /*final responseData = await apiService.fetchProfileDataForEditProfilePage(1, 1, 1, 1);
				final responseF = responseData['data'];
				// Ensure responseF['user'] is not null and is of the expected type
				if (responseF['user'] != null && responseF['user'] is Map) {
					profileData.value = ProfileData.fromJson(responseF['user']);
				//profileData.value = ProfileData.fromJson(responseF['user'] as Map<String, dynamic>);
				} else {
					profileData.value = ProfileData(first_name: ''); // Default value if data is not valid
				}*/
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
	
	// Update methods for gender and country
	void updateGender(int genderId) {
		//print('Updating gender to: $genderId');
		final selectedGenderItem = genderList.firstWhere((g) => g.id == genderId, orElse: () => Gender(id: -1, name: 'Unknown'));
		selectedGender.value = selectedGenderItem.id.toString();
	}
}
