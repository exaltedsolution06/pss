import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/Onboarding1/controllers/onboarding1_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';

class Onboarding1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Onboarding1Controller>(() => Onboarding1Controller(ApiService()));
  }
}
