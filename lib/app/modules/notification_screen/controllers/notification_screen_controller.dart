import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class NotificationScreenController extends GetxController {
	final ApiService apiService;
	NotificationScreenController(this.apiService);  // Constructor accepting ApiService

	var selected = 0.obs;  // To track the selected tab

	var currentPageAll = 1.obs;
	var currentPageUnread = 1.obs;
	var currentPageRead = 1.obs;
  
	var isFetchingData = false.obs;
	var hasMoreDataAll = true.obs;
	var hasMoreDataUnread = true.obs;
	var hasMoreDataRead = true.obs;

	var totalData = <dynamic>[].obs;
	var unreadData = <dynamic>[].obs;
	var readData = <dynamic>[].obs;

	@override
	void onInit() {
		super.onInit();
		loadInitialDataForTab(0);  // Load 'All' tab by default
	}

	void onTabChange(int index) {
		selected.value = index;
		loadInitialDataForTab(index);
	}

	void loadInitialDataForTab(int index) {
		switch (index) {
			case 0:
				if (totalData.isEmpty) loadMoreDataAll();
				break;
			case 1:
				if (unreadData.isEmpty) loadMoreDataUnread();
				break;
			case 2:
				if (readData.isEmpty) loadMoreDataRead();
				break;
		}
	}

  // Helper function to determine if more data can be loaded
  bool canLoadMore(int index) {
    switch (index) {
      case 0:
        return hasMoreDataAll.value && !isFetchingData.value;
      case 1:
        return hasMoreDataUnread.value && !isFetchingData.value;
      case 2:
        return hasMoreDataRead.value && !isFetchingData.value;
      default:
        return false;
    }
  }

  // Load more data for each tab
  Future<void> loadMoreDataAll() async {
    if (!canLoadMore(0)) return;
    
    isFetchingData.value = true;
    try {
		var response = await apiService.notifications(1, 0, 0, currentPageAll.value);
		/*final response = {
			'total': [
				{"avatar": Appcontent.pss1, "message": "Dennisa Nedry requested access to Isla Nublar SOC2 compliance report", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
			],
		};*/
		//var newData = response?['total'] ?? [];
		var newData = response['data']['all'];
		if (newData.isEmpty) {
			hasMoreDataAll.value = false;
		} else {
			totalData.addAll(newData);
			/*totalData.addAll(newData.map((item) {
				return RxMap<String, dynamic>.from({
					'avatar': item['avatar'],
					'message': item['message'],
					'created_at': item['created_at'],
				});
			}).toList());*/
			currentPageAll.value++;
		}
    } catch (e) {
      print('Error fetching All loadMoreDataAll - notification screen controller: $e');
    } finally {
      isFetchingData.value = false;
    }
  }

  Future<void> loadMoreDataUnread() async {
    if (!canLoadMore(1)) return;
    
    isFetchingData.value = true;
    try {
		var response = await apiService.notifications(0, 0, 1, currentPageUnread.value);
		/*final response = {
			'unread': [
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Dennisa Nedry requested access to Isla Nublar SOC2 compliance report.", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
			],
		};*/
		//var newData = response?['unread'] ?? [];
		var newData = response['data']['unread'];
		if (newData.isEmpty) {
			hasMoreDataUnread.value = false;
		} else {
			unreadData.addAll(newData);
			/*unreadData.addAll(newData.map((item) {
				return RxMap<String, dynamic>.from({
					'avatar': item['avatar'],
					'message': item['message'],
					'created_at': item['created_at'],
				});
			}).toList());*/
			currentPageUnread.value++;
		}
    } catch (e) {
      print('Error fetching Messages notifications: $e');
    } finally {
      isFetchingData.value = false;
    }
  }

  Future<void> loadMoreDataRead() async {
    if (!canLoadMore(2)) return;
    
    isFetchingData.value = true;
    try {
		var response = await apiService.notifications(0, 1, 0, currentPageRead.value);
		/*final response = {
			'read': [
				{"avatar": Appcontent.pss1, "message": "Dennisa Nedry requested access to Isla Nublar SOC2 compliance report", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Someone unlocked your post.", "created_at": "3 days ago"},
				{"avatar": Appcontent.pss1, "message": "Dennisa Nedry requested access to Isla Nublar SOC2 compliance report.", "created_at": "3 days ago"},
			],
		};*/
		//var newData = response?['read'] ?? [];
		var newData = response['data']['read'];
		if (newData.isEmpty) {
			hasMoreDataRead.value = false;
		} else {
			readData.addAll(newData);
			/*readData.addAll(newData.map((item) {
				return RxMap<String, dynamic>.from({
					'avatar': item['avatar'],
					'message': item['message'],
					'created_at': item['created_at'],
				});
			}).toList());*/
			currentPageRead.value++;
		}
    } catch (e) {
      print('Error fetching Likes notifications: $e');
    } finally {
      isFetchingData.value = false;
    }
  }


  // This method will be called when the user scrolls to the bottom
  void loadMoreData() {
    if (selected.value == 0) {
      loadMoreDataAll();
    } else if (selected.value == 1) {
      loadMoreDataUnread();
    } else if (selected.value == 2) {
      loadMoreDataRead();
    }
  }
}
