import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/comment_controller.dart';
// Comment section builder
Widget buildCommentSection(int post_id) {
	//final CommentController commentController = Get.put(CommentController());
	final CommentController commentController = Get.find<CommentController>();

	// Fetch comments when the widget is built
	commentController.fetchComments(post_id);
	return Column(
		children: [
		  // Text field to add a new comment
		  Container(
			height: 66.0,
			color: AppColor.purple,
			child: Row(
			  children: [
				Material(
				  color: Colors.transparent,
				  child: IconButton(
					onPressed: () {
					  // Handle emoji toggle
					},
					icon: const Icon(Icons.emoji_emotions, color: Colors.white),
				  ),
				),
				Expanded(
				  child: Padding(
					padding: const EdgeInsets.symmetric(vertical: 8.0),
					child: autoWidthTextFieldForComment(
					  text: '',
					  text1: 'Type a message',
					  width: Get.size.width,
					  controller: TextEditingController(),
					 /* onSubmitted: (text) {
						if (text.isNotEmpty) {
						  commentController.addComment(text, post_id);
						}
					  },*/
					),
				  ),
				),
				Material(
				  color: Colors.transparent,
				  child: IconButton(
					onPressed: () {
					  // Handle send message
					  // Handle send message (add comment)
					  final textController = TextEditingController();
					  if (textController.text.isNotEmpty) {
						commentController.addComment(textController.text, post_id);
						textController.clear(); // Clear the input field
					  }
					},
					icon: const Icon(Icons.send, color: Colors.white),
				  ),
				),
			  ],
			),
		  ),
		  // List of existing comments
		  Obx(() {
				if (commentController.isLoading.value) {
				  return const Center(child: CircularProgressIndicator());
				}

				if (commentController.comments.isEmpty) {
				  return const Center(child: Text("No comments yet"));
				}
				return ListView.builder(
					shrinkWrap: true,
					physics: const NeverScrollableScrollPhysics(),
					itemCount: commentController.comments.length, // Example count
					itemBuilder: (context, index) {
						final comment = commentController.comments[index];
						return ListTile(
							leading: CircleAvatar(
							  radius: 15,
							  backgroundImage: AssetImage('assets/avatar.png'), // Example image
							),
							title: Text('@${comment.username}'),
							subtitle: Text(comment.message),
							trailing: Text(comment.created_at),
						);
					},
				);
			}),
		],
	  );
	}