import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:picturesourcesomerset/app/modules/home/views/showimage_view.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/custom_modal.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/video_player_widget.dart';


import '../controllers/proflie_screen_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/comment_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/post_controller.dart';

// ignore: must_be_immutable
//class ProflieScreenView extends GetView<ProflieScreenController> {
class ProflieScreenView extends StatelessWidget {
	//ProflieScreenView({super.key});
	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	//final ProflieScreenController controller = Get.put(ProflieScreenController(Get.find<ApiService>()));
	final ProflieScreenController proflieScreenController = Get.find();
	ProflieScreenView() {
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				proflieScreenController.loadMoreFeedData(); // Load more data on vertical scroll
			}
		});
	}
	void _showCustomModal(BuildContext context, String title, Widget content) {
		showDialog(
		  context: context,
		  builder: (BuildContext context) {
			return CustomModal(
			  title: title,
			  content: content,
			  onClose: () {
				Navigator.of(context).pop();
			  },
			);
		  },
		);
	}

	final CommentController commentController = Get.find<CommentController>();
	final PostController postController = Get.find<PostController>();
  
	final actionTextStyle =
  TextStyle(fontSize: 14, color: AppColor.purple, fontFamily: 'Urbanist-medium', fontWeight: FontWeight.w500);
  
	@override
	Widget build(BuildContext context) {
		final double screenWidth = MediaQuery.of(context).size.width;
		final double screenHeight = MediaQuery.of(context).size.height;
		
  
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              centerTitle: true,
              title: const Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Urbanist-semibold',
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
              actions: [
                const SizedBox(width: 20),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: InkWell(
                      onTap: () {
						Get.toNamed(Routes.ACTIVITY_SCREEN);
                      },
					  child: const Icon(Icons.settings, color: Colors.black)),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            body: Obx(() {
				if (proflieScreenController.isFetchingData.value) {
					return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
				} else {
			
					final profileData = proflieScreenController.profileData.value;
					return SingleChildScrollView(
					  scrollDirection: Axis.vertical,
					  /*child: SizedBox(
						height: Get.size.height - 120,
						width: Get.size.width,*/
						child: Column(
						  children: [
							// Profile Banner, Pic and Name
							Container(
								height: 350,
								width: screenWidth,
								child: Stack(
									children: [
									  // Banner Image
									  Container(
										height: 173,
										width: screenWidth,
										decoration: BoxDecoration(
										  image: DecorationImage(
											//image: AssetImage('assets/Banner.png'),
											image: profileData.cover != null && profileData.cover.isNotEmpty
											  ? NetworkImage(profileData.cover) as ImageProvider
											  : AssetImage('assets/Banner.png'),
												fit: BoxFit.fill,
										  ),
										  borderRadius: BorderRadius.only(
											bottomLeft: Radius.circular(20),
											bottomRight: Radius.circular(20),
										  ),
										),
									  ),
									  // New Section Below Banner Image
									  Positioned(
										bottom: 10,
										left: 0,
										right: 0,
										child: InkWell(
										  onTap: () {
											Get.toNamed(Routes.FOLLOW_SCREEN);
										  },
										  child: Container(
											height: 77,
											width: screenWidth,
											//color: AppColor.BlackGreyscale[200],
											child: Padding(
											  padding: const EdgeInsets.symmetric(horizontal: 20),
											  child: Container(
												height: 77,
												width: double.infinity,
												decoration: BoxDecoration(
												  borderRadius: BorderRadius.circular(15),
												  color: Colors.white,
												  border: Border.all(
													width: 1,
													color: const Color(0xffE2E8F0),
												  ),
												),
												child: Row(
												  mainAxisAlignment: MainAxisAlignment.center,
												  crossAxisAlignment: CrossAxisAlignment.center,
												  children: [
													_buildStatColumn('${proflieScreenController.socialUserTotalPosts.value}', 'Posts'),
													_buildStatColumn('${proflieScreenController.socialUserTotalFollowers.value}', 'Followers'),
													_buildStatColumn('${proflieScreenController.socialUserTotalFollowing.value}', 'Following'),
												  ],
												),
											  ),
											),
										  ),
										),
									  ),
									  // Positioned Avatar and Details
									  Positioned(
										top: 150,
										left: 20,
										right: 0,
										child: Row(
										  children: [
											Stack(
											  children: [
												Container(
												  height: 100,
												  width: 100,
												  decoration: BoxDecoration(
													color: Colors.indigo.shade300,
													border: Border.all(color: Colors.white, width: 5),
													shape: BoxShape.circle,
													image: DecorationImage(
													  image: profileData.avatar != null && profileData.avatar.isNotEmpty
														  ? NetworkImage(profileData.avatar) as ImageProvider
														  : AssetImage('assets/avatar.png'),
													  //fit: BoxFit.cover, // Optional: to ensure the image covers the entire circle
													),
												  ),
												),
												Positioned(
												  right: 0,
												  bottom: 0,
												  child: Container(
													height: 32,
													width: 32,
													decoration: BoxDecoration(
													  borderRadius: BorderRadius.circular(30),
													  border: Border.all(color: Colors.white, width: 3),
													   color: 	profileData.user_verify == 1 ? Colors.green : 
																Colors.red, // Set icon color based on condition
													),
													child: Icon(
														profileData.user_verify == 1 ? Icons.check : 
														Icons.gpp_bad, // Default icon if user_verify is not 1
														color: Colors.white,
													  size: 20, // Adjust the size of the icon
													),
												  ),
												),
											  ],
											),
											const SizedBox(width: 1),
											Expanded(
											  child: Padding(
												padding: const EdgeInsets.only(top: 16.0),
												child: ListTile(
												  title: Text(
													'${profileData.name}',
													overflow: TextOverflow.ellipsis,
													style: TextStyle(
													  fontSize: 18,
													  fontFamily: 'Urbanist-semibold',
													),
												  ),
												  subtitle: Text(
													'@${profileData.username}',
													overflow: TextOverflow.ellipsis,
													style: TextStyle(
													  fontSize: 12,
													  fontFamily: 'Urbanist-regular',
													),
												  ),
												),
											  ),
											),
										  ],
										),
									  ),
									],
								),
							),
							// Edit Profile and floating button
							Padding(
							  padding: const EdgeInsets.only(top: 30),
							  child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
								  elevated1(
									text: 'Edit Profile',
									onPress: () {
										Get.delete<ProflieScreenController>(); // Deletes the controller
										Get.toNamed(Routes.EDITPROFILE_SCREEN);
									},
								  ),
								],
							  ),
							),
						   const SizedBox(height: 10),
							Text(
								'Feeds',
								style: TextStyle(
									fontSize: 16,
									color: Colors.black,
									fontFamily: 'Urbanist-regular'
								),
								overflow: TextOverflow.ellipsis,
							),
							const SizedBox(height: 10),

									// Post
							SizedBox(
								height: Get.size.height - 220,
								width: Get.width,
								child: MediaQuery.removePadding(
									context: context,
									removeTop: true,
									child: Obx(() {
									  if (proflieScreenController.isFetchingFeedData.value && proflieScreenController.feedData.isEmpty) {
										return Center(
										  child: CircularProgressIndicator(
											valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
										  ),
										);
									  } else if (proflieScreenController.feedData.isNotEmpty) {
										return buildSearchList(proflieScreenController.feedData); // Ensure this function returns a Widget
									  } else {
										return Center(child: Text('No Posts Yet')); // Handle empty state
									  }
									}),
								),
							)
					  
					  
							  
						   //const SizedBox(height: 100),


						  ],
					   // ),
					  ),
					);	
				}			
			}),
          );
        },
      ),
    );
  }
  Widget buildSearchList(RxList data) {
	  return Padding(
		padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
		child: Obx(() {
		  // Check if data is still being fetched
		  if (proflieScreenController.isFetchingFeedData.value && data.isEmpty) {
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

		  //return Obx(() {
			return ListView.separated(
				controller: _verticalScrollController,
				itemCount: data.length + 1,  // Add 1 to display loading indicator at the end
				separatorBuilder: (context, index) => const SizedBox(height: 10),
				itemBuilder: (context, index) {
				  if (index == data.length) {
					// Show loading indicator at the end of the list if more data is being fetched
					return proflieScreenController.isFetchingFeedData.value
						? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),))
						: const SizedBox.shrink();
				  }

				  // Cast each item in the list to an observable map
				  final RxMap<String, dynamic> feedData = RxMap<String, dynamic>.from(data[index]);

				  return buildSearchItem(feedData, index, context);
				},
			);
			//});
		}),
	  );
	}
	// Method to build a single search item
	Widget buildSearchItem(RxMap<String, dynamic> feedData, int index, BuildContext context) {
		final double screenWidth = MediaQuery.of(context).size.width;
		return Container(
		margin: const EdgeInsets.symmetric(vertical: 8.0),
		child: Column(
		  crossAxisAlignment: CrossAxisAlignment.start,
		  children: [
			// ListTile layout for search item
			ListTile(
			  contentPadding: EdgeInsets.zero,
			  leading: CircleAvatar(
				radius: 28, // 56px height/width
				backgroundImage: NetworkImage(feedData['avatar']),
			  ),
			  title: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Expanded(
						child: Text(
						  feedData['name'],
						  style: const TextStyle(
							fontSize: 16,
							fontFamily: 'Urbanist-medium',
							fontWeight: FontWeight.w500,
							overflow: TextOverflow.ellipsis,
						  ),
						),
					),
					const SizedBox(width: 10),
					feedData['content_type'] == 'locked' 
						? Container(
							padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
							decoration: BoxDecoration(
							  color: AppColor.purple, // Background color
							  borderRadius: BorderRadius.circular(15), // Rounded corners
							),
							child: Text(
							  'PPV',
							  style: TextStyle(
								color: Colors.white, // Text color
								fontFamily: 'Urbanist-semibold',
								fontWeight: FontWeight.w500,
								fontSize: 12, // Font size
							  ),
							),
						  )
						: SizedBox.shrink(), // Empty widget when condition is false
					const SizedBox(width: 10),

					Text(
						feedData['created_at'],
						style: const TextStyle(
							fontSize: 12,
							color: Color(0xff64748B),
							fontWeight: FontWeight.w400,
							fontFamily: 'Urbanist-regular',
						),
					),
					PopupMenuButton<String>(
						onSelected: (String result) {
							if (result == 'Edit') {
								// Handle Edit action
								print('Edit clicked');
								Navigator.pushNamed(
									context,
									Routes.EDITPOST_SCREEN,
									arguments: {'postId': feedData['post_id'].toString()}, // Convert postId to String before passing
								);
							} else if (result == 'Delete') {
								// Handle Delete action
								print('Delete clicked');
								_confirmDeletePost(context, feedData['post_id']); // Show confirmation before deletion
							}
						},
						itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
							const PopupMenuItem<String>(
							  value: 'Edit',
							  child: Text('Edit post'),
							),
							const PopupMenuItem<String>(
							  value: 'Delete',
							  child: Text('Delete post'),
							),
						],
						icon: Icon(Icons.more_vert),
					),
					
					
					
				],
			  ),
			  subtitle: Text(
				'@${feedData['username']}',
				style: const TextStyle(
				  fontSize: 12,
				  color: Color(0xff64748B),
				  fontWeight: FontWeight.w400,
				  overflow: TextOverflow.ellipsis,
				),
			  ),
			),
			
			const SizedBox(height: 5),
			// Bio section or any additional info
			RichReadMoreText.fromString(
				text: feedData['post_text'],
				textStyle: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Urbanist-medium', fontWeight: FontWeight.w400),
				settings: LengthModeSettings(
					trimLength: 70,
					trimCollapsedText: '...Show more',
					trimExpandedText: ' Show less',
					lessStyle: actionTextStyle,
					moreStyle: actionTextStyle,
					onPressReadMore: () {
					/// specific method to be called on press to show more
					},
					onPressReadLess: () {
					/// specific method to be called on press to show less
					},
				),
			),
			if (feedData['attachments'].isNotEmpty)
			  Padding(
				padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
				child: Center(
				  child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
					  feedData['attachments'].length > 0
					  ? SizedBox(
						  height: 150,
						  width: double.infinity,
						  child: PageView.builder(
							itemCount: feedData['attachments'].length,
							itemBuilder: (context, index) {
							  var attachment = feedData['attachments'][index];
							  String contentType = attachment['content_type'];
							  print('Attachment type at index $index: $contentType');

							  return GestureDetector(
								onTap: () {
								  if (contentType == 'image') {
									print('Navigating to full screen with image URL: ${attachment['file']}');
									Navigator.push(
									  context,
									  MaterialPageRoute(
										builder: (context) => FullScreenImage(
										  imageUrl: attachment['file'],
										  tag: "generate_a_unique_tag_$index",
										),
									  ),
									);
								  }
								},
								child: ClipRRect(
								  borderRadius: BorderRadius.circular(10),
								  child: Builder(
									builder: (BuildContext context) {
									  switch (contentType) {
										case 'image':
										  return Image.network(
											attachment['file'],
											fit: BoxFit.cover,
											errorBuilder: (context, error, stackTrace) {
											  print('Error loading image: $error');
											  return Icon(Icons.error);
											},
											loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
											  if (loadingProgress == null) {
												return child;
											  }
											  return Center(
												child: CircularProgressIndicator(
												  valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
												  value: loadingProgress.expectedTotalBytes != null
													  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
													  : null,
												),
											  );
											},
										  );
										/*case 'locked':
										  return Container(
											color: AppColor.Greyscale,
											child: Column(
											  mainAxisAlignment: MainAxisAlignment.center,
											  children: [
												Stack(
												  children: [
													Center(
													  child: Icon(
														Icons.lock,
														size: 50.0,
														color: Colors.white,
													  ),
													),
												  ],
												),
											  ],
											),
										  );*/
										case 'video':
										  return VideoPlayerWidget(videoUrl: attachment['file'],);
										default:
										  print('Unsupported content type: $contentType');
										  return Text('Unsupported content');
									  }
									},
								  ),
								),
							  );
							},
						  ),
						)
					  : GestureDetector(
						  onTap: () {
							var attachment = feedData['attachments'][0]; // Single attachment case
							String contentType = attachment['content_type'];
							if (contentType == 'image') {
							  print('Navigating to full screen with image URL: ${attachment['file']}');
							  Navigator.push(
								context,
								MaterialPageRoute(
								  builder: (context) => FullScreenImage(
									imageUrl: attachment['file'],
									tag: "generate_a_unique_tag_single",
								  ),
								),
							  );
							}
						  },
						  child: SizedBox(
							height: 150,
							width: double.infinity,
							child: ClipRRect(
							  borderRadius: BorderRadius.circular(10),
							  child: Image.network(
								feedData['attachments'][0]['file'],
								fit: BoxFit.cover,
								errorBuilder: (context, error, stackTrace) {
								  print('Error loading single image: $error');
								  return Icon(Icons.error);
								},
							  ),
							),
						  ),
						),
					],
				  ),
				),
			  ), 
			const SizedBox(height: 10),       
			// Social actions row (Likes, Comments, Tips)
			Padding(
			  padding: const EdgeInsets.only(right: 20, top: 5),
			  child: Row(
				children: [
				  Icon(Icons.favorite, color: AppColor.purple, size: 15.0),
				  const SizedBox(width: 5),
				  Obx(
					  () => Text(
						'${feedData['likesCount']} ${feedData['likesCount'] > 1 ? 'likes' : 'like'}',
						style: const TextStyle(
						  fontSize: 12,
						  color: AppColor.BlackGreyscale,
						  fontFamily: 'Urbanist-regular',
						),
					  ),
					),
				  const SizedBox(width: 10),              
				  Icon(Icons.chat, color: AppColor.BlackGreyscale, size: 15.0),
				  const SizedBox(width: 5),
				  Obx(
					  () => Text(
						'${feedData['commentsCount']} ${feedData['commentsCount'] > 1 ? 'comments' : 'comment'}',
						style: const TextStyle(
						  fontSize: 12,
						  color: AppColor.BlackGreyscale,
						  fontFamily: 'Urbanist-regular',
						),
					  ),
					),
				  const SizedBox(width: 10),              
				  Icon(Icons.payments, color: AppColor.BlackGreyscale, size: 15.0),
				  const SizedBox(width: 5),
				  Obx(
					  () => Text(
						'${feedData['tipsCount']} ${feedData['tipsCount'] > 1 ? 'tips' : 'tip'}',
						style: const TextStyle(
						  fontSize: 12,
						  color: AppColor.BlackGreyscale,
						  fontFamily: 'Urbanist-regular',
						),
					  ),
					),
				],
			  ),
			),
			const SizedBox(height: 10),        
			// Action buttons (Like, Comment, Tip)
			Row(
			  children: [
				// Like button
				GestureDetector(
				  onTap: () {
					// Like/unlike post when tapped
					postController.toggleLikePost(index: index, post_id: feedData['post_id'], feedData: feedData);
				  },
				  child: Obx(() {  // Observe changes in feedData
					return Container(
					  height: 36,
					  width: 36,
					  decoration: BoxDecoration(
						border: Border.all(
						  color: postController.selectPostIndex.contains(index) || feedData['own_like']
							  ? Colors.grey.shade200 
							  : Colors.red,  // Change border color based on like status
						),
						borderRadius: BorderRadius.circular(100),
					  ),
					  child: Icon(
						postController.selectPostIndex.contains(index) || feedData['own_like']
							? Icons.favorite
							: Icons.favorite_border,
						color: postController.selectPostIndex.contains(index) || feedData['own_like']
							? AppColor.purple
							: AppColor.BlackGreyscale,  // Change icon color based on like status
					  ),
					);
				  }),
				),					
				const SizedBox(width: 10),
				// Comment button
				GestureDetector(
				  onTap: () {
					_showCommentsBottomSheet(context, index, feedData['post_id'], feedData);
				  },
				  child: Container(
					height: 36,
					width: 36,
					decoration: BoxDecoration(
					  border: Border.all(color: AppColor.purple),
					  borderRadius: BorderRadius.circular(100),
					),
					child: Icon(Icons.chat, color: AppColor.BlackGreyscale),
				  ),
				),
			  ],
			),
		  ],
		),
	  );
	}
	
	//confirmation delete of post
	void _confirmDeletePost(BuildContext context, int postId) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
			  return AlertDialog(
				title: Text("Delete Post"),
				content: Text("Are you sure you want to delete this post?"),
				actions: [
				  TextButton(
					onPressed: () {
					  Navigator.of(context).pop(); // Dismiss the dialog
					},
					child: Text("Cancel",
						style: const TextStyle(
							color: AppColor.purple,
						),
					),
				  ),
				  TextButton(
					onPressed: () {
					  Navigator.of(context).pop(); // Dismiss the dialog
					  proflieScreenController.deletePost(postId); // Call delete function
					},
					child: Text("Delete",
						style: const TextStyle(
							color: AppColor.purple,
						),
					),
				  ),
				],
			  );
			},
		);
	}

	// Function to show comments bottom sheet
	void _showCommentsBottomSheet(BuildContext context, int index, int post_id, RxMap<String, dynamic> feedData) {
	  showModalBottomSheet(
		context: context,
		shape: const RoundedRectangleBorder(
		  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
		),
		builder: (context) {
		  return SingleChildScrollView(
			child: Column(
			  children: [
				ListTile(
				  title: const Text(
					'Comments',
					style: TextStyle(fontSize: 15, fontFamily: 'Urbanist-semibold'),
					textAlign: TextAlign.center,
				  ),
				  trailing: InkWell(
					onTap: () => Navigator.pop(context),
					child: const Icon(Icons.close, color: Colors.black),
				  ),
				),
				_buildCommentSection(post_id, feedData),
			  ],
			),
		  );
		},
	  );
	}
	// Comment section builder
