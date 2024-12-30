import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/otp_verification_screen/controllers/otp_verification_screen_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';

class OtpVerificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationScreenController>(() => OtpVerificationScreenController(ApiService()));
  }
}
