import 'package:flutter/material.dart';

import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

class ActivityScreenController extends GetxController {
	final ApiService apiService;
	ActivityScreenController(this.apiService);  // Constructor accepting ApiService
	
	// Observable to track loading state
	var isLoading = false.obs;
	var isSubmittingData = false.obs;
	var isFetchingData = false.obs;
	
	var showPassword = true.obs;  // RxBool
	var showNPassword = true.obs;  // RxBool
	var showCPassword = true.obs;  // RxBool
	void changePasswordHideAndShow() {
		showPassword.value = !showPassword.value;  // Use .value to update RxBool
	}
	void changeNPasswordHideAndShow() {
		showNPassword.value = !showNPassword.value;  // Use .value to update RxBool
	}
	void changeCPasswordHideAndShow() {
		showCPassword.value = !showCPassword.value;  // Use .value to update RxBool
	}
	
	// List of options for the dropdown
	final List<String> paymentMethods = ['Bank transfer', 'Other'];
	// Reactive payment method variable
	var selectedPaymentMethods = ''.obs;
	var showBankNameField = true.obs;
	var available_balance = ''.obs;
	var pending_balance = ''.obs;
	// Method to update the selected payment method
	void updatePaymentMethods(String value) {
		selectedPaymentMethods.value = value;
	}
	
	var paymentData = [].obs; // List to store payment data
	
	// Flag to control whether fetchPaymentHistory should be called
	bool shouldFetchPaymentHistory = false;
	// Flag to control whether fetchInvoiceDetails should be called
	bool shouldFetchInvoiceDetails = false;
	// Flag to control whether fetchRatesData should be called
	bool shouldFetchRates = false;
	// Flag to control whether fetchSubscriptionData should be called
	bool shouldFetchSubscriptionData = false;
	// Flag to control whether fetchSettingsNotificationData should be called
	bool shouldFetchSettingsNotification = false;
	// Flag to control whether fetchSettingsPrivacyData should be called
	bool shouldFetchSettingsPrivacy = false;
	// Flag to control whether fetchSettingsVerifyData should be called
	bool shouldFetchSettingsVerify = false;
	// Flag to control whether fetchFAQPage should be called
	bool shouldFetchFAQpageData = false;
  
	@override
	void onInit() {
		super.onInit();
		/*if (shouldFetchPaymentHistory) {
			fetchPaymentHistory(); // Fetch data only if the flag is true
		} if (shouldFetchInvoiceDetails) {
			int paymentInvoiceId = Get.arguments['paymentInvoiceId'];
			print('payment Invoice Id: $paymentInvoiceId');
			fetchInvoiceDetails(paymentInvoiceId); // Fetch details when the controller is initialized
		} if (shouldFetchRates) {
			fetchRatesData(); // Fetch data only if the flag is true
		} if (shouldFetchSubscriptionData) {
			fetchSubscriptionData(); // Fetch data only if the flag is true
		}*/ if (shouldFetchSettingsNotification) {
			fetchSettingsNotificationData(); // Fetch data only if the flag is true
		}/* if (shouldFetchSettingsPrivacy) {
			fetchSettingsPrivacyData(); // Fetch data only if the flag is true
		} if (shouldFetchSettingsVerify) {
			fetchSettingsVerifyData(); // Fetch data only if the flag is true
		} if (shouldFetchFAQpageData) {
			fetchFAQPage(); // Fetch data only if the flag is true
		}*/
	}
	
	
  
