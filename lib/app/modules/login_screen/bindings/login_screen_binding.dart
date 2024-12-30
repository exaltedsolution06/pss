import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginScreenController>(() => LoginScreenController(ApiService()));
  }
}
