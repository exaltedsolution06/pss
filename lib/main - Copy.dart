import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/comment_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/post_controller.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/bottom_navigation.dart';

/*Future<void> ZimkitAutoLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('userEmail');
  String? name = prefs.getString('userName');

  if (email != null && name != null) {
	try {
	  await ZIMKit().connectUser(id: email, name: name);
	  print("User auto-logged in: $email");
	} catch (e) {
	  print("Auto-login failed: $e");
	}
  } else {
	print("No saved login data.");
  }
}*/
	
void main() async {
	/*await ZIMKit().init(
		appID: 1549749425, // your appid
		appSign: 'ffdec103b84977930ffee550af170811203564e826e6f45c208a23b001a3b51b', // your appSign
	);*/
		
	WidgetsFlutterBinding.ensureInitialized();
	
	//await ZimkitAutoLogin();
  
	// Initialize the ApiService
	final apiService = ApiService();
	
	// Get.lazyPut<ApiService>(() => ApiService());
	 
	// Register controllers with the ApiService instance
	Get.put(HomeController(apiService));
	Get.put(CommentController(apiService));
	Get.put(PostController(apiService));
	// Register the BaseApiService with GetX dependency injection
	Get.put(BaseApiService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String?> _getToken() async {
    final baseApiService = Get.find<BaseApiService>();
    return await baseApiService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
		title: "Application",
		theme: ThemeData(
			textSelectionTheme: TextSelectionThemeData(
			  cursorColor: Colors.black, // Change cursor color
			  selectionColor: Colors.red.withOpacity(0.3), // Change selection highlight color
			  selectionHandleColor: Colors.black, // Change the purple circle to black (or any color)
			),
		),
		
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),), // Show loading indicator
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            // Token exists, navigate to Bottom screen
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Get.offAll(Bottom());
			  
			  // Load home data after navigation and login verification
              final homeController = Get.find<HomeController>();
              homeController.loadInitialDataForCourseUser();
              homeController.loadInitialDataForFeed();
            });
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),), // Show loading indicator
              ),
            );
          } else {
            // No token, navigate to INITIAL page
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Get.offAllNamed(AppPages.INITIAL);
            });
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),), // Show loading indicator
              ),
            );
          }
        },
      ),
    );
  }
}

