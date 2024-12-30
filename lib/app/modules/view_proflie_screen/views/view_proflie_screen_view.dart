import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:picturesourcesomerset/app/modules/home/views/showimage_view.dart';
import 'package:picturesourcesomerset/app/modules/editprofile_screen/views/editprofile_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/addcard_screen/views/addcard_screen_view.dart';
import 'package:picturesourcesomerset/app/modules/follow_screen/views/follow_screen_view.dart';

import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/custom_modal.dart';
import 'package:picturesourcesomerset/config/custom_expandable.dart';
import 'package:picturesourcesomerset/config/video_player_widget.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';

import '../controllers/view_proflie_screen_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/comment_controller.dart';
import 'package:picturesourcesomerset/app/modules/feeds_common_use/controllers/post_controller.dart';

// ignore: must_be_immutable
class ViewProflieScreenView extends StatelessWidget {
	final String userId; // Declare the instance variable

	// Scroll controllers for vertical and horizontal scrolling
	final ScrollController _verticalScrollController = ScrollController();
	
	final ViewProflieScreenController viewProflieScreenController = Get.find();
	//final ViewProflieScreenController viewProflieScreenController = Get.put(ViewProflieScreenController(Get.find<ApiService>()));
	
	ViewProflieScreenView({required this.userId}) {
		// This code will run when the widget is instantiated
		_verticalScrollController.addListener(() {
			if (_verticalScrollController.position.pixels == _verticalScrollController.position.maxScrollExtent) {
				// Convert userId to int for loading more data
				int parsedUserId = int.parse(userId);
				viewProflieScreenController.loadMoreFeedData(parsedUserId); // Load more data on vertical scroll
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
  
	//final ViewProflieScreenController viewProflieScreenController = Get.put(ViewProflieScreenController());
	final CommentController commentController = Get.find<CommentController>();
	final PostController postController = Get.find<PostController>();
	
	final actionTextStyle =  TextStyle(fontSize: 14, color: AppColor.purple, fontFamily: 'Urbanist-medium', fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
	// Access the userId through arguments if needed
	final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
	String userId = args['userId']; // Make sure this is of type String
	
	const TextStyle actionTextStyle = TextStyle(
		fontSize: 14,
		color: AppColor.purple,
		fontFamily: 'Urbanist-medium',
		fontWeight: FontWeight.w500,
	);

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
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              centerTitle: true,
              title: const Text(
                'View Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Urbanist-semibold',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              actions: [
                const Icon(Icons.share, color: AppColor.black, size: 24.0),
                const SizedBox(width: 15),
              ],
            ),
            body: Obx(() {
				if (viewProflieScreenController.isFetchingData.value) {
					return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));
				} else {
			
					final profileData = viewProflieScreenController.profileData.value;
						return SingleChildScrollView(
						  scrollDirection: Axis.vertical,
						  
							child: Column(
						  children: [
						  
							// Fixed top section
							Container(
							  height: 350,
							  width: screenWidth,
							  color: AppColor.white,
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
													_buildStatColumn('${viewProflieScreenController.socialUserTotalPosts.value}', 'Posts'),
													_buildStatColumn('${viewProflieScreenController.socialUserTotalFollowers.value}', 'Followers'),
													_buildStatColumn('${viewProflieScreenController.socialUserTotalFollowing.value}', 'Following'),
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
											if (profileData.is_paid_profile == 0 && profileData.has_active_sub == 0) ...[
												const SizedBox(width: 1),											
												Flexible(
												  child: Padding(
													padding: const EdgeInsets.only(top: 16.0),
													child: Obx(() => iconBtn(
													  text: viewProflieScreenController.isFollowing.value ? "Unfollow" : "Follow",
													  width: 120,
													  height: 35,
													  onPress: () {
															// Replace 'controller' with the instance of your controller
															viewProflieScreenController.toggleFollowStatus(profileData.id, viewProflieScreenController.isFollowing.value ? 0 : 1);
													  },
													  icon: viewProflieScreenController.isFollowing.value ? Icons.person_remove : Icons.person_add, // person_remove (unfollow)
													
													)),
												  ),
												),
											],
											
										  ],
										),
									  ),
								],
							  ),
							),
							if (viewProflieScreenController.subscription_bundle_single.isNotEmpty) ...[
								//Subscribe button
								Padding(
								  padding: const EdgeInsets.only(top: 1),
								  child: Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
									  subcribeBtn(
										lefttext: 'Subscribe',
										righttext: viewProflieScreenController.subscription_bundle_single['subscription_text'],
										screenWidth: screenWidth,
										onPress: () => _showSubscribtionModal(context, viewProflieScreenController.subscription_bundle_single),
									  ),
									],
								  ),
								),
								if (viewProflieScreenController.subscription_bundle.isNotEmpty) ...[
									const SizedBox(height: 10),
									ExpandableSection(
										  headerText: 'Subscriptions bundles',
										  width: screenWidth,
										  headerIcon: Icons.info,
										  expandIcon: Icons.expand_more,
										  collapseIcon: Icons.expand_less,
										  initialExpanded: false,
										  body: Column(
											  children: [										
												Padding(
												  padding: const EdgeInsets.only(top: 1),
												  child: Column(
													mainAxisAlignment: MainAxisAlignment.center,
													children: viewProflieScreenController.subscription_bundle.entries
														.where((entry) => !['title', 'name', 'username', 'avatar', 'created_at'].contains(entry.key))
														.map((entry) {
														  final subscriptionData = entry.value;

														  // Ensure subscriptionData is a Map<String, dynamic>
														  if (subscriptionData is Map<String, dynamic>) {
															return Padding(
															  padding: const EdgeInsets.symmetric(vertical: 5), // Add spacing between buttons
															  child: subcribeBtnBundles(
																lefttext: 'Subscribe',
																righttext: subscriptionData['subscription_text'] ?? 'Free',
																screenWidth: screenWidth,
																// Convert subscriptionData to RxMap
																onPress: () => _showSubscribtionModal(context, RxMap<String, dynamic>.from(subscriptionData)),
															  ),
															);
														  } else {
															return SizedBox.shrink(); // Handle unexpected type
														  }
														}).toList(),
													),
												),
											],
										),
									),
								],
							],
								const SizedBox(height: 10),
								const Text(
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
								  height: viewProflieScreenController.feedData.isEmpty ? 50 : Get.size.height - 220,
								  width: Get.width,
								  child: MediaQuery.removePadding(
									context: context,
									removeTop: true,
									child: Obx(() {
									  if (viewProflieScreenController.isFetchingFeedData.value && viewProflieScreenController.feedData.isEmpty) {
										return Center(
										  child: CircularProgressIndicator(
											valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),
										  ),
										);
									  } else if (viewProflieScreenController.feedData.isNotEmpty) {
										return buildSearchList(viewProflieScreenController.feedData); // Ensure this function returns a Widget
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
			}),
          );
        },
      ),
    );
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
  
