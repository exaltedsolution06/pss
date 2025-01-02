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


class DeliveryAddressPage extends StatefulWidget {
  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {


  final OrderController orderController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  List<Map<String, dynamic>> addressLists = [
    {
      "id": 1,
      "name": "Home",
      "phone": "123456789",
      "address": "test my addresss 1",
    },
    {
      "id": 2,
      "name": "Office",
      "phone": "987654321",
      "address": "test my addresss 2",
    },
  ];


  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
	final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body: Form(
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
								  child: Column(
									mainAxisSize: MainAxisSize.min, // Adjust the width of the row to fit its children
									children: [
									  Text(
										"Total",
										textAlign: TextAlign.right,
										style: TextStyle(
										  fontSize: 16,
										  color: AppColor.SecondaryGreyscale,
										),
									  ),
									  SizedBox(height: 8), // Adds space between the icon and the text
									  Text(
										"Add more",
										textAlign: TextAlign.right,
										style: TextStyle(
										  fontSize: 16,
										  color: AppColor.black,
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
					itemCount: addressLists.length,
					itemBuilder: (context, index) {
					  final item = addressLists[index];
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
								  // Rdaio
								  
								  const SizedBox(width: 16),
								  // Item Details
								  Expanded(
									child: Column(
									  crossAxisAlignment: CrossAxisAlignment.start,
									  children: [
										Text(
										  item["name"],
										  style: const TextStyle(
											fontWeight: FontWeight.bold,
											fontSize: 16,
										  ),
										),
										const SizedBox(height: 4),
										Text(
										  item["phone"],
										  style: const TextStyle(
											fontSize: 14,
											color: Colors.grey,
										  ),
										),
										const SizedBox(height: 4),
										Text(
										  item["address"],
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
										icon: const Icon(Icons.edit, color: Colors.green),
										onPressed: () {
										  setState(() {
											
										  });
										},
									  ),
									],
								  ),
								],
							  ),
							),
						  ),
						  // Cross Icon Positioned at the Top Right Corner
						  Positioned(
							  top: 13,
							  right: 22,
							  child: GestureDetector(
								onTap: () {
								  setState(() {
									addressLists.removeAt(index); // Remove the item
								  });
								},
								child: Container(
								  width: 18,
								  height: 18,
								  decoration: BoxDecoration(
									color: Colors.transparent, // Transparent background
									shape: BoxShape.circle, // Circular shape
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
							"Payment Method",
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
									"Rs. dsfs",
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
					onPress: orderController.isLoading.value
						? null
						: () {
							if (_formKey.currentState!.validate()) {
							  orderController.placeOrder(
							  );
							} else {
							}
						  },
				  );
				}),
			  ),
			),
					
        ],
      ),
	  ),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 3),
    );
  }
}

