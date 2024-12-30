import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:picturesourcesomerset/config/app_color.dart';

class CustomAlertWidget {
  static void showError({
    required BuildContext context,
    String title = 'Oops...',
    String text = 'Sorry, something went wrong',
    Color backgroundColor = Colors.white,
    Color titleColor = Colors.red,
    Color textColor = Colors.black,
    Color confirmBtnColor = Colors.red,
    String confirmBtnText = 'Okay',
    TextStyle? confirmBtnTextStyle,
    double borderRadius = 15.0,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title,
      text: text,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      textColor: textColor,
      confirmBtnColor: confirmBtnColor,
      confirmBtnText: confirmBtnText,
      confirmBtnTextStyle: confirmBtnTextStyle ?? TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
		fontFamily: 'Urbanist-semibold',
		color: AppColor.white
      ),
      borderRadius: borderRadius,
    );
  }

  static void showSuccess({
    required BuildContext context,
    String title = 'Success!',
    String text = 'Operation completed successfully',
    Color backgroundColor = Colors.white,
    Color titleColor = Colors.green,
    Color textColor = Colors.black,
    Color confirmBtnColor = Colors.green,
    String confirmBtnText = 'Okay',
    TextStyle? confirmBtnTextStyle,
    double borderRadius = 15.0,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title,
      text: text,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      textColor: textColor,
      confirmBtnColor: confirmBtnColor,
      confirmBtnText: confirmBtnText,
      confirmBtnTextStyle: confirmBtnTextStyle ?? TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
		fontFamily: 'Urbanist-semibold',
		color: AppColor.white
      ),
      borderRadius: borderRadius,
    );
  }

  static void showWarning({
    required BuildContext context,
    String title = 'Warning!',
    String text = 'Please be careful with this action.',
    Color backgroundColor = Colors.white,
    Color titleColor = Colors.orange,
    Color textColor = Colors.black,
    Color confirmBtnColor = Colors.yellow,
    String confirmBtnText = 'Got it',
    TextStyle? confirmBtnTextStyle,
    double borderRadius = 15.0,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title,
      text: text,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      textColor: textColor,
      confirmBtnColor: confirmBtnColor,
      confirmBtnText: confirmBtnText,
      confirmBtnTextStyle: confirmBtnTextStyle ?? TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
		fontFamily: 'Urbanist-semibold',
		color: AppColor.white
      ),
      borderRadius: borderRadius,
    );
  }

  static void showInfo({
    required BuildContext context,
    String title = 'Information',
    String text = 'Here is some useful information.',
    Color backgroundColor = Colors.white,
    Color titleColor = Colors.blue,
    Color textColor = Colors.black,
    Color confirmBtnColor = Colors.lightBlue,
    String confirmBtnText = 'Okay',
    TextStyle? confirmBtnTextStyle,
    double borderRadius = 15.0,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: title,
      text: text,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      textColor: textColor,
      confirmBtnColor: confirmBtnColor,
      confirmBtnText: confirmBtnText,
      confirmBtnTextStyle: confirmBtnTextStyle ?? TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
		fontFamily: 'Urbanist-semibold',
		color: AppColor.white
      ),
      borderRadius: borderRadius,
    );
  }

  static void showConfirm({
    required BuildContext context,
    String title = 'Confirm',
    String text = 'Are you sure you want to proceed?',
    Color backgroundColor = Colors.white,
    Color titleColor = Colors.black,
    Color textColor = Colors.black,
    Color confirmBtnColor = Colors.green,
    String confirmBtnText = 'Yes',
    TextStyle? confirmBtnTextStyle,
    double borderRadius = 15.0,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title,
      text: text,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      textColor: textColor,
      confirmBtnColor: confirmBtnColor,
      confirmBtnText: confirmBtnText,
      confirmBtnTextStyle: confirmBtnTextStyle ?? TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
		fontFamily: 'Urbanist-semibold',
		color: AppColor.white
      ),
      borderRadius: borderRadius,
    );
  }
}


/******How to use in View File

                CustomAlertWidget.showError(
                  context: context,
                  title: 'Oops...',
                  text: 'Something went wrong!',
                  backgroundColor: Colors.white,
                  titleColor: Colors.red,
                  textColor: Colors.black,
                  confirmBtnColor: Colors.blue,
                  confirmBtnText: 'Okay',
                );
				
                CustomAlertWidget.showSuccess(
                  context: context,
                  title: 'Success!',
                  text: 'Operation completed successfully',
                );
				
                CustomAlertWidget.showWarning(
                  context: context,
                  title: 'Warning!',
                  text: 'Please be careful with this action.',
                );
				
                CustomAlertWidget.showInfo(
                  context: context,
                  title: 'Information',
                  text: 'Here is some useful information.',
                );
				
                CustomAlertWidget.showConfirm(
                  context: context,
                  title: 'Confirm',
                  text: 'Are you sure you want to proceed?',
                  confirmBtnColor: Colors.green,
                );

**********/
