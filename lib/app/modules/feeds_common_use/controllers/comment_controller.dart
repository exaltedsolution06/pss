import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';

class CommentController extends GetxController {
	final ApiService apiService;
	CommentController(this.apiService);  // Constructor accepting ApiService
	
	var comments = [].obs; // List of comments
	var isLoading = true.obs;
	
	//for home view emoji in comments
	var emojiShowing = false.obs;
	TextEditingController textEditingController = TextEditingController();
	//ScrollController scrollController = ScrollController();

	void toggleEmojiPicker() {
	  emojiShowing.value = !emojiShowing.value;
	}


	@override
	void dispose() {
		textEditingController.dispose();
		//scrollController.dispose();
		super.dispose();
	}

  

  // Fetch comments by post_id
	Future<void> fetchComments(int post_id) async {
		try {
			isLoading(true);
			// Simulate API call
			// Example: final fetchedComments = await apiService.feeds_fetch_comments(post_id);
			var response = await apiService.feeds_fetch_comments(post_id);
			print("response: $response");

			comments.assignAll(response['data']);
		} catch (e) {
		  // Handle error
		  //print("Error fetching comments: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		} finally {
		  isLoading(false);
		}
	}

  // Add new comment
	//void addComment(String content, int post_id) {
	Future<void> addComment(RxMap<String, dynamic> feedData, String message) async {
		//comments.add(Comment(id: comments.length + 1, content: content, timestamp: 'Just now'));
		// Optionally, call the API to save the comment
		// Example: await apiService.addComment(feedData['post_id'], content);

		try {
			// Simulate API call
			var response = await apiService.feeds_post_comments(feedData['post_id'], message);
			// Clear the text field
			textEditingController.clear();
			
			// Close the emoji picker after submitting the comment
			emojiShowing.value = false;
			
			print("response: $response");
			if (response['status'] == 200) {		
				var responseData = await apiService.feeds_fetch_comments(feedData['post_id']);
				//print("response: $responseData");
				comments.assignAll(responseData['data']);
				feedData['commentsCount']++;
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}

			//comments.assignAll(response['data']);
		} catch (e) {
			// Handle error
			//print("Error fetching comments: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}
  
	//void removeComment(int post_comment_id) {
	Future<void> removeComment({required int post_comment_id, required int post_id, required Map<String, dynamic> feedData,}) async {
		//comments.removeWhere((comment) => comment['id'] == commentId);
		// Optionally call the API to remove the comment
		// Example: await apiService.removeComment(commentId);
		try {
			// Simulate API call
			var response = await apiService.feeds_delete_comments(post_comment_id);
			print("response: $response");
			if (response['status'] == 200) {	
				var responseData = await apiService.feeds_fetch_comments(post_id);
				//print("response: $responseData");
				comments.assignAll(responseData['data']);
				feedData['commentsCount']--;
				SnackbarHelper.showSuccessSnackbar(
				  title: Appcontent.snackbarTitleSuccess, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			} else {
				SnackbarHelper.showErrorSnackbar(
				  title: Appcontent.snackbarTitleError, 
				  message: response['message'],
				  position: SnackPosition.BOTTOM, // Custom position
				);
			}

			//comments.assignAll(response['data']);
		} catch (e) {
			// Handle error
			//print("Error fetching comments: $e");
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
		}
	}
	//top tab
	var selectCommentIndex = <int>[].obs;
	//int previousLikeCount = 0;
	// Toggle like/unlike with one API call
	Future<void> toggleLikeComment({required int index, required int post_comment_id, required int post_id}) async {
		print("post_comment_id: $post_comment_id");
		print("index: $index");
		print("post_id: $post_id");
		
		try {
		  // Toggle the UI state
		  if (selectCommentIndex.contains(index)) {
			selectCommentIndex.remove(index);
		  } else {
			selectCommentIndex.add(index);
		  }
		  var response = await apiService.feeds_like_comments(post_comment_id);
		  
		  // Handle the API response here
		  if (response['status'] == 200) {			
			//print("post_comment_likes_count: ${comments[index]['post_comment_likes_ount']}");
			var responseData = await apiService.feeds_fetch_comments(post_id);
			print("response: $responseData");

			comments.assignAll(responseData['data']);
			
			SnackbarHelper.showSuccessSnackbar(
			  title: Appcontent.snackbarTitleSuccess, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		  } else {
			// In case of API failure, revert the UI change
			if (selectCommentIndex.contains(index)) {
			  selectCommentIndex.remove(index);
			} else {
			  selectCommentIndex.add(index);
			}			
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: response['message'],
			  position: SnackPosition.BOTTOM, // Custom position
			);
		  }
		} catch (e) {
			// Handle error and revert UI change if API fails
			print('Error toggling comment like/unlike: $e');
			SnackbarHelper.showErrorSnackbar(
			  title: Appcontent.snackbarTitleError, 
			  message: Appcontent.snackbarCatchErrorMsg, 
			  position: SnackPosition.BOTTOM, // Custom position
			);
			if (selectCommentIndex.contains(index)) {
				selectCommentIndex.remove(index);
			} else {
				selectCommentIndex.add(index);
			}
		}
		update(); // Update the UI
	}

}




