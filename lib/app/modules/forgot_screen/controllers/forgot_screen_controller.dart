import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
//import 'package:picturesourcesomerset/app/modules/createpin_screen/views/createpin_screen_view.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class ForgotScreenController extends GetxController {
  final ApiService apiService;
  var isLoading = false.obs;

  ForgotScreenController(this.apiService);

  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
	/*Get.toNamed(
		Routes.OTP_VERIFICATION_SCREEN,
		parameters: {
			'email': 'test@test.com',
			'context': 'forgotPassword', // or 'anotherContext'
		},
	);*/
    try {
      final response = await apiService.forgotPassword(email);
      if (response['status'] == 200) {
		SnackbarHelper.showSuccessSnackbar(
		  title: Appcontent.snackbarTitleSuccess, 
		  message: response['message'],
		  position: SnackPosition.BOTTOM, // Custom position
		);
		// Debug print to verify email and navigation
		//print('Navigating to CreatepinScreenView with email: $email');
		Get.toNamed(
			Routes.OTP_VERIFICATION_SCREEN,
			parameters: {
				'email': email,
				'context': 'forgotPassword', // or 'anotherContext'
			},
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
