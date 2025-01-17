import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
//import 'package:picturesourcesomerset/config/bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
