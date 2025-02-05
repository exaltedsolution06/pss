import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';

import '../controllers/order_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {


  final OrderController orderController = Get.find();
  final CartController cartController = Get.find<CartController>();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
	final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Obx(() {
			return Form(
                key: _formKey,
                child: Column(
        children: [
			Padding(
				padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("2 Items in your cart", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-Regular')),
								GestureDetector(
								  onTap: () {
									//Get.toNamed(Routes.YOUR_TARGET_PAGE); // Replace with your desired route
								  },
								  child: Row(
									mainAxisSize: MainAxisSize.min, // Adjust the width of the row to fit its children
									children: [
									  Icon(
										Icons.add, // Use the desired icon
										color: AppColor.purple,
									  ),
									  SizedBox(width: 8), // Adds space between the icon and the text
									  Text(
										"Add more",
										textAlign: TextAlign.right,
										style: TextStyle(
										  fontSize: 16,
										  color: AppColor.purple,
										),
									  ),
									],
								  ),
								),
							],
						),
					],
				),
			),
			Expanded(
		  child: ListView.builder(
  itemCount: cartController.cartItems.length,
  itemBuilder: (context, index) {
    final itemKey = cartController.cartItems.keys.toList()[index];
    final item = cartController.cartItems[itemKey];
	
	int quantity = item?['quantity'] ?? 0;
	
//print("cart List: cartItems");
    return Stack(
      children: [
        // Main Card
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 3,
          color: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Image
                ClipRRect(
					borderRadius: BorderRadius.circular(8),
					child: Image.network(
						item["imageUrl"] ?? "https://via.placeholder.com/60",
						width: 60,
						height: 60,
						fit: BoxFit.cover,
						errorBuilder: (context, error, stackTrace) {
							return Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
						},
					),
                ),
                const SizedBox(width: 16),
                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
						
                      Text(
                        item["product_name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rs. ${item["price"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                // Quantity Controls
                Row(
                  children: [
					IconButton(
					  icon: const Icon(Icons.remove_circle, color: Colors.red),
					  onPressed: () {
						// Check if product_id and quantity are not null before calling the update
						final productIdM = item["product_id"];
						final quantityM = item["quantity"];
						
						if (productIdM != null && quantityM != null && quantityM > 1) {
							cartController.updateQuantity(productIdM, quantityM - 1);
						} else if (productIdM == null) {
							print("Click Minus - Product ID is null");
						} else if (quantityM == null) {
							print("Click Minus - quantityM is null");
						} else {
							cartController.updateQuantity(productIdM, 0);
							print("Click Minus - Product ID or quantityM is null");
						}
					  },
					),
					Text(
						item["quantity"].toString(),
						style: const TextStyle(
							fontSize: 16,
							fontWeight: FontWeight.bold,
						),
					),
                    IconButton(
					  icon: const Icon(Icons.add_circle, color: Colors.green),
					  onPressed: () {
						// Check if product_id and quantity are not null before calling the update
						final productId = item["product_id"];
						final quantity = item["quantity"];
						
						if (productId != null && quantity != null) {
						  cartController.updateQuantity(productId, quantity + 1);
						} else if (productId == null) {
						  print("Click Plus - Product ID is null");
						} else if (quantity == null) {
						  print("Click Plus - Quantity is null");
						} else {
						  print("Click Plus - Product ID or Quantity is null");
						}
					  },
					),


                  ],
                ),
              ],
            ),
          ),
        ),
        // Remove Item (Cross Icon)
        Positioned(
          top: 13,
          right: 22,
          child: GestureDetector(
            onTap: () {
              cartController.updateQuantity(item["product_id"], 0); // Removes item
            },
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.transparent, // Transparent background
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.BlackGreyscale, // Border color
                  width: 1, // Border width
                ),
              ),
              child: const Icon(
                Icons.close,
                color: AppColor.BlackGreyscale,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  },
),

		),

		Padding(
				padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							"Payment Summary",
							style: TextStyle(
								fontSize: 18,
								color: AppColor.black,
								fontFamily: 'Urbanist-semibold'
							),
						),
						const SizedBox(height: 10),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("Order Total", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.SecondaryGreyscale)),
								Text(
									"Rs. ${cartController.totalPrice.toStringAsFixed(2)}",
									textAlign: TextAlign.right,
									style: TextStyle(
										fontSize: 16,
										color: AppColor.black,
										fontFamily: 'Urbanist-semibold'
									),
								),
							],
						),
						const SizedBox(height: 5),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("Items Discount", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.SecondaryGreyscale)),
								Text(
									"-Rs. 20",
									textAlign: TextAlign.right,
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.black,
									  fontFamily: 'Urbanist-semibold'
									),
								),
							],
						),
						const SizedBox(height: 5),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("Coupon Discount", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.SecondaryGreyscale)),
								Text(
									"-Rs. 0",
									textAlign: TextAlign.right,
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.black,
									  fontFamily: 'Urbanist-semibold'
									),
								),
							],
						),
						const SizedBox(height: 5),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("Shipping", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.SecondaryGreyscale)),
								Text(
									"Free",
									textAlign: TextAlign.right,
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.black,
									  fontFamily: 'Urbanist-semibold'
									),
								),
							],
						),
						const SizedBox(height: 5),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("Total", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.black)),
								Text(
									"Rs. ${cartController.totalPrice.toStringAsFixed(2)}",
									textAlign: TextAlign.right,
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.black,
									  fontFamily: 'Urbanist-semibold'
									),
								),
							],
						),
					],
				),
			),

			Padding(
			  padding: const EdgeInsets.only(bottom: 16, top: 16),
			  child: Center(
				child: Obx(() {
				  return autoWidthBtn(
					text: orderController.isLoading.value ? 'Placing...' : Appcontent.placeOrder,
					width: screenWidth,
					onPress: () {
						orderController.placeOrder();
					},
				  );
				}),
			  ),
			),
					
        ],
      ),
	  );
	  }),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 3),
    );
  }
}

