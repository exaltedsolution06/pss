import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import '../controllers/order_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';

class OrderBinding extends Bindings {
	@override
	void dependencies() {
		Get.lazyPut<ApiService>(() => ApiService());
		Get.lazyPut<OrderController>(() => OrderController(Get.find<ApiService>()));
		// Initialize CartController
		Get.lazyPut<CartController>(() => CartController());
	}
}