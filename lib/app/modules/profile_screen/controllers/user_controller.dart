import 'package:get/get.dart';

class UserController extends GetxController {
	RxString userId = ''.obs;
	RxInt userType = 0.obs;
	RxString name = ''.obs;
	RxString firstName = ''.obs;
	RxString lastName = ''.obs;
	RxString email = ''.obs;
	RxString companyName = ''.obs;
	RxInt country = 0.obs;
	RxInt state = 0.obs;
	RxString city = ''.obs;
	RxString address = ''.obs;
	RxString zipcode = ''.obs;
	RxString latitude = ''.obs;
	RxString longitude = ''.obs;
	RxString phoneNumber = ''.obs;
	RxString dob = ''.obs;
	RxInt genderId = 0.obs;
	RxInt isProfileVerified = 0.obs;
	RxString profilePicture = ''.obs;

	void setUserData(Map<String, dynamic> data) {
		userId.value = data['id'].toString();
		userType.value = data['user_type'];
		name.value = data['name'] ?? '';
		firstName.value = data['first_name'] ?? '';
		lastName.value = data['last_name'] ?? '';
		email.value = data['email'] ?? '';
		companyName.value = data['company_name'] ?? '';
		country.value = data['country'] ?? 0;
		state.value = data['state'] ?? 0;
		city.value = data['city'] ?? '';
		address.value = data['address'] ?? '';
		latitude.value = data['latitude'] ?? '';
		longitude.value = data['longitude'] ?? '';
		zipcode.value = data['zipcode'] ?? '';
		phoneNumber.value = data['phone_number'] ?? '';
		dob.value = data['dob'] ?? '';
		genderId.value = data['gender_id'] ?? 0;
		isProfileVerified.value = data['profile_verified'] ?? 0;
		profilePicture.value = data['profile_image'] ?? '';
		
		print(data);
	}
	void setEditUserData(Map<String, dynamic> data) {
		name.value = data['name'] ?? '';
		firstName.value = data['first_name'] ?? '';
		lastName.value = data['last_name'] ?? '';
		email.value = data['email'] ?? '';
		companyName.value = data['company_name'] ?? '';
		country.value = data['country'] ?? 0;
		state.value = data['state'] ?? 0;
		city.value = data['city'] ?? '';
		address.value = data['address'] ?? '';
		latitude.value = data['latitude'] ?? '';
		longitude.value = data['longitude'] ?? '';
		zipcode.value = data['zipcode'] ?? '';
		phoneNumber.value = data['phone_number'] ?? '';
		dob.value = data['dob'] ?? '';
		genderId.value = data['gender_id'] ?? 0;
	}
	void setEditUserProfilePictureData(Map<String, dynamic> data) {
		profilePicture.value = data['profile_image'] ?? '';	
	}
	void setEditUserProfilePaymentVerifyData() {
		isProfileVerified.value = 1;
	}
}
