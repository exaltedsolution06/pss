import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/retailer.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/country.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/models/state.dart';
//import 'package:picturesourcesomerset/app/modules/profile_screen/models/city.dart';

class RegisterController extends GetxController {
	final ApiService apiService;  
	RegisterController(this.apiService);
  
	var isLoading = false.obs;
	var isFetchingData = false.obs;
	var showPassword = true.obs;  // RxBool
	var showCPassword = true.obs;  // RxBool
  
	// Declare observable lists
	var retailerList = <Retailer>[].obs; // Observable for the retailer list
	var selectedRetailer = Rxn<String>('1');
	var countryList = <Country>[].obs; // Observable for the country list
	var selectedCountry = Rxn<String>('231');
	var stateList = <StateModel>[].obs; // Observable for the state list
	var selectedState = Rxn<String>();
	var loadingState = false.obs; // New observable for loading country
	//var cityList = <CityModel>[].obs; // Observable for the city list
	//var selectedCity = Rxn<String>();
	var loadingCity = false.obs; // New observable for loading state
  
	void changePasswordHideAndShow() {
		showPassword.value = !showPassword.value;  // Use .value to update RxBool
	}
	void changeCPasswordHideAndShow() {
		showCPassword.value = !showCPassword.value;  // Use .value to update RxBool
	}
	@override
	void onInit() {
	  super.onInit();
	  fetchCountryList();
      fetchRetailerList();
	  fetchStateList(231); // Fetch states for country ID 231 on load
	}
	//fetch Retailer lists
	Future<void> fetchRetailerList() async {
		try {
			final response = await apiService.retailerList();
			print('Response: $response');
			if (response['status'] == 200) {						
				final List<Retailer> fetchedRetailerList = 
					(response['data'] as List)
						.map((data) => Retailer.fromJson(data))
						.toList();

				retailerList.assignAll(fetchedRetailerList); // This will now work
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			/*SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);*/
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
			/*SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);*/
		}
	}
	// Fetch the state list based on the selected country
	Future<void> fetchStateList(int countryId) async {
		try {
			loadingState.value = true; // Set loading to true
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
		} finally {
			loadingState.value = false; // Set loading to false
		}
	}
	// Fetch the city list based on the selected state
	/*Future<void> fetchCityList(int stateId) async {
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
		}
	}*/
  
	/*void updateCountry(int countryId) {
		print('Updating country to: $countryId');
		//final selectedCountryItem = countryList.firstWhere((g) => g.id == countryId, orElse: () => Country(id: -1, name: 'Unknown'));
		//selectedCountry.value = selectedCountryItem.id.toString();
	}*/
	Future<void> store_customer(first_name, last_name, email, password, confirmed_password, retailer, address, city, state, country, zipcode, phone_number) async {
		isLoading.value = true;
		print('First Name: $first_name');
		print('Last Name: $last_name');
		print('Email: $email');
		print('Password: $password');
		print('Confirm Password: $confirmed_password');
		//print('Company Name: $company_name');
		print('Address: $address');
		print('City: $city');
		print('State: $state');
		print('Country: $country');
		print('Zipcode: $zipcode');
		print('Phone Number: $phone_number');
		try {
			final response = await apiService.store_customer(first_name, last_name, email, password, confirmed_password, retailer, address, city, state, country, zipcode, phone_number);
   print('Response Register customer: $response');
			
			//final otpErrorsEmail = response['errors']['email'] as List<dynamic>;
			
			//print('testtttt: $otpErrorsEmail');
			if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
				// Debug print to verify email and navigation
				//print('Navigating to CreatepinScreenView with email: $email');
				//Get.toNamed(Routes.HOME);
				/*Get.toNamed( // Comment for otp logic is off now
					Routes.OTP_VERIFICATION_SCREEN,
					parameters: {
						'email': email,
						'context': 'register', // or 'anotherContext'
					},
				);*/
				Get.toNamed(Routes.LOGIN_SCREEN);
				
				
			} else if (response['status'] == 600) {
				// Extract OTP error messages
				final otpErrorsEmail = (response['errors']['email'] as List<dynamic>?) ?? [];
				final otpErrorsPass = (response['errors']['password'] as List<dynamic>?) ?? [];
				final otpErrorsCPass = (response['errors']['confirmed_password'] as List<dynamic>?) ?? [];

				// Default error messages
				const defaultEmailError = 'The email has already been taken.';
				const defaultPasswordError = 'The password confirmation does not match.';
				const defaultCPasswordError = 'The password confirmation field is required.';

				// Function to get the first error message if exists, otherwise return the default message
				String getFirstErrorMessage(List<dynamic> errors, String defaultMessage) {
				  return errors.isNotEmpty ? (errors.first as String?) ?? defaultMessage : defaultMessage;
				}

				// Determine the error message to display
				final emailOtpErrorMessage = getFirstErrorMessage(otpErrorsEmail, defaultEmailError);
				final passwordOtpErrorMessage = otpErrorsPass.isNotEmpty ? getFirstErrorMessage(otpErrorsPass, defaultPasswordError) : '';
				final cpasswordOtpErrorMessage = otpErrorsCPass.isNotEmpty ? getFirstErrorMessage(otpErrorsCPass, defaultCPasswordError) : '';

				// Display the first available error message in priority order
				final displayErrorMessage = otpErrorsEmail.isNotEmpty
					? emailOtpErrorMessage
					: otpErrorsPass.isNotEmpty
						? passwordOtpErrorMessage
						: cpasswordOtpErrorMessage;

				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: displayErrorMessage,
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
              print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isLoading.value = false;
		}
	}
  
	Future<void> store_retailer({
		required String first_name, 
		required String last_name, 
		required String email, 
		required String password, 
		required String confirmed_password, 
		required String company_name, 
		required String address, 
		required String city, 
		required int state, 
		required int country, 
		required String zipcode, 
		required String phone_number,
		List<File>? selectedFiles,
	}) async {
    isLoading.value = true;
	//print('Navigating to CreatepinScreenView with name: $name');
	//print('Navigating to CreatepinScreenView with email: $email');
	//print('Navigating to CreatepinScreenView with password: $password');
    try {
		if (selectedFiles != null && selectedFiles.isNotEmpty) {
			File imageFile = selectedFiles.first; // Get the first (and only) file
			final response = await apiService.store_retailer(imageFile, first_name:first_name, last_name:last_name, email:email, password:password, confirmed_password:confirmed_password, company_name:company_name, address:address, city:city, state:state, country:country, zipcode:zipcode, phone_number:phone_number);
			
			//final otpErrorsEmail = response['errors']['email'] as List<dynamic>;
		
		//print('testtttt: $otpErrorsEmail');
		if (response['status'] == 200) {
			SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
			// Debug print to verify email and navigation
			//print('Navigating to CreatepinScreenView with email: $email');
			//Get.toNamed(Routes.HOME);
			/*Get.toNamed( // Comment for otp logic is off now
				Routes.OTP_VERIFICATION_SCREEN,
				parameters: {
					'email': email,
					'context': 'register', // or 'anotherContext'
				},
			);*/
			Get.toNamed(Routes.LOGIN_SCREEN);
		} else if (response['status'] == 600) {
			// Extract OTP error messages
			final otpErrorsEmail = (response['errors']['email'] as List<dynamic>?) ?? [];
			final otpErrorsPass = (response['errors']['password'] as List<dynamic>?) ?? [];
			final otpErrorsCPass = (response['errors']['confirmed_password'] as List<dynamic>?) ?? [];

			// Default error messages
			const defaultEmailError = 'The email has already been taken.';
			const defaultPasswordError = 'The password confirmation does not match.';
			const defaultCPasswordError = 'The password confirmation field is required.';

			// Function to get the first error message if exists, otherwise return the default message
			String getFirstErrorMessage(List<dynamic> errors, String defaultMessage) {
			  return errors.isNotEmpty ? (errors.first as String?) ?? defaultMessage : defaultMessage;
			}

			// Determine the error message to display
			final emailOtpErrorMessage = getFirstErrorMessage(otpErrorsEmail, defaultEmailError);
			final passwordOtpErrorMessage = otpErrorsPass.isNotEmpty ? getFirstErrorMessage(otpErrorsPass, defaultPasswordError) : '';
			final cpasswordOtpErrorMessage = otpErrorsCPass.isNotEmpty ? getFirstErrorMessage(otpErrorsCPass, defaultCPasswordError) : '';

			// Display the first available error message in priority order
			final displayErrorMessage = otpErrorsEmail.isNotEmpty
				? emailOtpErrorMessage
				: otpErrorsPass.isNotEmpty
					? passwordOtpErrorMessage
					: cpasswordOtpErrorMessage;

			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: displayErrorMessage,
			  position: SnackPosition.BOTTOM, // Custom position
			);


		} else {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	
		}
		
		
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
  
  // Flag to control whether fetchTermsPage should be called
	//bool shouldFetchTermsPage = false;
	// Flag to control whether fetchPrivacyPage should be called
	//bool shouldFetchPrivacyPage = false;
	/*@override
	void onInit() {
		super.onInit();
		if (shouldFetchTermsPage) {
			fetchTermsPage(); // Fetch data only if the flag is true
		} if (shouldFetchPrivacyPage) {
			fetchPrivacyPage(); // Fetch details when the controller is initialized
		}
	}*/
	
	var pageTitle = ''.obs;
	var updatedDate = ''.obs;
	var pageContent = ''.obs;
	
	// Fetch terms and conditions page data
	/*Future<void> fetchTermsPage() async {
		print("Terms page data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  //await Future.delayed(Duration(seconds: 2));
		  final responseData = await apiService.cms_terms_page(1);

		  final response = responseData['data'];

		  print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {
				pageTitle.value = response['terms_and_conditions'][0]['title'];
				updatedDate.value = response['terms_and_conditions'][0]['updated_at'];
				pageContent.value = response['terms_and_conditions'][0]['content'];		  
			}
		} catch (e) {
			print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}*/
	// Fetch privacy policy page data
	/*var privacyPolicyPageTitle = ''.obs;
	var privacyPolicyUpdatedDate = ''.obs;
	var privacyPolicyPageContent = ''.obs;
	
	Future<void> fetchPrivacyPage() async {
		print("Privacy page data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  //await Future.delayed(Duration(seconds: 2));
		  final responseData = await apiService.cms_privacy_page(1);

		  final response = responseData['data'];

		  print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {
				privacyPolicyPageTitle.value = response['privacy_policy'][0]['title'];
				privacyPolicyUpdatedDate.value = response['privacy_policy'][0]['updated_at'];
				privacyPolicyPageContent.value = response['privacy_policy'][0]['content'];		  
			}
		} catch (e) {
			print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}*/
	

  
  
  
  Future<void> pickFile() async {
	  FilePickerResult? result = await FilePicker.platform.pickFiles();

	  if (result != null) {
		PlatformFile file = result.files.first;

		// Use the file
		print('File Name: ${file.name}');
		print('File Path: ${file.path}');
		print('File Size: ${file.size} bytes');

		if (file.path != null) {
		  //uploadFile(file.path!);
		}
	  } else {
		// User canceled the picker
		print('File selection canceled.');
	  }
	}
	
	

Future<void> uploadFile(String filePath) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://your-api-url.com/upload'),
  );

  request.files.add(await http.MultipartFile.fromPath(
    'file', // Field name expected by the API
    filePath,
  ));

  final response = await request.send();

  if (response.statusCode == 200) {
    print('File uploaded successfully!');
  } else {
    print('Failed to upload file. Status code: ${response.statusCode}');
  }
}



  
}
