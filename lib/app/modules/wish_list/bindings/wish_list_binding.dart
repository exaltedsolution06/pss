import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import '../controllers/wish_list_controller.dart';

class WishListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<WishListController>(() => WishListController(Get.find<ApiService>()));
  }
}
