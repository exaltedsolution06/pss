import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/order_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/views/delivery_address.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/views/wishlist_delivery_address.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/views/thank_you.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';

import 'package:picturesourcesomerset/app/modules/order_screen/models/order_details_model.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/models/wishlist_details_model.dart';

class OrderController extends GetxController {
	final ApiService apiService;
	var isLoading = false.obs;  // RxBool
	var isDAMLoading = false.obs;  // RxBool
	var isDAloading = false.obs;  // RxBool
	var isCOloading = false.obs;  // RxBool
	var deliveryAddressListData = <dynamic>[].obs;	
	
	var orders = [].obs; // Store orders list
	var wishlist = [].obs; // Store wishlist list
	//var isLoading = false.obs;
	var isOrderLoading = false.obs;
	var isWishlistLoading = false.obs;
	
	OrderController(this.apiService);
	
    var orderDetails = Rxn<OrderDetailsModel>();
    var wishlistDetails = Rxn<WishlistDetailsModel>();
	var isDetailsLoading = true.obs;
	
	// Reset the page number
	var currentOrderPage = 1.obs;
	var currentWishlistPage = 1.obs;
	
	final CartController cartController = Get.find<CartController>();
	var selectedId = Rxn<int>();
	
	// Enable loading more data
	var hasMoreOrderData = true.obs;
	var hasMoreWishlistData = true.obs;
	
	// Helper function to determine if more data can be loaded
	bool canLoadMoreOrders() {
		return hasMoreOrderData.value && !isOrderLoading.value;
	}
	bool canLoadMoreWishlists() {
		return hasMoreWishlistData.value && !isWishlistLoading.value;
	}
	
	Future<void> fetchOrders() async {
		if (!canLoadMoreOrders()) return;
		
		try {
		  isOrderLoading(true);
		  var response = await apiService.fetchMyOrder(currentOrderPage.value);

		  if (response['status'] == 200) {
			if (response['data'].isEmpty) {
				hasMoreOrderData.value = false;
			} else {
				orders.addAll(response['data']);
				currentOrderPage.value++;
			}
		  } else {
			Get.snackbar("Error", "Failed to load orders");
		  }
		} catch (e) {
		  Get.snackbar("Error", "Something went wrong");
		} finally {
		  isOrderLoading(false);
		}
	}
	Future<void> fetchWishlists() async {
		if (!canLoadMoreWishlists()) return;
		
		try {
		  isWishlistLoading(true);
		  var response = await apiService.fetchMyWishlist(currentWishlistPage.value);
		  
		  if (response['status'] == 200) {
			if (response['data'].isEmpty) {
				hasMoreWishlistData.value = false;
			} else {
				wishlist.addAll(response['data']);
				currentWishlistPage.value++;
			}			
		  } else {
			Get.snackbar("Error", "Failed to load wishlist");
		  }
		} catch (e) {
		  Get.snackbar("Error", "Something went wrong");
		} finally {
		  isWishlistLoading(false);
		}
	}
  
	void fetchOrderDetails(int orderId) async {
		try {
		  isDetailsLoading(true);
		  Map<String, dynamic> response = await apiService.fetchOrderDetails(orderId);
			print('ORDER ID is $orderId');
			print(response['data']);
		  orderDetails.value = OrderDetailsModel.fromJson(response['data']);
		} catch (e, stackTrace) {
    print("Error: $e\nStackTrace: $stackTrace");
		  SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: "Failed to fetch order details",
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isDetailsLoading(false);
		}
	}
	void fetchWishlistDetails(int orderId) async {
		try {
		  isDetailsLoading(true);
		  Map<String, dynamic> response = await apiService.fetchWishlistDetails(orderId);
		  print('WISHLIST ID is $orderId');
			print(response['data']);
		  wishlistDetails.value = WishlistDetailsModel.fromJson(response['data']);
		} catch (e, stackTrace) {
    print("Error: $e\nStackTrace: $stackTrace");
		  SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: "Failed to fetch order details",
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isDetailsLoading(false);
		}
	}
  
	Future<void> placeOrderPage() async {
	  isLoading.value = true;
	  Get.to(() => DeliveryAddressPage());
	  isLoading.value = false;
	}
	Future<void> placeWishlistOrderPage(int orderId) async {
	  isLoading.value = true;
	  //Get.to(() => WishlistDeliveryAddressPage());
	  Get.to(() => WishlistDeliveryAddressPage(), arguments: {'wishlist_id': orderId});
	  isLoading.value = false;
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
		
		//print(orderData);
		final response = await apiService.placeOrder(orderData);
		
		if (response['status'] == 200) {
			SnackbarHelper.showSuccessSnackbar(
			  title: "Order Placed",
			  message: response['data'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
			
			final orderId = response['order_id'].toString();
			
			// Clear cart after order placement
			cartController.cartItems.clear();
			cartController.totalPrice.value = 0.0;
			cartController.itemCount.value = 0;
			
			Get.to(() => ThankYouPage(orderId: orderId));	
		} else {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['data'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
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
	Future<void> placeWishlistOrder(int orderId) async {
	  try {
	    isDAloading.value = true;
		
		final Map<String, dynamic> orderData = {
			"address_id": selectedId.value, // Selected address ID
			"wishlist_id": orderId, // order id
			"payment_method": "cod", // Change based on user selection
		};	
		
		//print(orderData);
		final response = await apiService.placeWishlistOrder(orderData);
		
		if (response['status'] == 200) {
			SnackbarHelper.showSuccessSnackbar(
			  title: "Order Placed",
			  message: response['data'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
			
			final orderId = response['order_id'].toString();
			
			Get.to(() => ThankYouPage(orderId: orderId));	
		} else {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['data'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
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
	Future<void> payNowWishlist(int orderId) async {
	  isDAloading.value = true;
	  if (selectedId.value == null) {
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: 'Please select a delivery address', 
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }else{
	    // Call the function to place order
		await placeWishlistOrder(orderId);
	  }
	  isDAloading.value = false; 
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
