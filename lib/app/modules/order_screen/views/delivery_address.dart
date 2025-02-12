import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/config/custom_modal.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/views/card_payment_screen.dart';

import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/controllers/user_controller.dart';
import '../controllers/order_controller.dart';

class DeliveryAddressPage extends StatefulWidget {
  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {

	final userController = Get.find<UserController>();
	final OrderController orderController = Get.find();
	final CartController cartController = Get.find();
	//final CartController cartController = Get.put(CartController());
	
	@override
	void initState() {
		super.initState();
		orderController.deliveryAddressData();
		
		// Listen for profile verification changes
		  ever(userController.isProfileVerified, (value) {
			if (value == 1) {
			  Get.back(); // Close the dialog if it's open
			}
		  });
	}


	final TextEditingController addressTypeController = TextEditingController();
	final TextEditingController phoneController = TextEditingController();
	final TextEditingController addressController = TextEditingController();
	final FocusNode _addressTypeFocusNode = FocusNode();
	final FocusNode _phoneFocusNode = FocusNode();
	final FocusNode _addressFocusNode = FocusNode();
  
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	// Define a GlobalKey for the modalform
	final GlobalKey<FormState> _modalFormKey = GlobalKey<FormState>();
	
	void _showCustomModal(BuildContext context, String title, Widget content) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return CustomModal(
					title: title,
					content: content,
					onClose: () {
						Navigator.of(context).pop();
					},
				);
			},
		);
	}
	void _addDeliveryAddress(BuildContext context) {
	  // Clear previous form values
	  addressTypeController.clear();
	  phoneController.clear();
	  addressController.clear();

	  _addressTypeFocusNode.unfocus();
	  _phoneFocusNode.unfocus();
	  _addressFocusNode.unfocus();

	  _showCustomModal(
		context,
		'Add New Address',
		SingleChildScrollView(
		  scrollDirection: Axis.vertical,
		  child: Form(
			key: _modalFormKey,
			child: Column(
			  children: [
				Padding(
				  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  autoWidthTextField(
						text: Appcontent.addressType,
						width: MediaQuery.of(context).size.width,
						controller: addressTypeController,
						focusNode: _addressTypeFocusNode,
						validator: (value) {
						  if (value == null || value.isEmpty) {
							return 'Address type cannot be blank';
						  }
						  return null;
						},
						onChanged: (value) {
						  if (value.isNotEmpty) {
							_modalFormKey.currentState?.validate();
						  }
						},
					  ),
					  autoWidthTextField(
						text: Appcontent.phoneNumber,
						width: MediaQuery.of(context).size.width,
						controller: phoneController,
						focusNode: _phoneFocusNode,
						validator: (value) {
						  if (value == null || value.isEmpty) {
							return 'Phone number cannot be blank';
						  }
						  return null;
						},
						onChanged: (value) {
						  if (value.isNotEmpty) {
							_modalFormKey.currentState?.validate();
						  }
						},
					  ),
					  ConstrainedBox(
						constraints: const BoxConstraints(minHeight: 74, maxHeight: 150),
						child: textAreaFieldDynamic(
						  text: Appcontent.address,
						  width: MediaQuery.of(context).size.width,
						  controller: addressController,
						  focusNode: _addressFocusNode,
						  validator: (value) {
							if (value == null || value.isEmpty) {
							  return 'Address cannot be blank';
							}
							if (value.length < 10) {
							  return 'Your post must contain more than 10 characters.';
							}
							return null;
						  },
						  onChanged: (value) {
							if (value.isNotEmpty) {
							  _modalFormKey.currentState?.validate();
							}
						  },
						),
					  ),
					],
				  ),
				),
				const SizedBox(height: 15),
				Obx(() {
				  return product(
					text: orderController.isDAMLoading.value ? 'SAVING...' : 'SUBMIT',
					onPress: orderController.isDAMLoading.value
						? null
						: () {
							if (_modalFormKey.currentState!.validate()) {
							  orderController.addDeliveryAddress(
								addressTypeController.text.trim(),
								phoneController.text.trim(),
								addressController.text.trim(),
							  );
							  Navigator.pop(context);
							}
						  },
				  );
				}),
				const SizedBox(height: 10),
			  ],
			),
		  ),
		),
	  );
	}
	void _editDeliveryAddress(int index) {
	  // Get the selected address data
	  var selectedAddress = orderController.deliveryAddressListData[index];

	  // Pre-fill text fields
	  addressTypeController.text = selectedAddress["address_type"];
	  phoneController.text = selectedAddress["phone_number"];
	  addressController.text = selectedAddress["address"];

	  // Show the modal for editing
	  _showCustomModal(
		context,
		'Edit Delivery Address',
		SingleChildScrollView(
		  child: Form(
			key: _modalFormKey,
			child: Column(
			  children: [
				Padding(
				  padding: const EdgeInsets.all(10),
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  autoWidthTextField(
						text: Appcontent.addressType,
						width: MediaQuery.of(context).size.width,
						controller: addressTypeController,
						validator: (value) => value!.isEmpty ? 'Address type cannot be blank' : null,
					  ),
					  autoWidthTextField(
						text: Appcontent.phoneNumber,
						width: MediaQuery.of(context).size.width,
						controller: phoneController,
						validator: (value) => value!.isEmpty ? 'Phone number cannot be blank' : null,
					  ),
					  textAreaFieldDynamic(
						text: Appcontent.address,
						width: MediaQuery.of(context).size.width,
						controller: addressController,
						validator: (value) {
						  if (value == null || value.isEmpty) return 'Address cannot be blank';
						  if (value.length < 10) return 'Address must be at least 10 characters long.';
						  return null;
						},
					  ),
					],
				  ),
				),
				const SizedBox(height: 15),
				Obx(() {
				  return product(
					text: orderController.isDAMLoading.value ? 'UPDATING...' : 'UPDATE',
					onPress: orderController.isDAMLoading.value
						? null
						: () {
							if (_modalFormKey.currentState!.validate()) {
							  orderController.updateDeliveryAddress(
								selectedAddress["id"],
								addressTypeController.text.trim(),
								phoneController.text.trim(),
								addressController.text.trim(),
							  );
							  Navigator.pop(context); // Close modal
							}
						  },
				  );
				}),
			  ],
			),
		  ),
		),
	  );
	}
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Column(
      mainAxisSize: MainAxisSize.min, // Adjust the width of the row to fit its children
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
      children: [
        Text(
          "${cartController.itemCount.value} Items in your cart",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-Regular'),
        ),
        // Add Address Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
          child: GestureDetector(
		    onTap: () => _addDeliveryAddress(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text(
                  "Add Address",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Urbanist-semibold',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    GestureDetector(
      onTap: () {
        // Navigate to another page if needed
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Total",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.SecondaryGreyscale,
              fontFamily: 'Urbanist-Regular',
            ),
          ),
          SizedBox(height: 8),
          Text(
            "\$${cartController.totalPrice.value.toStringAsFixed(2)}",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.black,
              fontFamily: 'Urbanist-semibold',
            ),
          ),
        ],
      ),
    ),
  ],
),
                ],
              ),
            ),
            // Scrollable Middle Section (Delivery Address)
        Expanded(
          child: Obx(() {
              /*if (orderController.deliveryAddressListData.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
                  ),
                );
              }*/
			if (orderController.deliveryAddressListData.isEmpty) {
				return Center(
					child: Text(
					  "No delivery address found",
					  style: TextStyle(
						fontSize: 16,
						color: AppColor.black,
						fontFamily: 'Urbanist-semibold',
					  ),
					),
				);
			}
  
            return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address List
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Prevent scrolling inside
                  shrinkWrap: true, // Let ListView adjust its height
                  itemCount: orderController.deliveryAddressListData.length,
                  itemBuilder: (context, index) {
                    final item = orderController.deliveryAddressListData[index];
                    return Stack(
                      children: [
                        // Address Card
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 3,
                          color: AppColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                // Radio Button
                                Obx(() => Radio(
								  value: item["id"],
								  groupValue: orderController.selectedId.value, // Get selected ID from OrderController
								  activeColor: AppColor.purple,
								  onChanged: (value) {
									orderController.selectedId.value = value as int; // Update selected address
								  },
								)),
                                const SizedBox(width: 16),
                                // Address Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["address_type"],
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist-semibold',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item["phone_number"],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Urbanist-Regular',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item["address"],
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist-Regular',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () => _editDeliveryAddress(index),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Remove Button
                        Positioned(
                          top: 13,
                          right: 22,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                orderController.removeAddress(item["id"]); // Remove item
                              });
                            },
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.BlackGreyscale,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColor.BlackGreyscale,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
              ],
            ),
          );
		  }),
		  
		  
		  
        ),
            Obx(() {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Method",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColor.black,
                        fontFamily: 'Urbanist-semibold'),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Colors.transparent, // Transparent background
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color:
                              Colors.grey.shade200, // Background for the icon
                        ),
                        child: Icon(Icons.credit_card,
                            size: 24, color: Colors.black54),
                      ),
                      title: Text(
                        userController.isProfileVerified.value == 1
						  ? 'Profile Verified'
						  : 'Credit/Debit Card',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
						  color: userController.isProfileVerified.value == 1
							? Colors.green
							: Colors.black, // Green color for verified
                        ),
                      ),
                      trailing: userController.isProfileVerified.value == 1
						? null // No trailing icon when verified
						: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
					  onTap: userController.isProfileVerified.value == 1
						? null
						: () {
						  showDialog(
							context: context,
							builder: (context) => Dialog(
							  shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(15),
							  ),
							  child: Container(
								padding: EdgeInsets.all(20),
								width: MediaQuery.of(context).size.width * 0.8,
								height: MediaQuery.of(context).size.height * 0.6, // Adjust size
								child: CardVerificationScreen(),
							  ),
							),
						  );
						},
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            );
			}),
			if (userController.isProfileVerified.value == 1) ...[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Obx(() {
                  return autoWidthBtn(
                    text: orderController.isDAloading.value
                        ? 'Paying...'
                        : Appcontent.payNow,
                    width: screenWidth,
                    onPress: orderController.isDAloading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              orderController.payNow();
                            } else {}
                          },
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
			]
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 3),
    );
  }
}
