import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';

import 'package:picturesourcesomerset/app/modules/activity_screen/control_screen.dart';


import 'package:picturesourcesomerset/app/modules/activity_screen/account_screen.dart';

import 'package:picturesourcesomerset/app/modules/activity_screen/notifications_screen.dart';


import 'package:picturesourcesomerset/config/bottom_navigation.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import '../../../config/common_textfield.dart';
import 'activity_screen_controller.dart';

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
	
	List<String> micons = [
		'home',
		'settings',
		'logout',	
	];
    List text = [
		'Home',
		'Account',
		'Logout'
    ];
    List sutext = [
		"Get back to your home page",
		"Manage your account settings.",
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
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
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
							activityScreenController.logout();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ListTile(
                          leading: Stack(
                            children: [							  
							  Container(
								padding: const EdgeInsets.all(10.0),
								//margin: const EdgeInsets.only(right: 9.0),
								decoration: BoxDecoration(
								  color: AppColor.Greyscale,
								  borderRadius: BorderRadius.circular(100),
								),
								child: Icon(getIconData(micons[index]), color: Colors.black),
							  )
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