  Widget buildSearchList(RxList data) {
	  return Padding(
		padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
		child: Obx(() {
		  // Check if data is still being fetched
		  if (viewProflieScreenController.isFetchingFeedData.value && data.isEmpty) {
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
				return viewProflieScreenController.isFetchingFeedData.value
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
												value: viewProflieScreenController.selectedCountry.value,
												items: ['USA', 'Canada', 'Mexico'],
												onChanged: (value) => viewProflieScreenController.updateCountry(value!),
											)),
											Obx(() => dropdownField(
												text1: 'State / Province', 
												width: screenWidth,
												value: viewProflieScreenController.selectedState.value,
												items: ['California', 'Texas', 'Florida'],
												onChanged: (value) => viewProflieScreenController.updateState(value!),
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
														value: viewProflieScreenController.isChecked.value,
														onChanged: (bool? value) {
														  viewProflieScreenController.toggleCheckbox(value!);
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
	
	// Function to show subscribe modal
	void _showSubscribtionModal(BuildContext context, RxMap<String, dynamic> subscriptionBundle) {
		final double screenWidth = MediaQuery.of(context).size.width;

		print("Subscription Bundle Name: ${subscriptionBundle['name']}");

		final TextEditingController tipFirstNameController = TextEditingController();
		final TextEditingController tipLastNameController = TextEditingController();
		final TextEditingController tipCountryController = TextEditingController();
		final TextEditingController tipStateController = TextEditingController();
		final TextEditingController tipCityController = TextEditingController();
		final TextEditingController tipPostCodeController = TextEditingController();
		final TextEditingController tipAddressController = TextEditingController();

		final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

		final FocusNode _tipFirstNameFocusNode = FocusNode();
		final FocusNode _tipLastNameFocusNode = FocusNode();
		final FocusNode _tipCountryFocusNode = FocusNode();
		final FocusNode _tipStateFocusNode = FocusNode();
		final FocusNode _tipCityFocusNode = FocusNode();
		final FocusNode _tipPostCodeFocusNode = FocusNode();
		final FocusNode _tipAddressFocusNode = FocusNode();
		
		final post_id = 0;
		//final tipsCount = feedData['tipsCount'];
		//print("Post Id: $post_id");
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
										image: NetworkImage(subscriptionBundle['avatar']), fit: BoxFit.fill),
										borderRadius: BorderRadius.circular(100),
								),
							  ),
							),
							title: Row(
							  children: [
								Text(
								  subscriptionBundle['name'],
								  style: const TextStyle(
									  fontSize: 16,
									  fontFamily: 'Urbanist-semibold',
									  fontWeight: FontWeight.w600),
								),
							  ],
							),
							subtitle: Text(
							  '@${subscriptionBundle['username']}',
							  style: TextStyle(
								  fontSize: 12,
								  color: Colors.grey,
								  fontFamily: 'Urbanist-regular',
								  fontWeight: FontWeight.w400),
							),
						  ),
						),
						Text(
						  'Subscribe to ${subscriptionBundle['name']} for ${subscriptionBundle['subscription_text']}',
						  style: TextStyle(
							  fontSize: 14,
							  color: Colors.black,
							  fontFamily: 'Urbanist-semibold'),
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
							Text(
							  '\$${subscriptionBundle['subscription_price'].toStringAsFixed(2)}', // Reactive subtotal
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							),
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
							Text(
							  '\$${postController.taxes.value.toStringAsFixed(2)}', // Reactive taxes
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							),
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
							Text(
							  '\$${subscriptionBundle['subscription_price'].toStringAsFixed(2)}', // Reactive total
							  style: TextStyle(
								  fontSize: 14,
								  color: AppColor.black,
								  fontFamily: 'Urbanist-semibold'),
							),
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
							onTap: () => postController.toggleSubcriptionValue(),
							leading: SizedBox(
							  height: 20,
							  width: 20,
							  child: Icon(Icons.person, color: AppColor.black, size: 15.0),
							),
							title: Text('Credit (\$${tipsData.available_credit})',
								style: TextStyle(fontFamily: 'Urbanist-medium', fontSize: 16)),
							trailing: Obx(() => Checkbox(
								  activeColor: AppColor.purple,
								  value: postController.isCheckedSubcription.value,
								  onChanged: (value) {
									postController.toggleSubcriptionValue();
								  },
								)),
						  ),
						),
						// Display the checkbox error message below the submit button
						  Obx(() {
							// If the error message is not empty, show it below the submit button
							if (postController.checkboxSubcriptionError.value.isNotEmpty) {
							  return Padding(
								padding: const EdgeInsets.only(top: 8.0), // Add some spacing
								child: Text(
								  postController.checkboxSubcriptionError.value,
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
												final amount = subscriptionBundle['subscription_price'];
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
													postController.subscriptionSubmit(
														amount,
														first_name,
														last_name,
														state,
														city,
														post_code,
														countryId, // Pass null if not selected
														address,
														subscriptionBundle
													).then((success) {
														if (success) {
															Navigator.of(context).pop();

															// Reset all input fields and checkbox state
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
												if (_tipFirstNameFocusNode.hasFocus || tipFirstNameController.text.trim().isEmpty) {
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

		// Get the title safely from subscriptionBundle
		  String modalTitle = subscriptionBundle['subscription_duration'] is String 
			? '${viewProflieScreenController.toCamelCase(subscriptionBundle['subscription_duration'])} Subscription'
			: 'Subscription Details';

		  // Call the custom modal function with the title and content
		  _showCustomModal(context, modalTitle, content);
	}
	  
	// Function to show subscribe modal, not use
	void _showSubscriberModal(BuildContext context, RxMap<String, dynamic> subscription_bundle) {
		final double screenWidth = MediaQuery.of(context).size.width;
		// Create the content for the tip modal
		Widget content = SingleChildScrollView(
			scrollDirection: Axis.vertical,
			child: Obx(() {				  
				return SingleChildScrollView(
					scrollDirection: Axis.vertical,
					child: SizedBox(
						//height: Get.size.height * 1.2,
						width: Get.size.width,
						child: Column(
						  children: [
							Stack(
							  clipBehavior: Clip.none,
							  children: [
								Container(
								  height: 173,
								  width: Get.size.width,
								  decoration: const BoxDecoration(
									image: DecorationImage(
									  image: AssetImage('assets/Banner.png'),
									  fit: BoxFit.fill,
									),
									borderRadius: BorderRadius.only(
									  bottomLeft: Radius.circular(20),
									  bottomRight: Radius.circular(20),
									),
								  ),
								),
								Positioned(
								  bottom: -70,
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
											  image: const DecorationImage(
												image: AssetImage('assets/avatar.png'),
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
												color: Colors.green,
												border: Border.all(color: Colors.white, width: 3),
											  ),
											),
										  ),
										],
									  ),
									  const SizedBox(width: 1),
									  Expanded(
									  child: Padding(
										padding: const EdgeInsets.only(top: 16.0), // Adjust the padding value as needed
										child: ListTile(
										  title: Text(
											'Williamson1',
											style: TextStyle(
											  fontSize: 18,
											  fontFamily: 'Urbanist-semibold',
											),
										  ),
										  subtitle: Text(
											'@williamson',
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
							const SizedBox(height: 90),
							Text(
							  'SUBSCRIBE AND GET THESE BENEFITS',
							  style: TextStyle(
								fontSize: 16,
								color: AppColor.BlackGreyscale,
								fontFamily: 'Urbanist-semibold',
							  ),
							),
							const SizedBox(height: 20),
							Column(
							  mainAxisAlignment: MainAxisAlignment.center,
							  children: [
								_benefitRow(Icons.done, 'Full access to this user\'s content'),
								const SizedBox(height: 10.0),
								_benefitRow(Icons.done, 'Direct message with this user'),
								const SizedBox(height: 10.0),
								_benefitRow(Icons.done, 'Cancel your subscription at any time Cancel your subscription at any time'),
								const SizedBox(height: 20.0),
								elevated(
									text: 'Please Add a Payment Card',
									onPress: () {
										Navigator.push(
											context,
											MaterialPageRoute(
												builder: (context) =>
												  AddcardScreenView()
											)
										);
									},
								),
								const SizedBox(height: 10),
							  ],
							),
						  ],
						),
					  ),
					);
				}),
			);

		// Call the common modal function with the content
		_showCustomModal(context, 'One month subsscription -dynamin', content);
	}
	
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