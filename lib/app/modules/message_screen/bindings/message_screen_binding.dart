import 'package:get/get.dart';

import '../controllers/message_screen_controller.dart';

class MessageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageScreenController>(
      () => MessageScreenController(),
    );
  }
}
