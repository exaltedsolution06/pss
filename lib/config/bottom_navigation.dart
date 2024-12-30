import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/app/modules/home/views/home_view.dart';
import 'package:picturesourcesomerset/app/modules/home/bindings/home_binding.dart';

import 'package:picturesourcesomerset/app/modules/live_screen/views/live_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
	//final HomeController homeController = Get.find<HomeController>();
	
	final HomeController homeController = Get.find();
  
  final List<Widget> bottomViews = [
    HomeView()
  ];
	final List<String> bottomRoutes = [
		Routes.HOME,
		Routes.SERACH_SCREEN,
		Routes.NEWPOST_SCREEN,
		Routes.PROFLIE_SCREEN,
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
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        elevation: 0,
        backgroundColor: const Color(0xffd10037),
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LiveScreenView()),
          );
        },
        child: Icon(Icons.videocam, color: Colors.white, size: 34.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Non-clickable area
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    color: Colors.transparent, // Make it transparent or any other color
                  ),
                ),
              ),
              // Clickable items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _buildBottomNavItem(Icons.home, 'Home', 0)),
                  Expanded(child: _buildBottomNavItem(Icons.search, 'Search', 1)),
                  const SizedBox(width: 48), // Space for FAB
                  Expanded(child: _buildBottomNavItem(Icons.post_add, 'Post', 2)),
                  Expanded(child: _buildBottomNavItem(Icons.person, 'Profile', 3)),
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
            color: isSelected ? Colors.black : const Color(0xff94A3B8),
            size: 24.0,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.black : const Color(0xff94A3B8),
              fontFamily: 'Urbanist-regular',
            ),
          ),
        ],
      ),
    );
  }
}
