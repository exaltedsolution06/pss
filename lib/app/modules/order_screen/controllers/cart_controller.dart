import 'package:get/get.dart';

class CartController extends GetxController {
   var cartItems = <int, dynamic>{}.obs;
   var quantity = 0.obs; // Example observable for quantity

  // Add to cart
  void addToCart(int product_id, String imageUrl, String product_name, String price) {
    //double parsedPrice = double.tryParse(price) ?? 0.0; // Convert price to double

    if (cartItems.containsKey(product_id)) {
      cartItems.update(product_id, (existingItem) => {
            'product_id': existingItem['product_id'],
            'product_name': existingItem['product_name'],
            'imageUrl': existingItem['imageUrl'],
            'quantity': (existingItem['quantity'] as int) + 1,
            'price': existingItem['price'], // Keep existing price
          });
    } else {
      cartItems[product_id] = {
        'product_id': product_id,
        'product_name': product_name,
        'imageUrl': imageUrl,
        'quantity': 1,
        'price': price, // Store price as double
      };
    }
  }

	// Update quantity
	void updateQuantity(int product_id, int quantity) {
	  print("Update Quantity Called");
	  print("Update Quantity product_id: $product_id");
	  print("Update Quantity quantity: $quantity");

	  if (cartItems.containsKey(product_id)) {
		var existingItem = cartItems[product_id];

		// Safely accessing fields to avoid null errors
		String productName = existingItem?['product_name'] ?? "Unknown Product";
		String imageUrl = existingItem?['imageUrl'] ?? "";
		String price = existingItem?['price'] ?? '';
		//double price = existingItem?['price'] ?? 0.0;

		if (quantity > 0) {
		  cartItems.update(product_id, (existingItem) => {
			'product_id': product_id,
			'product_name': productName,
			'imageUrl': imageUrl,
			'quantity': quantity,
			'price': price,
		  });
		} else {
		  cartItems.remove(product_id); // Remove item if quantity is 0
		}

		print("Cart Items: $cartItems");
	  } else {
		print("Product ID $product_id not found in cart");
	  }
	}




  // Remove from cart
  void removeFromCart(int product_id) {
    if (cartItems.containsKey(product_id)) {
      int currentQuantity = cartItems[product_id]!['quantity'];
      if (currentQuantity > 1) {
        cartItems.update(product_id, (existingItem) => {
              'quantity': (existingItem['quantity'] as int) - 1
            });
      } else {
        cartItems.remove(product_id); // Remove item if quantity reaches 0
      }
    }
  }

	// Get total price
	double get totalPrice => cartItems.entries.fold(
	  0, 
	  (sum, item) {
		final price = double.tryParse(item.value['price'].toString()) ?? 0.0;
		final quantity = item.value['quantity'] as int;
		return sum + (quantity * price);
	  }
	);

}
