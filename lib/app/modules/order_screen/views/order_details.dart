import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/order_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController(ApiService()));

  @override
  Widget build(BuildContext context) {
    final int orderId = Get.arguments['order_id']; // Replace with dynamic order ID
    orderController.fetchOrderDetails(orderId);

    return Scaffold(
	  appBar: AppBar(
		title: Text("Order Details", style: TextStyle(fontSize: 20)),
		centerTitle: true,
	  ),
	  body: Obx(() {
		if (orderController.isDetailsLoading.value) {
		  return Center(child: CircularProgressIndicator());
		}

		final order = orderController.orderDetails.value;
		if (order == null) {
		  return Center(child: Text("No order details available"));
		}

		return SingleChildScrollView(
		  child: Padding(
			padding: EdgeInsets.all(16),
			child: Column(
			  crossAxisAlignment: CrossAxisAlignment.start,
			  children: [
				// Order Details Card
				SizedBox(
				  width: double.infinity,
				  child: Card(
					elevation: 3,
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
					child: Padding(
					  padding: EdgeInsets.all(16),
					  child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
						  Text("Order ID: ${order.orderId}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
						  SizedBox(height: 5),
						  Text("Customer: ${order.customerName}", style: TextStyle(fontSize: 16)),
						  Text("Email: ${order.customerEmail}", style: TextStyle(fontSize: 16)),
						  Text("Phone: ${order.deliveryPhone}", style: TextStyle(fontSize: 16)),
						  Text("Delivery Address: ${order.deliveryAddress}", style: TextStyle(fontSize: 16, color: Colors.grey)),
						],
					  ),
					),
				  ),
				),
				SizedBox(height: 20),

				// Retailer Details
				SizedBox(
				  width: double.infinity,
				  child: Card(
					elevation: 3,
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
					child: Padding(
					  padding: EdgeInsets.all(16),
					  child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
						  Text("Retailer Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
						  SizedBox(height: 5),
						  Text("Name: ${order.retailerName}", style: TextStyle(fontSize: 16)),
						  Text("Email: ${order.retailerEmail}", style: TextStyle(fontSize: 16)),
						  Text("Phone: ${order.retailerPhone}", style: TextStyle(fontSize: 16)),
						  Text("Address: ${order.retailerAddress}", style: TextStyle(fontSize: 16, color: Colors.grey)),
						],
					  ),
					),
				  ),
				),
				SizedBox(height: 20),

				// Order Items List
				Text("Ordered Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
				SizedBox(height: 10),

				// Wrapping ListView inside a `Container` with a fixed height
				ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Adjust the height as needed
				  itemCount: order.items.length,
				  itemBuilder: (context, index) {
					final item = order.items[index];
					return Card(
					  elevation: 2,
					  margin: EdgeInsets.only(bottom: 10),
					  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
					  child: ListTile(
						leading: ClipRRect(
						  borderRadius: BorderRadius.circular(8),
						  child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
						),
						title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
						subtitle: Column(
						  crossAxisAlignment: CrossAxisAlignment.start,
						  children: [
							Text("\$${item.price}", style: TextStyle(color: Colors.green, fontSize: 16)),
							Text("Quantity: ${item.quantity}", style: TextStyle(fontSize: 14, color: Colors.black54)),
						  ],
						),
					  ),
					);
				  }
				),

				SizedBox(height: 20),

				// Bottom Total Price Section
				Container(
				  padding: EdgeInsets.all(16),
				  decoration: BoxDecoration(
					color: Colors.white,
					border: Border(top: BorderSide(color: Colors.grey.shade300)),
				  ),
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
					  Text("Total Price: \$${order.totalPrice}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
					  SizedBox(height: 5),
					  Text("Final Total: \$${order.totalPrice}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
					],
				  ),
				),
			  ],
			),
		  ),
		);
	  }),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
	);
  }
}
