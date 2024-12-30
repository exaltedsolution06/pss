import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

import 'activity_screen_controller.dart';

// ignore: must_be_immutable
class FaqScreenView extends GetView<ActivityScreenController> {
  const FaqScreenView({super.key});

  

  @override
  Widget build(BuildContext context) {
    final ActivityScreenController activityScreenController = Get.find();
    final double screenWidth = MediaQuery.of(context).size.width;
    activityScreenController.shouldFetchFAQpageData = true;

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
        title: Obx(() => Text(
            activityScreenController.faqPageTitle.value,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (activityScreenController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
        } else if (activityScreenController.faqPageTitle.value.isEmpty) {
          return const Center(child: Text('No details available for this page.'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0), // Adjust the padding value as needed
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        activityScreenController.faqPageTitle.value,
                        style: const TextStyle(
                          fontSize: 26,
                          color: AppColor.black,
                          fontFamily: 'Urbanist-semibold',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Last updated: ${activityScreenController.faqUpdatedDate.value}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColor.black,
                          fontFamily: 'Urbanist-regular',
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Corrected Html() widget
                      Html(
                        data: activityScreenController.faqPageContent.value,
                        style: {
                          "h4": Style(fontFamily: 'Urbanist-semibold', fontSize: FontSize(26)),
                          "p": Style(fontFamily: 'Urbanist-regular', fontSize: FontSize(18)),
                          "a": Style(fontFamily: 'Urbanist-regular', fontSize: FontSize(18), color: AppColor.purple, textDecoration: TextDecoration.none),
                          // Add more styles as needed
                        },
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
