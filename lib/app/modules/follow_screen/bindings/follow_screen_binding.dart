import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/follow_screen/controllers/follow_screen_controller.dart';

class FollowScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<FollowScreenController>(() => FollowScreenController(Get.find<ApiService>()));
  }
}