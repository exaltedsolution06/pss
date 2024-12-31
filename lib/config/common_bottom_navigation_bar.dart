import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
/*import 'home_page.dart';
import 'search_page.dart';
import 'notifications_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';*/

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  CommonBottomNavigationBar({required this.currentIndex});

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        //Get.offAll(() => HomePage());
		Get.toNamed(Routes.HOME);
        break;
      case 1:
        //Get.offAll(() => SearchPage());
		Get.toNamed(Routes.SERACH_SCREEN);
        break;
      case 2:
        //Get.offAll(() => NotificationsPage());
		Get.toNamed(Routes.NOTIFICATION_SCREEN);
        break;
      case 3:
        //Get.offAll(() => CartPage());
		Get.toNamed(Routes.SHOP_SCREEN);
        break;
      case 4:
        //Get.offAll(() => ProfilePage());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _onBottomNavTap,
	  type: BottomNavigationBarType.fixed, // Ensures even spacing
      iconSize: 30.0, // Adjusts the size of the icons
      items: [
        BottomNavigationBarItem(
			icon: Icon(
				Icons.home,
				color: currentIndex == 0 ? AppColor.purple : AppColor.BlackGreyscale,
				size: 30.0,
			),
			label: '',
        ),
        BottomNavigationBarItem(
			icon: Icon(
				Icons.search,
				color: currentIndex == 1 ? AppColor.purple : AppColor.BlackGreyscale,
				size: 30.0,
			),
			label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
			Icons.notifications,
				color: currentIndex == 2 ? AppColor.purple : AppColor.BlackGreyscale,
				size: 30.0,
			),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
			Icons.shopping_cart,
				color: currentIndex == 3 ? AppColor.purple : AppColor.BlackGreyscale,
				size: 30.0,
			),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 15, // Adjust size of the profile picture
            backgroundImage: AssetImage(Appcontent.pss1),
            backgroundColor: Colors.transparent, // No background color
          ),
          label: '',
        ),
      ],
    );
  }
}
