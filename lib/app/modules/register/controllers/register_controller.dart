import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
//import 'package:picturesourcesomerset/config/bottom_navigation.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class RegisterController extends GetxController {
  final ApiService apiService;  
  RegisterController(this.apiService);
  var isLoading = false.obs;
  var isFetchingData = false.obs;
  var showPassword = true.obs;  // RxBool
  var showCPassword = true.obs;  // RxBool
  
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
	

  
  void changePasswordHideAndShow() {
    showPassword.value = !showPassword.value;  // Use .value to update RxBool
  }
  void changeCPasswordHideAndShow() {
    showCPassword.value = !showCPassword.value;  // Use .value to update RxBool
  }
  
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



  Future<void> register(String firstname, String lastname, String email, String password, String password_confirmation, String company_name, address, city, state, zipcode, phone) async {
    isLoading.value = true;
	//print('Navigating to CreatepinScreenView with name: $name');
	//print('Navigating to CreatepinScreenView with email: $email');
	//print('Navigating to CreatepinScreenView with password: $password');
    /*try {
		final response = await apiService.register(name, email, password, password_confirmation);
		
		//final otpErrorsEmail = response['errors']['email'] as List<dynamic>;
		
		//print('testtttt: $otpErrorsEmail');
		if (response['status'] == '200') {
			SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
			// Debug print to verify email and navigation
			//print('Navigating to CreatepinScreenView with email: $email');
			//Get.toNamed(Routes.HOME);
			Get.toNamed(
				Routes.OTP_VERIFICATION_SCREEN,
				parameters: {
					'email': email,
					'context': 'register', // or 'anotherContext'
				},
			);
		} else if (response['status'] == '600') {
			// Extract OTP error messages
			final otpErrorsEmail = (response['errors']['email'] as List<dynamic>?) ?? [];
			final otpErrorsPass = (response['errors']['password'] as List<dynamic>?) ?? [];
			final otpErrorsCPass = (response['errors']['password_confirmation'] as List<dynamic>?) ?? [];

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
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: Appcontent.snackbarCatchErrorMsg, 
		  position: SnackPosition.BOTTOM, // Custom position
		);
    } finally {
      isLoading.value = false;
    }*/
  }
}