	//submit Password Data for account update in settings menu
	Future<void> accountSubmit(
	  String password, 
	  String new_password, 
	  String confirm_password
	) async {
		isLoading.value = true;
		/*print('password: $password');
		print('new_password: $new_password');
		print('confirm_password: $confirm_password');*/
		try {
			isSubmittingData(true);
			final response = await apiService.account_update(password, new_password, confirm_password);
			

			if (response['status'] == 200) {
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else if (response['status'] == 600) {
				final firstErrorMessages = <String>[];

				// Iterate through the errors map and collect the first error messages
				response['errors'].forEach((key, value) {
					firstErrorMessages.add(value[0]);
				});

				// Now you can use the `firstErrorMessages` list directly
				//print(firstErrorMessages); // This will print: ["The password is incorrect.", "The confirm password and new password must match."]

				// Or access individual messages by index
				final firstPasswordError = firstErrorMessages[0];
				//final firstConfirmPasswordError = firstErrorMessages[1];

				//print(firstPasswordError); // Outputs: The password is incorrect.
				//print(firstConfirmPasswordError); // Outputs: The confirm password 
  
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: firstPasswordError,
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
	}
	
	// Fetch Wallet Balance data
	Future<void> fetchWalletBalance() async {
		print("Wallet balance data fetch initiated");
		//isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  final response = await apiService.wallet_available_pending_balance();
		  
		  available_balance.value = response['available_balance']['formatted_amount'] ?? '\$0.00' ;
		  pending_balance.value = response['pending_balance']['formatted_amount'] ?? '\$0.00' ;

		 // print('API Response: $available_balance'); // Print the full API response
		  
		  // Update the slider data
		 // walletData.assignAll(response);

		  // Note: Avoid interacting with pageController directly here
		  // Ensure the PageController is only used when the view is fully loaded

		} catch (e) {
		  //print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  //isLoading.value = false; // Stop loading
		}
	}
	
	//submit Wallet Deposit in settings menu
	Future<void> wallet_deposit(
	  int amount
	) async {
		isLoading.value = true;
		/*print('amount: $amount');*/
		try {
			isSubmittingData(true);
			final response = await apiService.wallet_deposit(amount);
			

			if (response['status'] == 200) {
			  SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
			  SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
	}
	
	//submit Wallet Request in settings menu
	Future<void> wallet_request_withdraw(
	  int amount,
	  String payment_method,
	  String payment_identifier,
	  String message	  
	) async {
		isLoading.value = true;
		print('amount: $amount');
		print('payment_method: $payment_method');
		print('payment_identifier: $payment_identifier');
		print('message: $message');
		try {
			isSubmittingData(true);
			final response = await apiService.wallet_request_withdraw(amount, payment_method, payment_identifier, message ?? '');
			if (response['status'] == 200) {
				available_balance.value = response['totalAmount'] ?? '\$0.00' ;
				pending_balance.value = response['pendingBalance'] ?? '\$0.00' ;
		  
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
	}
	
	// Fetch Payment History data
	Future<void> fetchPaymentHistory() async {
		//print("Payment History data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  final responseData = await apiService.payments_fetch();
		  final response = responseData['payments'];

		  //print('API Response: $response'); // Print the full API response
		  
		  // Update the payment data
		  paymentData.assignAll(response);

		} catch (e) {
		  //print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}
	
	var invoice = ''.obs;
	var invoiceDate = ''.obs;
	var dueDate = ''.obs;
	var invoicedName = ''.obs;
	var invoicedAddress = ''.obs;
	var invoicedCity = ''.obs;
	var invoicedCountry = ''.obs;
	var invoiceFromName = ''.obs;
	var invoiceFromAddress = ''.obs;
	var invoiceFromCity = ''.obs;
	var invoiceFromCountry = ''.obs;
	var invoiceFromCompanyNumber = ''.obs;
	var invoiceType = ''.obs;
	var invoiceTypePrice = ''.obs;
	var invoiceTaxPrice = ''.obs;
	var invoiceTotalPrice = ''.obs;
	
	// Fetch Invoice details data
	Future<void> fetchInvoiceDetails(int paymentInvoiceId) async {
		//print("Invoice details data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  await Future.delayed(Duration(seconds: 2));
		  final responseData = await apiService.invoices(paymentInvoiceId);

		  final response = responseData['data'];

		 // print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {
				invoice.value = response['invoice'];
				dueDate.value = response['dueDate'];
				invoicedName.value = response['Invoiced']['name'];
				invoicedAddress.value = response['Invoiced']['address'];
				invoicedCity.value = response['Invoiced']['city'];
				invoicedCountry.value = response['Invoiced']['country'];
				invoiceFromName.value = response['Invoice From']['name'];
				invoiceFromAddress.value = response['Invoice From']['address'];
				invoiceFromCity.value = response['Invoice From']['city'];
				invoiceFromCountry.value = response['Invoice From']['country'];
				invoiceFromCompanyNumber.value = response['Invoice From']['company_number'];
				invoiceType.value = response['type'];
				invoiceTypePrice.value = response['subtotal'];
				invoiceTaxPrice.value = response['taxesTotalAmount'];
				invoiceTotalPrice.value = response['totalAmount'];
		  
			}
		} catch (e) {
			//print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}
	
	var paid_profile = true.obs;
	var profile_access_price = ''.obs;
	var profile_access_price_3_months = ''.obs;
	var profile_access_price_6_months = ''.obs;
	var profile_access_price_12_months = ''.obs;
	var is_offer_active = false.obs;
	var current_offer_expires_at = ''.obs;
	
	//For Rates page switcher
	void toggleSwitch(bool value) {
		print('Switch toggled to: $value'); // Debugging line
		paid_profile.value = value;
		
		final paid_profile_val = value ? 1 : 0;
		
		print('checked value: ${is_offer_active.value}');
		print('date field value: ${current_offer_expires_at.value}');
		
		paidProfileSwitch(paid_profile_val);

	} 
  
	final TextEditingController profileAccessPriceController = TextEditingController();
	final TextEditingController profileAccessPriceThreeMonthsController = TextEditingController();
	final TextEditingController profileAccessPriceSixMonthsController = TextEditingController();
	final TextEditingController profileAccessPriceTweleveMonthsController = TextEditingController();
	final TextEditingController isOfferActiveController = TextEditingController();
	final TextEditingController currentOfferExpiresAtController = TextEditingController();
	
	void toggleCheckbox(bool value) {
		is_offer_active.value = value;
		print('checked value: $value');
		print('date field value: ${current_offer_expires_at.value}');
		if (!value) {
			// Clear the date field when the checkbox is unchecked
			current_offer_expires_at.value = '';
			currentOfferExpiresAtController.clear();
		}
	}
	
	// Method to show date picker
    Future<void> selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
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
        currentOfferExpiresAtController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
		current_offer_expires_at.value = currentOfferExpiresAtController.text;
		is_offer_active.value = true;
      }
    }
	@override
	void onClose() {
		// Dispose the controller when the screen is closed
		currentOfferExpiresAtController.dispose();
		super.onClose();
	}
	
	// Fetch Rates data
	Future<void> fetchRatesData() async {
		//print("Rates data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  await Future.delayed(Duration(seconds: 2));
		  final responseData = await apiService.rates_fetch();

		  final response = responseData['data'];

		 // print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {
				paid_profile.value = response['paid_profile'] == 1 ? true : false;
  
				profile_access_price.value = response['profile_access_price'].toString();
				profile_access_price_3_months.value = response['profile_access_price_3_months'].toString();
				profile_access_price_6_months.value = response['profile_access_price_6_months'].toString();
				profile_access_price_12_months.value = response['profile_access_price_12_months'].toString();
				is_offer_active.value = response['is_offer'];
				current_offer_expires_at.value = response['current_offer_expires_at'].toString();		  
			}
		} catch (e) {
		  //print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}
	//submit Rates page paid-prfile switch in settings menu
	Future<void> paidProfileSwitch(
	  int paid_profile  
	) async {
		print('Paid profile switch value: $paid_profile');
		try {
			//isSubmittingData(true);
			final response = await apiService.rates_type(paid_profile);
			if (response['status'] == 200) {		  
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}
	
	//submit Rates data in settings menu
	Future<void> rates_update(
	  int isOffer,
	  int profileAccessPrice,
	  int profileAccessPriceThreeMonths,
	  int profileAccessPriceSixMonths,
	  int profileAccessPriceTweleveMonths,	  
	  String currentOfferExpiresAt	  
	) async {
		isLoading.value = true;
		print('is Offer: $isOffer');
		print('profile Access Price: $profileAccessPrice');
		print('profile Access Price Three Months: $profileAccessPriceThreeMonths');
		print('profile Access Price Six Months: $profileAccessPriceSixMonths');
		print('profile Access Price Tweleve Months: $profileAccessPriceTweleveMonths');
		print('current Offer Expires At: $currentOfferExpiresAt');
		try {
			isSubmittingData(true);
			final response = await apiService.rates_update(isOffer, profileAccessPrice.toString(), profileAccessPriceThreeMonths.toString(), profileAccessPriceSixMonths.toString(), profileAccessPriceTweleveMonths.toString(), currentOfferExpiresAt);
			if (response['status'] == 200) {		  
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
	}
	
	var subscriptionData = [].obs; // List to store subscription data
	var subscriberData = [].obs; // List to store subscriber data
	// Fetch subscriptions data
	Future<void> fetchSubscriptionData() async {
		print("Subscription data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  final responseData = await apiService.subscriptions_fetch();
		  final response = responseData['data'];

		 // print('API Response: $response'); // Print the full API response
		  
		  // Update the payment data
		  subscriptionData.assignAll(response);
		  
		  final responseSubscriberData = await apiService.subscribers_fetch();
		  final responseSubscriber = responseSubscriberData['data'];

		  //print('API Response: $responseSubscriber'); // Print the full API response
		  
		  // Update the payment data
		  subscriberData.assignAll(responseSubscriber);

		} catch (e) {
		  //print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}
	
	//cancel subscription from settings > subscriptions menu
	Future<void> cancelSubscription(int id) async {
	  //print('Subscription ID: $id');
	  try {
		final response = await apiService.subscriptions_canceled(id);

		if (response['status'] == 200) {
		  final index = subscriptionData.indexWhere((subscription) => subscription['id'] == id);
		  //print('Cancel subscription data hit row: $index');
		  if (index != -1) {
			final updatedSubscription = {
			  ...subscriptionData[index],
			  'to': response['data']['to'],
			  'status': response['data']['status'],
			  'paid_with': response['data']['paid_with'],
			  'renews': response['data']['renews'],
			  'expires_at': response['data']['expires_at'],
			  'cancel_subscriptions': false,
			};
			subscriptionData[index] = updatedSubscription; // Update the data
			//print('Updated subscription data: ${subscriptionData[index]}');
			// Trigger UI update
			update();
			//print('update() method called');
		  }

		  SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} else {
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	  } catch (e) {
		//print("Error Canceling Subscription: $e");
		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: Appcontent.snackbarCatchErrorMsg, 
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  } finally {
		isSubmittingData(false);
		isLoading.value = false;
	  }
	}

	//cancel subscriber from settings > subscriptions menu
	Future<void> cancelSubscriber(
	  int id
	) async {
		print('Subscriber ID: $id');
		try {
			final response = await apiService.subscribers_canceled(id);
			
			if (response['status'] == 200) {		  
				final index = subscriberData.indexWhere((subscriber) => subscriber['id'] == id);
				//print('Cancel subscriber data hit row: $index');
				if (index != -1) {
				final updatedSubscriber = {
				  ...subscriberData[index],
				  'from': response['data']['from'],
				  'status': response['data']['status'],
				  'paid_with': response['data']['paid_with'],
				  'renews': response['data']['renews'],
				  'expires_at': response['data']['expires_at'],
				  'cancel_subscriber': false,
				};
					subscriberData[index] = updatedSubscriber; // Update the data
					//print('Updated subscriber data: ${subscriberData[index]}');
					// Trigger UI update
					update();
					//print('update() method called');
				}
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
			isSubmittingData(false);
			isLoading.value = false;
		}
	}
	
	var notification_email_new_sub = false.obs;
	var notification_email_new_tip = false.obs;
	var notification_email_new_ppv_unlock = false.obs;
	var notification_email_new_message = false.obs;
	var notification_email_new_comment = false.obs;
	var notification_email_expiring_subs = false.obs;
	var notification_email_renewals = false.obs;
	var notification_email_creator_went_live = false.obs;
	
	//For settings notifications page switcher
	void toggleSwitchSettingsNotification(bool value, [String? additionalParameter]) {
		// Your logic for handling the switch
		print('Switch value: $value');
		print('Additional parameter: $additionalParameter');
		switch (additionalParameter) {
			case 'notification_email_new_sub':
			  notification_email_new_sub.value = value;
			  break;
			case 'notification_email_new_tip':
			  notification_email_new_tip.value = value;
			  break;
			case 'notification_email_new_ppv_unlock':
			  notification_email_new_ppv_unlock.value = value;
			  break;
			case 'notification_email_new_message':
			  notification_email_new_message.value = value;
			  break;
			case 'notification_email_new_comment':
			  notification_email_new_comment.value = value;
			  break;
			case 'notification_email_expiring_subs':
			  notification_email_expiring_subs.value = value;
			  break;
			case 'notification_email_renewals':
			  notification_email_renewals.value = value;
			  break;
			case 'notification_email_creator_went_live':
			  notification_email_creator_went_live.value = value;
			  break;
			default:
			  print('Invalid parameter: $additionalParameter');
		}
		if (additionalParameter != null) {
			settingsNotificationSwitch(additionalParameter, value);
		}
	} 
	
	//submit settings notifications page switch in settings menu
	Future<void> settingsNotificationSwitch(
	  String key,  
	  bool value  
	) async {
		print('Switch key: $key');
		print('Switch value: $value');
		try {
			//isSubmittingData(true);
			final response = await apiService.settings_notifications_update(key, value);
			print('settingsNotificationSwitch: $response');
			if (response['status'] == 200) {		  
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
			  SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg,
			  position: SnackPosition.TOP, // Custom position
			);
		}
	}
	
	// Fetch settings notifications data
	Future<void> fetchSettingsNotificationData() async {
		//print("Settings notification data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  //await Future.delayed(Duration(seconds: 2));
		  final responseData = await apiService.settings_notifications();

		  final response = responseData['data'];

		  //print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {			
				notification_email_new_sub.value = response['notification_email_new_sub'];
				notification_email_new_tip.value = response['notification_email_new_tip'];
				notification_email_new_ppv_unlock.value = response['notification_email_new_ppv_unlock'];
				notification_email_new_message.value = response['notification_email_new_message'];
				notification_email_new_comment.value = response['notification_email_new_comment'];
				notification_email_expiring_subs.value = response['notification_email_expiring_subs'];
				notification_email_renewals.value = response['notification_email_renewals'];
				notification_email_creator_went_live.value = response['notification_email_creator_went_live'];	  
			}
		} catch (e) {
		  //print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}
	
	var public_profile = false.obs;
	var enable_2fa = false.obs;
	
	//For settings notifications page switcher
	void toggleSwitchSettingsPrivacy(bool value, [String? additionalParameter]) {
		// Your logic for handling the switch
		//print('Switch value: $value');
		//print('Additional parameter: $additionalParameter');
		switch (additionalParameter) {
			case 'public_profile':
			  public_profile.value = value;
			  break;
			case 'enable_2fa':
			  enable_2fa.value = value;
			  break;
			default:
			  print('Invalid parameter: $additionalParameter');
		}
		if (additionalParameter != null) {
			settingsPrivacySwitch(additionalParameter, value);
		}
	} 
	
	//submit settings parivacy page switch in settings menu
	Future<void> settingsPrivacySwitch(
	  String key,  
	  bool value  
	) async {
		print('Switch key: $key');
		print('Switch value: $value');
		try {			 
			final response = await apiService.privacy_update(key, value);
			print('settingsNotificationSwitch: $response');
			if (response['status'] == 200) {		  
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}
		} catch (e) {
			//print("Error Acount Update: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}
	
	// Fetch settings privacy data
	Future<void> fetchSettingsPrivacyData() async {
		//print("Settings privacy data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  final responseData = await apiService.privacy_fetch();

		  final response = responseData['data'];

		  //print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {			
				public_profile.value = response['public_profile'];
				enable_2fa.value = response['enable_2fa'] == 1 ? true : false;
			}
		} catch (e) {
		  print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}
	
	var email_verified_status = ''.obs;
	var email_verified_message = ''.obs;
	var birthdate_set_status = ''.obs;
	var birthdate_set_message = ''.obs;
	var identity_verification_status = ''.obs;
	var identity_verification_message = ''.obs;
	
	// Fetch settings verify data
	Future<void> fetchSettingsVerifyData() async {
		//print("Settings verify data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  final responseData = await apiService.verify_email_birthdate();

		  final response = responseData['data'];

		  //print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {			
				email_verified_status.value = response['email_verified']['status'].toString();
				email_verified_message.value = response['email_verified']['message'];
				birthdate_set_status.value = response['birthdate_set']['status'].toString();
				birthdate_set_message.value = response['birthdate_set']['message'];
				identity_verification_status.value = response['identity_verification']['status'].toString();
				identity_verification_message.value = response['identity_verification']['message'];
			}
		} catch (e) {
		  //print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}
	
	//verify screen
	var selectedFiles = <PlatformFile>[].obs;

	Future<void> pickFiles() async {
		try {
		  isLoading.value = true;
		  FilePickerResult? result = await FilePicker.platform.pickFiles(
			allowMultiple: true,
			type: FileType.custom,
			allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'xls', 'xlsx'],
		  );

		  if (result != null) {
			List<PlatformFile> selected = result.files.where((file) => file.size <= 4 * 1024 * 1024).toList();
			if (selected.isNotEmpty) {
			  selectedFiles.addAll(selected);
			}
		  }
		} catch (e) {
		  print("Error picking files: $e");
		} finally {
		  isLoading.value = false;
		}
	}

	
	Future<void> uploadVerifyImage() async {
	  bool isSuccess = true;
	  //identity_verification_status.value = '2';  // Indicating the process has started
		String finalMessage = '';  // Variable to store the message from the last upload
	  try {
		// Assuming you're handling multiple file uploads
		for (PlatformFile file in selectedFiles) {
		  File imageFile = File(file.path!);
		  
		  // Get the UploadResponse result from uploadVerifyImageDynamic
		  UploadResponse result = await uploadVerifyImageDynamic(imageFile);
		  
		  print('Result: $result');
		  // Update the final message with the current result's message
			finalMessage = result.message;

		  // Check the statusCode in the result
		  if (result.status != 200) {
			isSuccess = false;
			identity_verification_status.value = '0';  // Mark as failed
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: result.message,
			  position: SnackPosition.BOTTOM, // Custom position
			);
			break;  // Stop further uploads if one fails
		  }
		}

		if (isSuccess) {
		  selectedFiles.clear();  // Clear the selected files if all uploads were successful
			
			final responseData = await apiService.verify_email_birthdate();

		  final response = responseData['data'];

		  print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {			
				email_verified_status.value = response['email_verified']['status'].toString();
				email_verified_message.value = response['email_verified']['message'];
				birthdate_set_status.value = response['birthdate_set']['status'].toString();
				birthdate_set_message.value = response['birthdate_set']['message'];
				identity_verification_status.value = response['identity_verification']['status'].toString();
				identity_verification_message.value = response['identity_verification']['message'];
			}

		  SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: finalMessage.isNotEmpty ? finalMessage : 'Upload successful.',
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	  } catch (e) {
		isSuccess = false;
		identity_verification_status.value = '0';

		SnackbarHelper.showErrorSnackbar(
		  title: Appcontent.snackbarTitleError, 
		  message: Appcontent.snackbarCatchErrorMsg, 
		  position: SnackPosition.BOTTOM, // Custom position
		);
	  }
	}

	
	Future<UploadResponse> uploadVerifyImageDynamic(File imageFile) async {
	  try {
		// Assuming verify_Identity_check is a method in your ApiService that returns a response
		final response = await apiService.verify_Identity_check(imageFile);

		// Return both statusCode and message in an UploadResponse object
		return UploadResponse(
		  status: response['status'],
		  message: response['message'], // Assuming response has a 'msg' field
		);
	  } catch (e) {
		// In case of an error, return a failure response
		return UploadResponse(
		  status: 500, // You can assign a status code for the error
		  message: 'Upload failed: $e',
		);
	  }
	}
	// Method to remove selected file
	void removeFile(PlatformFile file) {
		selectedFiles.remove(file);
	}
	
	// Fetch FAQ page data
	var faqPageTitle = ''.obs;
	var faqUpdatedDate = ''.obs;
	var faqPageContent = ''.obs;
	
	Future<void> fetchFAQPage() async {
		print("FAQ page data fetch initiated");
		isLoading.value = true; // Start loading
		try {
		  isFetchingData(true);
		  //await Future.delayed(Duration(seconds: 2));
		  final responseData = await apiService.cms_faq_page(1);

		  final response = responseData['data'];

		  print('API Response: $response'); // Print the full API response
		  
			if(responseData['status'] == 200) {
				faqPageTitle.value = response['help_faq'][0]['title'];
				faqUpdatedDate.value = response['help_faq'][0]['updated_at'];
				faqPageContent.value = response['help_faq'][0]['content'];		  
			}
		} catch (e) {
			print('Error occurred: $e'); // Print the error if any occurs
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isFetchingData(false);
		  isLoading.value = false; // Stop loading
		}
	}

	
	
  // List of options for the dropdown
  List<String> list = <String>['1 Weeks', '2 Weeks', '3 Weeks', '4 Weeks'];
  


  // Some integer value
  int gValue = 0;

  // Reactive count variable
  final count = 0.obs;

  // Reactive selected string variable
  final selected = "".obs;



  // Method to increment count
  void increment() => count.value++;

  // Method to set selected value
  void setSelected(String value) {
    selected.value = value;
  }

  // Method to change gValue and notify listeners
  void changeValue({int? value}) {
    gValue = value ?? 0;
    update(); // This will notify listeners of changes
  }

	
	//For Privacy page switcher
	/*var isSwitchedPrivacy1 = true.obs;
	void toggleSwitchPrivacy1(bool value) {
		isSwitchedPrivacy1.value = value;
	} 
	var isSwitchedPrivacy2 = true.obs;
	void toggleSwitchPrivacy2(bool value) {
		isSwitchedPrivacy2.value = value;
	}*/
	
	
  
  
  //Logout
  Future<void> logout() async {
	final BaseApiService _baseApiService = Get.find<BaseApiService>();  
	_baseApiService.clearToken();
	//Get.toNamed(Routes.LOGIN_SCREEN);
	Get.offAllNamed(Routes.LOGIN_SCREEN);
  }
}

class UploadResponse {
  final int status;
  final String message;

  UploadResponse({required this.status, required this.message});

  @override
  String toString() {
    return 'UploadResponse(status: $status, message: $message)';
  }
}


