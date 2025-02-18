import 'package:flutter/material.dart';
import 'package:picturesourcesomerset/config/app_color.dart';

//used
Widget autoWidthTextField({
  required String text,
  required double width,
  IconData? icon,
  IconData? subicon,
  IconData? subicone,
  String? defaultValue,
  TextEditingController? controller,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  FocusNode? focusNode,
  Widget? suffixIcon,
  bool obscureText = false,
}) {
  // Use the provided controller or create a new one if not provided
  final TextEditingController _controller = controller ?? TextEditingController(text: defaultValue);

  // Clean up the controller if created internally
  void _disposeController() {
    if (controller == null) {
      _controller.dispose();
    }
  }

  return SizedBox(
    height: 68,
    width: width,
    child: TextFormField(
      controller: _controller,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      obscureText: obscureText,
      style: const TextStyle(color: AppColor.formTextColor),
      decoration: InputDecoration(
		/*labelText: text,
		labelStyle: TextStyle(
          color: AppColor.formTextColor,  // Use the passed color or default to grey
		  fontSize: 14,
		  fontFamily: 'Urbanist-regular'
        ),*/
        hintText: text,
		hintStyle: TextStyle(
			color: AppColor.formTextColor, 
			fontFamily: 'Urbanist-regular', 
			fontSize: 14
		),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColor.formBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColor.formBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
		  fontFamily: 'Urbanist-regular'
        ),
      ),
    ),
  );
}

Widget textFieldWithIconDynamic({
  required String text,
  required double width,
  IconData? icon,
  IconData? subicon,
  IconData? subicone,
  String? defaultValue,
  TextEditingController? controller,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  FocusNode? focusNode,
  Widget? suffixIcon,
  bool obscureText = false,
}) {
  // Use the provided controller or create a new one if not provided
  final TextEditingController _controller = controller ?? TextEditingController(text: defaultValue);

  return Container(
	height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    child: TextFormField(
      controller: _controller,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        //contentPadding: const EdgeInsets.symmetric(vertical: 0).copyWith(left: 50), // Shift text after icon
        contentPadding: const EdgeInsets.symmetric(vertical: 0).copyWith(left: 5), // Shift text after icon
        /*labelText: text,
		labelStyle: TextStyle(
          color: AppColor.formTextColor,  // Use the passed color or default to grey
		  fontSize: 14,
		  fontFamily: 'Urbanist-regular'
        ),*/
        hintText: text,
		hintStyle: TextStyle(
			color: AppColor.formTextColor, 
			fontFamily: 'Urbanist-regular', 
			fontSize: 14
		),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        // Icon on the left
        prefixIcon: icon != null
            ? Container(
				padding: const EdgeInsets.only(left: 10.0, right: 2.0),
				margin: const EdgeInsets.only(right: 9.0),
				decoration: BoxDecoration(
				  //color: AppColor.Greyscale,
				  borderRadius: BorderRadius.only(
					topLeft: Radius.circular(25.7),
					topRight: Radius.circular(0),
					bottomLeft: Radius.circular(25.7),
					bottomRight: Radius.circular(0),
				  ),
				),
				child: Icon(icon, color: Colors.grey.shade700),
			  )
            : null,
        // Custom border when enabled (unfocused)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        // Custom border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
		  fontFamily: 'Urbanist-regular'
        ),
        // Adjust constraints for the icon to give it space from the label text
        prefixIconConstraints: BoxConstraints(
          minWidth: 38, // Ensure the icon area has enough space
          minHeight: 40,
        ),
      ),
    ),
  );
}


// Define a TextField for the textarea
Widget textAreaFieldDynamic({
  required String text,
  required double width,
  TextEditingController? controller,
  FocusNode? focusNode,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
}) {
  // Use the provided controller or create a new one if not provided
  final TextEditingController _controller = controller ?? TextEditingController();

  // Clean up the controller if created internally
  void _disposeController() {
    if (controller == null) {
      _controller.dispose();
    }
  }

  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
		focusNode: focusNode,
		controller: _controller,
		maxLines: null, // Allows the TextField to be multiline and grow
		minLines: 5, // Sets the minimum number of lines, increasing the default height
		decoration: InputDecoration(
        /*labelText: text,
		labelStyle: TextStyle(
          color: AppColor.formTextColor,  // Use the passed color or default to grey
		  fontSize: 14,
		  fontFamily: 'Urbanist-regular'
        ),*/
        hintText: text,
		hintStyle: TextStyle(
			color: AppColor.formTextColor, 
			fontFamily: 'Urbanist-regular', 
			fontSize: 14
		),
        alignLabelWithHint: true, // Align the hint text with the top
        contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        focusedBorder: OutlineInputBorder(
			borderRadius: BorderRadius.circular(6),
			borderSide: const BorderSide(color: Color(0xffE2E8F0)),
		),
		enabledBorder: OutlineInputBorder(
			borderRadius: BorderRadius.circular(6),
			borderSide: const BorderSide(color: Color(0xffE2E8F0)),
		),
		errorBorder: OutlineInputBorder(
			borderRadius: BorderRadius.circular(6),
			borderSide: const BorderSide(color: Colors.red),
		),
		focusedErrorBorder: OutlineInputBorder(
			borderRadius: BorderRadius.circular(6),
			borderSide: const BorderSide(color: Colors.red),
		),
		errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
		  fontFamily: 'Urbanist-regular'
        ),
      ),
      keyboardType: TextInputType.multiline, // Ensure multiline input is supported
      validator: validator,
      onChanged: onChanged,
    ),
  );
}


