import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

class Onboarding1Controller extends GetxController {
  var index = 0.obs; // Observable variable

  void onPageChanged(int value) {
    index.value = value; // Update the index value
  }
  
  final ApiService apiService;
  Onboarding1Controller(this.apiService);

  // Observable to track loading state and slider data
  var isFetchingData = false.obs;
  var isLoading = true.obs;
  var sliderData = [].obs; // List to store slider data
  
  // PageController for the slider
  //late PageController pageController;
  final count = 0.obs;

  /*@override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 0.8, keepPage: true);
    fetchSliderData(); // Fetch data on initialization
  }*/

  /*@override
  void onClose() {
    pageController.dispose(); // Dispose of the controller when not needed
    super.onClose();
  }*/

  // Fetch Slider data
  /*Future<void> fetchSliderData() async {
    print("Slider data fetch initiated");
    isLoading.value = true; // Start loading
    try {
      isFetchingData(true);
      final responseData = await apiService.slider_data();
      final response = responseData['data'];

      //print('API Response: $response'); // Print the full API response
      
      // Update the slider data
      sliderData.assignAll(response);

      // Note: Avoid interacting with pageController directly here
      // Ensure the PageController is only used when the view is fully loaded

    } catch (e) {
      print('Error occurred: $e'); // Print the error if any occurs
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: Appcontent.snackbarCatchErrorMsg, 
		  position: SnackPosition.BOTTOM, // Custom position
		);
    } finally {
      isFetchingData(false);
      isLoading.value = false; // Stop loading
    }
  }*/

  void increment() => count.value++;
}
