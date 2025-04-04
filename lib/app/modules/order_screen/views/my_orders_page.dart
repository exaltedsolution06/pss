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

	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	
  @override
  void initState() {
    super.initState();
    orderController.fetchOrders();
  }
  
  _MyOrdersState() {
		// Vertical Scroll Listener
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				orderController.fetchOrders();  // Load more data on vertical scroll
			}
		});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  appBar: AppBar(
		title: Text("My Orders", style: TextStyle(fontSize: 20)),
		centerTitle: true,
	  ),
      body: Obx(() {
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (_verticalScrollController.hasClients && _verticalScrollController.position.maxScrollExtent == 0) {
			  orderController.fetchOrders();
			}
		});
			  
        if (orderController.isOrderLoading.value && orderController.orders.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (orderController.orders.isEmpty) {
          return Center(child: Text("No orders found"));
        }

        return ListView.builder(
		  controller: _verticalScrollController,
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
			if (index == orderController.orders.length) {
              // Show loader at bottom when more data is loading
              return orderController.isOrderLoading.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox.shrink();
            }
			
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
