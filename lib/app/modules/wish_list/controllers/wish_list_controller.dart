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
	var wishListEntries = <Map<String, String>>[].obs;	
	final CartController cartController = Get.find<CartController>();
	
	void addEntry(Map<String, String> entry) {
		wishListEntries.add(entry);
	}
  
	//Future<void> wishListCreate(String email, String relationship, String birthday, String anniversary) async {
	//Future<void> wishListCreate(String grandfatherEmail, String grandfatherPhone, String grandmotherEmail, String grandmotherPhone, String motherEmail, String motherPhone, String fatherEmail, String fatherPhone, String spouseEmail, String spousePhone, String brotherEmail, String brotherPhone, String sisterEmail, String sisterPhone, String sonEmail, String sonPhone, String daughterEmail, String daughterPhone, String grandsonEmail, String grandsonPhone, String granddaughterEmail, String granddaughterPhone, String friendEmail, String friendPhone, String birthday, String anniversary) async {
	
	void wishListCreate(List<Map<String, dynamic>> w_entries) async {
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
		
		// Step 1: Create contact list
		/*final List<Map<String, String>> contacts = [
		  {"relation": "grandfather", "email": grandfatherEmail, "phone": grandfatherPhone},
		  {"relation": "grandmother", "email": grandmotherEmail, "phone": grandmotherPhone},
		  {"relation": "mother", "email": motherEmail, "phone": motherPhone},
		  {"relation": "father", "email": fatherEmail, "phone": fatherPhone},
		  {"relation": "spouse", "email": spouseEmail, "phone": spousePhone},
		  {"relation": "brother", "email": brotherEmail, "phone": brotherPhone},
		  {"relation": "sister", "email": sisterEmail, "phone": sisterPhone},
		  {"relation": "son", "email": sonEmail, "phone": sonPhone},
		  {"relation": "daughter", "email": daughterEmail, "phone": daughterPhone},
		  {"relation": "grandson", "email": grandsonEmail, "phone": grandsonPhone},
		  {"relation": "granddaughter", "email": granddaughterEmail, "phone": granddaughterPhone},
		  {"relation": "friend", "email": friendEmail, "phone": friendPhone},
		];*/
		
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
			// "email_address": email, // Selected email
			// "relationship": relationship, // Selected relationship
			//"birthday": birthday, // Selected birthday
			//"anniversary": anniversary, // Selected anniversary
			"cart_items": cartData, // Cart items list
			"total_amount": cartController.totalPrice.value, // Total price of the cart
			"payment_method": "cod", // Change based on user selection
			"contacts": w_entries,
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
			
			wishListEntries.clear();
			
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
