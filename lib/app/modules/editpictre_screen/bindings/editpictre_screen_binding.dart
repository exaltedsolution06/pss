import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/editpictre_screen/controllers/editpictre_screen_controller.dart';

class EditpictreScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditpictreScreenController>(
      () => EditpictreScreenController(),
    );
  }
}
