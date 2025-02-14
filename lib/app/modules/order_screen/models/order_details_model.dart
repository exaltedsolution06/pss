class OrderDetailsModel {
  final int orderId;
  final String customerName;
  final String customerEmail;
  final String customerAddress;
  final String retailerName;
  final String retailerEmail;
  final String retailerPhone;
  final String retailerAddress;
  final List<OrderItemModel> items;
  final double totalPrice;

  OrderDetailsModel({
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.customerAddress,
    required this.retailerName,
    required this.retailerEmail,
    required this.retailerPhone,
    required this.retailerAddress,
    required this.items,
    required this.totalPrice,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      orderId: json['order_id'],
      customerName: json['customers_name'],
      customerEmail: json['customers_email'],
      customerAddress: json['customers_address'],
      retailerName: json['retailer_name'],
      retailerEmail: json['retailer_email'],
      retailerPhone: json['retailer_phone'],
      retailerAddress: json['retailer_address'],
      totalPrice: (json['final_amount'] as num).toDouble(),
      items: (json['order_items'] as List)
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
