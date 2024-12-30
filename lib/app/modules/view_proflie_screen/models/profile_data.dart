// lib/app/modules/proflie_screen/models/profile_data.dart
class ProfileData {
	final int id;
	final String name;
	final String username;
	final String avatar;
	final int default_avatar;
	final String cover;
	final int default_cover;
	final int user_verify;
	final int is_follow;
	final int is_paid_profile;
	final int has_active_sub;
	final String monthly_subscription_text;
	final int monthly_subscription_price;
	final String monthly_subscription_duration;
  // Add other fields here if needed

	ProfileData({
		this.id = 0,
		this.name = '',
		this.username = '',
		this.avatar = '',
		this.default_avatar = 0,
		this.cover = '',
		this.default_cover = 0,
		this.user_verify = 0,
		this.is_follow = 0,
		this.is_paid_profile = 0,
		this.has_active_sub = 0,
		this.monthly_subscription_text = '',
		this.monthly_subscription_price = 0,
		this.monthly_subscription_duration = '',	
	});

	factory ProfileData.fromJson(Map<String, dynamic> json) {
		return ProfileData(
			id: json['id'] as int? ?? 0,
			name: json['name'] as String? ?? '',
			username: json['username'] as String? ?? '',
			avatar: json['avatar'] as String? ?? '',
			default_avatar: json['default_avatar'] as int? ?? 0,
			cover: json['cover'] as String? ?? '',
			default_cover: json['default_cover'] as int? ?? 0,
			user_verify: json['user_verify'] as int? ?? 0,
			is_follow: json['is_follow'] as int? ?? 0,
			is_paid_profile: json['is_paid_profile'] as int? ?? 0,
			has_active_sub: json['has_active_sub'] as int? ?? 0,
			monthly_subscription_text: json['monthly_subscription_text'] as String? ?? '',
			monthly_subscription_price: json['monthly_subscription_price'] as int? ?? 0,
			monthly_subscription_duration: json['monthly_subscription_duration'] as String? ?? '',
			// Parse other fields here if needed
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'name': name,
			'username': username,
			'avatar': avatar,
			'default_avatar': default_avatar,
			'cover': cover,
			'default_cover': default_cover,
			'user_verify': user_verify,
			'is_follow': is_follow,
			'is_paid_profile': is_paid_profile,
			'has_active_sub': has_active_sub,
			'monthly_subscription_text': monthly_subscription_text,
			'monthly_subscription_price': monthly_subscription_price,
			'monthly_subscription_duration': monthly_subscription_duration,
			// Convert other fields here if needed
		};
	}
}