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
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';

class OrderController extends GetxController {
	final ApiService apiService;
	var isLoading = false.obs;  // RxBool
	var isDAMLoading = false.obs;  // RxBool
	var isDAloading = false.obs;  // RxBool
	var isCOloading = false.obs;  // RxBool
	var deliveryAddressListData = <dynamic>[].obs;	
	
	OrderController(this.apiService);
	
	final CartController cartController = Get.find<CartController>();
	var selectedId = Rxn<int>();
	
	Future<void> placeOrderPage() async {
	  isLoading.value = true;
	  Get.to(() => DeliveryAddressPage());
	}
	Future<void> placeOrder() async {
	  try {
	    isDAloading.value = true;

		if (cartController.cartItems.isEmpty) {
		  SnackbarHelper.showErrorSnackbar(
			title: "Cart Empty",
			message: "Your cart is empty. Please add items before placing an order.",
			position: SnackPosition.BOTTOM, // Custom position
		  );
		  isDAloading.value = false;
		  return;
		}
		
		// Prepare the order payload
		final List<Map<String, dynamic>> cartData = cartController.cartItems.entries.map((entry) {
			final item = entry.value;
			return {
			  "product_id": item["product_id"],
			  "product_name": item["product_name"],
			  "image_url": item["imageUrl"],
			  "quantity": item["quantity"],
			  "price": item["price"],
			};
		}).toList();
		
		final Map<String, dynamic> orderData = {
			"address_id": selectedId.value, // Selected address ID
			"cart_items": cartData, // Cart items list
			"total_amount": cartController.totalPrice.value, // Total price of the cart
			"payment_method": "cod", // Change based on user selection
		};
		
		print('Order Data: $orderData');
		var response = await apiService.placeOrder(orderData);
		
		
		
	  } catch (e) {
		print('Error placing order: $e');
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: 'Error placing order: $e',
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  } finally {
		isDAloading.value = false;
	  }
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
	Future<void> addDeliveryAddress(address_type, phone_number, latitude, longitude, address) async {
		isDAMLoading.value = true;
		print("Address Type: $address_type");
		print("Phone Number: $phone_number");
		print("Address: $address");
		try {
			var response = await apiService.addDeliveryAddress(address_type, phone_number, latitude, longitude, address);
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
	
	void updateDeliveryAddress(int id, String type, String phone, String latitude, String longitude, String address) async {
	  isDAMLoading.value = true;
	  try {
	    var response = await apiService.editDeliveryAddress(id, type, phone, latitude, longitude, address);
		
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
	  if (selectedId.value == null) {
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: 'Please select a delivery address', 
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }else{
	    // Call the function to place order
		await placeOrder();
	  }
	  isDAloading.value = false;

	  // Proceed with the payment
	  //print("Proceeding with payment for address ID: $selectedId");
	  //Get.toNamed(Routes.HOME); 
	  //Get.to(() => ThankYouPage());	  
	}
	Future<void> continueOrder() async {
	  isCOloading.value = true;
	  Get.toNamed(Routes.HOME); 
	}
	Future<void> removeAddress(int id) async {
	  try {
	    var response = await apiService.deleteDeliveryAddress(id);
		
		if (response['status'] == 200) {
			if (selectedId.value == id) {
			  selectedId.value = null; // Reset selected ID if removed
			}
			deliveryAddressData();
			SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['data'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} else {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['message'],
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
	  }
	}
}
