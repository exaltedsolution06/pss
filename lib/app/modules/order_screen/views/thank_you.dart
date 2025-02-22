import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';

import '../controllers/order_controller.dart';

class ThankYouPage extends StatefulWidget {
  final String orderId; // Accept orderId as a parameter

  const ThankYouPage({Key? key, required this.orderId}) : super(key: key);
  
  @override
  _ThankYouPageState createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {

	final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(	  
	  appBar: AppBar(
		title: Text(Appcontent.thankYou, style: TextStyle(fontSize: 20)),
		centerTitle: true,
	  ),
		body: SingleChildScrollView(
            child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Padding(
						padding: const EdgeInsets.all(10),
						child: Column(
							children: [
								Image.asset(
								  Appcontent.orderSuccess,
								  fit: BoxFit.cover,
								  width: double.infinity,
								),
								const SizedBox(height: 20),
								Text(
									Appcontent.thankYou,
									style: TextStyle(fontSize: 24, fontFamily: 'Urbanist-semibold'),
								),
								const SizedBox(height: 20),
								Text(
									"${Appcontent.thankYouDescFirst} ${widget.orderId}. ${Appcontent.thankYouDescLast}",
									style: TextStyle(fontSize: 14, fontFamily: 'Urbanist-Regular'),
								),
								const SizedBox(height: 30),
								Obx(() {
								  return autoWidthBtn(
									text: orderController.isCOloading.value
										? 'Loading...'
										: Appcontent.continueOrder,
									width: screenWidth,
									onPress: () {orderController.continueOrder();},
								  );
								}),
							],
						),
					),
				],
            ),
        ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 3),
    );
  }
}
