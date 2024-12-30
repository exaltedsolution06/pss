import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/modules/editpost_screen/controllers/editpost_screen_controller.dart';

class EditpostScreenBinding extends Bindings {
  @override
  void dependencies() {
	// Register the ApiService first
    Get.put(ApiService());
    
    // Now register the EditpostScreenController
    final args = Get.arguments as Map<String, dynamic>;
    String postId = args['postId']; // Get the postId from arguments
    Get.put(EditpostScreenController(Get.find<ApiService>(), postId));
	
    //Get.lazyPut<ApiService>(() => ApiService());
    //Get.lazyPut<EditpostScreenController>(() => EditpostScreenController(Get.find<ApiService>()));
  }
}
