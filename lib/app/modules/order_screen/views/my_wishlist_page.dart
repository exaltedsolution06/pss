import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';

class MyWishlistPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController(ApiService()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Wishlist")),
      body: Obx(() {
        if (orderController.isWishlistLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (orderController.wishlist.isEmpty) {
          return Center(child: Text("No wishlist found"));
        }

        return ListView.builder(
          itemCount: orderController.wishlist.length,
          itemBuilder: (context, index) {
            var wishlist = orderController.wishlist[index];
			return GestureDetector(
				onTap: () {
				  Get.toNamed(
					  Routes.WISHLIST_DETAILS,
					  arguments: {'wishlist_id': wishlist['order_id']},
				  );
				},
				child: Card(
				  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
				  child: ListTile(
					leading: ClipRRect(
					  borderRadius: BorderRadius.circular(8.0),
					  child: Image.network(
						wishlist['image'],
						width: 50,
						height: 50,
						fit: BoxFit.cover,
						errorBuilder: (context, error, stackTrace) {
						  return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
						},
					  ),
					),
					title: Text("Final Amount: \$${wishlist['final_amount']}"),
					subtitle: Text("Order Date: ${wishlist['order_date']}"),
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
