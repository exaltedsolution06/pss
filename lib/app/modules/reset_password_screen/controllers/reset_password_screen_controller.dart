import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class ResetPasswordScreenController extends GetxController {
  final ApiService apiService;
  var isLoading = false.obs;  // RxBool
  var showPassword = true.obs;  // RxBool
  var showCPassword = true.obs;  // RxBool

  ResetPasswordScreenController(this.apiService);

  void changePasswordHideAndShow() {
    showPassword.value = !showPassword.value;  // Use .value to update RxBool
  }
  void changeCPasswordHideAndShow() {
    showCPassword.value = !showCPassword.value;  // Use .value to update RxBool
  }

  Future<void> resetPassword(String email, String password, String password_confirmation) async {
    isLoading.value = true;  // Use .value to update RxBool
	//Get.toNamed(Routes.LOGIN_SCREEN);
	try {
		final response = await apiService.resetPassword(email, password, password_confirmation);
		print('Response received: $response');
		isLoading.value = false;  // Use .value to update RxBool
		if (response['status'] == 200) {
			SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
			Get.toNamed(Routes.LOGIN_SCREEN);
			//Get.offAll(LoginScreenView());
		} else if (response['status'] == 600) {
			// Extract OTP error messages
			final otpErrors = response['errors']['password'] as List<dynamic>;
			// Check if there are any error messages and use the first one
			final firstOtpErrorMessage = otpErrors.isNotEmpty ? otpErrors.first as String : 'Invalid password';
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: firstOtpErrorMessage,
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
    }
  }
}
