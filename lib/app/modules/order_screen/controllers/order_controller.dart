import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/order_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/views/delivery_address.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/views/thank_you.dart';

class OrderController extends GetxController {
	final ApiService apiService;
	var isLoading = false.obs;  // RxBool
	var isDAloading = false.obs;  // RxBool
	var isCOloading = false.obs;  // RxBool
	OrderController(this.apiService);
	
	Future<void> placeOrder() async {
	  isLoading.value = true;
	  //Get.toNamed(Routes.HOME); 
		Get.to(() => DeliveryAddressPage());	  
	}
	
	Future<void> payNow() async {
	  isDAloading.value = true;
	  //Get.toNamed(Routes.HOME); 
		Get.to(() => ThankYouPage());	  
	}
	Future<void> continueOrder() async {
	  isCOloading.value = true;
	  Get.toNamed(Routes.HOME); 
	}
}
