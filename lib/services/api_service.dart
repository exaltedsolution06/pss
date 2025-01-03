import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:dio/dio.dart'; // Import Dio for FormData and MultipartFile
import 'package:picturesourcesomerset/config/api_endpoints.dart';

class ApiService extends BaseApiService {
  ApiService() : super();
  
  //BaseApiService baseApiService = BaseApiService();

  
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
	
	//Slider data for onboarding page
	Future<Map<String, dynamic>> slider_data() {
		return get(ApiEndpoints.slider_data, requiresAuth: false);
	}
	
	//Login page
	Future<Map<String, dynamic>> login(String username, String password) async {
		final response = await post(ApiEndpoints.login, {'email': username, 'password': password});
		if (response.containsKey('access_token')) {
			saveToken(response['access_token']);
		}
		return response;
	}
	// Method for Google login that accepts the user object
	Future<Map<String, dynamic>> googleLogin(user) async {
		final response = await post(ApiEndpoints.googleLogin, {'user': user});

		if (response.containsKey('access_token')) {
		  saveToken(response['access_token']);
		}
		return response;
	}
	
	//Forgot Password page
	Future<Map<String, dynamic>> forgotPassword(String email) async {
		final response = await post(ApiEndpoints.forgotPassword, {'email': email});
		return response;
	}
	
	//Forgot Password Verify OTP page
	Future<Map<String, dynamic>> forgotPassword_verifyOtp(String email, String otp) async {
		final response = await post(ApiEndpoints.forgotPassword_verifyOtp, {'email': email, 'otp': otp});
		return response;
	}
	
	//Reset Password
	Future<Map<String, dynamic>> resetPassword(String email, String password, String password_confirmation) async {
		final response = await post(ApiEndpoints.resetPassword, {'email': email, 'password': password, 'password_confirmation': password_confirmation});
		return response;
	}
	
	//Register
	Future<Map<String, dynamic>> register(String name, String email, String password, String password_confirmation) async {
		final response = await post(ApiEndpoints.register, {'name': name, 'email': email, 'password': password, 'password_confirmation': password_confirmation});
		if (response.containsKey('access_token')) {
			saveToken(response['access_token']);
		}
		return response;
	}
	//Register email Verify OTP page
	Future<Map<String, dynamic>> register_verifyOtp(String email, String otp) async {
		final response = await post(ApiEndpoints.register_verifyOtp, {'email': email, 'otp': otp}, requiresAuth: true);
		return response;
	}
	//Fetch profile data for profile page
	Future<Map<String, dynamic>> fetchProfileDataForViewProfilePage(int user, int social_user, int feeds) async {
		final response = await post(ApiEndpoints.profile, {'user': user, 'social_user': social_user, 'feeds': feeds}, requiresAuth: true);
		return response;
	}
	//Fetch profile data for edit profile page
	Future<Map<String, dynamic>> fetchProfileDataForEditProfilePage(int user, int user_verify, int genders, int countries) async {
		final response = await post(ApiEndpoints.profile, {'user': user, 'user_verify': user_verify, 'genders': genders, 'countries': countries}, requiresAuth: true);
		return response;
	}
	//Edit Profile
	Future<Map<String, dynamic>> profile_submit(
		String username, 
		String name, 
		String bio, 
		String birthdate, 
		int gender_id, 
		String gender_pronoun, 
		int country_id, 
		String location, 
		String website
	) async {
		// Construct the request body dynamically
		final Map<String, dynamic> requestBody = {
			'username': username,
			'name': name,
			'bio': bio,
			'birthdate': birthdate,
			'gender_pronoun': gender_pronoun,
			'location': location,
			'website': website,
		};

		// Include gender_id and country_id only if they are non-zero
		if (gender_id != 0) {
			requestBody['gender_id'] = gender_id;
		}

		if (country_id != 0) {
			requestBody['country_id'] = country_id;
		}

		// Make the API request
		final response = await post(ApiEndpoints.profile_submit, requestBody, requiresAuth: true);

		return response;
	}
	
