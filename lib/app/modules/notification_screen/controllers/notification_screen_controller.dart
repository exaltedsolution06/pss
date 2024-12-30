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
  var currentPageMessages = 1.obs;
  var currentPageLikes = 1.obs;
  var currentPageSubscriptions = 1.obs;
  var currentPageTips = 1.obs;
  
  var isFetchingData = false.obs;
  var hasMoreDataAll = true.obs;
  var hasMoreDataMessages = true.obs;
  var hasMoreDataLikes = true.obs;
  var hasMoreDataSubscriptions = true.obs;
  var hasMoreDataTips = true.obs;
  
  var totalData = <dynamic>[].obs;
  var messagesData = <dynamic>[].obs;
  var likesData = <dynamic>[].obs;
  var subscriptionsData = <dynamic>[].obs;
  var tipsData = <dynamic>[].obs;

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
        if (messagesData.isEmpty) loadMoreDataMessages();
        break;
      case 2:
        if (likesData.isEmpty) loadMoreDataLikes();
        break;
      case 3:
        if (subscriptionsData.isEmpty) loadMoreDataSubscriptions();
        break;
      case 4:
        if (tipsData.isEmpty) loadMoreDataTips();
        break;
    }
  }

  // Helper function to determine if more data can be loaded
  bool canLoadMore(int index) {
    switch (index) {
      case 0:
        return hasMoreDataAll.value && !isFetchingData.value;
      case 1:
        return hasMoreDataMessages.value && !isFetchingData.value;
      case 2:
        return hasMoreDataLikes.value && !isFetchingData.value;
      case 3:
        return hasMoreDataSubscriptions.value && !isFetchingData.value;
      case 4:
        return hasMoreDataTips.value && !isFetchingData.value;
      default:
        return false;
    }
  }

  // Load more data for each tab
  Future<void> loadMoreDataAll() async {
    if (!canLoadMore(0)) return;
    
    isFetchingData.value = true;
    try {
      var response = await apiService.notifications(1, 0, 0, 0, 0, currentPageAll.value);
      var newData = response['data']['total'];
      if (newData.isEmpty) {
        hasMoreDataAll.value = false;
      } else {
        totalData.addAll(newData);
        currentPageAll.value++;
      }
    } catch (e) {
      print('Error fetching All loadMoreDataAll - notification screen controller: $e');
    } finally {
      isFetchingData.value = false;
    }
  }

  Future<void> loadMoreDataMessages() async {
    if (!canLoadMore(1)) return;
    
    isFetchingData.value = true;
    try {
      var response = await apiService.notifications(0, 1, 0, 0, 0, currentPageMessages.value);
      var newData = response['data']['messages'];
      if (newData.isEmpty) {
        hasMoreDataMessages.value = false;
      } else {
        messagesData.addAll(newData);
        currentPageMessages.value++;
      }
    } catch (e) {
      print('Error fetching Messages notifications: $e');
    } finally {
      isFetchingData.value = false;
    }
  }

  Future<void> loadMoreDataLikes() async {
    if (!canLoadMore(2)) return;
    
    isFetchingData.value = true;
    try {
      var response = await apiService.notifications(0, 0, 1, 0, 0, currentPageLikes.value);
      var newData = response['data']['likes'];
      if (newData.isEmpty) {
        hasMoreDataLikes.value = false;
      } else {
        likesData.addAll(newData);
        currentPageLikes.value++;
      }
    } catch (e) {
      print('Error fetching Likes notifications: $e');
    } finally {
      isFetchingData.value = false;
    }
  }

  Future<void> loadMoreDataSubscriptions() async {
    if (!canLoadMore(3)) return;
    
    isFetchingData.value = true;
    try {
      var response = await apiService.notifications(0, 0, 0, 1, 0, currentPageSubscriptions.value);
      var newData = response['data']['subscriptions'];
      if (newData.isEmpty) {
        hasMoreDataSubscriptions.value = false;
      } else {
        subscriptionsData.addAll(newData);
        currentPageSubscriptions.value++;
      }
    } catch (e) {
      print('Error fetching Subscriptions notifications: $e');
    } finally {
      isFetchingData.value = false;
    }
  }

  Future<void> loadMoreDataTips() async {
    if (!canLoadMore(4)) return;
    
    isFetchingData.value = true;
    try {
      var response = await apiService.notifications(0, 0, 0, 0, 1, currentPageTips.value);
      var newData = response['data']['tips'];
      if (newData.isEmpty) {
        hasMoreDataTips.value = false;
      } else {
        tipsData.addAll(newData);
        currentPageTips.value++;
      }
    } catch (e) {
      print('Error fetching Tips notifications: $e');
    } finally {
      isFetchingData.value = false;
    }
  }

  // This method will be called when the user scrolls to the bottom
  void loadMoreData() {
    if (selected.value == 0) {
      loadMoreDataAll();
    } else if (selected.value == 1) {
      loadMoreDataMessages();
    } else if (selected.value == 2) {
      loadMoreDataLikes();
    } else if (selected.value == 3) {
      loadMoreDataSubscriptions();
    } else if (selected.value == 4) {
      loadMoreDataTips();
    }
  }
}
