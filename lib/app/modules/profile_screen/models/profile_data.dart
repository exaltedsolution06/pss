// lib/app/modules/profile_screen/models/profile_data.dart
class ProfileData {
	final String first_name;
	final String last_name;
	final String email;
	final String avatar;
	final int default_avatar;
	final String company_name;
	final String birthdate;
	final String address;
	final String city;
	final String state;
	final int gender_id;
	final String latitude;
	final String longitude;
	final String zipcode;
	final String phone;
	// Add other fields here if needed

	ProfileData({
		this.first_name = '',
		this.last_name = '',
		this.email = '',
		this.avatar = '',
		this.default_avatar = 0,
		this.company_name = '',
		this.birthdate = '',
		this.address = '',
		this.city = '',
		this.state = '',
		this.gender_id = 0,
		this.latitude = '',
		this.longitude = '',
		this.zipcode = '',
		this.phone = '',
	});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
		first_name: json['first_name'] as String? ?? '', // Default value if null
		last_name: json['last_name'] as String? ?? '', // Default value if null
		email: json['email'] as String? ?? '', // Default value if null
		avatar: json['avatar'] as String? ?? '', // Default value if null
		default_avatar: json['default_avatar'] as int? ?? 0, // Default value if null
		company_name: json['company_name'] as String? ?? '', // Default value if null
		birthdate: json['birthdate'] as String? ?? '', // Default value if null
		address: json['address'] as String? ?? '', // Default value if null
		city: json['city'] as String? ?? '', // Default value if null
		state: json['state'] as String? ?? '', // Default value if null
		gender_id: json['gender_id'] as int? ?? 0, // Default value if null
		latitude: json['latitude'] as String? ?? '', // Default value if null
		longitude: json['longitude'] as String? ?? '', // Default value if null
		zipcode: json['zipcode'] as String? ?? '', // Default value if null
		phone: json['phone'] as String? ?? '', // Default value if null
      // Parse other fields here if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'avatar': avatar,
      'default_avatar': default_avatar,
      'company_name': company_name,
      'birthdate': birthdate,
      'address': address,
      'city': city,
      'state': state,
      'gender_id': gender_id,
      'latitude': latitude,
      'longitude': longitude,
      'zipcode': zipcode,
      'phone': phone,
      // Convert other fields here if needed
    };
  }
}