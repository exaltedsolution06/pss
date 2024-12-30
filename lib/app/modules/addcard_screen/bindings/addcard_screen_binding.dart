import 'package:get/get.dart';

import '../controllers/addcard_screen_controller.dart';

class AddcardScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddcardScreenController>(
      () => AddcardScreenController(),
    );
  }
}
