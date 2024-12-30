import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/serach_screen/controllers/serach_screen_controller.dart';

class SerachScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<SerachScreenController>(() => SerachScreenController(Get.find<ApiService>()));
  }
}
