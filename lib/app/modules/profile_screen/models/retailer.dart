class Retailer {
  final int id;
  final String name;

  Retailer({required this.id, required this.name});

  factory Retailer.fromJson(Map<String, dynamic> json) {
    return Retailer(
      id: json['id'],
      name: json['name'],
    );
  }
}
