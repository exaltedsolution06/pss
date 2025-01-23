import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

import 'package:picturesourcesomerset/app/modules/home/views/home_view.dart';
import 'package:picturesourcesomerset/app/modules/home/bindings/home_binding.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';

/*import 'package:picturesourcesomerset/app/modules/serach_screen/views/serach_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/serach_screen/bindings/serach_screen_binding.dart';
import 'package:picturesourcesomerset/app/modules/serach_screen/controllers/serach_screen_controller.dart';*/


class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
	final HomeController homeController = Get.find();
	//final SerachScreenController serachScreenController = Get.find();
  
	final List<Widget> bottomViews = [
		HomeView(),
		//SerachScreenView(),
	];
	final List<String> bottomRoutes = [
		Routes.HOME,
		Routes.SERACH_SCREEN,
		Routes.NOTIFICATION_SCREEN,
		Routes.SHOP_SCREEN,
		Routes.PROFILE_SCREEN,
	];
	// And then in your onTap handler:
	void _onTabTapped(int index) {
		Get.toNamed(bottomRoutes[index]);
	}

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 2,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Clickable items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _buildBottomNavItem(Icons.home, 'Home', 0)),
                  Expanded(child: _buildBottomNavItem(Icons.search, 'Search', 1)),
                  Expanded(child: _buildBottomNavItem(Icons.notifications, 'Notifications', 2)),
                  Expanded(child: _buildBottomNavItem(Icons.shopping_cart, 'Shop', 3)),
                  Expanded(child: _buildProfileImageNavItem('Profile', 4)),
                ],
              ),
            ],
          ),
        ),
      ),
      body: bottomViews[_selectedIndex],
    );
  }

	Widget _buildBottomNavItem(IconData icon, String label, int index) {
		final bool isSelected = _selectedIndex == index;
		return GestureDetector(
		  onTap: () => _onTabTapped(index),
		  child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
			  Icon(
				icon,
				color: isSelected ? AppColor.purple : const Color(0xff94A3B8),
				size: 30.0,
			  ),
			],
		  ),
		);
	}
  
	// Custom widget for profile image
	Widget _buildProfileImageNavItem(String label, int index) {
		final bool isSelected = _selectedIndex == index;

		// Assuming you have the profile image URL in `homeController.profileData.avatar`
		//final profileImageUrl = homeController.profileData.avatar;
		final profileImageUrl = Appcontent.pss1;

//? NetworkImage(profileImageUrl)

		return GestureDetector(
		  onTap: () => _onTabTapped(index),
		  child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
			  CircleAvatar(
				radius: 18.0, // Adjust the size as needed
				backgroundColor: AppColor.purple,
				backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty					
					? AssetImage(profileImageUrl)
					: null, // Use placeholder image if no profile image
				child: profileImageUrl == null || profileImageUrl.isEmpty
					? Icon(
						Icons.person,
						color: Colors.white,
						size: 20.0,
					  )
					: null, // Default icon if no image
			  ),
			],
		  ),
		);
	}


}
