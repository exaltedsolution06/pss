import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/views/thank_you_wishlist.dart';
import 'package:picturesourcesomerset/app/modules/wish_list/controllers/wish_list_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';

class WishListController extends GetxController {
	final ApiService apiService;
	var isLoading = false.obs;  // RxBool
	WishListController(this.apiService);
		
	final CartController cartController = Get.find<CartController>();
	
	Future<void> wishListCreate(String email, String relationship, String birthday, String anniversary) async {
	  try {
		isLoading.value = true;
		
		if (cartController.cartItems.isEmpty) {
		  SnackbarHelper.showErrorSnackbar(
			title: "Cart Empty",
			message: "Your cart is empty. Please add items before wishlist an order.",
			position: SnackPosition.BOTTOM, // Custom position
		  );
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
			"email_address": email, // Selected email
			"relationship": relationship, // Selected relationship
			"birthday": birthday, // Selected birthday
			"anniversary": anniversary, // Selected anniversary
			"cart_items": cartData, // Cart items list
			"total_amount": cartController.totalPrice.value, // Total price of the cart
			"payment_method": "cod", // Change based on user selection
		};
		
		final response = await apiService.wishlistOrder(orderData);
		
		if (response['status'] == 200) {
			SnackbarHelper.showSuccessSnackbar(
			  title: "Order Wishlist",
			  message: response['data'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
			
			final orderId = response['order_id'].toString();
			
			// Clear cart after order placement
			cartController.cartItems.clear();
			cartController.totalPrice.value = 0.0;
			cartController.itemCount.value = 0;
			
			Get.to(() => ThankYouWishlistPage(orderId: orderId));	
		} else {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['data'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	  } catch (e) {
		print('Error wishlist order: $e');
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: 'Error placing order: $e',
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  } finally {
		isLoading.value = false;
	  }
	}
}
