import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/proflie_screen/controllers/proflie_screen_controller.dart';

class ProflieScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<ProflieScreenController>(() => ProflieScreenController(Get.find<ApiService>()));
  }
}
