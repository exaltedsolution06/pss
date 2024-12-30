import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';

//import 'package:picturesourcesomerset/app/modules/Generalaetting_screen/invite_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/control_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/recentsearch_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/story_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/timespent_screen.dart';

import 'package:picturesourcesomerset/app/modules/activity_screen/account_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/wallet_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/payments_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/rates_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/subscriptions_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/notifications_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/privacy_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/verify_screen.dart';
import 'package:picturesourcesomerset/app/modules/activity_screen/faq_screen_view.dart';

import 'package:picturesourcesomerset/config/bottom_navigation.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import '../../../config/common_textfield.dart';
import 'activity_screen_controller.dart';
import 'history_screen.dart';

IconData getIconData(String iconName) {
  switch (iconName) {
	case 'home':
      return Icons.home;
    case 'account_balance_wallet':
      return Icons.account_balance_wallet;
    case 'credit_card':
      return Icons.credit_card;
	case 'stacks':
      return Icons.payments;
	case 'credit_card_clock':
      return Icons.group;
	case 'notifications_active':
      return Icons.notifications_active;
	case 'shield':
      return Icons.shield;
	case 'check':
      return Icons.check;
	case 'logout':
      return Icons.logout;
	case 'faq':
      return Icons.quiz;
    default:
      return Icons.settings; // Default icon if no match is found
  }
}


class ActivityScreenView extends GetView<ActivityScreenController> {
  ActivityScreenView({super.key});

  @override
  Widget build(BuildContext context) {
	
	final ActivityScreenController activityScreenController = Get.put(ActivityScreenController(Get.find<ApiService>()));
	
	//final ActivityScreenController activityScreenController = Get.put(ActivityScreenController());
	
    /*List img = [
      'assets/timer.png',
      'assets/note.png',
      'assets/archive-tick.png',
      'assets/clipboard-tick.png',
      'assets/global-search.png',
      'assets/note.png',
    ];*/
	List<String> micons = [
		'home',
		'settings',
		'account_balance_wallet',
		'credit_card',
		'stacks',
		'credit_card_clock',
		'notifications_active',
		'shield',
		'check',
		'faq',
		'logout',
		
	];
    List text = [
		'Home',
		'Account',
		'Wallet',
		'Payments',
		'Rates',
		'Subscriptions',
		'Notifications',
		'Privacy',
		'Verify',
		'Help & FAQ',
		'Logout'
      /*'Time Spent',
      'History Account',
      'Archived',
      'Saved',
      'Recent Searches',
      'Content Control',*/
    ];
    List sutext = [
		"Get back to your home page",
		"Manage your account settings.",
		"Your payments & wallet.",
		"Your payments & wallet.",
		"Prices & Bundles.",
		"Your active subscriptions.",
		'Your email notifications settings.',
		'Your privacy and safety matters.',
		'Get verified and start earning now.',
		'Help.',
		'Logout your account.'
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: const Text(
              'Activity',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            centerTitle: true,
            /*actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InviteScreen(),
                      ));
                },
                child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/setting-4.png')),
              ),
              const SizedBox(
                width: 15,
              ),
            ],*/
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                /*Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 30),
                  child: textfield1(text: 'Search..', text1: 'Search'),
                ),*/
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: micons.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Bottom()));
                        } else if (index == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountScreenView()));
                        } else if (index == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WalletScreenView()));
                        } else if (index == 3) {
                          Navigator.push(
							  context,
							  MaterialPageRoute(
								builder: (context) {
								  activityScreenController.fetchPaymentHistory(); // Call the function here
								  return const PaymentsScreenView();
								},
							  ),
							);

                        } else if (index == 4) {
							Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) {
									  activityScreenController.fetchRatesData(); // Call the function here
									  return const RatesScreenView();
									},
								)
							);
                        } else if (index == 5) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
								builder: (context) {
									  activityScreenController.fetchSubscriptionData(); // Call the function here
									  return SubscriptionsScreenView();
									},
								));
                        } else if (index == 6) {
							Navigator.push(
							  context,
							  MaterialPageRoute(
								builder: (context) {
								  activityScreenController.fetchSettingsNotificationData(); // Call the function here
								  return const NotificationsScreenView();
								},
							  ),
							);
                        } else if (index == 7) {
							Navigator.push(
							  context,
							  MaterialPageRoute(
								builder: (context) {
								  activityScreenController.fetchSettingsPrivacyData(); // Call the function here
								  return const PrivacyScreenView();
								},
							  ),
							);
                        } else if (index == 8) {
							Navigator.push(
							  context,
							  MaterialPageRoute(
								builder: (context) {
								  activityScreenController.fetchSettingsVerifyData(); // Call the function here
								  return const VerifyScreenView();
								},
							  ),
							);
                        } else if (index == 9) {
							Navigator.push(
							  context,
							  MaterialPageRoute(
								builder: (context) {
								  activityScreenController.fetchFAQPage(); // Call the function here
								  return FaqScreenView();
								},
							  ),
							);
                        } else if (index == 10) {
							activityScreenController.logout();
                          //Get.find<AuthController>().logout();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ListTile(
                          leading: Stack(
                            children: [
                              /*Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xffF8F9FD),
                                ),
                              ),*/
							  
							  Container(
								padding: const EdgeInsets.all(10.0),
								//margin: const EdgeInsets.only(right: 9.0),
								decoration: BoxDecoration(
								  color: AppColor.Greyscale,
								  borderRadius: BorderRadius.circular(100),
								),
								child: Icon(getIconData(micons[index]), color: Colors.black),
							  )
			  
                              /*Positioned(
                                top: 11,
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(img[index]),
                                ),
                              ),*/
                            ],
                          ),
                          title: Text(
                            text[index],
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist-semibold',
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            sutext[index],
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff64748B),
                                fontFamily: 'Urbanist-medium',
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(Icons.navigate_next),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