Widget _buildCommentSection(int post_id, RxMap<String, dynamic> feedData) {

	final TextEditingController textEditingController = TextEditingController();
	
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
					  commentController.toggleEmojiPicker();
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
					  controller: textEditingController,
					),
				  ),
				),
				Material(
					color: Colors.transparent,
					child: IconButton(
					onPressed: () {
						// Handle send message
						// Handle send message (add comment)
						print("post_id: $post_id");
						print("message: ${textEditingController.text.trim()}");
							if (textEditingController.text.isNotEmpty) {
								commentController.addComment(feedData, textEditingController.text);
								textEditingController.clear(); // Clear the input field
							}
						},
						icon: const Icon(Icons.send, color: Colors.white),
					),
				),
			  ],
			),
		  ),
		  Obx(() => Offstage(
			  offstage: !commentController.emojiShowing.value,
			  child: EmojiPicker(
				onEmojiSelected: (category, emoji) {
				  // Append the selected emoji to the TextField controller's current text
				  textEditingController.text = emoji.emoji;
				  textEditingController.selection = TextSelection.fromPosition(
					TextPosition(offset: textEditingController.text.length),
				  );
				},
				textEditingController: textEditingController, // Keep this if required
				config: Config(
				  height: 256,
				  checkPlatformCompatibility: true,
				  emojiViewConfig: EmojiViewConfig(
					emojiSizeMax: 28 *
						(defaultTargetPlatform == TargetPlatform.iOS
							? 1.2
							: 1.0),
				  ),
				  //swapCategoryAndBottomBar: false,
				  skinToneConfig: SkinToneConfig(),
				  categoryViewConfig: CategoryViewConfig(),
				  bottomActionBarConfig: BottomActionBarConfig(
					backgroundColor: AppColor.purple, // Bottom bar color
				  ),
				  searchViewConfig: SearchViewConfig(),
				),
			  ),
			)),
		  // List of existing comments
		  Obx(() {
				if (commentController.isLoading.value) {
				  return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple)));
				}

				if (commentController.comments.isEmpty) {
				  return const Center(child: Text("No comments yet"));
				}
				return ListView.builder(
				  shrinkWrap: true,
				  physics: const NeverScrollableScrollPhysics(),
				  itemCount: commentController.comments.length, // Number of comments
				  itemBuilder: (context, index) {
					final comment = commentController.comments[index];
					// Null check for any potentially null fields
					final postCommentLikesCount = comment['post_comment_likes_count'] ?? 0;
					return Padding(
					  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add left & right padding
					  child: Row(
						crossAxisAlignment: CrossAxisAlignment.start, // Align content to the top
						children: [
						  // The avatar, aligned to the top
						  CircleAvatar(
							radius: 15,
							backgroundImage: NetworkImage(comment['avatar']), // Avatar image
						  ),
						  const SizedBox(width: 10), // Space between avatar and text

						  // Expanded widget for username, message, and remove icon
						  Expanded(
							child: Column(
							  crossAxisAlignment: CrossAxisAlignment.start,
							  children: [
								Row(
								  children: [
									// Username (Left side)
									Expanded(
									  child: Text(
										'@${comment['username']}',
										style: TextStyle(
										  fontWeight: FontWeight.bold,
										),
									  ),
									),
									GestureDetector(
									  onTap: () {
										if (comment['own_comment']) {
										  // Remove comment if it's the user's own comment
										  commentController.removeComment(post_comment_id: comment['id'], post_id: comment['post_id'], feedData: feedData);
										} else {
										  // Like comment if it's not the user's own comment
										  commentController.toggleLikeComment(index: index, post_comment_id: comment['id'], post_id: comment['post_id']);
										}
									  },
									  child: comment['own_comment'] 
										? Container(
											height: 30,
											width: 30,
											decoration: BoxDecoration(
											  border: Border.all(color: Colors.red),
											  borderRadius: BorderRadius.circular(100),
											),
											child: Icon(
												Icons.delete,
												color: AppColor.BlackGreyscale, // Customize icon color for remove
												size: 20,
											),
										  )									  
										: Container(
											height: 30,
											width: 30,
											decoration: BoxDecoration(
											  border: Border.all(
												color: commentController.selectCommentIndex.contains(index) || comment['own_like']
													? Colors.grey.shade200 
													: Colors.red, // Customize border color for like
											  ),
											  borderRadius: BorderRadius.circular(100),
											),
											child: Icon(
												commentController.selectCommentIndex.contains(index) || comment['own_like']
												  ? Icons.favorite 
												  : Icons.favorite_border,
												color: commentController.selectCommentIndex.contains(index) || comment['own_like']
												  ? AppColor.purple 
												  : AppColor.BlackGreyscale, // Customize icon color for like
												size: 20,
											),
										),
									),
								  ],
								),
								// Message content
								Text(comment['message']),
								// Timestamp
								Row(
									children: [						
										Text(
											comment['created_at'],
											style: TextStyle(color: Colors.grey, fontSize: 12),
										),
										const SizedBox(width: 10),				
										Text(
											'$postCommentLikesCount ${postCommentLikesCount > 1 ? 'likes' : 'like'}',
											style: TextStyle(color: Colors.grey, fontSize: 12),
										),
									],
								),
							  ],
							),
						  ),
						],
					  ),
					);
				  },
				);
			}),
		],
	  );
	}

}
  Widget _buildStatColumn(String number, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Urbanist-semibold',
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff64748B),
              fontFamily: 'Urbanist-medium',
            ),
          ),
        ],
      ),
    );
  }

Widget _benefitRow(IconData icon, String text) {
  return Row(
    children: [
      Icon(
        icon,
        size: 20.0,
        color: Colors.green,
      ),
      const SizedBox(width: 8.0),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Urbanist-semibold',
          ),
        ),
      ),
    ],
  );
}