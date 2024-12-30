import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/forgot_screen/controllers/forgot_screen_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';

class ForgotScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotScreenController>(() => ForgotScreenController(ApiService()));
  }
}
