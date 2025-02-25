import 'package:get/get.dart';

class CartController extends GetxController {
	var cartItems = <int, dynamic>{}.obs;
	var totalPrice = 0.0.obs; // Make totalPrice observable
	var itemCount = 0.obs; // Observable variable for the cart item count

  // Add to cart
  void addToCart(int product_id, String imageUrl, String image_id, String product_name, String price) {
	double parsedPrice = double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0; // Remove non-numeric characters
	int parsedImageId = int.tryParse(image_id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (cartItems.containsKey(parsedImageId)) {
      cartItems.update(parsedImageId, (existingItem) => {
            'product_id': existingItem['product_id'],
            'product_name': existingItem['product_name'],
            'imageUrl': existingItem['imageUrl'],
            'image_id': existingItem['image_id'],
            'quantity': (existingItem['quantity'] as int) + 1,
            'price': existingItem['price'],
          });
    } else {
      cartItems[parsedImageId] = {
        'product_id': product_id,
        'product_name': product_name,
        'imageUrl': imageUrl,
        'image_id': image_id,
        'quantity': 1,
        'price': parsedPrice,
      };
	  itemCount.value++; // Increment the item count whenever an item is added
    }
    calculateTotalPrice(); // Update total price
  }

  // Update quantity
  void updateQuantity(int product_id, String image_id, int quantity) {
	int parsedImageId = int.tryParse(image_id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (cartItems.containsKey(parsedImageId)) {
      var existingItem = cartItems[parsedImageId];

      if (quantity > 0) {
        cartItems.update(parsedImageId, (existingItem) => {
              'product_id': existingItem?['product_id'],
              'product_name': existingItem?['product_name'],
              'imageUrl': existingItem?['imageUrl'],
              'image_id': existingItem?['image_id'],
              'quantity': quantity,
              'price': existingItem?['price'],
            });
      } else {
        cartItems.remove(parsedImageId);
		itemCount.value--; // Decreament the item count whenever an item is removed
      }
      calculateTotalPrice(); // Update total price
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
        cartItems.remove(product_id);
		itemCount.value--; // Decreament the item count whenever an item is removed
      }
      calculateTotalPrice(); // Update total price
    }
  }

	// Calculate total price and update observable value
	void calculateTotalPrice() {
	  double total = 0.0;
	  cartItems.forEach((key, item) {
		print("Raw price: ${item['price']}"); // Debugging
		double price = item['price'] is double ? item['price'] : double.tryParse(item['price'].toString()) ?? 0.0;
		print("Parsed price: $price"); // Check the output
		int quantity = item['quantity'] as int;
		total += price * quantity;
	  });
	  totalPrice.value = total;
	}

}
