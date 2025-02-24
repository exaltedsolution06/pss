import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';

class MyWishlistPage extends StatefulWidget {
  @override
  State<MyWishlistPage> createState() => _MyWishlistState();
}

class _MyWishlistState extends State<MyWishlistPage> {
  final OrderController orderController = Get.put(OrderController(ApiService()));

	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	
  @override
  void initState() {
    super.initState();
    orderController.fetchWishlists();
  }
  
  _MyWishlistState() {
		// Vertical Scroll Listener
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				orderController.fetchWishlists();  // Load more data on vertical scroll
			}
		});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  appBar: AppBar(
		title: Text("My Wishlist", style: TextStyle(fontSize: 20)),
		centerTitle: true,
	  ),
      body: Obx(() {
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (_verticalScrollController.hasClients && _verticalScrollController.position.maxScrollExtent == 0) {
			  orderController.fetchWishlists();
			}
		});
		
        if (orderController.isWishlistLoading.value && orderController.wishlist.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (orderController.wishlist.isEmpty) {
          return Center(child: Text("No wishlist found"));
        }

        return ListView.builder(
		  controller: _verticalScrollController,
          itemCount: orderController.wishlist.length,
          itemBuilder: (context, index) {
		    if (index == orderController.wishlist.length) {
              // Show loader at bottom when more data is loading
              return orderController.isWishlistLoading.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox.shrink();
            }
			
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
