import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picturesourcesomerset/config/api_endpoints.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/services/base_api_service.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/controllers/user_controller.dart';

class CardVerificationScreen extends StatefulWidget {
  @override
  _CardVerificationScreenState createState() => _CardVerificationScreenState();
}

class _CardVerificationScreenState extends State<CardVerificationScreen> {
  CardFieldInputDetails? _card;

  final userController = Get.find<UserController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  appBar: AppBar(
		title: Text("Card Verification", style: TextStyle(fontSize: 20)),
		centerTitle: true,
	  ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardField(
              onCardChanged: (card) {
                setState(() {
                  _card = card;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _card?.complete == true
                  ? _verifyCard
                  : null, // Disable button if card is incomplete
              child: const Text("Verify Card"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyCard() async {
    try {
      // Create payment method without charging
		/*final paymentMethod = await Stripe.instance.createPaymentMethod(
		  params: PaymentMethodParams.card(
			paymentMethodData: PaymentMethodData(),
		  ),
		);*/
		final paymentMethod = await Stripe.instance.createPaymentMethod(
			params: PaymentMethodParams.card(
			  paymentMethodData: PaymentMethodData(
				billingDetails: BillingDetails(
				  name: 'Picturesource', // Replace with dynamic data
				  email: 'test@example.com', // Replace with dynamic data
				  phone: '+1234567890', // Replace with dynamic data
				),
			  ),
			),
		);
		// Call your backend API to create a subscription
		  final prefs = await SharedPreferences.getInstance();
		  final ApiService apiService = ApiService();
		  var response = await apiService.profileVerified(paymentMethod.id);
			if (response['status'] == 200) {
				await prefs.setInt('isProfileVerified', 1);
				
				// Update UserController
				userController.setEditUserProfilePaymentVerifyData();
				
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['data'],
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification Failed: $e'),
      ));
    }
  }
}
