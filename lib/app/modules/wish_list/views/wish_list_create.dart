import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    'Son',
    'Daughter',
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController anniversaryController = TextEditingController();

  final RxnString selectedRelation = RxnString();

  @override
  Widget build(BuildContext context) {
  
    final double screenWidth = MediaQuery.of(context).size.width;
	
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
                  DropdownButtonFormField<String>(
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
                  ),
				  /*dropdownFieldFinal(
					text1: Appcontent.placeholderCountry,
					width: screenWidth,
					value: selectedRelation.value?.isNotEmpty ? selectedRelation.value : '0',
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Email is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Phone is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: birthdayController,
                    decoration: const InputDecoration(
                      labelText: "Birthday",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1990),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        birthdayController.text =
                            pickedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: anniversaryController,
                    decoration: const InputDecoration(
                      labelText: "Anniversary",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        anniversaryController.text =
                            pickedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                  ),
                  const SizedBox(height: 16),
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
                        });

                        // Reset inputs
                        selectedRelation.value = null;
                        emailController.clear();
                        phoneController.clear();
                        birthdayController.clear();
                        anniversaryController.clear();
                        _formKey.currentState!.reset();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Another"),
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
                        ...controller.wishListEntries.map((entry) {
                          return Card(
                            child: ListTile(
                              title: Text(entry['relation'] ?? ''),
                              subtitle: Text(
                                  "Email: ${entry['email']}\nPhone: ${entry['phone']}\nBirthday: ${entry['birthday']}\nAnniversary: ${entry['anniversary']}"),
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
									//controller.wishListCreate(controller.wishListEntries);
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
