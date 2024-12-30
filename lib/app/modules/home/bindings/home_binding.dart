import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put for ApiService: It will be created only when needed
    Get.lazyPut<ApiService>(() => ApiService());

    // Lazy put for HomeController, ensure ApiService is already available
    Get.lazyPut<HomeController>(() => HomeController(Get.find<ApiService>()));
  }
}
