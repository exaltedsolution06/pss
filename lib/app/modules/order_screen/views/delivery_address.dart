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

import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';
import '../controllers/order_controller.dart';

class DeliveryAddressPage extends StatefulWidget {
  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {

	final OrderController orderController = Get.find();
	final CartController cartController = Get.find();
	//final CartController cartController = Get.put(CartController());
	
	@override
	void initState() {
		super.initState();
		orderController.deliveryAddressData();
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
            onTap: () => _showCustomModal(
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
                              width: screenWidth,
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
                              width: screenWidth,
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
                                width: screenWidth,
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
                                        addressController.text.trim()
                                      );
									  Navigator.pop(context); // Close modal
                                    } else {
                                      if (_addressTypeFocusNode.hasFocus) {
                                        _addressTypeFocusNode.requestFocus();
                                      } else if (_phoneFocusNode.hasFocus) {
                                        _phoneFocusNode.requestFocus();
                                      } else if (_addressFocusNode.hasFocus) {
                                        _addressFocusNode.requestFocus();
                                      }
                                    }
                                  },
							);
                        }),
						
                      /*product(
                        text: 'SUBMIT',
                        onPress: () {
                          if (_modalFormKey.currentState?.validate() ?? false) {
                            Navigator.pop(context); // Close modal
                          } else {
                            print("Validation failed");
                          }
                        },
                      ),*/
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
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
              if (orderController.deliveryAddressListData.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
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
                                Radio(
                                  value: item["id"],
                                  groupValue: selectedId,
                                  activeColor: AppColor.purple,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedId = value; // Update selected address
                                    });
                                  },
                                ),
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
                                  onPressed: () {
                                    // Logic for editing
                                  },
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
                                orderController.deliveryAddressListData.removeAt(index); // Remove item
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
            
            Padding(
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
                        'Credit/Debit Card',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.black54),
                      onTap: () {
                        // Handle onTap action
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
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
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 3),
    );
  }
}
