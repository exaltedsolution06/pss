import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/reset_password_screen/controllers/reset_password_screen_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';

class ResetPasswordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordScreenController>(() => ResetPasswordScreenController(ApiService()));
  }
}
