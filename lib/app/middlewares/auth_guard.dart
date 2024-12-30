import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';

class AuthGuard extends GetMiddleware {
  final BaseApiService _baseApiService = Get.find<BaseApiService>();  
  
  @override
  RouteSettings? redirect(String? route) {
    final token = _baseApiService.getTokenSync(); // Use a synchronous method to get the token

	print("Auth Guard token=======: $token");
    if (token == null) {
      return RouteSettings(name: AppPages.INITIAL);  // Redirect to login if not authenticated
    }

    return null;  // Continue to the requested route if authenticated
  }
}

