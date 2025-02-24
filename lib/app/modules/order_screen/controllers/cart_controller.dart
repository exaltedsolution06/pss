import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <int, List<Map<String, dynamic>>>{}.obs;
  var totalPrice = 0.0.obs;
  var itemCount = 0.obs;

  // Add to cart
  void addToCart(int product_id, String imageUrl, String product_name, String price) {
    double parsedPrice = double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

    if (cartItems.containsKey(product_id)) {
      // Check if same image exists
      int index = cartItems[product_id]!.indexWhere((item) => item['imageUrl'] == imageUrl);
      
      if (index != -1) {
        // If the same image exists, increase quantity
        cartItems[product_id]![index]['quantity'] += 1;
      } else {
        // If a new image is added, store it separately under the same product_id
        cartItems[product_id]!.add({
          'product_id': product_id,
          'product_name': product_name,
          'imageUrl': imageUrl,
          'quantity': 1,
          'price': parsedPrice,
        });
      }
    } else {
      // Create a new list if the product_id is new
      cartItems[product_id] = [
        {
          'product_id': product_id,
          'product_name': product_name,
          'imageUrl': imageUrl,
          'quantity': 1,
          'price': parsedPrice,
        }
      ];
    }

    itemCount.value++; 
    calculateTotalPrice();
  }

  // Update quantity
  void updateQuantity(int product_id, String imageUrl, int quantity) {
    if (cartItems.containsKey(product_id)) {
      int index = cartItems[product_id]!.indexWhere((item) => item['imageUrl'] == imageUrl);
      
      if (index != -1) {
        if (quantity > 0) {
          cartItems[product_id]![index]['quantity'] = quantity;
        } else {
          cartItems[product_id]!.removeAt(index);
          itemCount.value--; // Decrease item count when removed
        }

        // If all images for a product are removed, delete the product_id
        if (cartItems[product_id]!.isEmpty) {
          cartItems.remove(product_id);
        }

        calculateTotalPrice();
      }
    }
  }

  // Remove from cart
  void removeFromCart(int product_id, String imageUrl) {
    if (cartItems.containsKey(product_id)) {
      int index = cartItems[product_id]!.indexWhere((item) => item['imageUrl'] == imageUrl);
      
      if (index != -1) {
        int currentQuantity = cartItems[product_id]![index]['quantity'];

        if (currentQuantity > 1) {
          cartItems[product_id]![index]['quantity'] -= 1;
        } else {
          cartItems[product_id]!.removeAt(index);
          itemCount.value--; 
        }

        // If all images for a product are removed, delete the product_id
        if (cartItems[product_id]!.isEmpty) {
          cartItems.remove(product_id);
        }

        calculateTotalPrice();
      }
    }
  }

  // Calculate total price
  void calculateTotalPrice() {
    double total = 0.0;
    
    cartItems.forEach((key, itemList) {
      for (var item in itemList) {
        double price = item['price'] is double ? item['price'] : double.tryParse(item['price'].toString()) ?? 0.0;
        int quantity = item['quantity'] as int;
        total += price * quantity;
      }
    });

    totalPrice.value = total;
  }
}
