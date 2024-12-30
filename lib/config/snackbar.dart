import 'package:flutter/material.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  required SnackbarType type,
  SnackBarPosition position = SnackBarPosition.bottom,
}) {
  Color backgroundColor;
  Icon icon;

  switch (type) {
    case SnackbarType.success:
      backgroundColor = Colors.green;
      icon = Icon(Icons.check_circle, color: Colors.white);
      break;
    case SnackbarType.error:
      backgroundColor = Colors.red;
      icon = Icon(Icons.error, color: Colors.white);
      break;
    case SnackbarType.info:
      backgroundColor = Colors.blue;
      icon = Icon(Icons.info, color: Colors.white);
      break;
    default:
      backgroundColor = Colors.grey;
      icon = Icon(Icons.notifications, color: Colors.white);
      break;
  }
	double screenHeight = MediaQuery.of(context).size.height;
	double statusBarHeight = MediaQuery.of(context).padding.top;
	double appBarHeight = kToolbarHeight;
	
	//print("height: $screenHeight");
	//print("status bar height: $statusBarHeight");

  final snackBar = SnackBar(
    content: Row(
      children: [
        icon,
        SizedBox(width: 30),
        Expanded(child: Text(message, style: TextStyle(color: Colors.white))),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    duration: Duration(seconds: 3),
    margin: EdgeInsets.only(
      bottom: position == SnackBarPosition.bottom ? screenHeight - (statusBarHeight * 2 + appBarHeight + 20) : 0,
      top: position == SnackBarPosition.top ? statusBarHeight : 0,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

enum SnackbarType { success, error, info, defaultType }
enum SnackBarPosition { top, bottom }
