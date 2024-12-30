import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/register/controllers/register_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';

class RetailerRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController(ApiService()));
  }
}
