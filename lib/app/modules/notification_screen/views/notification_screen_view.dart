import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import '../controllers/notification_screen_controller.dart';

class NotificationScreenView extends StatelessWidget {
  // Initialize the NotificationScreenController
  final NotificationScreenController notificationScreenController = Get.find<NotificationScreenController>();

  final ScrollController _scrollController = ScrollController();

  NotificationScreenView() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        notificationScreenController.loadMoreData();  // Load more data when user scrolls
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,  // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          centerTitle: true,
          title: const Text('Notifications', style: TextStyle(fontSize: 18, color: Colors.black)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Obx(() {
              int selectedIndex = notificationScreenController.selected.value;
              return TabBar(
                onTap: (index) {
                  notificationScreenController.onTabChange(index);
                },
                isScrollable: true,  // Enable scrolling for the TabBar
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: AppColor.purple,
                  ),
                  insets: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Urbanist-bold',
                  fontWeight: FontWeight.w700,
                ),
                labelColor: AppColor.purple,
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Urbanist-regular',
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Messages'),
                  Tab(text: 'Likes'),
                  Tab(text: 'Subscriptions'),
                  Tab(text: 'Tips'),
                ],
              );
            }),
          ),
        ),
        body: Obx(() {
          if (notificationScreenController.isFetchingData.value && notificationScreenController.totalData.isEmpty) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
          }
          return TabBarView(
            children: [
              buildNotificationList(notificationScreenController.totalData),
              buildNotificationList(notificationScreenController.messagesData),
              buildNotificationList(notificationScreenController.likesData),
              buildNotificationList(notificationScreenController.subscriptionsData),
              buildNotificationList(notificationScreenController.tipsData),
            ],
          );
        }),
      ),
    );
  }

  // Helper method to build the list for each tab
  Widget buildNotificationList(RxList data) {
    return Padding(
		padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
		child: Obx(() {
		  // Check if data is still being fetched
			if (notificationScreenController.isFetchingData.value && data.isEmpty) {
				return Center(
					child: CircularProgressIndicator(
						valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple), // Set your desired color here
					),
				);
			}
			
			// Check if the data is empty after loading
			if (data.isEmpty) {
				return Center(
					child: Text(
						'No data found',
						style: TextStyle(
						  fontSize: 16,
						  color: Colors.grey, // Customize the color if needed
						  fontFamily: 'Urbanist-regular',
						),
					),
				);
			}
	  
			return ListView.separated(
			   controller: _scrollController,
				itemCount: data.length + 1,  // Add 1 to display loading indicator at the end
				separatorBuilder: (context, index) => const SizedBox(height: 10),
				itemBuilder: (context, index) {
				  if (index == data.length) {
					// Show loading indicator at the end of the list if more data is being fetched
					return notificationScreenController.isFetchingData.value
						? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),))
						: const SizedBox.shrink();
				  }

				  final notification = data[index];
				  return buildNotificationItem(notification);
				},
			);
		}),
	);
}

  // Method to build a single notification item
  Widget buildNotificationItem(dynamic notification) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
			  height: 56,
			  width: 56,
			  child: Container(
				decoration: BoxDecoration(
				  shape: BoxShape.circle,
				  color: Colors.grey[300], // Background color for the CircleAvatar
				),
				child: CircleAvatar(
				  backgroundImage: NetworkImage(notification['avatar']),
				  // Optionally handle errors and provide a default image
				  onBackgroundImageError: (error, stackTrace) {
					// You can log the error or handle it as needed
				  },
				),
			  ),
			),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notification['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Urbanist-medium',
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  notification['created_at'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff64748B),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Urbanist-regular',
                  ),
                ),
              ],
            ),
            subtitle: Text(
              notification['username'],
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff64748B),
                fontWeight: FontWeight.w400,
                fontFamily: 'Urbanist-regular',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            notification['message'],
            style: TextStyle(
              fontSize: 14,
              color: AppColor.BlackGreyscale,
              fontFamily: 'Urbanist-semibold',
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

}