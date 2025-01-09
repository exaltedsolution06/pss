import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
//import 'package:picturesourcesomerset/app/modules/reset_password_screen/views/reset_password_screen_view.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class OtpVerificationScreenController extends GetxController {
  final ApiService apiService;
  var isLoading = false.obs;

  OtpVerificationScreenController(this.apiService);

  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String context,
  }) async {
    isLoading.value = true;
	//Get.toNamed(Routes.RESET_PASSWORD_SCREEN, parameters: {'email': email});
    try {
      late final Map<String, dynamic> response;
	  
	  //print('Navigating to CreatepinScreenView with context: $otp');
	  
      if (context == 'forgotPassword') {
        response = await apiService.forgotPassword_verifyOtp(email, otp);
      } else if (context == 'register') {
        response = await apiService.register_verifyOtp(email, otp);
      } else {
        throw Exception('Invalid context');
      }

      if (response['status'] == 200) {
        SnackbarHelper.showSuccessSnackbar(
		  title: Appcontent.snackbarTitleSuccess, 
		  message: response['message'],
		  position: SnackPosition.BOTTOM, // Custom position
		);
        if (context == 'forgotPassword') {
			Get.toNamed(Routes.RESET_PASSWORD_SCREEN, parameters: {'email': email});
        } else {
			Get.toNamed(Routes.HOME);
		}
      } else if (response['status'] == '600') {
        final otpErrors = response['errors']['otp'] as List<dynamic>;
        final firstOtpErrorMessage = otpErrors.isNotEmpty ? otpErrors.first as String : 'Invalid OTP';
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

