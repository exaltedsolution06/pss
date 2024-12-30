import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  // Function to show error snackbar with customizable position
  static void showErrorSnackbar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM, // Default position
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Color(0xffd10037),
      colorText: Colors.white,
      snackPosition: position, // Dynamic position
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      duration: Duration(seconds: 2),
    );
  }

  // Function to show success snackbar with customizable position
  static void showSuccessSnackbar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM, // Default position
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Color(0xffd10037),
      colorText: Colors.white,
      snackPosition: position, // Dynamic position
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    );
  }
}
