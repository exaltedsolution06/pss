import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'activity_screen_controller.dart';

class WalletScreenView extends GetView<ActivityScreenController> {
  WalletScreenView({super.key});
  final ActivityScreenController activityScreenController = Get.find();
  
  
  
  final TextEditingController depositAmountController = TextEditingController();
  final TextEditingController withdrawAmountController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController paymentAccountController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final FocusNode _depositAmountFocusNode = FocusNode();
  final FocusNode _withdrawAmountFocusNode = FocusNode();
  final FocusNode _bankAccountFocusNode = FocusNode();
  final FocusNode _paymentAccountFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
	activityScreenController.fetchWalletBalance();
	
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Wallet', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
		child: Form(
			key: _formKey,
			child: Column(
			  crossAxisAlignment: CrossAxisAlignment.stretch,
			  children: [
				Column(
				  children: [
					Padding(
					  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
					  child: Text(
						'Your payments & wallet',
						style: TextStyle(
						  fontSize: 14,
						  color: AppColor.black, // Adjust as per AppColor
						  fontFamily: 'Urbanist-Regular',
						),
					  ),
					),
				  ],
				),
				Obx(() {
				return Column(
				  crossAxisAlignment: CrossAxisAlignment.center,
				  children: [
					Padding(
					  padding: EdgeInsets.only(left: 30.0, top: 0, right: 30.0, bottom: 0),
					  child: WarningMessage(
						price: activityScreenController.available_balance.value,
						message: "Available funds. You can deposit more money or become a creator to earn more."
					  ),
					),
				  ],
				);
				}),
				const SizedBox(height: 10),
				DefaultTabController(
				  length: 2,
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
					  const TabBar(
						indicatorColor: AppColor.purple,
						tabs: [
						  Tab(
							child: Text('Deposit', style: TextStyle(color: Colors.black, fontSize: 16)),
						  ),
						  Tab(
							child: Text('Withdraw', style: TextStyle(color: Colors.black, fontSize: 16)),
						  ),
						],
					  ),
					  SizedBox(
						height: MediaQuery.of(context).size.height - 150,
						child: TabBarView(
						  children: [
							// Content for the 'Deposit' tab
							Padding(
							  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
							  child: Column(
								children: [
								  const SizedBox(height: 15),
								  const Text(
									'Proceed with payment',
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.BlackGreyscale,
									  fontFamily: 'Urbanist-semibold'
									),
								  ),
								  const SizedBox(height: 15),
									textFieldWithIconDynamic(
										text: '0',
										text1: 'Amount (\$5 min, \$500 max)',
										icon: Icons.payments, // Pass the desired icon here
										width: screenWidth,
										controller: depositAmountController,
										focusNode: _depositAmountFocusNode,
										validator: (value) {
											if (value == null || value.isEmpty) {
												return 'Amount cannot be blank';
											}
											final int? amount = int.tryParse(value);
											if (amount == null) {
											  return 'Please enter a valid integer';
											}
											if (amount < 5 || amount > 500) {
											  return 'Amount must be between \$5 and \$500';
											}
										},
										onChanged: (value) {
										  if (value.isNotEmpty) {
											_formKey.currentState?.validate();
										  }
										},
									),
								  /*textFieldWithIcon(
									text: '0',
									icon: Icons.payments, // Pass the desired icon here
									text1: 'Amount (\$5 min, \$500 max)',
								  ),*/
								  const SizedBox(height: 15),
									Obx(() {
										return autoWidthBtn(
										text: activityScreenController.isLoading.value ? 'ADDING FUNDS...' : 'ADD FUNDS',
										width: screenWidth,
										onPress: activityScreenController.isLoading.value
											? null
											: () {
												if (_formKey.currentState!.validate()) {
													int depositAmount = int.parse(depositAmountController.text.trim());
													activityScreenController.wallet_deposit(depositAmount);
												} else {
													if (_depositAmountFocusNode.hasFocus) {
														_depositAmountFocusNode.requestFocus();
													}
												}
											},
										);
									}),
								  /*autoWidthBtn(
									text: 'ADD FUNDS',
									width: screenWidth,
									onPress: () {
									  // Your onPress action here
									},
								  ),*/
								],
							  ),
							),
							// Content for the 'Withdraw' tab
							Padding(
							  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
							  child: Column(
								children: [
									const SizedBox(height: 15),
									Obx(() {
										return Text(
											'Pending balance (${activityScreenController.pending_balance.value})',
											style: TextStyle(
											  fontSize: 14,
											  color: AppColor.black,
											  fontFamily: 'Urbanist-Regular'
											),
										);
									}),
									const SizedBox(height: 15),
									textFieldWithIconDynamic(
										text: '0',
										text1: 'Amount (\$20 min, \$500 max)',
										icon: Icons.payments, // Pass the desired icon here
										width: screenWidth,
										controller: withdrawAmountController,
										focusNode: _withdrawAmountFocusNode,
										validator: (value) {
											if (value == null || value.isEmpty) {
												return 'Amount cannot be blank';
											}
											final int? amount = int.tryParse(value);
											if (amount == null) {
											  return 'Please enter a valid integer';
											}
											if (amount < 20 || amount > 500) {
											  return 'Amount must be between \$20 and \$500';
											}
										},
										onChanged: (value) {
										  if (value.isNotEmpty) {
											_formKey.currentState?.validate();
										  }
										},
									),
									const SizedBox(height: 15),
									Obx(() {
										// Ensure the selected value is valid and matches one of the DropdownMenuItem values
										  String? currentPMValue = activityScreenController.selectedPaymentMethods.value.isNotEmpty
											  ? activityScreenController.selectedPaymentMethods.value
											  : null;

										  // Check if the current value exists in the list
										  bool isValidValue = activityScreenController.paymentMethods
											  .any((pm) => pm.toString() == currentPMValue);

										  if (!isValidValue) {
											currentPMValue = null; // Reset to null if the value is not valid
										  }
										  
									  return Column(
										children: [
										  dropdownFieldFinal(
											text1: 'Payment method',
											width: screenWidth,
											value: currentPMValue ?? '',
											items: activityScreenController.paymentMethods
												.map<DropdownMenuItem<String>>((pm) => DropdownMenuItem<String>(
													  value: pm.toString(), // Use ID as the value
													  child: Text(pm),    // Display name
													))
												.toList(),
											onChanged: (value) {
											  // Update the selected payment method
											  activityScreenController.updatePaymentMethods(value!);

											  // Perform actions based on the selected value
											  if (value == 'Bank transfer') {
												// Display Bank Name field
												activityScreenController.showBankNameField.value = true;
											  } else {
												// Hide Bank Name field
												activityScreenController.showBankNameField.value = false;
											  }
											},
										  ),
										  const SizedBox(height: 8),
										  // Display Bank Name field conditionally
										  activityScreenController.showBankNameField.value
											  ? autoWidthTextField(
												  text: "Bank account",
												  width: screenWidth,
												  controller: bankAccountController,
												  focusNode: _bankAccountFocusNode,
												  validator: (value) {
													if (value == null || value.isEmpty) {
													  return 'Bank account cannot be blank';
													}
													return null;
												  },
												  onChanged: (value) {
													if (value.isNotEmpty) {
													  _formKey.currentState?.validate();
													}
												  },
												)
											  : autoWidthTextField(
												  text: "Payment account",
												  width: screenWidth,
												  controller: paymentAccountController,
												  focusNode: _paymentAccountFocusNode,
												  validator: (value) {
													if (value == null || value.isEmpty) {
													  return 'Payment account cannot be blank';
													}
													return null;
												  },
												  onChanged: (value) {
													if (value.isNotEmpty) {
													  _formKey.currentState?.validate();
													}
												  },
												),
											],
										);
									}),
									ConstrainedBox(
										  constraints: const BoxConstraints(
											minHeight: 74, // Set minimum height
											maxHeight: 150, // Set maximum height
										  ),
										  child: textAreaFieldDynamic(
											text: 'Bank account, notes, etc.', // Hint text
											width: screenWidth, // Screen width or custom width
											controller: messageController,
											focusNode: _messageFocusNode,
										  ),
									),

								  const SizedBox(height: 15),
									Obx(() {
										// Determine the current values for gender and country, defaulting to null if not set
										final selectedPaymentMethodValue = activityScreenController.selectedPaymentMethods.value;

										  // Handle potential parsing issues
										final paymentMethods = selectedPaymentMethodValue.isNotEmpty
											? selectedPaymentMethodValue
											: '';
										  
										return autoWidthBtn(
										text: activityScreenController.isLoading.value ? 'REQUESTING WITHDRAWAL...' : 'REQUEST WITHDRAWAL',
										width: screenWidth,
										onPress: activityScreenController.isLoading.value
											? null
											: () {
												if (_formKey.currentState!.validate()) {
													int withdrawAmount = int.parse(withdrawAmountController.text.trim());
													activityScreenController.wallet_request_withdraw(
														withdrawAmount,
														paymentMethods,
														bankAccountController.text.trim().isNotEmpty ? bankAccountController.text.trim() : paymentAccountController.text.trim(),
														messageController.text.trim() ?? ''
													);
												} else {
													if (_withdrawAmountFocusNode.hasFocus) {
														_withdrawAmountFocusNode.requestFocus();
													}
												}
											},
										);
									}),
								  /*autoWidthBtn(
									text: 'REQUEST WITHDRAWAL',
									width: screenWidth,
									onPress: () {
									  // Your onPress action here
									},
								  ),*/
								],
							  ),
							),
						  ],
						),
					  ),
					],
				  ),
				),
				const SizedBox(height: 10),
			  ],
			),
		),
      ),
    );
  }
}

class WarningMessage extends StatefulWidget {
  final String price;
  final String message;

  WarningMessage({required this.price, required this.message});

  @override
  _WarningMessageState createState() => _WarningMessageState();
}

class _WarningMessageState extends State<WarningMessage> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                //colors: [Colors.purple, Colors.pink],
                colors: [AppColor.purple, AppColor.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.message,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isVisible = false;
                    });
                  },
                ),
              ],
            ),
          )
        : SizedBox.shrink(); // Renders nothing when not visible
  }
}

