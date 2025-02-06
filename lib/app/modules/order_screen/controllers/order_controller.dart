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
	var isDAMLoading = false.obs;  // RxBool
	var isDAloading = false.obs;  // RxBool
	var isCOloading = false.obs;  // RxBool
	var deliveryAddressListData = <dynamic>[].obs;	
	
	OrderController(this.apiService);
	
	Future<void> placeOrder() async {
	  isLoading.value = true;
	  //Get.toNamed(Routes.HOME); 
		Get.to(() => DeliveryAddressPage());	  
	}
	
	// DeliveryAddressPage address data
	Future<void> deliveryAddressData() async {
		try {
			var response = await apiService.deliveryAddressList();
			deliveryAddressListData.clear();  // or reset it to initial state
			var newFeedData = response['data']; 
			deliveryAddressListData.addAll(newFeedData);
			
			print(deliveryAddressListData);
		} catch (e) {
			print('Error fetching All DeliveryAddressPage data - order controller: $e');
		}
	}
	// DeliveryAddressPage add address data
	Future<void> addDeliveryAddress(address_type, phone_number, address) async {
		isDAMLoading.value = true;
		print("Address Type: $address_type");
		print("Phone Number: $phone_number");
		print("Address: $address");
		try {
			var response = await apiService.addDeliveryAddress(address_type, phone_number, address);
			print("Response: $response");
			if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['data'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
				deliveryAddressData();				
			} else if (response['status'] == '600') {
				final firstErrorMessages = <String>[];

				// Iterate through the errors map and collect the first error messages
				response['errors'].forEach((key, value) {
					firstErrorMessages.add(value[0]);
				});
				// Or access individual messages by index
				final firstPasswordError = firstErrorMessages[0];
				
				//print(firstPasswordError);
				
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: firstPasswordError,
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['data'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			print('Error add DeliveryAddressPage data - order controller: $e');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isDAMLoading.value = false;
		}
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
