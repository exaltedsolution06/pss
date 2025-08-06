import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

import '../controllers/wish_list_controller.dart';

class WishListCreateView extends GetView<WishListController> {
  WishListCreateView({Key? key}) : super(key: key);

  final WishListController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final List<String> relationships = [
    'Grandfather',
    'Grandmother',
    'Father',
    'Mother',
    'Spouse',
    'Brother',
    'Sister',
    'Son',
    'Daughter',
    'Grandson',
    'Granddaughter',
    'Friend',
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController anniversaryController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();

  final RxnString selectedRelation = RxnString();

  @override
  Widget build(BuildContext context) {
  
    final double screenWidth = MediaQuery.of(context).size.width;
		
	// Method to show date picker
	Future<void> _selectBdate(BuildContext context) async {
	  final DateTime? pickedDate = await showDatePicker(
		context: context,
		initialDate: DateTime.now(),
		firstDate: DateTime(1900),
		//firstDate: DateTime(2000),
		lastDate: DateTime(2101),
		builder: (BuildContext context, Widget? child) {
		  return Theme(
			data: Theme.of(context).copyWith(
			  colorScheme: ColorScheme.light(
				primary: Colors.red, // Change the header background color (also OK button)
				onPrimary: Colors.white, // Change the text color of the header (OK button text color)
				onSurface: Colors.black, // Change the text color of the body (dates, months, year text)
			  ),
			  textButtonTheme: TextButtonThemeData(
				style: TextButton.styleFrom(
				  foregroundColor: Colors.red, // Change the color of the "Cancel" and "OK" buttons
				),
			  ),
			  dialogBackgroundColor: Colors.white, // Change the background color of the dialog
			),
			child: child!,
		  );
		},
	  );

	  if (pickedDate != null) {
		birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
	  }
	}
	Future<void> _selectAdate(BuildContext context) async {
	  final DateTime? pickedDate = await showDatePicker(
		context: context,
		initialDate: DateTime.now(),
		firstDate: DateTime(1900),
		//firstDate: DateTime(2000),
		lastDate: DateTime(2101),
		builder: (BuildContext context, Widget? child) {
		  return Theme(
			data: Theme.of(context).copyWith(
			  colorScheme: ColorScheme.light(
				primary: Colors.red, // Change the header background color (also OK button)
				onPrimary: Colors.white, // Change the text color of the header (OK button text color)
				onSurface: Colors.black, // Change the text color of the body (dates, months, year text)
			  ),
			  textButtonTheme: TextButtonThemeData(
				style: TextButton.styleFrom(
				  foregroundColor: Colors.red, // Change the color of the "Cancel" and "OK" buttons
				),
			  ),
			  dialogBackgroundColor: Colors.white, // Change the background color of the dialog
			),
			child: child!,
		  );
		},
	  );

	  if (pickedDate != null) {
		anniversaryController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
	  }
	}
	
    return Scaffold(
      appBar: AppBar(title: const Text("Create Wishlist")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /*DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Select Relation",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedRelation.value,
                    items: relationships.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedRelation.value = newValue;
                    },
                    validator: (value) =>
                        value == null ? 'Please select a relation' : null,
                  ),*/
				  dropdownFieldFinal(
					text1: "Select Relation",
					width: screenWidth,
					value: selectedRelation.value ?? '',
                    items: relationships.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedRelation.value = newValue;
                    },
                    validator: (value) =>
                        value == null ? 'Please select a relation' : null,
				  ),
				  autoWidthTextField(
					  text: "Email",
					  width: screenWidth,
					  controller: emailController,
					  validator: (value) {
						  if (value!.isEmpty) return 'Email is required';
						  return null;
					  },
				  ),
				  autoWidthTextField(
					  text: "Phone",
					  width: screenWidth,
					  controller: phoneController,
					  validator: (value) {
                      if (value!.isEmpty) return 'Phone is required';
						  return null;
					  },
				  ),
				  autoWidthDateField(
					text: "Birthday",
					width: screenWidth,
					controller: birthdayController,
					onTap: () {
					  _selectBdate(context);
					},
				  ),
				  autoWidthDateField(
					text: "Anniversary",
					width: screenWidth,
					controller: anniversaryController,
					onTap: () {
					  _selectAdate(context);
					},
				  ),
				  autoWidthTextField(
					  text: "Facebook Address",
					  width: screenWidth,
					  controller: facebookController,
				  ),
				  autoWidthTextField(
					  text: "Instagram Address",
					  width: screenWidth,
					  controller: instagramController,
				  ),
				  autoWidthTextField(
					  text: "TikTok Address",
					  width: screenWidth,
					  controller: tiktokController,
				  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedRelation.value != null) {
                        controller.addEntry({
                          'relation': selectedRelation.value!,
                          'email': emailController.text.trim(),
                          'phone': phoneController.text.trim(),
                          'birthday': birthdayController.text.trim(),
                          'anniversary': anniversaryController.text.trim(),
                          'facebook': facebookController.text.trim(),
                          'instagram': instagramController.text.trim(),
                          'tiktok': tiktokController.text.trim(),
                        });

                        // Reset inputs
                        selectedRelation.value = null;
                        emailController.clear();
                        phoneController.clear();
                        //_formKey.currentState!.reset();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  ),
                  const SizedBox(height: 20),
                  if (controller.wishListEntries.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Added Contacts:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...controller.wishListEntries.asMap().entries.map((entry) {
						  final index = entry.key;
						  final data = entry.value;

						  return Card(
							child: ListTile(
							  title: Text(data['relation'] ?? ''),
							  subtitle: Text("Email: ${data['email']}\nPhone: ${data['phone']}"),
							  trailing: IconButton(
								icon: Icon(Icons.delete, color: Colors.red),
								onPressed: () {
								  controller.wishListEntries.removeAt(index);
								},
							  ),
							),
						  );
						}).toList(),
						const SizedBox(height: 20),
						autoWidthBtn(
							text: controller.isLoading.value ? 'Submitting...' : Appcontent.submit,
							width: screenWidth,
							onPress: controller.isLoading.value
								? null
								: () {
									controller.wishListCreate(controller.wishListEntries);
								  },
						  )
                      ],
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
