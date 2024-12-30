import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';

import 'package:rich_readmore/rich_readmore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:picturesourcesomerset/app/modules/home/views/showimage_view.dart';
import 'package:picturesourcesomerset/app/modules/view_proflie_screen/views/view_proflie_screen_view.dart';
//import 'package:picturesourcesomerset/app/modules/message_screen/Message_screen.dart';
import 'package:picturesourcesomerset/app/modules/newpost_screen/views/newpost_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/notification_screen/views/notification_screen_view.dart';
import '../../message_screen/views/message_screen_view.dart';
//import 'package:picturesourcesomerset/app/modules/zegocloud/zim_chat_list_screen.dart';
import 'package:story_view/story_view.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/custom_modal.dart';
import 'package:picturesourcesomerset/config/custom_expandable.dart';
import 'package:picturesourcesomerset/config/video_player_widget.dart';

import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/app/modules/notification_screen/controllers/notification_screen_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/comment_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/post_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
	//HomeView({super.key});
	final HomeController homeController = Get.find<HomeController>();
	final CommentController commentController = Get.find<CommentController>();
	final PostController postController = Get.find<PostController>();
	//final CommentController commentController = Get.put(CommentController(Get.find<ApiService>()));
	final apiService = ApiService();
	//final CommentController commentController = Get.find<CommentController>(); // Ensure ApiService is already initialized
	//final PostController postController = Get.find<PostController>(); // Ensure ApiService is already initialized
	
	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	final ScrollController _horizontalScrollController = ScrollController();
	
	@override
	void onInit() {
		//super.onInit();
		homeController.loadInitialDataForCourseUser();  // Load data for user
		homeController.loadInitialDataForFeed();  // Load data for user
	}
		
	HomeView() {
		// Vertical Scroll Listener
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				homeController.loadMoreFeedData();  // Load more data on vertical scroll
			}
		});

		// Horizontal Scroll Listener
		_horizontalScrollController.addListener(() {
			if (_horizontalScrollController.position.pixels == _horizontalScrollController.position.maxScrollExtent) {
				homeController.loadMoreCourseUserData();  // Load more data on horizontal scroll
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
  final actionTextStyle =
  TextStyle(fontSize: 14, color: AppColor.purple, fontFamily: 'Urbanist-medium', fontWeight: FontWeight.w500);
  
  @override
  Widget build(BuildContext context) {
	final NotificationScreenController notificationScreenController = Get.put(NotificationScreenController(apiService));
	final double screenWidth = MediaQuery.of(context).size.width;
	
    return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Story and Message
              Stack(
                clipBehavior: Clip.none,
				
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 44, child: Image(image: AssetImage(Appcontent.maillonglogo))),
                        const SizedBox(width: 5,),
                        const Expanded(child: SizedBox(width: 160,),
                        ),
                        SizedBox(
                          height: 32,
                          child: Row(
                            children: [
                              
                              InkWell(
								onTap: () => Get.toNamed(Routes.NEWPOST_SCREEN),
                                  child: SizedBox(
                                    height: 38,
                                      //child: Image.asset(Appcontent.addpostst)
                                      child: Icon(Icons.add_box, size: 35, color: AppColor.black,),
								)),
                              const SizedBox(width: 10),
                              GestureDetector(
                                //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreenView(),)),
								
								onTap: () => Navigator.push(
								  context,
								  MaterialPageRoute(
									builder: (context) {
									  notificationScreenController.loadInitialDataForTab(0); // Call the function here
									  return NotificationScreenView();
									},
								  ),
								),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                        height: 38,
                                        //child: Image.asset(Appcontent.notification),
										child: Icon(Icons.notifications, size: 35, color: AppColor.black,),
									),
                                    Positioned(
                                      left: 10,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: AppColor.purple,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: const Center(
                                          child: Text('99+', style: TextStyle(fontSize: 10, fontFamily: 'Urbanist-medium', fontWeight: FontWeight.w500, color: Colors.white),),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
								GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreenView(),)),
                               // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ZIMKitChatsListsPage(),)),
								
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 38,
                                        //child: Image.asset(Appcontent.messager),
                                        child: Icon(Icons.sms, size: 35, color: AppColor.black,),
									),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: AppColor.purple,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: const Center(
                                          child: Text('99+', style: TextStyle(fontSize: 10, fontFamily: 'Urbanist-medium', fontWeight: FontWeight.w500, color: Colors.white),),
                                        ),
                                      ),
                                    ),
                                  ],
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10,),
                      ],
                    ),
                  ),
				  SizedBox(
					  height: 132,
					  child: Center(
						child: Container(
							width: double.infinity,
							height: 2,
						  decoration: BoxDecoration(
							borderRadius: BorderRadius.circular(8), // Rounded corners
							gradient: LinearGradient(
							  colors: [AppColor.white, AppColor.purple], // Gradient color
							  begin: Alignment.centerLeft,
							  end: Alignment.centerRight,
							),
							boxShadow: [
							  BoxShadow(
								color: Colors.black.withOpacity(0.1), // Shadow color and opacity
								spreadRadius: 2, // Spread of the shadow
								blurRadius: 4, // Blur radius of the shadow
								offset: Offset(0, 2), // Offset of the shadow
							  ),
							],
						  ),
						  padding: const EdgeInsets.symmetric(horizontal: 16),
						  child: Divider(
							color: Colors.transparent, // Divider color is transparent to show gradient
							thickness: 2, // Adjust thickness of the divider
							indent: 0, // No padding on the left
							endIndent: 0, // No padding on the right
						  ),
						),
					  ),
					),


                  Positioned(
                    bottom: -40,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 90,
                      width: Get.size.width,
                      alignment: Alignment.center,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Get.toNamed(Routes.NEWPOST_SCREEN),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
										height: 60,
										width: 60,
										margin: const EdgeInsets.symmetric(horizontal: 10),
										decoration: BoxDecoration(
											color: AppColor.purple, // Replace with your desired background color
											borderRadius: BorderRadius.circular(100),
											border: Border.all(color: AppColor.black, width: 1), // Replace with your desired border color
										),
										child: Padding(
											padding: const EdgeInsets.all(8.0), // Add padding to ensure border does not touch the icon
											child: Icon(
												Icons.post_add, // Replace with your desired icon
												color: AppColor.white, // Replace with your desired icon color
												size: 40
											),
										),
									),
                                    Positioned(
                                      left: 50,
                                      bottom: 0,
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: AppColor.black,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: const Icon(Icons.add, color: AppColor.white, size: 15),
                                        ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                const Text('Add Story', style: TextStyle(fontSize: 10, fontFamily: 'Urbanist-regular', fontWeight: FontWeight.w400,),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
				  //course user lists
                  Positioned(
					  bottom: -40,
					  left: 80,
					  right: 0,
					  child: Container(
						height: 90,
						width: Get.size.width,
						alignment: Alignment.center,
						child: Obx(() {
						  // Wrap ListView.builder in Obx to reactively rebuild on data changes
						  return ListView.builder(
							controller: _horizontalScrollController, // Attach the controller to ListView
							scrollDirection: Axis.horizontal,
							itemCount: homeController.feedCourseUserData.length + 1, // Adjust the length if needed
							itemBuilder: (context, index) {
							  // Final dynamic data for each user in the list
							  if (index == homeController.feedCourseUserData.length) {
								 // Show centered progress bar when data is being fetched
								return homeController.isFetchingCourseUserData.value
									? Container(
										width: Get.size.width, // Full width container for centering
										alignment: Alignment.center, // Center the loader
										child: Container(
										  width: 60, // Set desired width for progress bar
										  child: LinearProgressIndicator(
											backgroundColor: Colors.grey[300], // Background color
											valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple), // Progress bar color
										  ),
										),
									  )
									: SizedBox.shrink(); // Empty widget if not loading
							  } else {
								// Display each user with avatar and name
								final courseUserData = homeController.feedCourseUserData[index];
								return GestureDetector(
									onTap: () {
									  int userId = courseUserData['id']; // Assuming courseUserData is a map
									  Navigator.pushNamed(
										context,
										Routes.VIEW_PROFLIE_SCREEN,
										arguments: {'userId': userId.toString()}, // Convert userId to String before passing
									  );
									},
								  child: Container(
									margin: const EdgeInsets.symmetric(horizontal: 10),
									child: Column(
									  children: [
										Container(
										  height: 60,
										  width: 60,
										  decoration: BoxDecoration(
											color: Colors.white, // Replace with your desired background color
											borderRadius: BorderRadius.circular(100),
											border: Border.all(color: Colors.black, width: 1), // Replace with your desired border color
										  ),
										  child: Padding(
											padding: const EdgeInsets.all(8.0),
											child: ClipRRect(
											  borderRadius: BorderRadius.circular(92),
											  child: Image.network(
												courseUserData['avatar'], // Use dynamic avatar
												fit: BoxFit.fill,
												width: double.infinity,
												height: double.infinity,
											  ),
											),
										  ),
										),
										const SizedBox(height: 10),
										Text(
										  courseUserData['name'], // Use dynamic name
										  style: TextStyle(
											fontSize: 10,
											fontFamily: 'Urbanist-regular',
											fontWeight: FontWeight.w400,
										  ),
										),
									  ],
									),
								  ),
								);
							  }
							},
						  );
						}),
					  ),
					),

                ],
              ),
              const SizedBox(height: 40,),

              // Post
				SizedBox(
				  height: Get.size.height - 220,
				  width: Get.width,
				  child: MediaQuery.removePadding(
					context: context,
					removeTop: true,
					child: Obx(() {
					  if (homeController.isFetchingFeedData.value && homeController.feedData.isEmpty) {
						return Center(
						  child: CircularProgressIndicator(
							valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
						  ),
						);
					  } else if (homeController.feedData.isNotEmpty) {
						return buildSearchList(homeController.feedData); // Ensure this function returns a Widget
					  } else {
						return Center(child: Text('No Posts Yet')); // Handle empty state
					  }
					}),
				  ),
				)
             
            ],
          ),
        );
  }
  
  Widget buildSearchList(RxList data) {
	  return Padding(
		padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
		child: Obx(() {
		  // Check if data is still being fetched
		  if (homeController.isFetchingFeedData.value && data.isEmpty) {
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
			controller: _verticalScrollController,
			itemCount: data.length + 1,  // Add 1 to display loading indicator at the end
			separatorBuilder: (context, index) => const SizedBox(height: 10),
			itemBuilder: (context, index) {
			  if (index == data.length) {
				// Show loading indicator at the end of the list if more data is being fetched
				return homeController.isFetchingFeedData.value
					? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),))
					: const SizedBox.shrink();
			  }

			  // Cast each item in the list to an observable map
			  final RxMap<String, dynamic> feedData = RxMap<String, dynamic>.from(data[index]);

			  return buildSearchItem(feedData, index, context);
			},
		  );
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
				  Text(
					feedData['created_at'],
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
				feedData['username'],
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
										case 'locked':
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
												SizedBox(height: 20.0),
												Padding(
												  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
												  child: autoWidthBtn(
													text: 'UNLOCK POST FOR \$${attachment?['price'] ?? '0'}',
													width: screenWidth,
													onPress: () {
													  print("Unlock button pressed for \$${attachment['price']}");
													  _showCustomModal(context, 'Title', _buildModalSubscribeContent(screenWidth));
													},
												  ),
												),
											  ],
											),
										  );
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
							} else if (contentType == 'locked') {										
							} else if (contentType == 'video') {
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
				const SizedBox(width: 10),            
				// Tip button
				GestureDetector(
				  onTap: () => _showTipModal(context, index, feedData),
				  child: Container(
					  height: 36,
					  width: 120, // Adjust width to fit both icon and text
					  decoration: BoxDecoration(
						border: Border.all(
						  color:  AppColor.purple
						),
						borderRadius: BorderRadius.circular(100),
					  ),
					  child: Row(
						mainAxisAlignment: MainAxisAlignment.center, // Center items horizontally
						children: [
						  Icon(
							Icons.attach_money,
							color: AppColor.BlackGreyscale,
						  ),
						  SizedBox(width: 4), // Add some space between icon and text
						  Text(
							'Send a tip',
							style: TextStyle(
							  fontSize: 14,
							  color: AppColor.BlackGreyscale,
							  fontFamily: 'Urbanist-semibold',
							),
						  ),
						],
					  ),
					),
				),
			  ],
			),
		  ],
		),
	  );
	}
	Widget _buildModalSubscribeContent(screenWidth) {
		return SingleChildScrollView(
			scrollDirection: Axis.vertical,
			child: SizedBox(
				width: Get.size.width,
				child: Column(
					children: [
						// First Section
						Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Padding(
									padding: EdgeInsets.all(10.0),
									child: Text(
										'BILLING DETAILS',
										style: TextStyle(
											fontSize: 16,
											color: AppColor.BlackGreyscale, // Adjust as per AppColor
											fontFamily: 'Urbanist-semibold',
										),
									),
								),
								Padding(
									padding: EdgeInsets.only(left: 10.0, top: 0, right: 10.0, bottom: 16.0),
									child: Text(
										'We are fully compliant with Payment Card Industry Data Security Standards.',
										style: TextStyle(
											fontSize: 14,
											color: AppColor.black, // Adjust as per AppColor
											fontFamily: 'Urbanist-semibold',
										),
									),
								),
							],
						),	
						const SizedBox(height: 10),
						// Second Section
						Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Padding(
									padding: EdgeInsets.only(left: 10.0, top: 0, right: 10.0, bottom: 0),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
											Obx(() => dropdownField(
												text1: 'Country', 
												width: screenWidth,
												value: homeController.selectedCountry.value,
												items: ['USA', 'Canada', 'Mexico'],
												onChanged: (value) => homeController.updateCountry(value!),
											)),
											Obx(() => dropdownField(
												text1: 'State / Province', 
												width: screenWidth,
												value: homeController.selectedState.value,
												items: ['California', 'Texas', 'Florida'],
												onChanged: (value) => homeController.updateState(value!),
											)),
											autoWidthTextField(text: 'Enter your Address', width: screenWidth),
											autoWidthTextField(text: 'Enter your City', width: screenWidth),
											autoWidthTextField(text: 'Enter your Zip', width: screenWidth),
										]
									),
								),	
							],
						),					  
						// 3rd Section
						Column(
							children: [
								Padding(
									padding: EdgeInsets.all(10.0),
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												'CARD DETAILS',
												style: TextStyle(
													fontSize: 16,
													color: AppColor.BlackGreyscale, // Adjust as per AppColor
													fontFamily: 'Urbanist-semibold',
												),
											),
										],
									),
								),
							],
						),				  
						const SizedBox(height: 10),
						// 4th Section
						Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Padding(
									padding: EdgeInsets.only(left: 10.0, top: 0, right: 10.0, bottom: 0),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
											autoWidthTextField(text: 'Enter your Email Address', width: screenWidth),
											autoWidthTextField(text: 'Enter your Name on the Card', width: screenWidth),
											autoWidthTextField(text: 'Enter your Card Number', width: screenWidth),
											autoWidthTextField(text: 'Enter your Card Expiry', width: screenWidth),
											const SizedBox(width: 10),
											autoWidthTextField(text: 'Enter your Card CVC', width: screenWidth),
												
										]
									),
								),
								
							],
						),
						const SizedBox(height: 10),
						// 5th Section
						Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Padding(
									padding: EdgeInsets.all(10.0),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
											Row(
												mainAxisAlignment: MainAxisAlignment.center,
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
												  Obx(() => Column(
													mainAxisSize: MainAxisSize.min,
													children: [
													  Checkbox(
														value: homeController.isChecked.value,
														onChanged: (bool? value) {
														  homeController.toggleCheckbox(value!);
														},
													  ),
													],
												  )),
												  Flexible(
													child: Text(
													  'Tick here to confirm that you are at least 18 years old and the age of majority in your place of residence',
													  style: TextStyle(fontSize: 14),
													),
												  ),
												],
											),
											const SizedBox(height: 20),
											autoWidthBtn(
												text: 'Please Add a Payment Card', 
												width: screenWidth,
												onPress: () {
													// Your onPress logic here
												},
											),
										],
									),
								),
							],
						),
					],
				),
			),
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
	// Function to show tip modal
	void _showTipModal(BuildContext context, int index, RxMap<String, dynamic> feedData) {
		final double screenWidth = MediaQuery.of(context).size.width;

		//print("Feed Data: ${feedData['post_text']}");

		final TextEditingController tipAmountController = TextEditingController();
		final TextEditingController tipFirstNameController = TextEditingController();
		final TextEditingController tipLastNameController = TextEditingController();
		final TextEditingController tipCountryController = TextEditingController();
		final TextEditingController tipStateController = TextEditingController();
		final TextEditingController tipCityController = TextEditingController();
		final TextEditingController tipPostCodeController = TextEditingController();
		final TextEditingController tipAddressController = TextEditingController();

		final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

		final FocusNode _tipAmountFocusNode = FocusNode();
		final FocusNode _tipFirstNameFocusNode = FocusNode();
		final FocusNode _tipLastNameFocusNode = FocusNode();
		final FocusNode _tipCountryFocusNode = FocusNode();
		final FocusNode _tipStateFocusNode = FocusNode();
		final FocusNode _tipCityFocusNode = FocusNode();
		final FocusNode _tipPostCodeFocusNode = FocusNode();
		final FocusNode _tipAddressFocusNode = FocusNode();
		
		final post_id = feedData['post_id'];
		final tipsCount = feedData['tipsCount'];
		print("Post Id: $post_id");
		postController.fetchTipsData();
		
		//print("First Name: ${firstName.value}");

		// Create the content for the tip modal
		Widget content = SingleChildScrollView(
			scrollDirection: Axis.vertical,
			child: Obx(() {
				if (postController.isLoading.value) {
					return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple));
				}			
				final tipsData = postController.tipData.value;
				// Ensure that the controller is only set once
				if (tipFirstNameController.text.isEmpty && tipsData.first_name != null) {
					tipFirstNameController.text = tipsData.first_name!;
				} if (tipLastNameController.text.isEmpty && tipsData.last_name != null) {
					tipLastNameController.text = tipsData.last_name!;
				} if (tipStateController.text.isEmpty && tipsData.state != null) {
					tipStateController.text = tipsData.state!;
				} if (tipCityController.text.isEmpty && tipsData.city != null) {
					tipCityController.text = tipsData.city!;
				} if (tipPostCodeController.text.isEmpty && tipsData.postcode != null) {
					tipPostCodeController.text = tipsData.postcode!;
				} if (tipAddressController.text.isEmpty && tipsData.address != null) {
					tipAddressController.text = tipsData.address!;
				}
				  
				return Form(
					key: _formKey,
					child: Column(
					  children: [
						Padding(
						  padding: const EdgeInsets.all(0),
						  child: ListTile(
							leading: SizedBox(
							  height: 48,
							  width: 48,
							  child: Container(
								height: 173,
								width: Get.size.width,
								decoration: BoxDecoration(
								  image: DecorationImage(
										image: NetworkImage(feedData['avatar']), fit: BoxFit.fill),
										borderRadius: BorderRadius.circular(100),
								),
							  ),
							),
							title: Row(
							  children: [
								Text(
								  feedData['name'],
								  style: const TextStyle(
									  fontSize: 16,
									  fontFamily: 'Urbanist-semibold',
									  fontWeight: FontWeight.w600),
								),
							  ],
							),
							subtitle: Text(
							  feedData['created_at'],
							  style: TextStyle(
								  fontSize: 12,
								  color: Colors.grey,
								  fontFamily: 'Urbanist-regular',
								  fontWeight: FontWeight.w400),
							),
						  ),
						),
						const Text(
						  'Send a tip to this user',
						  style: TextStyle(
							  fontSize: 14,
							  color: Colors.black,
							  fontFamily: 'Urbanist-semibold'),
						),
						const SizedBox(height: 15),
						textFieldWithIconDynamic(
							text: '0',
							text1: 'Amount (\$1 min, \$500 max)',
							icon: Icons.payments, // Pass the desired icon here
							width: screenWidth,
							controller: tipAmountController,
							focusNode: _tipAmountFocusNode,
							validator: (value) {
								if (value == null || value.isEmpty) {
									return 'Amount cannot be blank';
								}
								final int? amount = int.tryParse(value);
								if (amount == null) {
								  return 'Please enter a valid integer';
								}
								if (amount < 1 || amount > 500) {
								  return 'Amount must be between \$1 and \$500';
								}
							},
							onChanged: (value) {
							  if (value.isNotEmpty) {
								_formKey.currentState?.validate();
								final int? amount = int.tryParse(value);
								if (amount != null && amount >= 1 && amount <= 500) {
								  postController.subtotal.value = amount.toDouble(); // Update subtotal
								  postController.total.value = amount.toDouble(); // Update subtotal
								}
							  } else {
								postController.subtotal.value = 0.0; // Reset subtotal if empty
								postController.total.value = 0.0; // Reset subtotal if empty
							  }
							},
						),
						const SizedBox(height: 15),
						ExpandableSection(
						  headerText: 'Billing agreement details',
						  width: screenWidth,
						  headerIcon: Icons.info,
						  expandIcon: Icons.expand_more,
						  collapseIcon: Icons.expand_less,
						  initialExpanded: tipsData.first_name != null ? false : true,
						  body: Column(
							  children: [
								autoWidthTextField(
									text: "First Name",					  
									width: screenWidth,
									controller: tipFirstNameController,
									focusNode: _tipFirstNameFocusNode,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'First name cannot be blank';
										}
										return null;
									},
									onChanged: (value) {
										if (value.isNotEmpty) {
											_formKey.currentState?.validate();
										}
									},
								),
								autoWidthTextField(
									text: "Last Name",					  
									width: screenWidth,
									controller: tipLastNameController,
									focusNode: _tipLastNameFocusNode,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'Last name cannot be blank';
										}
										return null;
									},
									onChanged: (value) {
										if (value.isNotEmpty) {
											_formKey.currentState?.validate();
										}
									},
								),
								Obx(() {
								  // Ensure the selected value is valid and matches one of the DropdownMenuItem values
								  String? currentCValue = postController.selectedCountry.value.isNotEmpty
									  ? postController.selectedCountry.value
									  : tipsData.country_id != 0 ? tipsData.country_id.toString() : null;

								  // Check if the current value exists in the list
								  bool isValidValue = postController.countryList
									  .any((country) => country.id.toString() == currentCValue);

								  if (!isValidValue) {
									currentCValue = null; // Reset to null if the value is not valid
								  }

								  return dropdownFieldFinal(
									text1: 'Country',
									width: screenWidth,
									value: currentCValue ?? '',  // Provide a fallback value if currentCValue is null
									items: postController.countryList
										.map<DropdownMenuItem<String>>((country) => DropdownMenuItem<String>(
											  value: country.id.toString(), // Use ID as the value
											  child: Text(country.name),    // Display name
											))
										.toList(),
									onChanged: (value) {
										if (value != null) {
											// Update selected country in the controller
											postController.selectedCountry.value = value;
											
											// Optionally, update the country ID in tipsData if needed
											final selectedCountryId = int.parse(value);
											postController.updateCountry(selectedCountryId);
										}
									},
								  );
								}),
								autoWidthTextField(
									text: "State / Province",					  
									width: screenWidth,
									controller: tipStateController,
									focusNode: _tipStateFocusNode,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'State / Province cannot be blank';
										}
										return null;
									},
									onChanged: (value) {
										if (value.isNotEmpty) {
											_formKey.currentState?.validate();
										}
									},
								),
								autoWidthTextField(
									text: "City",					  
									width: screenWidth,
									controller: tipCityController,
									focusNode: _tipCityFocusNode,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'City cannot be blank';
										}
										return null;
									},
									onChanged: (value) {
										if (value.isNotEmpty) {
											_formKey.currentState?.validate();
										}
									},
								),
								autoWidthTextField(
									text: "Zip",					  
									width: screenWidth,
									controller: tipPostCodeController,
									focusNode: _tipPostCodeFocusNode,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'Zip cannot be blank';
										}
										return null;
									},
									onChanged: (value) {
										if (value.isNotEmpty) {
											_formKey.currentState?.validate();
										}
									},
								),
								Padding(
									padding: const EdgeInsets.symmetric(horizontal: 0),
									child: ConstrainedBox(
										constraints: const BoxConstraints(minHeight: 74, maxHeight: 150),
										child: textAreaFieldDynamic(
										  text: 'Address',
										  width: screenWidth,
										  controller: tipAddressController,
										  focusNode: _tipAddressFocusNode,
										  validator: (value) {
											if (value == null || value.isEmpty) {
											  return 'Address cannot be blank';
											}
											return null;
										  },
										  onChanged: (value) {
											if (value.isNotEmpty) {
											  _formKey.currentState?.validate();
											}
										  },
										),
									),
								),
							  ],
							),
						),
						const SizedBox(height: 15),
						const Text(
						  'Payment summary',
						  style: TextStyle(
							  fontSize: 16,
							  color: AppColor.BlackGreyscale,
							  fontFamily: 'Urbanist-semibold'),
						),
						const SizedBox(height: 15),
						Row(
						  mainAxisAlignment: MainAxisAlignment.spaceBetween,
						  children: [
							Text(
							  'Subtotal:',
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							),
							Obx(() => Text(
							  '\$${postController.subtotal.value.toStringAsFixed(2)}', // Reactive subtotal
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							)),
						  ],
						),
						Row(
						  mainAxisAlignment: MainAxisAlignment.spaceBetween,
						  children: [
							Text(
							  'Taxes',
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							),
							Obx(() => Text(
							  '\$${postController.taxes.value.toStringAsFixed(2)}', // Reactive taxes
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							)),
						  ],
						),
						Row(
						  mainAxisAlignment: MainAxisAlignment.spaceBetween,
						  children: [
							Text(
							  'Total',
							  style: TextStyle(
								  fontSize: 16,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							),
							Obx(() => Text(
							  '\$${postController.total.value.toStringAsFixed(2)}', // Reactive total
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							)),
						  ],
						),
						const SizedBox(height: 15),
						Row(
						  mainAxisAlignment: MainAxisAlignment.spaceBetween,
						  children: [
							Text(
							  'Payment Method',
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.BlackGreyscale,
								  fontFamily: 'Urbanist-semibold'),
							),
							Text(
							  'Cash/Card',
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.BlackGreyscale,
								  fontFamily: 'Urbanist-semibold'),
							),
						  ],
						),
						const SizedBox(height: 15),
						Container(
						  height: 62,
						  width: 350,
						  decoration: BoxDecoration(
							borderRadius: BorderRadius.circular(35),
							border: Border.all(color: const Color(0xffE2E8F0)),
						  ),
						  child: ListTile(
							onTap: () => postController.toggleCCValue(),
							leading: SizedBox(
							  height: 20,
							  width: 20,
							  child: Icon(Icons.person, color: AppColor.black, size: 15.0),
							),
							title: Text('Credit (\$${tipsData.available_credit})',
								style: TextStyle(fontFamily: 'Urbanist-medium', fontSize: 16)),
							trailing: Obx(() => Checkbox(
								  activeColor: AppColor.purple,
								  value: postController.isChecked.value,
								  onChanged: (value) {
									postController.toggleCCValue();
								  },
								)),
						  ),
						),
						// Display the checkbox error message below the submit button
						  Obx(() {
							// If the error message is not empty, show it below the submit button
							if (postController.checkboxError.value.isNotEmpty) {
							  return Padding(
								padding: const EdgeInsets.only(top: 8.0), // Add some spacing
								child: Text(
								  postController.checkboxError.value,
								  style: TextStyle(color: Colors.red), // Customize the style for error text
								),
							  );
							}
							return SizedBox.shrink(); // Return an empty widget if there's no error
						  }),
						const SizedBox(height: 15),
						Text(
						  'Note: After clicking on the button, you will be directed to a secure gateway for payment. After completing the payment process, you will be redirected back to the website.',
						  style: TextStyle(
							  fontSize: 16,
							  color: AppColor.BlackGreyscale,
							  fontFamily: 'Urbanist-regular'),
						),
						const SizedBox(height: 15),
						Obx(() {
							// Determine the current values for country, defaulting to null if not set
							final selectedCountryValue = postController.selectedCountry.value;

							// Handle potential parsing issues
							final countryId = selectedCountryValue.isNotEmpty
								? int.tryParse(selectedCountryValue)
								: tipsData.country_id.toString().isNotEmpty
									? tipsData.country_id
									: null;							
											
							return autoWidthBtn(
								text: postController.isLoading.value ? 'SUBMITTING...' : 'SUBMIT',
								width: screenWidth,
								onPress: postController.isLoading.value
									? null
									: () {
										
											// If the checkbox is checked, proceed with form validation
											if (_formKey.currentState!.validate()) {										
												// Extract values
												final amount = int.parse(tipAmountController.text.trim());
												final first_name = tipFirstNameController.text.trim();
												final last_name = tipLastNameController.text.trim();
												final state = tipStateController.text.trim();
												final city = tipCityController.text.trim();
												final post_code = tipPostCodeController.text.trim();
												final address = tipAddressController.text.trim();
												// Call the submit function with optional parameters
												// Reset the checkbox error initially
												postController.checkboxError.value = '';

												// Check if the checkbox is checked
												if (!postController.isChecked.value) {
												  // Set the error message if checkbox is not checked
												  postController.checkboxError.value = 'Please select your payment method.';
												} else {
													postController.sendAtipSubmit(
														post_id,
														amount,
														first_name,
														last_name,
														state,
														city,
														post_code,
														countryId, // Pass null if not selected
														address,
														feedData
													).then((success) {
														if (success) {
															Navigator.of(context).pop();

															// Reset all input fields and checkbox state
															tipAmountController.clear();
															tipFirstNameController.clear();
															tipLastNameController.clear();
															tipStateController.clear();
															tipCityController.clear();
															tipPostCodeController.clear();
															tipAddressController.clear();
															postController.isChecked.value = false;
															postController.selectedCountry.value = ''; // Reset selected country
															postController.checkboxError.value = ''; // Clear checkbox error
														}
													});
												}
											} else {
												// Focus on the first invalid field if validation fails
												if (_tipAmountFocusNode.hasFocus || tipAmountController.text.trim().isEmpty) {
													_tipAmountFocusNode.requestFocus();
												} else if (_tipFirstNameFocusNode.hasFocus || tipFirstNameController.text.trim().isEmpty) {
													_tipFirstNameFocusNode.requestFocus();
												} else if (_tipLastNameFocusNode.hasFocus || tipLastNameController.text.trim().isEmpty) {
													_tipLastNameFocusNode.requestFocus();
												} else if (_tipStateFocusNode.hasFocus || tipStateController.text.trim().isEmpty) {
													_tipStateFocusNode.requestFocus();
												} else if (_tipCityFocusNode.hasFocus || tipCityController.text.trim().isEmpty) {
													_tipCityFocusNode.requestFocus();
												} else if (_tipPostCodeFocusNode.hasFocus || tipPostCodeController.text.trim().isEmpty) {
													_tipPostCodeFocusNode.requestFocus();
												} else if (_tipAddressFocusNode.hasFocus || tipAddressController.text.trim().isEmpty) {
													_tipAddressFocusNode.requestFocus();
												}
											}
										
									},
							);
						}),
						const SizedBox(height: 10),
					  ],
					),
				);
			}),
		);

		// Call the common modal function with the content
		_showCustomModal(context, 'Send a tip', content);
	}
  
  
}