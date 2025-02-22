import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  State<MyOrdersPage> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrdersPage> {
  final OrderController orderController = Get.put(OrderController(ApiService()));

  @override
  void initState() {
    super.initState();
    orderController.fetchOrders();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  appBar: AppBar(
		title: Text("My Orders", style: TextStyle(fontSize: 20)),
		centerTitle: true,
	  ),
      body: Obx(() {
        if (orderController.isOrderLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (orderController.orders.isEmpty) {
          return Center(child: Text("No orders found"));
        }

        return ListView.builder(
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            var order = orderController.orders[index];
			return GestureDetector(
				onTap: () {
				  Get.toNamed(
					  Routes.ORDER_DETAILS,
					  arguments: {'order_id': order['order_id']},
				  );
				},
				child: Card(
				  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
				  child: ListTile(
					leading: ClipRRect(
					  borderRadius: BorderRadius.circular(8.0),
					  child: Image.network(
						order['image'],
						width: 50,
						height: 50,
						fit: BoxFit.cover,
						errorBuilder: (context, error, stackTrace) {
						  return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
						},
					  ),
					),
					title: Text("Final Amount: \$${order['final_amount']}"),
					subtitle: Text("Order Date: ${order['order_date']}"),
				  ),
				),
			);
          },
        );
      }),	  
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }
}
