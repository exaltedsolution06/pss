import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/notification_screen/controllers/notification_screen_controller.dart';

class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<NotificationScreenController>(() => NotificationScreenController(Get.find<ApiService>()));
  }
}
