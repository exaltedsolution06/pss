import 'package:get/get.dart';
//import '../../Onboarding1/views/onboarding1_view.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
		//print('Navigating to Onboarding1View');
		Get.offNamed(Routes.ONBOARDING1);

    });
  }

  void increment() => count.value++;
}