// Date Field
Widget autoWidthDateField({
  required String text,
  required double width,
  IconData? icon,
  IconData? subicon,
  IconData? subicone,
  String? defaultValue,
  TextEditingController? controller,
  void Function()? onTap,
}) {
  // If controller is not provided, create a new one with the default value
  final TextEditingController effectiveController = controller ?? TextEditingController(text: defaultValue);

  return SizedBox(
    height: 68,
    width: width,
    child: TextField(
      controller: effectiveController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        /*labelText: text,
		labelStyle: TextStyle(
          color: AppColor.formTextColor,  // Use the passed color or default to grey
		  fontSize: 14,
		  fontFamily: 'Urbanist-regular'
        ),*/
        hintText: text,
		hintStyle: TextStyle(
			color: AppColor.formTextColor, 
			fontFamily: 'Urbanist-regular', 
			fontSize: 14
		),
        //contentPadding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
		contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
		errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
		  fontFamily: 'Urbanist-regular'
        ),
      ),
      onTap: onTap,
      readOnly: onTap != null, // Make the field read-only if onTap is provided
    ),
  );
}


Widget dropdownFieldFinal({
  Key? key,
  required String text1,
  required double width,
  required String value,
  required List<DropdownMenuItem<String>> items,
  FormFieldValidator<String>? validator,
  required ValueChanged<String?> onChanged,
  bool isEnabled = true, // Add a new parameter to control enabled state
}) {
  return SizedBox(
    key: key,
    height: 68,
    width: width,
    child: DropdownButtonFormField<String>(
      value: value.isNotEmpty ? value : null, // Handle empty case
      decoration: InputDecoration(
        isDense: true, // Compact layout
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Adjust padding for alignment
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontFamily: 'Urbanist-regular',
        ),
      ),
      hint: Text(
        text1,
        style: const TextStyle(
          color: Color(0xFF6B7280), // Replace with AppColor.formTextColor
          fontFamily: 'Urbanist-regular',
          fontSize: 16,
        ),
        textAlign: TextAlign.start, // Left alignment
      ),
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      validator: validator,
      onChanged: isEnabled ? onChanged : null, // Disable interaction if not enabled
      items: isEnabled ? items : null, // Disable dropdown if not enabled
      dropdownColor: isEnabled ? Colors.white : Colors.grey[200], // Optional: Change dropdown background when disabled
    ),
  );
}




///////////////////////////////////////

Widget autoWidthTextFieldForComment({
  required String text,
  required String text1,
  required double width,
  IconData? icon,
  IconData? subicon,
  IconData? subicone,
  String? defaultValue,
  TextEditingController? controller,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  FocusNode? focusNode,
  Widget? suffixIcon,
  bool obscureText = false,
  ScrollController? scrollController, // Add a separate ScrollController
}) {
  // Use the provided controller or create a new one if not provided
  final TextEditingController _controller = controller ?? TextEditingController(text: defaultValue);
  final ScrollController _scrollController = scrollController ?? ScrollController(); // Use separate ScrollController

  return Theme(
    data: ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white, // Change cursor color
        selectionColor: Colors.white.withOpacity(0.3), // Change selection highlight color
        selectionHandleColor: Colors.white, // Change the selection handle color
      ),
    ),
    child: SizedBox(
      height: 74,
      width: width,
      child: TextFormField(
        controller: _controller,
        scrollController: _scrollController,
        validator: validator,
        onChanged: onChanged,
        focusNode: focusNode,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: text1,
          labelStyle: const TextStyle(
            color: Colors.white, // Customize label text color
          ),
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.white70, // Customize hint text color
          ),
          suffixIcon: suffixIcon, // Add suffixIcon if provided
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: const BorderSide(color: Color(0xffE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: const BorderSide(color: Color(0xffE2E8F0)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}








///////////////////////////////////////////////
Widget textFieldWithIcon({
  required String text,
  IconData? icon,
  required String text1
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25.7),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        hintText: text,
        labelText: text1,
		labelStyle: TextStyle(
          color: AppColor.black,  // Use the passed color or default to grey
        ),
        prefixIcon: icon != null
            ? Container(
                padding: const EdgeInsets.only(left: 10.0, right: 12.0),
				margin: const EdgeInsets.only(right: 9.0),
                decoration: BoxDecoration(
                  color: AppColor.Greyscale,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.7),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(25.7),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Icon(icon, color: Colors.grey.shade700),
              )
            : null,
        //suffixIcon: SizedBox(width: 10), // Adjust the width to create space after the icon
        border: InputBorder.none,
      ),
    ),
  );
}