	//Edit Profile Cover Image Upload
	/*Future<Map<String, dynamic>> profile_cover_image_upload(file) async {
		// Construct the request body dynamically
		final Map<String, dynamic> requestBody = {'file': file};
		// Make the API request
		final response = await post(ApiEndpoints.profile_cover_image_upload, requestBody, requiresAuth: true);

		return response;
	}*/

	


	Future<Map<String, dynamic>> profile_cover_image_upload(File file) async {
		// Create Dio instance
		Dio dio = Dio(BaseOptions(
		  validateStatus: (status) => status != null && status < 500,
		));

		// Prepare FormData object
		FormData formData = FormData.fromMap({
		  'file': await MultipartFile.fromFile(file.path),
		});

		// Prepare Dio options with headers
		Options options = Options(
		  headers: await getHeaders(true) ?? {}, // Ensure headers are not null
		);

		// Make the API request
		final response = await dio.post(
		  '$baseUrl/${ApiEndpoints.profile_cover_image_upload}',
		  data: formData,
		  options: options,
		);
		//var dd = response.data;
		//print("Response data : $dd");
		// Ensure response data is not null before returning
		//return response.data != null ? response.data : {'success': false};
		return response.data;
	}
	
	Future<Map<String, dynamic>> profile_avatar_image_upload(File file) async {
		// Create Dio instance
		Dio dio = Dio(BaseOptions(
		  validateStatus: (status) => status != null && status < 500,
		));

		// Prepare FormData object
		FormData formData = FormData.fromMap({
		  'file': await MultipartFile.fromFile(file.path),
		});

		// Prepare Dio options with headers
		Options options = Options(
		  headers: await getHeaders(true) ?? {}, // Ensure headers are not null
		);

		// Make the API request
		final response = await dio.post(
		  '$baseUrl/${ApiEndpoints.profile_avatar_image_upload}',
		  data: formData,
		  options: options,
		);
		//var dd = response.data;
		//print("Response data : $dd");
		// Ensure response data is not null before returning
		//return response.data != null ? response.data : {'success': false};
		return response.data;
	}
	
	//Remove Avatar image
	Future<Map<String, dynamic>> profile_avatar_image_delete() async {
		final response = await post(ApiEndpoints.profile_avatar_image_delete, {}, requiresAuth: true);
		return response;
	}
	//Remove Cover image
	Future<Map<String, dynamic>> profile_cover_image_delete() async {
		final response = await post(ApiEndpoints.profile_cover_image_delete, {}, requiresAuth: true);
		return response;
	}
	
	//Account update from Settings menu
	Future<Map<String, dynamic>> account_update(String password, String new_password, String confirm_password) async {
		final response = await post(ApiEndpoints.account_update, {'password': password, 'new_password': new_password, 'confirm_password': confirm_password}, requiresAuth: true);
		return response;
	}
	
	//Wallet balance from Settings menu
	Future<Map<String, dynamic>> wallet_available_pending_balance() {
		return get(ApiEndpoints.wallet_available_pending_balance, requiresAuth: true);
	}
	
	//Wallet deposit from Settings menu
	Future<Map<String, dynamic>> wallet_deposit(int amount) async {
		final response = await post(ApiEndpoints.wallet_deposit, {'amount': amount}, requiresAuth: true);
		return response;
	}
	
	//Wallet request from Settings menu
	Future<Map<String, dynamic>> wallet_request_withdraw(int amount, String payment_method, String payment_identifier, String message) async {
		final response = await post(ApiEndpoints.wallet_request_withdraw, {'amount': amount, 'payment_method': payment_method, 'payment_identifier': payment_identifier, 'message': message}, requiresAuth: true);
		return response;
	}
	//Payment History from Settings menu
	Future<Map<String, dynamic>> payments_fetch() {
		return get(ApiEndpoints.payments_fetch, requiresAuth: true);
	}
	//Invoice details from Payment History page in Settings menu
	Future<Map<String, dynamic>> invoices(int id) {
		return get(ApiEndpoints.invoices, id: id.toString(), requiresAuth: true);
	}
	
