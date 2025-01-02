import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/app/modules/wish_list/controllers/wish_list_controller.dart';

class WishListController extends GetxController {
	final ApiService apiService;
	var isLoading = false.obs;  // RxBool
	WishListController(this.apiService);
	
	Future<void> wishListCreate(String email, String relationship, String birthday, String anniversary) async {
	  isLoading.value = true;
	  print("clicked to cart page");
	  Get.toNamed(Routes.CART_PAGE); 	
	}
}
