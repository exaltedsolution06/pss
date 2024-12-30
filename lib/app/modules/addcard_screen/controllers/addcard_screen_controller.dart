import 'package:get/get.dart';

class AddcardScreenController extends GetxController {
  //TODO: Implement AddcardScreenController
	
  final count = 0.obs;

  void increment() => count.value++;
  
	var isChecked = false.obs;
	var selectedCountry = 'USA'.obs;
	var selectedState = 'California'.obs;
	
	void toggleCheckbox(bool value) {
    isChecked.value = value;
  }
  
	void updateCountry(String value) {
		selectedCountry.value = value;
	}

	void updateState(String value) {
		selectedState.value = value;
	}

  
}