	//Fetch Rates data in Settings menu
	Future<Map<String, dynamic>> rates_fetch() {
		return get(ApiEndpoints.rates_fetch, requiresAuth: true);
	}
	//Rates page paid-profile update from Settings menu
	Future<Map<String, dynamic>> rates_type(int paid_profile) async {
		final response = await post(ApiEndpoints.rates_type, {'paid_profile': paid_profile}, requiresAuth: true);
		return response;
	}
	//Rates page form update from Settings menu
	Future<Map<String, dynamic>> rates_update(int is_offer, String profile_access_price, String profile_access_price_3_months, String profile_access_price_6_months, String profile_access_price_12_months, String profile_access_offer_date) async {
		final response = await post(ApiEndpoints.rates_update, {'is_offer': is_offer, 'profile_access_price': profile_access_price, 'profile_access_price_3_months': profile_access_price_3_months, 'profile_access_price_6_months': profile_access_price_6_months, 'profile_access_price_12_months': profile_access_price_12_months, 'profile_access_offer_date': profile_access_offer_date}, requiresAuth: true);
		return response;
	}
	//Subscriptions list from Settings menu
	Future<Map<String, dynamic>> subscriptions_fetch() {
		return get(ApiEndpoints.subscriptions_fetch, requiresAuth: true);
	}
	//Subscription Cancel update from Settings menu
	Future<Map<String, dynamic>> subscriptions_canceled(int id) async {
		final response = await post(ApiEndpoints.subscriptions_canceled, {'id': id}, requiresAuth: true);
		return response;
	}
	//Subscribers list from Settings menu
	Future<Map<String, dynamic>> subscribers_fetch() {
		return get(ApiEndpoints.subscribers_fetch, requiresAuth: true);
	}
	//Subscribers Cancel update from Settings menu
	Future<Map<String, dynamic>> subscribers_canceled(int id) async {
		final response = await post(ApiEndpoints.subscribers_canceled, {'id': id}, requiresAuth: true);
		return response;
	}
	
	//fetch settings notifications in Settings menu
	Future<Map<String, dynamic>> settings_notifications() {
		return get(ApiEndpoints.settings_notifications, requiresAuth: true);
	}
	//Settings notification update from Settings menu
	Future<Map<String, dynamic>> settings_notifications_update(String key, bool value) async {
		final response = await post(ApiEndpoints.settings_notifications_update, {'key': key, 'value': value}, requiresAuth: true);
		return response;
	}
	
	//fetch settings privacy in Settings menu
	Future<Map<String, dynamic>> privacy_fetch() {
		return get(ApiEndpoints.privacy_fetch, requiresAuth: true);
	}
	//Settings privacy update from Settings menu
	Future<Map<String, dynamic>> privacy_update(String key, bool value) async {
		int intValue = value == true ? 1 : 0;  // Convert bool to int
		print('key: $key');
		print('Value: $value');
		final response = await post(ApiEndpoints.privacy_update, {'key': key, 'value': intValue}, requiresAuth: true);
		return response;
	}
	
	//fetch settings verify in Settings menu
	Future<Map<String, dynamic>> verify_email_birthdate() {
		return get(ApiEndpoints.verify_email_birthdate, requiresAuth: true);
	}
	
	Future<Map<String, dynamic>> verify_Identity_check(File file) async {
		// Create Dio instance
		Dio dio = Dio(BaseOptions(
		  validateStatus: (status) => status != null && status < 500,
		));

		// Prepare FormData object
		FormData formData = FormData.fromMap({
		  'files[]': await MultipartFile.fromFile(file.path),
		});

		// Prepare Dio options with headers
		Options options = Options(
		  headers: await getHeaders(true) ?? {}, // Ensure headers are not null
		);

		// Make the API request
		final response = await dio.post(
		  '$baseUrl/${ApiEndpoints.verify_Identity_check}',
		  data: formData,
		  options: options,
		);
		var dd = response.data;
		print("Response data : $dd");
		// Ensure response data is not null before returning
		return response.data != null ? response.data : {'success': false};
		return response.data;
	}
	
