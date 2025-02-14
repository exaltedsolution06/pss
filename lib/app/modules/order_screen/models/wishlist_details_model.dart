class WishlistDetailsModel {
  final int orderId;
  final String customerName;
  final String customerEmail;
  final String customerAddress;
  final List<OrderItemModel> items;
  final double totalPrice;

  WishlistDetailsModel({
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.customerAddress,
    required this.items,
    required this.totalPrice,
  });

  factory WishlistDetailsModel.fromJson(Map<String, dynamic> json) {
    return WishlistDetailsModel(
      orderId: json['wistlist_id'],
      customerName: json['customers_name'],
      customerEmail: json['customers_email'],
      customerAddress: json['customers_address'],
      totalPrice: (json['final_amount'] as num).toDouble(),
      items: (json['wistlist_items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }
}

class OrderItemModel {
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItemModel({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['product_name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      imageUrl: json['image_url'],
    );
  }
}