Widget textfield(
    {required String text,
    IconData? icon,
     IconData? subicon,
    IconData? subicone,
    required String text1}) {
  return TextField(
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelText: text1,
		labelStyle: TextStyle(
          color: AppColor.black,  // Use the passed color or default to grey
        ),
        hintText: text,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade200),
        )),
  );
}

Widget textfield1(
    {required String text,
    IconData? icon,
    String? subicon,
    IconData? subicone,
    required String text1}) {
  return TextField(
    decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintText: text,
        labelText: text1,
		labelStyle: TextStyle(
          color: AppColor.black,  // Use the passed color or default to grey
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade200),
        )),
  );
}

Widget textfield2({IconData? icon, IconData? subicon, IconData? subicone}) {
  return SizedBox(
    height: 32,
    width: 239,
    child: TextField(
      style: const TextStyle(color: Colors.grey),
      decoration: InputDecoration(
        suffixIcon: Icon(subicon),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    ),
  );
}

// Edit profile
Widget textfield3(
    {required String text,
    required String text1,
    IconData? icon,
    IconData? subicon,
    IconData? subicone}) {
  return SizedBox(
    height: 74,
    width: 350,
    child: TextField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: text1,
		labelStyle: TextStyle(
          color: AppColor.black,  // Use the passed color or default to grey
        ),
        hintText: text,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
      ),
    ),
  );
}


//Date Field with right side rounded corner
Widget autoWidthDateFieldOneSideRounded({
  required String text,
  required String text1,
  required double width,
  IconData? icon,
  IconData? subicon,
  IconData? subicone,
  String? defaultValue,
  TextEditingController? controller,
  void Function()? onTap,
}) {
  // If controller is not provided, create a new one with the default value
  final TextEditingController effectiveController = controller ?? TextEditingController(text: defaultValue);

  return SizedBox(
    height: 74,
    width: width,
    child: TextField(
      controller: effectiveController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: text1,
		labelStyle: TextStyle(
          color: AppColor.black,  // Use the passed color or default to grey
        ),
        hintText: text,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
			topLeft: Radius.circular(0),
			topRight: Radius.circular(35),
			bottomLeft: Radius.circular(0),
			bottomRight: Radius.circular(35),
		  ),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.only(
			topLeft: Radius.circular(0),
			topRight: Radius.circular(35),
			bottomLeft: Radius.circular(0),
			bottomRight: Radius.circular(35),
		  ),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
      ),
      onTap: onTap,
      readOnly: onTap != null, // Make the field read-only if onTap is provided
    ),
  );
}


// Define a TextField for the textarea

Widget textAreaField({required String text, required double width}) {
  return Container(
    width: width,
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      maxLines: null, // Allows the TextField to be multiline
	  expands: true,
      decoration: InputDecoration(
        hintText: text,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
      ),
    ),
  );
}

// Half text field
Widget textfield4(
    {required String text,
    required String text1,
    IconData? icon,
    IconData? subicon,
    IconData? subicone}) {
  return SizedBox(
    height: 74,
    width: 175,
    child: TextField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: text1,
		labelStyle: TextStyle(
          color: AppColor.black,  // Use the passed color or default to grey
        ),
        hintText: text,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
      ),
    ),
  );
}

// Live comment textfield
Widget livetextfield({required String text,}) {
  return SizedBox(
    height: 44,
    width: 215,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.40),
        borderRadius: BorderRadius.circular(35),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Urbanist-medium'),
        decoration: InputDecoration(
          hintText: text,hintStyle: const TextStyle(color: Colors.white, fontFamily: 'Urbanist-medium'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide:  BorderSide(color: Colors.grey.withOpacity(0.40)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide:  BorderSide(color: Colors.grey.withOpacity(0.40)),
          ),
        ),
      ),
    ),
  );
}

// General Settings and Search
// ignore: non_constant_identifier_names
Widget General({required String text,}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: TextField(
      autofocus: false,
      style: const TextStyle(fontSize: 16, color: Color(0xFF94A3B8)),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(Icons.search, color: Colors.grey.shade700),
          //child: Image.asset('assets/search.png',height: 20,width: 20,),
		  
        ),
        filled: true,
        fillColor: const Color(0xffF8F9FD),
        hintText: 'search...',hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Urbanist-regular', fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff3BBAA6)),
          borderRadius: BorderRadius.circular(25.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffF8F9FD)),
          borderRadius: BorderRadius.circular(25.7),
        ),
      ),
    ),
  );
}









Widget dropdownField({
  Key? key,
  required String text1,
  required double width,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return SizedBox(
    key: key,
    height: 74,
    width: width,
    child: DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: text1,
		labelStyle: TextStyle(
          color: AppColor.black,  // Use the passed color or default to grey
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Color(0xffE2E8F0)),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down),
      isExpanded: true,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    ),
  );
}