	//CMS page terms-and-conditions / privacy-policy / faq
	Future<Map<String, dynamic>> cms_terms_page(int val) async {
		final response = await post(ApiEndpoints.cms, {'terms_and_conditions': val}, requiresAuth: false);
		return response;
	}
	Future<Map<String, dynamic>> cms_privacy_page(int val) async {
		final response = await post(ApiEndpoints.cms, {'privacy_policy': val}, requiresAuth: false);
		return response;
	}
	Future<Map<String, dynamic>> cms_faq_page(int val) async {
		final response = await post(ApiEndpoints.cms, {'help_faq': val}, requiresAuth: false);
		return response;
	}
	//Notification page from top right corner header (All)
	Future<Map<String, dynamic>> notifications(int total, int messages, int likes, int subscriptions, int tips, int page) async {
		final response = await post(ApiEndpoints.notifications, {'total': total, 'messages': messages, 'likes': likes, 'subscriptions': subscriptions, 'tips': tips, 'page': page}, requiresAuth: true);
		return response;
	}
	//Follow screen page from view profile page sticker
	Future<Map<String, dynamic>> social_lists(int followers, int following, int blocked, int page) async {
		final response = await post(ApiEndpoints.social_lists, {'followers': followers, 'following': following, 'blocked': blocked, 'page': page}, requiresAuth: true);
		return response;
	}
	//New Post File
	Future<Map<String, dynamic>> post_create_file(File file, {required String post_id}) async {
		// Create Dio instance
		Dio dio = Dio(BaseOptions(
			validateStatus: (status) => status != null && status < 500,
		));
		
		print("post_id: $post_id");

		// Prepare FormData object
		FormData formData = FormData.fromMap({
			'post_id': post_id, // Adding the id field
			'files[]': await MultipartFile.fromFile(file.path), // File upload field
		});

		// Prepare Dio options with headers
		Options options = Options(
			headers: await getHeaders(true) ?? {}, // Ensure headers are not null
		);

		// Make the API request
		final response = await dio.post(
			'$baseUrl/${ApiEndpoints.post_create_file}',
			data: formData,
			options: options,
		);

		var dd = response.data;
		print("Response data : $dd");

		// Ensure response data is not null before returning
		return response.data != null ? response.data : {'success': false};
	}
	
	//Function to create a new post
	Future<Map<String, dynamic>> post_create(String text, int price) async {
		final response = await post(ApiEndpoints.post_create, {'text': text, 'price': price}, requiresAuth: true);
		return response;
	}
	//Fetch post data for edit post page
	Future<Map<String, dynamic>> fetchPostDataForEditPostPage(int post_id) async {
		final response = await post(ApiEndpoints.fetch_post, {'post_id': post_id}, requiresAuth: true);
		return response;
	}
	//Function to edit a post
	Future<Map<String, dynamic>> post_edit(int post_id, String text, int price) async {
		final response = await post(ApiEndpoints.post_edit, {'post_id': post_id, 'text': text, 'price': price}, requiresAuth: true);
		return response;
	}
	//Function to delete a post
	Future<Map<String, dynamic>> post_delete(int post_id) async {
		final response = await post(ApiEndpoints.post_delete, {'post_id': post_id}, requiresAuth: true);
		return response;
	}
	//Function to delete a post
	Future<Map<String, dynamic>> post_delete_files(int post_id, String file_id) async {
		final response = await post(ApiEndpoints.post_delete_files, {'post_id': post_id, 'file_id': file_id}, requiresAuth: true);
		return response;
	}
	//Search page from bottom left corner home page
	Future<Map<String, dynamic>> search(String query, int top, int latest, int people, int photos, int videos, int page) async {
		final response = await post(ApiEndpoints.search, {'query': query, 'top': top, 'latest': latest, 'people': people, 'photos': photos, 'videos': videos, 'page': page}, requiresAuth: true);
		return response;
	}
	
