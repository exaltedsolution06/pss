import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/invoice_details_screen.dart';
import '../../../../config/app_color.dart';
import '../../../../config/common_button.dart';
import 'activity_screen_controller.dart';

class PaymentsScreenView extends GetView<ActivityScreenController> {
  const PaymentsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
	
	final ActivityScreenController activityScreenController = Get.find();
	// Set the flag to true for this specific page
    activityScreenController.shouldFetchPaymentHistory = true;
  
    //final List<String> date = ['02/07/2024', '03/07/2024', '04/04/2024'];
    //final List<String> details = ['Paid for tip to @ususususu', 'Paid for profile', 'Subscribe to see @ududud\'s post'];
    //final List<String> price = ['\$10', '\$20', '\$30'];

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
        title: const Text('Payments', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (activityScreenController.isLoading.value) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
        } else if (activityScreenController.paymentData.isEmpty) {
          return Center(child: Text('No payment history available.'));
        } else {
          return Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: DataTable(
              columns: [
                DataColumn(label: Container(width: 100, child: Text('Type'))),
                DataColumn(label: Container(width: 80, child: Text('Status'))),
                DataColumn(label: Container(width: 80, child: Text('Amount'))),
                DataColumn(label: Container(width: 80, child: Text('From'))),
                DataColumn(label: Container(width: 80, child: Text('To'))),
                DataColumn(label: Container(width: 50, child: Text(''))),
                // Optionally add DataColumn for actions if needed
              ],
              rows: List.generate(
                activityScreenController.paymentData.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(activityScreenController.paymentData[index]['type'], overflow: TextOverflow.ellipsis)),
					DataCell(
					  Container(
						padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),  // Internal padding for the "button" effect
						//alignment: Alignment.center,  // Centers the text
						decoration: BoxDecoration(
						  color: activityScreenController.paymentData[index]['status'] == 'approved'
								? Colors.green
								: Colors.red,  // Background color to make it look like a button
						  borderRadius: BorderRadius.circular(4.0),  // Rounded corners for button-like appearance
						),
						child: Text(
						  activityScreenController.paymentData[index]['status'],
						  overflow: TextOverflow.ellipsis,
						  textAlign: TextAlign.center,
						  style: TextStyle(
							color: Colors.white,  // Text color to contrast with background
							fontSize: 12, 
						  ),
						),
					  ),
					),
                    DataCell(Text(activityScreenController.paymentData[index]['formatted_amount'])),
                    DataCell(Text(activityScreenController.paymentData[index]['sender']['name'])),
                    DataCell(Text(activityScreenController.paymentData[index]['receiver']['name'])),
					DataCell(
						activityScreenController.paymentData[index]['view_invoice']['invoice_exists'] == true
							? GestureDetector(
								  onTap: () {
									// Get the paymentInvoiceId
									int paymentInvoiceId = activityScreenController.paymentData[index]['invoice_id'];
									
									// Fetch the invoice details
									activityScreenController.fetchInvoiceDetails(paymentInvoiceId);
									
									// Navigate to the desired page, passing any relevant data
									Get.to(InvoiceDetailsScreenView(), arguments: {
									  'paymentInvoiceId': paymentInvoiceId
									});
								  },
								  child: Icon(Icons.content_paste_search, size: 30, color: Colors.black),
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
      );
	  }
	  }),
    );
  }
}
