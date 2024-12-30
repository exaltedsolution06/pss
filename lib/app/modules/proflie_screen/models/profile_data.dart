// lib/app/modules/proflie_screen/models/profile_data.dart
class ProfileData {
  final String name;
  final String username;
  final String avatar;
  final int default_avatar;
  final String cover;
  final int default_cover;
  final String bio;
  final String birthdate;
  final String gender_pronoun;
  final String location;
  final String website;
  final int country_id;
  final int gender_id;
  final int user_verify;
  // Add other fields here if needed

  ProfileData({
	this.name = '',
	this.username = '',
	this.avatar = '',
	this.default_avatar = 0,
	this.cover = '',
	this.default_cover = 0,
	this.bio = '',
	this.birthdate = '',
	this.gender_pronoun = '',
	this.location = '',
	this.website = '',
	this.country_id = 0,
	this.gender_id = 0,
	this.user_verify = 0,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'] as String? ?? '', // Default value if null
      username: json['username'] as String? ?? '', // Default value if null
      avatar: json['avatar'] as String? ?? '', // Default value if null
      default_avatar: json['default_avatar'] as int? ?? 0, // Default value if null
      cover: json['cover'] as String? ?? '', // Default value if null
      default_cover: json['default_cover'] as int? ?? 0, // Default value if null
      bio: json['bio'] as String? ?? '', // Default value if null
      birthdate: json['birthdate'] as String? ?? '', // Default value if null
      gender_pronoun: json['gender_pronoun'] as String? ?? '', // Default value if null
      location: json['location'] as String? ?? '', // Default value if null
      website: json['website'] as String? ?? '', // Default value if null
      country_id: json['country_id'] as int? ?? 0, // Default value if null
      gender_id: json['gender_id'] as int? ?? 0, // Default value if null
	  user_verify: json['user_verify'] as int? ?? 0, // Default value if null
      // Parse other fields here if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'avatar': avatar,
      'default_avatar': default_avatar,
      'cover': cover,
      'default_cover': default_cover,
      'bio': bio,
      'birthdate': birthdate,
      'gender_pronoun': gender_pronoun,
      'location': location,
      'website': website,
      'country_id': country_id,
      'gender_id': gender_id,
      'user_verify': user_verify,
      // Convert other fields here if needed
    };
  }
}

class Gender {
  final int id;
  final String name;

  Gender({
    required this.id,
    required this.name,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      id: json['id'],
      name: json['gender_name'],
    );
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
