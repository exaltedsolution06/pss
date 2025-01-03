import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/bottom_navigation.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';


class LoginScreenController extends GetxController {
	final ApiService apiService;
	var isLoading = false.obs;  // RxBool
	var showPassword = true.obs;  // RxBool
	RxBool rememberMe = false.obs;
	LoginScreenController(this.apiService);
  

	void changePasswordHideAndShow() {
		showPassword.value = !showPassword.value;  // Use .value to update RxBool
	}
	
	// Load saved credentials
	Future<void> loadSavedCredentials(TextEditingController usernameController, TextEditingController passwordController) async {
		final prefs = await SharedPreferences.getInstance();
		rememberMe.value = prefs.getBool('rememberMe') ?? false;

		if (rememberMe.value) {
		  usernameController.text = prefs.getString('savedUsername') ?? '';
		  passwordController.text = prefs.getString('savedPassword') ?? '';
		}
	}
	// Save credentials
	Future<void> saveCredentials(String username, String password) async {
		final prefs = await SharedPreferences.getInstance();
		if (rememberMe.value) {
		  await prefs.setBool('rememberMe', true);
		  await prefs.setString('savedUsername', username);
		  await prefs.setString('savedPassword', password);
		} else {
		  await prefs.remove('rememberMe');
		  await prefs.remove('savedUsername');
		  await prefs.remove('savedPassword');
		}
	}
	/// Handle "Remember Me" checkbox toggle
	void toggleRememberMe() {
		rememberMe.value = !rememberMe.value;
	}
	
	


	Future<void> login(String username, String password) async {
	  isLoading.value = true;
	  //Get.offAll(Bottom());
	  Get.toNamed(Routes.HOME);
	  /*final response = await apiService.login(username, password);
	  isLoading.value = false;

	  if (response.containsKey('access_token')) {
		// Save credentials if "Remember Me" is checked
		await saveCredentials(username, password);
		saveTokenAndNavigate(response['access_token'], response['message']);
	  } else {
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: response['message'],
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }*/
	  
		
	}
	
	// Method for Google login that takes the user object
	Future<void> googleLogin(user) async {
		isLoading.value = true;
		
		// Make API call to login using the Google user object
		final response = await apiService.googleLogin(user);
		//print(response);
		isLoading.value = false;

		if (response.containsKey('access_token')) {
		  saveTokenAndNavigate(response['access_token'], response['message']);
		} else {
		  SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
		  );
		}
	}
	  
	// Save token and navigate to Bottom view
	void saveTokenAndNavigate(String token, String message) async {
		final baseApiService = Get.find<BaseApiService>();
		baseApiService.saveToken(token);

		SnackbarHelper.showSuccessSnackbar(
			title: Appcontent.snackbarTitleSuccess, 
			message: message,
			position: SnackPosition.BOTTOM, // Custom position
		);
		  
		// Load home data after navigation and login verification
		final homeController = Get.find<HomeController>();
		homeController.loadInitialDataForFeed();
			  
		await Future.delayed(Duration(seconds: 3));
		Get.offAll(Bottom());
	}

}
