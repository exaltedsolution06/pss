import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/view_proflie_screen/controllers/view_proflie_screen_controller.dart';

class ViewProflieScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Register the ApiService first
    Get.put(ApiService());
    
    // Now register the ViewProflieScreenController
    final args = Get.arguments as Map<String, dynamic>;
    String userId = args['userId']; // Get the userId from arguments
    Get.put(ViewProflieScreenController(Get.find<ApiService>(), userId));
  }
}
