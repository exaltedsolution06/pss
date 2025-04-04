import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/custom_switch.dart';
import '../../../../config/app_color.dart';
import 'activity_screen_controller.dart';

class NotificationsScreenView extends GetView<ActivityScreenController> {
  const NotificationsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    //final ActivityScreenController controller = Get.put(ActivityScreenController());
	final ActivityScreenController activityScreenController = Get.find();
	activityScreenController.shouldFetchSettingsNotification = true;
    return Scaffold(
      //backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        //backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Notifications', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                'Your email notifications settings',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.black,
                  fontFamily: 'Urbanist-Regular',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
				padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 16.0),
				child: Column(
                    children: [
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_new_sub.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_new_sub'),
							label: 'New subscription registered',
						)),
						const SizedBox(height: 15),
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_new_tip.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_new_tip'),
							label: 'Received a tip',
						)),
						const SizedBox(height: 15),
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_new_ppv_unlock.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_new_ppv_unlock'),
							label: 'Your PPV content has been unlocked',
						)),
						const SizedBox(height: 15),
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_new_message.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_new_message'),
							label: 'New message received',
						)),
						const SizedBox(height: 15),
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_new_comment.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_new_comment'),
							label: 'New comment received',
						)),
						const SizedBox(height: 15),
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_expiring_subs.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_expiring_subs'),
							label: 'Expiring subscriptions',
						)),
						const SizedBox(height: 15),
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_renewals.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_renewals'),
							label: 'Upcoming renewals',
						)),
						const SizedBox(height: 15),
						Obx(() => customSwitch(
							value: activityScreenController.notification_email_creator_went_live.value,
							onToggle: (value) => activityScreenController.toggleSwitchSettingsNotification(value, 'notification_email_creator_went_live'),
							label: 'A user I am following went live',
						)),
					]
				),
            ),
          ],
        ),
      ),
    );
  }
}
