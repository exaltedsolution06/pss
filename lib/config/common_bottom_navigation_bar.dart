import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/app/modules/profile_screen/controllers/user_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final userController = Get.find<UserController>();
  final CartController cartController = Get.put(CartController());
  //final cartController = Get.find<CartController>();

  CommonBottomNavigationBar({required this.currentIndex});

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME);
        break;
      case 1:
        Get.toNamed(Routes.SERACH_SCREEN);
        break;
      case 2:
        Get.toNamed(Routes.NOTIFICATION_SCREEN);
        break;
      case 3:
        Get.toNamed(Routes.CART_PAGE);
        break;
      case 4:
        Get.toNamed(Routes.PROFILE_SCREEN);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
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
            icon: Stack(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: currentIndex == 3 ? AppColor.purple : AppColor.BlackGreyscale,
                  size: 30.0,
                ),
                if (cartController.itemCount.value > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cartController.itemCount.value}',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            label: '',
          ),
          /*BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: userController.profilePicture.value != null && userController.profilePicture.value.isNotEmpty
                  ? NetworkImage(userController.profilePicture.value)
                  : AssetImage(Appcontent.defaultLogo) as ImageProvider,
              backgroundColor: Colors.transparent,
            ),
            label: '',
          ),*/
		  BottomNavigationBarItem(
			  icon: Container(
				padding: EdgeInsets.all(2), // Optional: to make border more visible
				decoration: BoxDecoration(
				  shape: BoxShape.circle,
				  border: Border.all(color: AppColor.BlackGreyscale, width: 2),
				),
				child: CircleAvatar(
				  radius: 15,
				  backgroundImage: userController.profilePicture.value != null && userController.profilePicture.value.isNotEmpty
					  ? NetworkImage(userController.profilePicture.value)
					  : AssetImage(Appcontent.defaultLogo) as ImageProvider,
				  backgroundColor: Colors.transparent,
				),
			  ),
			  label: '',
		  ),
        ],
      );
    });
  }
}
