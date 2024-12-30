import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class FollowScreenController extends GetxController {
	//TODO: Implement FollowScreenController
	final ApiService apiService;
	FollowScreenController(this.apiService);  // Constructor accepting ApiService
	
	var selected = 0.obs;  // To track the selected tab
  
	var currentPageFollowing = 1.obs;
	var currentPageFollowers = 1.obs;
	var currentPageBlocked = 1.obs;

	var isFetchingData = false.obs;
	
	var hasMoreDataFollowing = true.obs;
	var hasMoreDataFollowers = true.obs;
	var hasMoreDataBlocked = true.obs;

	var followingData = <dynamic>[].obs;
	var followersData = <dynamic>[].obs;
	var blockedData = <dynamic>[].obs;
	
	@override
	void onInit() {
		super.onInit();
		loadInitialDataForTab(0);  // Load 'Following' tab by default
	}
	void onTabChange(int index) {
		selected.value = index;
		loadInitialDataForTab(index);
	}
	
	void loadInitialDataForTab(int index) {
		switch (index) {
			case 0:
				if (followingData.isEmpty) loadMoreDataFollowing();
				break;
			case 1:
				if (followersData.isEmpty) loadMoreDataFollowers();
				break;
			case 2:
				if (blockedData.isEmpty) loadMoreDataBlocked();
				break;
		}
	}
	
	// Helper function to determine if more data can be loaded
	bool canLoadMore(int index) {
		switch (index) {
			case 0:
				return hasMoreDataFollowing.value && !isFetchingData.value;
			case 1:
				return hasMoreDataFollowers.value && !isFetchingData.value;
			case 2:
				return hasMoreDataBlocked.value && !isFetchingData.value;
			default:
				return false;
		}
	}
	
	// Load more data for each tab
	Future<void> loadMoreDataFollowing() async {
		if (!canLoadMore(0)) return;

		isFetchingData.value = true;
		try {
			var response = await apiService.social_lists(1, 1, 1, currentPageFollowing.value);
			var newData = response['data']['following'];
			if (newData.isEmpty) {
				hasMoreDataFollowing.value = false;
			} else {
				followingData.addAll(newData);
				currentPageFollowing.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreDataFollowing - follow screen controller: $e');
		} finally {
			isFetchingData.value = false;
		}
	}
	
	Future<void> loadMoreDataFollowers() async {
		if (!canLoadMore(1)) return;

		isFetchingData.value = true;
		try {
			var response = await apiService.social_lists(1, 1, 1, currentPageFollowers.value);
			var newData = response['data']['followers'];
			if (newData.isEmpty) {
				hasMoreDataFollowers.value = false;
			} else {
				followersData.addAll(newData);
				currentPageFollowers.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreDataFollowers - follow screen controller: $e');
		} finally {
			isFetchingData.value = false;
		}
	}
	
	Future<void> loadMoreDataBlocked() async {
		if (!canLoadMore(2)) return;

		isFetchingData.value = true;
		try {
			var response = await apiService.social_lists(1, 1, 1, currentPageBlocked.value);
			var newData = response['data']['blocked'];
			if (newData.isEmpty) {
				hasMoreDataBlocked.value = false;
			} else {
				blockedData.addAll(newData);
				currentPageBlocked.value++;
			}
		} catch (e) {
			print('Error fetching All loadMoreDataBlocked - follow screen controller: $e');
		} finally {
			isFetchingData.value = false;
		}
	}
	// This method will be called when the user scrolls to the bottom
	void loadMoreData() {
		if (selected.value == 0) {
			loadMoreDataFollowing();
		} else if (selected.value == 1) {
			loadMoreDataFollowers();
		} else if (selected.value == 2) {
			loadMoreDataBlocked();
		}
	}
  
	/*var selectindex = [];
	int selectitem = 0;
	final count = 0.obs;

	int gValue = 0;

	RxInt selected = 0.obs;
	int currentindex = 0;

	void increment() => count.value++;

	changevalue({int? value}) {
	if (selectindex.contains(value)) {
		selectindex.remove(value);
	} else {
		selectindex.add(value);
	}
	update();
	}

	changecatwise({int? index}) {
		currentindex = index ?? 0;
		update();
	}

	changeValue({int? value}) {
		gValue = value ?? 0;
		update();
	}*/
}
