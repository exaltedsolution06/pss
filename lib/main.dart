import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/controllers/user_controller.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
//import 'package:picturesourcesomerset/config/bottom_navigation.dart';
import 'package:picturesourcesomerset/consts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> loadUserData() async {
	final prefs = await SharedPreferences.getInstance();
	final userController = Get.put(UserController());

	userController.setUserData({
		'id': prefs.getString('userId') ?? '',
		'user_type': prefs.getInt('userType') ?? 0,
		'name': prefs.getString('name') ?? '',
		'first_name': prefs.getString('firstName') ?? '',
		'last_name': prefs.getString('lastName') ?? '',
		'email': prefs.getString('email') ?? '',
		'company_name': prefs.getString('companyName') ?? '',
		'country': prefs.getInt('country') ?? 0,
		'state': prefs.getInt('state') ?? 0,
		'city': prefs.getString('city') ?? '',
		'address': prefs.getString('address') ?? '',
		'latitude': prefs.getString('latitude') ?? '',
		'longitude': prefs.getString('longitude') ?? '',
		'zipcode': prefs.getString('zipcode') ?? '',
		'phone_number': prefs.getString('phoneNumber') ?? '',
		'dob': prefs.getString('dob') ?? '',
		'gender_id': prefs.getInt('genderId') ?? 0,
		'profile_verified': prefs.getInt('isProfileVerified') ?? 0,
		'profile_image': prefs.getString('profilePicture') ?? '',
	});
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
	
  // Initialize UserController
  //Get.put(UserController());
  await loadUserData();
  // Initialize the ApiService
  final apiService = ApiService();
  
  // Register controllers with the ApiService instance
  Get.put(HomeController(apiService));
  
  // Register the BaseApiService with GetX dependency injection
  Get.put(BaseApiService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String?> _getToken() async {
    try {
      final baseApiService = Get.find<BaseApiService>();
      return await baseApiService.getToken();
    } catch (e) {
      print("Error fetching token: $e");
      return null; // Handle the error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Picture Source Somerset",
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.red.withOpacity(0.3),
          selectionHandleColor: Colors.black,
        ),
      ),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSplashScreen();
          } else if (snapshot.hasData && snapshot.data != null) {
            // Token exists, navigate to Bottom screen
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              //Get.offAll(Bottom());
				Get.toNamed(Routes.HOME);
              // Load home data after navigation and login verification
				//final homeController = Get.find<HomeController>();
				//homeController.loadInitialDataForCategory();  // Load data for user
				//homeController.loadInitialDataForArtist();
            });
            return _buildSplashScreen();
          } else {
            // No token, navigate to INITIAL page
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Get.offAllNamed(AppPages.INITIAL);
            });
            return _buildSplashScreen();
          }
        },
      ),
    );
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
        ),
      ),
    );
  }
}
