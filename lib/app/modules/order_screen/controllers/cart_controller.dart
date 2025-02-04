import 'package:get/get.dart';

class CartController extends GetxController {
	//var cartItems = <String, Map<String, dynamic>>{}.obs;
	var cartItems = <String, dynamic>{}.obs; // Ensure it's initialized
	// add to cart
	void addToCart(String imageUrl, String product, String price) {
		if (cartItems.containsKey(product)) {
			cartItems[product]!['quantity'] += 1;
		} else {
			cartItems[product] = {'imageUrl': imageUrl, 'quantity': 1, 'price': price};
		}
	}

	void updateQuantity(String product, int quantity) {
		if (quantity > 0) {
			cartItems[product]!['quantity'] = quantity;
		} else {
			cartItems.remove(product);
		}
	}
	void removeFromCart(String product) {
		if (cartItems.containsKey(product)) {
			cartItems[product] = cartItems[product]! - 1;
			if (cartItems[product] == 0) cartItems.remove(product);
		}
	}

	double get totalPrice => cartItems.entries
      .fold(0, (sum, item) => sum + (item.value['quantity'] * item.value['price']));
}
