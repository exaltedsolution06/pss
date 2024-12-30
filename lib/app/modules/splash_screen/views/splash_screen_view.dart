import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

import '../controllers/splash_screen_controller.dart';

// ignore: must_be_immutable
class SplashScreenView extends GetView<SplashScreenController> {
  SplashScreenView({super.key});

    @override
  SplashScreenController controller = Get.put(SplashScreenController());
   @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(builder: (controller) => const Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
                width: 150,
                child: Image(image: AssetImage(Appcontent.splashlogo))),
            SizedBox(width: 10,),
            //Text('Defende Student', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: 'Urbanist')),
          ],
        ),
      ),
    ));
  }
}
