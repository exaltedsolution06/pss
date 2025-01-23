import 'dart:io';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/profile_data.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/country.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/state.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/city.dart';

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
		zipcode: '',
		phone: '',
	));
  
	EditprofileScreenController(this.apiService);  // Constructor accepting ApiService
	
	// Observable to track loading state
	var isLoading = true.obs;
	// Declare observable lists
	var genderList = <Gender>[].obs;
	var selectedGender = ''.obs;
	
	// Declare observable lists
	var countryList = <Country>[].obs; // Observable for the country list
	var selectedCountry = Rxn<String>();
	var stateList = <StateModel>[].obs; // Observable for the state list
	var selectedState = Rxn<String>();
	var cityList = <CityModel>[].obs; // Observable for the city list
	var selectedCity = Rxn<String>();

	@override
	void onReady() {
		super.onReady();
		fetchProfile();
		print("Profile fetch EDIT Profile screen");
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
		try {
		  final response = await apiService.stateList(countryId);
		  
		  if (response['status'] == 200) {
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
		}
	}
	// Fetch the city list based on the selected state
	Future<void> fetchCityList(int stateId) async {
		try {
		  final response = await apiService.cityList(stateId);
		  
		  if (response['status'] == 200) {
			final List<CityModel> fetchedCityList = (response['data'] as List)
				.map((data) => CityModel.fromJson(data))
				.toList();
			stateList.assignAll(fetchedCityList);
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
		}
	}
	// Fetch user profile data
	Future<void> fetchProfile() async {

		isLoading.value = true; // Start loading
		try {
			isFetchingData(true);
			//final responseData = await apiService.fetchProfileDataForEditProfilePage(1, 1, 1, 1);
			final Map<String, dynamic> responseData = {
				"data": {
					"user": {
						"id": 4,
						"first_name": "First Name",
						"last_name": "Last Name",
						"avatar": "https://exaltedsolution.com/defencestudent/public/img/default-avatar.jpg",
						"default_avatar": 1,
						"company_name": "tttttttttttttttttt",
						"birthdate": null,
						"address": "asdfghjkl",
						"city": "ASDFGHJKL",
						"state": "WB",
						"gender_id": 1,
						"zipcode": "123456",
						"phone": "36963"
					},
					"genders": [
						{
							"id": 3,
							"gender_name": "Couple"
						},
						{
							"id": 2,
							"gender_name": "Female"
						},
						{
							"id": 1,
							"gender_name": "Male"
						},
						{
							"id": 4,
							"gender_name": "Other"
						}
					],
				},
			};
			
			final Map<String, dynamic>? response = responseData['data'] as Map<String, dynamic>?;
			// Ensure response['user'] is not null and is of the expected type
			//if (response['user'] != null && response['user'] is Map) {
			if (response != null && response['user'] is Map<String, dynamic>) {
				profileData.value = ProfileData.fromJson(response['user'] as Map<String, dynamic>);
			//profileData.value = ProfileData.fromJson(response['user'] as Map<String, dynamic>);
			} else {
				profileData.value = ProfileData(first_name: ''); // Default value if data is not valid
			}
			// Handle the 'genders' list
			if (response != null && response['genders'] is List) {
			  final List<dynamic> gendersDynamic = response['genders'] as List<dynamic>;
			  
			  // Ensure each item is a Map<String, dynamic>
			  final List<Gender> fetchedGenderList = gendersDynamic
				  .where((data) => data is Map<String, dynamic>)
				  .map((data) => Gender.fromJson(data as Map<String, dynamic>))
				  .toList();
			  
			  genderList.assignAll(fetchedGenderList); // Update the observable list
			} else {
			  genderList.assignAll([]); // Assign an empty list if 'genders' is not valid
			}

			// Set the selected gender, ensuring it's a valid string
			selectedGender.value = profileData.value.gender_id?.toString() ?? '';
			/*final List<Gender> fetchedGenderList = (response['genders'] as List).map((data) => Gender.fromJson(data)).toList();
			genderList.assignAll(fetchedGenderList); // Update the observable list
			
			// Ensure selectedGender is set based on the profile data
			selectedGender.value = profileData.value.gender_id.toString();*/

			//print('Gender List2: ${genderList.map((g) => g.name).toList()}');
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
		String first_name, 
		String last_name, 
		String email, 
		String? company_name, 
		String? birthdate, 
		String? address, 
		String? city, 
		String? state, 
		int? gender_id, 
		String? zipcode, 
		String? phone
	) async {
		isLoading.value = true;
		/*print('first_name: $first_name');
		print('last_name: $last_name');
		print('email: $email');
		print('company_name: $company_name');
		print('birthdate: $birthdate');
		print('address: $address');
		print('city: $city');
		print('state: $state');
		print('gender_id: $gender_id');
		print('zipcode: $zipcode');
		print('phone: $phone');*/
		try {
			isSubmittingData(true);
			/*final response = await apiService.profile_submit(
			  first_name, 
			  last_name, 
			  email, 
			  company_name ?? '', 
			  birthdate ?? '',  
			  address ?? '', 
			  city ?? ''
			  state ?? ''
			  gender_id ?? 0, 
			  zipcode ?? '', 
			  phone ?? '',
			);*/
			final response = {
			  'status': 200,
			  'message': 'Success'
			};
			//print('Status: $response');

			if (response['status'] == 200) {
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
	
	Future<void> uploadAvatarImage(File image) async {
	//print("Cover image selected Controller: $image");
	  try {
		// Call your API service to upload the image
		isUploadedProfileImageFile.value = true;
		profileImageFile.value = image;
		//var response = await apiService.profile_avatar_image_upload(image);

		/*if (response['status']=='200') {
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
		}*/
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
			profileImageFile.value = null;
			isUploadedProfileImageFile.value = false;
				
			final response = await apiService.profile_avatar_image_delete();
			//print('Status: $response');

			/*if (response['status'] == '200') {
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
					profileData.value = ProfileData(first_name: ''); // Default value if data is not valid
				}
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError,
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}*/
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
