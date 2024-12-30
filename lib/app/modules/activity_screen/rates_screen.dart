import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import '../../../config/custom_switch.dart';
import '../../../../config/app_color.dart';
import 'activity_screen_controller.dart';

class RatesScreenView extends GetView<ActivityScreenController> {
  const RatesScreenView({super.key});
	
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
	final ActivityScreenController activityScreenController = Get.find();
	
	activityScreenController.shouldFetchRates = true;
	
	

	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

	final FocusNode _profileAccessPriceFocusNode = FocusNode();
	final FocusNode _profileAccessPriceThreeMonthsFocusNode = FocusNode();
	final FocusNode _profileAccessPriceSixMonthsFocusNode = FocusNode();
	final FocusNode _profileAccessPriceTweleveMonthsFocusNode = FocusNode();
	final FocusNode _isOfferActiveFocusNode = FocusNode();
	final FocusNode _currentOfferExpiresAtFocusNode = FocusNode();
  

    

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
        title: const Text('Rates', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (activityScreenController.isFetchingData.value) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
        } else {
			// Ensure that the controller is only set once
			if (activityScreenController.profileAccessPriceController.text.isEmpty && activityScreenController.profile_access_price.value != null) {
				activityScreenController.profileAccessPriceController.text = activityScreenController.profile_access_price.value!;
			} 
			if (activityScreenController.profileAccessPriceThreeMonthsController.text.isEmpty && activityScreenController.profile_access_price_3_months.value != null) {
				activityScreenController.profileAccessPriceThreeMonthsController.text = activityScreenController.profile_access_price_3_months.value!;
			} 
			if (activityScreenController.profileAccessPriceSixMonthsController.text.isEmpty && activityScreenController.profile_access_price_6_months.value != null) {
				activityScreenController.profileAccessPriceSixMonthsController.text = activityScreenController.profile_access_price_6_months.value!;
			} 
			if (activityScreenController.profileAccessPriceTweleveMonthsController.text.isEmpty && activityScreenController.profile_access_price_12_months.value != null) {
				activityScreenController.profileAccessPriceTweleveMonthsController.text = activityScreenController.profile_access_price_12_months.value!;
			} 
			if (activityScreenController.currentOfferExpiresAtController.text.isEmpty && activityScreenController.current_offer_expires_at.value != null) {
				activityScreenController.currentOfferExpiresAtController.text = activityScreenController.current_offer_expires_at.value!;
			}
			return SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: Form(
					key: _formKey,
					child: Column(
						  crossAxisAlignment: CrossAxisAlignment.stretch,
						  children: [
							Column(
							  children: [
								Padding(
								  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
								  child: Text(
									'Prices & Bundles',
									style: TextStyle(
									  fontSize: 14,
									  color: AppColor.black, // Adjust as per AppColor
									  fontFamily: 'Urbanist-Regular',
									),
								  ),
								),
							  ],
							),
							const SizedBox(height: 10),
							Padding(
							  padding: const EdgeInsets.only(left: 30.0, top: 0, right: 30.0, bottom: 0),
							  child: Row(
								mainAxisAlignment: MainAxisAlignment.start,
								children: [
									Obx(() => customSwitch(
										value: activityScreenController.paid_profile.value,
										onToggle: activityScreenController.toggleSwitch,
										label: 'Paid profile',
									)),
								],
							  ),
							),
							SizedBox(height: 20),
							Obx(() => activityScreenController.paid_profile.value
							  ? Column(
								  crossAxisAlignment: CrossAxisAlignment.center,
								  children: [
									Padding(
									  padding: const EdgeInsets.only(left: 30.0, top: 0, right: 30.0, bottom: 0),
									  child: Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
											const SizedBox(height: 10),
										 // autoWidthTextField(text1: 'Monthly subscription price', text: 'Enter your Monthly subscription price', width: screenWidth, defaultValue: '${activityScreenController.profile_access_price.value}'),
										  
											autoWidthTextField(
												text: 'Enter your Monthly subscription price',
												width: screenWidth,
												controller: activityScreenController.profileAccessPriceController,
												focusNode: _profileAccessPriceFocusNode,
												validator: (value) {
													if (value == null || value.isEmpty) {
														return 'Monthly subscription price cannot be blank';
													}
													final int? amount = int.tryParse(value);
													if (amount == null) {
														return 'Please enter a valid integer';
													}
													return null;
												},
												onChanged: (value) {
												  if (value.isNotEmpty) {
													_formKey.currentState?.validate();
												  }
												},
											),
										  const SizedBox(height: 10),
										  //autoWidthTextField(text1: 'Monthly price for 3 months subscriptions', text: 'Enter your Monthly price for 3 months subscriptions', width: screenWidth, defaultValue: '${activityScreenController.profile_access_price_3_months.value}'),
											autoWidthTextField(
												text: 'Enter your Monthly price for 3 months subscriptions',
												width: screenWidth,
												controller: activityScreenController.profileAccessPriceThreeMonthsController,
												focusNode: _profileAccessPriceThreeMonthsFocusNode,
												validator: (value) {
													if (value == null || value.isEmpty) {
														return 'Monthly price for 3 months subscriptions cannot be blank';
													}
													final int? amount = int.tryParse(value);
													if (amount == null) {
														return 'Please enter a valid integer';
													}
													return null;
												},
												onChanged: (value) {
												  if (value.isNotEmpty) {
													_formKey.currentState?.validate();
												  }
												},
											),
										  const SizedBox(height: 10),
										  //autoWidthTextField(text1: 'Monthly price for 6 months subscriptions', text: 'Enter your Monthly price for 6 months subscriptions', width: screenWidth, defaultValue: '${activityScreenController.profile_access_price_6_months.value}'),
											autoWidthTextField(
												text: 'Enter your Monthly price for 6 months subscriptions',
												width: screenWidth,
												controller: activityScreenController.profileAccessPriceSixMonthsController,
												focusNode: _profileAccessPriceSixMonthsFocusNode,
												validator: (value) {
													if (value == null || value.isEmpty) {
														return 'Monthly price for 6 months subscriptions cannot be blank';
													}
													final int? amount = int.tryParse(value);
													if (amount == null) {
														return 'Please enter a valid integer';
													}
													return null;
												},
												onChanged: (value) {
												  if (value.isNotEmpty) {
													_formKey.currentState?.validate();
												  }
												},
											),
										  const SizedBox(height: 10),
										  //autoWidthTextField(text1: 'Monthly price for yearly subscriptions', text: 'Enter your Monthly price for yearly subscriptions', width: screenWidth, defaultValue: '${activityScreenController.profile_access_price_12_months.value}'),
											autoWidthTextField(
												text: 'Enter your Monthly price for yearly subscriptions',
												width: screenWidth,
												controller: activityScreenController.profileAccessPriceTweleveMonthsController,
												focusNode: _profileAccessPriceTweleveMonthsFocusNode,
												validator: (value) {
													if (value == null || value.isEmpty) {
														return 'Monthly price for yearly subscriptions cannot be blank';
													}
													final int? amount = int.tryParse(value);
													if (amount == null) {
														return 'Please enter a valid integer';
													}
													return null;
												},
												onChanged: (value) {
												  if (value.isNotEmpty) {
													_formKey.currentState?.validate();
												  }
												},
											),
										  const SizedBox(height: 10),
										  Row(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
											  CustomCheckbox(
												value: activityScreenController.is_offer_active.value,
												onChanged: (bool? value) {
												  //activityScreenController.toggleCheckbox(value!);
												  if (value != null) {
													activityScreenController.toggleCheckbox(value);
													_formKey.currentState?.validate(); // Trigger validation
												  }
												},
											  ),
											  autoWidthDateFieldOneSideRounded(
												text1: 'Discount Offer Ends',
												text: 'dd-MM-yyyy',
												width: screenWidth - 116, 
												controller: activityScreenController.currentOfferExpiresAtController,
												onTap: () {
												  activityScreenController.selectDate(context);
												},
												/*onTap: activityScreenController.is_offer_active.value
												  ? () => activityScreenController.selectDate(context)
												  : null, // Disable date picker when checkbox is unchecked*/
											  ),
											],
										  ),
										  const SizedBox(height: 10),
										  Text(
											'In order to start a promotion, reduce your monthly prices and select a future promotion end date.',
											style: TextStyle(
											  fontSize: 14,
											  color: AppColor.BlackGreyscale, // Adjust as per AppColor
											  fontFamily: 'Urbanist-Regular',
											),
										  ),
										  const SizedBox(height: 20),
										Obx(() {
											int isChecked = activityScreenController.is_offer_active.value 
												? 1 
												: 0;

											return autoWidthBtn(
												text: activityScreenController.isLoading.value ? 'SAVING...' : 'SAVE',
												width: screenWidth,
												onPress: activityScreenController.isLoading.value
													? null
													: () {
														if (_formKey.currentState!.validate()) {
															int isOffer = isChecked;
															int profileAccessPrice = int.parse(activityScreenController.profileAccessPriceController.text.trim());
															int profileAccessPriceThreeMonths = int.parse(activityScreenController.profileAccessPriceThreeMonthsController.text.trim());
															int profileAccessPriceSixMonths = int.parse(activityScreenController.profileAccessPriceSixMonthsController.text.trim());
															int profileAccessPriceTweleveMonths = int.parse(activityScreenController.profileAccessPriceTweleveMonthsController.text.trim());
															String currentOfferExpiresAt = activityScreenController.currentOfferExpiresAtController.text.trim();
															activityScreenController.rates_update(
																isOffer,
																profileAccessPrice,
																profileAccessPriceThreeMonths,
																profileAccessPriceSixMonths,
																profileAccessPriceTweleveMonths,
																currentOfferExpiresAt,
															);
														} else {
															if (_profileAccessPriceFocusNode.hasFocus) {
																_profileAccessPriceFocusNode.requestFocus();
															}
														}
													},
											);
										}),
										  /*autoWidthBtn(
											text: 'SAVE',
											width: screenWidth,
											onPress: () {
											  // Your onPress action here
											},
										  ),*/
										  const SizedBox(height: 10),
										],
									  ),
									),
								  ],
								)
							  : SizedBox.shrink()
							),
						  ],
						),
					),
			  );
			}
		}),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 8.0), // Add padding around the checkbox
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color of the container
        borderRadius: BorderRadius.only(
			topLeft: Radius.circular(25.7),
			topRight: Radius.circular(0),
			bottomLeft: Radius.circular(25.7),
			bottomRight: Radius.circular(0),
		  ),
      ),
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        checkColor: Colors.white,
        activeColor: AppColor.purple, // Color when checked
        side: BorderSide(color: AppColor.purple, width: 2), // Border color and width
      ),
    );
  }
}
