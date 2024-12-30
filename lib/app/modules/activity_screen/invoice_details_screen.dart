import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/activity_screen_view.dart';
import '../../../../config/app_color.dart';
import '../../../../config/common_button.dart';
import 'activity_screen_controller.dart';

class InvoiceDetailsScreenView extends GetView<ActivityScreenController> {
  const InvoiceDetailsScreenView({super.key});

	@override
	Widget build(BuildContext context) {
	
		final ActivityScreenController activityScreenController = Get.find();
		//final ActivityScreenController activityScreenController = Get.put(ActivityScreenController());
		// Set the flag to true for this specific page
		activityScreenController.shouldFetchInvoiceDetails = true;
		
		//print('payment Invoice Id: $paymentInvoiceId');

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
			title: const Text('Invoice Details', style: TextStyle(fontSize: 18, color: Colors.black)),
			centerTitle: true,
		  ),
			body: Obx(() {
				if (activityScreenController.isLoading.value) {
				  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
				} else if (activityScreenController.invoice.value.isEmpty) {
				  return Center(child: Text('No details available for this invoice.'));
				} else {
					return Padding(
					  padding: const EdgeInsets.all(16.0),  // Adjust the padding value as needed
					  child: Stack(
						children: [
						  SingleChildScrollView(
							child: Column(
							  children: [
								Column(
								  children: [
									Row(
										children: [
											Padding(
												padding: const EdgeInsets.all(0), // Adjust or remove this if not needed
												child: Text('INVOICE:',style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-semibold'),),
											),
											const SizedBox(width: 10),
											Text('${activityScreenController.invoice.value}', style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-regular',),),
										],
									),
									Row(
										children: [
											Padding(
												padding: const EdgeInsets.all(0), // Adjust or remove this if not needed
												child: Text('Invoice Date:',style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-semibold'),),
											),
											const SizedBox(width: 10),
											Text('${activityScreenController.invoiceDate.value}', style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-regular',),),
										],
									),
									Row(
										children: [
											Padding(
												padding: const EdgeInsets.all(0), // Adjust or remove this if not needed
												child: Text('Due Date:',style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-semibold'),),
											),
											const SizedBox(width: 10),
											Text('${activityScreenController.dueDate.value}', style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-regular',),),
										],
									),
									const SizedBox(height: 20),
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Padding(
												padding: const EdgeInsets.all(0), // Adjust or remove this if not needed
												child: Text('Invoiced',style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-semibold'),),
											),
											const SizedBox(width: 10),
											Text('Invoice From', style: TextStyle(fontSize: 14, color: AppColor.SecondaryGreyscale, fontFamily: 'Urbanist-semibold',),),
										],
									),
									
									Row(
									  crossAxisAlignment: CrossAxisAlignment.start, // Aligns both columns at the top
									  mainAxisAlignment: MainAxisAlignment.spaceBetween,
									  children: [
										Flexible(
											flex: 2,
										  fit: FlexFit.loose,
										  child: Padding(
											padding: const EdgeInsets.all(0), // Adjust or remove this if not needed
											child: Column(
											  crossAxisAlignment: CrossAxisAlignment.start,
											  children: [
												Text(
												  '${activityScreenController.invoicedName.value}',
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
												Text(
												  '${activityScreenController.invoicedAddress.value}',
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
												Text(
												  '${activityScreenController.invoicedCity.value}',
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
												Text(
												  '${activityScreenController.invoicedCountry.value}',
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
											  ],
											),
										  ),
										),
										Spacer(), // Adds spacing between the two columns
										Flexible(
											flex: 3,
										  fit: FlexFit.loose,
										  child: Padding(
											padding: const EdgeInsets.all(0), // Adjust or remove this if not needed
											child: Column(
											  crossAxisAlignment: CrossAxisAlignment.end, // Aligns text to the right
											  children: [
												Text(
												  '${activityScreenController.invoiceFromName.value}',
												  textAlign: TextAlign.right,
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
												Text(
												  '${activityScreenController.invoiceFromAddress.value}',
												  textAlign: TextAlign.right,
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
												Text(
												  '${activityScreenController.invoiceFromCity.value}',
												  textAlign: TextAlign.right,
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
												Text(
												  '${activityScreenController.invoiceFromCountry.value}',
												  textAlign: TextAlign.right,
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
												Text(
												  'VAT Number ${activityScreenController.invoiceFromCompanyNumber.value}',
												  textAlign: TextAlign.right,
												  style: TextStyle(
													fontSize: 14,
													color: AppColor.SecondaryGreyscale,
													fontFamily: 'Urbanist-regular',
												  ),
												),
											  ],
											),
										  ),
										),
									  ],
									),


								  ],
								),
								DataTable(
								  columns: [
									DataColumn(
									  label: Container(
										//width: 100,
										child: Text('Description'),
									  ),
									),
									DataColumn(
									  label: Container(
										//width: 200,
										child: Text('Total'),
									  ),
									),
								  ],
								  rows: [
									DataRow(
									  cells: [
										DataCell(Text('${activityScreenController.invoiceType.value}')),
										DataCell(Text('${activityScreenController.invoiceTypePrice.value}'))
									  ],
									),
									DataRow(
									  cells: [
										DataCell(Text('Total taxes')),
										DataCell(Text('${activityScreenController.invoiceTaxPrice.value}')),
									  ],
									),
									DataRow(
									  cells: [
										DataCell(Text('Total')),
										DataCell(Text('${activityScreenController.invoiceTotalPrice.value}')),
									  ],
									),
									// Add more rows as needed
								  ],
								),

							  ],
							),
						  ),
						],
					  ),
					);
				}
			}),

		);
	}
}
