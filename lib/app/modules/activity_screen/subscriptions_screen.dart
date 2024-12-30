import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/common_button.dart';

import '../../../../config/app_color.dart';
import 'activity_screen_controller.dart';

class SubscriptionsScreenView extends GetView<ActivityScreenController> {
  const SubscriptionsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    
	final ActivityScreenController activityScreenController = Get.find();
	// Set the flag to true for this specific page
    activityScreenController.shouldFetchSubscriptionData = true;	
	final double screenWidth = MediaQuery.of(context).size.width;
	
	final ScrollController _scrollController = ScrollController();
    final RxBool _showLeftIndicator = false.obs;
    final RxBool _showRightIndicator = false.obs;
	
	_scrollController.addListener(() {
      _showLeftIndicator.value = _scrollController.offset > 0;
      _showRightIndicator.value = _scrollController.offset < _scrollController.position.maxScrollExtent;
    });

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
        title: const Text('Subscriptions', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
	  print('UI Rebuilt with subscription data length: ${controller.subscriptionData.length}');
        if (activityScreenController.isLoading.value) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
        } else if (activityScreenController.subscriptionData.isEmpty) {
          return Center(child: Text('No Subscription Yet.'));
        } else {
		
          return SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: Column(
				  crossAxisAlignment: CrossAxisAlignment.stretch,
				  children: [
					Column(
					  children: [
						Padding(
						  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
						  child: Text(
							'Your active subscriptions',
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
					DefaultTabController(
					  length: 2,
					  child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
						  const TabBar(
							indicatorColor: AppColor.purple,
							tabs: [
							  Tab(
								child: Text('Subscriptions', style: TextStyle(color: Colors.black, fontSize: 16)),
							  ),
							  Tab(
								child: Text('Subscribers', style: TextStyle(color: Colors.black, fontSize: 16)),
							  ),
							],
						  ),
						  SizedBox(
							height: MediaQuery.of(context).size.height - 150,
							child: TabBarView(
							  children: [
								// Content for the 'subscription' tab
								Padding(
								  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
								  child: Stack(
									children: [
									  SingleChildScrollView(
										scrollDirection: Axis.horizontal,
										controller: _scrollController,
										child: DataTable(
										  columns: [
											DataColumn(label: Container(width: 100, child: Text('To'))),
											DataColumn(label: Container(width: 80, child: Text('Status'))),
											DataColumn(label: Container(width: 80, child: Text('Paid with'))),
											DataColumn(label: Container(width: 80, child: Text('Renews'))),
											DataColumn(label: Container(width: 80, child: Text('Expires at'))),
											DataColumn(label: Container(width: 80, child: Text(''))),
											// Optionally add DataColumn for actions if needed
										  ],
										  rows: List.generate(
											activityScreenController.subscriptionData.length,
											(index) => DataRow(
											  cells: [
												DataCell(
												  GestureDetector(
													onTap: () {
													  // Handle the tap event here
													  print('Image or text clicked');
													},
													child: Padding(
													  padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding to avoid touching the top and bottom
													  child: Container(
														width: 100, // Set the desired width of the entire cell
														child: Row(
														  children: [
															// Circle Avatar for Image
															ClipOval(
															  child: Image.network(
																activityScreenController.subscriptionData[index]['to']['avatar'],
																width: 40, // Adjust width as needed
																height: 40, // Adjust height as needed
																fit: BoxFit.cover, // Ensure the image fits inside the circle
															  ),
															),
															SizedBox(width: 10), // Add space between the image and text
															// Text widget without underline
															Expanded(
															  child: Text(
																activityScreenController.subscriptionData[index]['to']['name'],
																overflow: TextOverflow.ellipsis, // To avoid overflowing text
																style: TextStyle(
																  fontSize: 16, 
																  color: Colors.blue, // Link-like color
																  decoration: TextDecoration.none, // Remove underline
																),
															  ),
															),
														  ],
														),
													  ),
													),
												  ),
												),
												DataCell(
												  Container(
													padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),  // Internal padding for the "button" effect
													//alignment: Alignment.center,  // Centers the text
													decoration: BoxDecoration(
													  color: activityScreenController.subscriptionData[index]['status'] == 'completed'
															? Colors.green
															: Colors.red,  // Background color to make it look like a button
													  borderRadius: BorderRadius.circular(4.0),  // Rounded corners for button-like appearance
													),
													child: Text(
													  activityScreenController.subscriptionData[index]['status'],
													  overflow: TextOverflow.ellipsis,
													  textAlign: TextAlign.center,
													  style: TextStyle(
														color: Colors.white,  // Text color to contrast with background
														fontSize: 12, 
													  ),
													),
												  ),
												),

												DataCell(Text(activityScreenController.subscriptionData[index]['paid_with'])),
												DataCell(Text(activityScreenController.subscriptionData[index]['renews'])),
												DataCell(Text(activityScreenController.subscriptionData[index]['expires_at'])),
												DataCell(
													activityScreenController.subscriptionData[index]['cancel_subscriptions'] == true
														? GestureDetector(
															  onTap: () {
																// Get the subscriptionId
																int subscriptionId = activityScreenController.subscriptionData[index]['id'];
																
																// Fetch the invoice details
																activityScreenController.cancelSubscription(subscriptionId);

															  },
															  child: Icon(Icons.cancel, size: 30, color: Colors.red),
															)
														: SizedBox.shrink(),  // This will create an empty cell if the condition is false
												),

												// Optionally add DataCell for actions if needed
											  ],
											),
										  ),
										),
									  ),
									  Obx(() => _showLeftIndicator.value
										  ? Positioned(
											  left: 10,
											  top: MediaQuery.of(context).size.height / 4,
											  child: Icon(Icons.arrow_back, size: 30, color: Colors.grey.withOpacity(0.6)),
											)
										  : SizedBox.shrink(),
									  ),
									  Obx(() => _showRightIndicator.value
										  ? Positioned(
											  right: 10,
											  top: MediaQuery.of(context).size.height / 4,
											  child: Icon(Icons.arrow_forward, size: 30, color: Colors.grey.withOpacity(0.6)),
											)
										  : SizedBox.shrink(),
									  ),
									],
								  ),
								),
								// Content for the 'Subscriber' tab
								Padding(
								  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
								  child: Stack(
									children: [
									  SingleChildScrollView(
										scrollDirection: Axis.horizontal,
										controller: _scrollController,
										child: DataTable(
										  columns: [
											DataColumn(label: Container(width: 100, child: Text('From'))),
											DataColumn(label: Container(width: 80, child: Text('Status'))),
											DataColumn(label: Container(width: 80, child: Text('Paid with'))),
											DataColumn(label: Container(width: 80, child: Text('Renews'))),
											DataColumn(label: Container(width: 80, child: Text('Expires at'))),
											DataColumn(label: Container(width: 50, child: Text(''))),
											// Optionally add DataColumn for actions if needed
										  ],
										  rows: List.generate(
											activityScreenController.subscriberData.length,
											(index) => DataRow(
											  cells: [
												DataCell(
												  GestureDetector(
													onTap: () {
													  // Handle the tap event here
													  print('Image or text clicked');
													},
													child: Padding(
													  padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding to avoid touching the top and bottom
													  child: Container(
														width: 100, // Set the desired width of the entire cell
														child: Row(
														  children: [
															// Circle Avatar for Image
															ClipOval(
															  child: Image.network(
																activityScreenController.subscriberData[index]['from']['avatar'],
																width: 40, // Adjust width as needed
																height: 40, // Adjust height as needed
																fit: BoxFit.cover, // Ensure the image fits inside the circle
															  ),
															),
															SizedBox(width: 10), // Add space between the image and text
															// Text widget without underline
															Expanded(
															  child: Text(
																activityScreenController.subscriberData[index]['from']['name'],
																overflow: TextOverflow.ellipsis, // To avoid overflowing text
																style: TextStyle(
																  fontSize: 16, 
																  color: Colors.blue, // Link-like color
																  decoration: TextDecoration.none, // Remove underline
																),
															  ),
															),
														  ],
														),
													  ),
													),
												  ),
												),
												DataCell(
												  Container(
													padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),  // Internal padding for the "button" effect
													//alignment: Alignment.center,  // Centers the text
													decoration: BoxDecoration(
													  color: activityScreenController.subscriberData[index]['status'] == 'completed'
															? Colors.green
															: Colors.red,  // Background color to make it look like a button
													  borderRadius: BorderRadius.circular(4.0),  // Rounded corners for button-like appearance
													),
													child: Text(
													  activityScreenController.subscriberData[index]['status'],
													  overflow: TextOverflow.ellipsis,
													  textAlign: TextAlign.center,
													  style: TextStyle(
														color: Colors.white,  // Text color to contrast with background
														fontSize: 12, 
													  ),
													),
												  ),
												),
												DataCell(Text(activityScreenController.subscriberData[index]['paid_with'])),
												DataCell(Text(activityScreenController.subscriberData[index]['renews'])),
												DataCell(Text(activityScreenController.subscriberData[index]['expires_at'])),
												DataCell(
													activityScreenController.subscriberData[index]['cancel_subscriber'] == true
														? GestureDetector(
															  onTap: () {
																// Get the subscriptionId
																int subscriberId = activityScreenController.subscriberData[index]['id'];
																
																// Fetch the invoice details
																activityScreenController.cancelSubscriber(subscriberId);

															  },
															  child: Icon(Icons.cancel, size: 30, color: Colors.red),
															)
														: SizedBox.shrink(),  // This will create an empty cell if the condition is false
												),

												// Optionally add DataCell for actions if needed
											  ],
											),
										  ),
										),
									  ),
									  Obx(() => _showLeftIndicator.value
										  ? Positioned(
											  left: 10,
											  top: MediaQuery.of(context).size.height / 4,
											  child: Icon(Icons.arrow_back, size: 30, color: Colors.grey.withOpacity(0.6)),
											)
										  : SizedBox.shrink(),
									  ),
									  Obx(() => _showRightIndicator.value
										  ? Positioned(
											  right: 10,
											  top: MediaQuery.of(context).size.height / 4,
											  child: Icon(Icons.arrow_forward, size: 30, color: Colors.grey.withOpacity(0.6)),
											)
										  : SizedBox.shrink(),
									  ),
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
			  );
			}
		}),
    );
  }
}

