import 'package:flutter/material.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:flutter_switch/flutter_switch.dart';

Widget customSwitch({
  required bool value,
  required ValueChanged<bool> onToggle,
  required String label,
  Color activeColor = Colors.pink,
  Color inactiveColor = Colors.grey,
  Color toggleColor = Colors.white,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    decoration: BoxDecoration(
      color: Colors.white,
      //borderRadius: BorderRadius.circular(25.7),
      //border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        FlutterSwitch(
          value: value,
          onToggle: onToggle,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          toggleColor: toggleColor,
          width: 70.0,
          height: 35.0,
          borderRadius: 20.0,
          padding: 4.0,
        ),
        SizedBox(width: 8.0), // Space between the switch and the text
        Text(
			label, 
			style: TextStyle(
			  fontSize: 16,
			  color: AppColor.black,
			  fontFamily: 'Urbanist-Regular',
			),
		),
      ],
    ),
  );
}
