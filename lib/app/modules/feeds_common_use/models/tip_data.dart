class TipData {
	final int available_credit;
	final String first_name;
	final String last_name;
	final int country_id;
	final String city;
	final String state;
	final String postcode;
	final String address;

	TipData({
		this.available_credit = 0, 
		this.first_name = '', 
		this.last_name = '', 
		this.country_id = 0,
		this.city = '',
		this.state = '',
		this.postcode = '',
		this.address = '',
	});
	factory TipData.fromJson(Map<String, dynamic> json) {
		return TipData(
			available_credit: json['available_credit'] as int? ?? 0,
			first_name: json['first_name'] as String? ?? '',
			last_name: json['last_name'] as String? ?? '',
			country_id: json['country_id'] as int? ?? 0,
			city: json['city'] as String? ?? '',
			state: json['state'] as String? ?? '',
			postcode: json['postcode'] as String? ?? '',
			address: json['address'] as String? ?? '',
		);
	}
	Map<String, dynamic> toJson() {
		return {
		  'available_credit': available_credit,
		  'first_name': first_name,
		  'last_name': last_name,
		  'country_id': country_id,
		  'city': city,
		  'state': state,
		  'postcode': postcode,
		  'address': address
		  // Convert other fields here if needed
		};
	}
}

class Country {
  final int id;
  final String name;

  Country({
    required this.id,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
    );
  }
}
