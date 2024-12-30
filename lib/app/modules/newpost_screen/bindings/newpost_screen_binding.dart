/*import 'package:get/get.dart';

import '../controllers/newpost_screen_controller.dart';

class NewpostScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewpostScreenController>(
      () => NewpostScreenController(),
    );
  }
}*/

import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/newpost_screen/controllers/newpost_screen_controller.dart';

class NewpostScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<NewpostScreenController>(() => NewpostScreenController(Get.find<ApiService>()));
  }
}