	//feed fetch comments
	Future<Map<String, dynamic>> feeds_fetch_comments(int post_id) async {
		final response = await post(ApiEndpoints.feeds_fetch_comments, {'post_id': post_id}, requiresAuth: true);
		return response;
	}
	//post feed comments
	Future<Map<String, dynamic>> feeds_post_comments(int post_id, String message) async {
		final response = await post(ApiEndpoints.feeds_post_comments, {'post_id': post_id, 'message': message}, requiresAuth: true);
		return response;
	}
	//like feed comments
	Future<Map<String, dynamic>> feeds_like_comments(int post_comment_id) async {
		final response = await post(ApiEndpoints.feeds_like_comments, {'post_comment_id': post_comment_id}, requiresAuth: true);
		return response;
	}
	//delete feed comments
	Future<Map<String, dynamic>> feeds_delete_comments(int post_comment_id) async {
		final response = await post(ApiEndpoints.feeds_delete_comments, {'id': post_comment_id}, requiresAuth: true);
		return response;
	}
	//like feed posts
	Future<Map<String, dynamic>> feeds_post_like(int post_id) async {
		final response = await post(ApiEndpoints.feeds_post_like, {'post_id': post_id}, requiresAuth: true);
		return response;
	}
	//feed posts - fetch tips details for "send a tip" modal
	/*Future<Map<String, dynamic>> tips_fetch(int post_id) async {
		final response = await post(ApiEndpoints.tips_fetch, {'post_id': post_id}, requiresAuth: true);
		return response;
	}*/
	//fetch billing address
	Future<Map<String, dynamic>> billing_address([int? user_id]) async {
		// Prepare the request payload
		Map<String, dynamic> payload = {};

		// Include user_id only if it is not null and greater than 0
		if (user_id != null && user_id > 0) {
			payload['user_id'] = user_id;
		}

		// Make the POST request
		final response = await post(ApiEndpoints.billing_address, payload, requiresAuth: true);
		return response;
	}


	//feed posts - post tips details for "send a tip" modal
	Future<Map<String, dynamic>> tips_submit(int post_id, int amount, String first_name, String last_name, String state, String city, String postcode, int country, String billing_address ) async {
		final response = await post(ApiEndpoints.tips_submit, {'post_id': post_id, 'amount': amount, 'first_name': first_name, 'last_name': last_name, 'city': city, 'state': state, 'postcode': postcode, 'country': country, 'billing_address': billing_address}, requiresAuth: true);
		return response;
	}
	
	//Home page feeds
	Future<Map<String, dynamic>> feed_all_user(int page, int courses_user_page) async {
		final response = await post(ApiEndpoints.feed_all_user, {'page': page, 'courses_user_page': courses_user_page}, requiresAuth: true);
		return response;
	}
	//View profile page
	Future<Map<String, dynamic>> feeds_individual(int id, int page) async {
		final response = await post(ApiEndpoints.feeds_individual, {'id': id, 'page': page}, requiresAuth: true);
		return response;
	}
	//View profile own page
	Future<Map<String, dynamic>> feed_user(int page) async {
		final response = await post(ApiEndpoints.feed_user, {'page': page}, requiresAuth: true);
		return response;
	}
	//View profile page - Follow/Unfollow
	Future<Map<String, dynamic>> follow_creator(int user_id, int follow) async {
		print("user_id: $user_id, follow: $follow");
		final response = await post(ApiEndpoints.follow_creator, {'user_id': user_id, 'follow': follow}, requiresAuth: true);
		return response;
	}
}
