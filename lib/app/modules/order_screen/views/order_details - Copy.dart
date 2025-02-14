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
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';


class OrderDetailsPage extends StatefulWidget {
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {


  final HomeController homeController = Get.find();
  final OrderController orderController = Get.find();
  final CartController cartController = Get.find<CartController>();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
	final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Obx(() {
		return Form(
                key: _formKey,
                child: Column(
        children: [
		Expanded(
			child: ListView.builder(
			  itemCount: cartController.cartItems.length,
			  itemBuilder: (context, index) {
				final itemKey = cartController.cartItems.keys.toList()[index];
				final item = cartController.cartItems[itemKey];
				
				int quantity = item?['quantity'] ?? 0;
				
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
									"\$${item["price"]}",
									style: const TextStyle(
									  fontWeight: FontWeight.w500,
									  fontSize: 14,
									  color: Colors.red,
									),
								  ),
								],
							  ),
							),
						  ],
						),
					  ),
					),
				  ],
				);
			  },
			),
		),
		Container(
		  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
		  padding: const EdgeInsets.all(12),
		  decoration: BoxDecoration(
			color: Colors.white,
			borderRadius: BorderRadius.circular(12),
			boxShadow: [
			  BoxShadow(
				color: Colors.black.withOpacity(0.1),
				blurRadius: 5,
				spreadRadius: 1,
				offset: const Offset(0, 3),
			  ),
			],
		  ),
		  child: Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
			  const Text(
				"Delivery Address",
				style: TextStyle(
				  fontSize: 18,
				  fontWeight: FontWeight.bold,
				  fontFamily: 'Urbanist-semibold',
				),
			  ),
			  const SizedBox(height: 8),
			  Row(
				children: [
				  const Icon(Icons.location_on, color: Colors.redAccent),
				  const SizedBox(width: 8),
				  Expanded(
					child: Text(
					  "John Doe\n123 Main Street, Apt 4B\nNew York, NY 10001, USA",
					  style: TextStyle(
						fontSize: 16,
						color: AppColor.black,
						fontFamily: 'Urbanist-regular',
					  ),
					),
				  ),
				],
			  ),
			  const SizedBox(height: 8),
			  Row(
				children: [
				  const Icon(Icons.phone, color: Colors.blueAccent),
				  const SizedBox(width: 8),
				  Text(
					"+1 123 456 7890",
					style: TextStyle(
					  fontSize: 16,
					  color: AppColor.black,
					  fontFamily: 'Urbanist-regular',
					),
				  ),
				],
			  ),
			],
		  ),
		),
		if (cartController.cartItems.isNotEmpty) ...[
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
									"\$${cartController.totalPrice.value.toStringAsFixed(2)}",
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
								Obx(() => Text(
									"\$${cartController.totalPrice.value.toStringAsFixed(2)}",
									textAlign: TextAlign.right,
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.black,
									  fontFamily: 'Urbanist-semibold'
									),
								)),
							],
						),
					],
				),
			),
			]
        ],
		),
		);
	  }),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }
}

