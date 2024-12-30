import 'package:flutter/material.dart';
import 'package:picturesourcesomerset/config/app_color.dart';

Widget elevated({required String text,void Function()? onPress}){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(327, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), elevation: 0, backgroundColor: AppColor.purple),
      onPressed: onPress,
      child: Text(text, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', fontWeight: FontWeight.w600, color: AppColor.white)));
}
Widget whiteBgBlackBorderBtn({required String text,void Function()? onPress}){
	return ElevatedButton(
		style: ElevatedButton.styleFrom(
			fixedSize: const Size(327, 56), 
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(100),
				side: BorderSide(color: AppColor.black, width: 1),
			), 
			elevation: 0, 
			backgroundColor: AppColor.white
		),
		onPressed: onPress,
		child: Text(text, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', fontWeight: FontWeight.w600, color: AppColor.black)));
}
// Profile button
Widget elevated1({required String text,void Function()? onPress}){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(255, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), backgroundColor: AppColor.purple, elevation: 0),
      onPressed: onPress,
      child: Text(text, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.white)));
}
// Product button
Widget product({required String text,void Function()? onPress}){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(149, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), backgroundColor: AppColor.purple, elevation: 0),
      onPressed: onPress,
      child: Text(text, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.white)));
}
// Subscribe button
Widget subcribeBtn({required String lefttext, required String righttext, required double screenWidth, void Function()? onPress}){
	return ElevatedButton(
		style: ElevatedButton.styleFrom(
			fixedSize: Size(screenWidth - 50, 56), // width set to infinity, height set to 56
			shape: RoundedRectangleBorder(
			  borderRadius: BorderRadius.circular(100),
			),
			backgroundColor: AppColor.purple,
			elevation: 0,
		),
		onPressed: onPress,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween, // spaces out the children
			children: [
			  Text(lefttext, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.white)),
			  Text(righttext, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.white)),
			],
		),
	);
}
// Subscribe button bundles
Widget subcribeBtnBundles({required String lefttext, required String righttext, required double screenWidth, void Function()? onPress}){
	return ElevatedButton(
		style: ElevatedButton.styleFrom(
			fixedSize: Size(screenWidth - 50, 56), // width set to infinity, height set to 56
			shape: RoundedRectangleBorder(
			  borderRadius: BorderRadius.circular(100),
			  side: BorderSide(color: AppColor.purple, width: 1),
			),
			backgroundColor: AppColor.white,
			elevation: 0,
		),
		onPressed: onPress,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween, // spaces out the children
			children: [
			  Text(lefttext, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.purple)),
			  Text(righttext, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.purple)),
			],
		),
	);
}
// Autowidth button
Widget autoWidthBtn({required String text, required double width, void Function()? onPress}){
	return ElevatedButton(
		style: ElevatedButton.styleFrom(
			fixedSize: Size(width, 56), // width set to infinity, height set to 56
			shape: RoundedRectangleBorder(
			  borderRadius: BorderRadius.circular(100),
			),
			backgroundColor: AppColor.purple,
			elevation: 0,
		),
		onPressed: onPress,
		child: Text(text, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.white)),
	);
}
// Secondary button button
Widget secondaryBtn({required String text, required double width, void Function()? onPress}){
	return ElevatedButton(
		style: ElevatedButton.styleFrom(
			fixedSize: Size(width, 56), // width set to infinity, height set to 56
			shape: RoundedRectangleBorder(
			  borderRadius: BorderRadius.circular(100),
			),
			backgroundColor: AppColor.BlackGreyscale,
			elevation: 0,
		),
		onPressed: onPress,
		child: Text(text, style: const TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', color: AppColor.white)),
	);
}

// Icon added button
Widget iconBtn({
  required String text,
  required double width,
  required double height,
  void Function()? onPress,
  IconData? icon, // Optional icon parameter
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      fixedSize: Size(width, height), // width set to the specified value, height set to 56
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      backgroundColor: AppColor.purple,
      elevation: 0,
	  padding: const EdgeInsets.symmetric(horizontal: 4),
    ),
    onPressed: onPress,
    child: Row(
		mainAxisSize: MainAxisSize.min, 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColor.white),
          const SizedBox(width: 8), // Spacing between the icon and text
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Urbanist-semibold',
            color: AppColor.white,
          ),
        ),
      ],
    ),
  );
}

// Text button
Widget textButton({
  required String text,
  required double width,
  required double height,
  void Function()? onPress,
}) {
  return TextButton(
    onPressed: onPress,
    style: TextButton.styleFrom(
		minimumSize: Size(width, height),
		fixedSize: Size(width, height),
		padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0), // Adjusted padding
		shape: RoundedRectangleBorder(
			borderRadius: BorderRadius.circular(100),
		),
		backgroundColor: AppColor.white,
    ),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Urbanist-semibold',
          color: AppColor.black,
        ),
      ),
    ),
  );
}
