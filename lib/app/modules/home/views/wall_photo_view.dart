import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';

import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';

class WallPhotoView extends StatefulWidget {
  @override
  _WallPhotoViewState createState() => _WallPhotoViewState();
}

class _WallPhotoViewState extends State<WallPhotoView> {

	final HomeController homeController = Get.find();
	
  // Retrieve the captured image from the arguments
  final File? imageFile = Get.arguments as File?;

  late String selectedPhoto;
  Offset position = Offset(150, 150); // Default position of photo on the wall

  // List of photo asset paths
  final List<String> photoList = [
    Appcontent.pss1,
    Appcontent.pss2,
    Appcontent.pss3,
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the selectedPhoto field with the value from Get.arguments if available
    selectedPhoto = photoList[0]; // Set to first photo if no image is passed
  }
  
  // Define a GlobalKey for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wall Photo View'),
      ),
      body: Form(
        key: _formKey, // Assign the form key here
			child: Column(
			children: [
			  // Wall with photo
			  Expanded(
				flex: 3,
				child: GestureDetector(
				  onPanUpdate: (details) {
					setState(() {
					  // Update position based on relative position (localPosition)
					  position = Offset(details.localPosition.dx, details.localPosition.dy);
					});
				  },
				  child: Stack(
					children: [
					  // Wall background
					  imageFile != null
						  ? Container(
							  decoration: BoxDecoration(
								image: DecorationImage(
								  image: FileImage(imageFile!), // Use the non-nullable File
								  fit: BoxFit.cover, // Adjust the image to cover the container
								),
							  ),
							  child: Center(
								child: Text(
								  'Your Wall',
								  style: TextStyle(fontSize: 18, color: Colors.black54),
								),
							  ),
							)
						  : Container(
							  color: Colors.grey[300], // Default color if no image is selected
							  child: Center(
								child: Text(
								  'Your Wall',
								  style: TextStyle(fontSize: 18, color: Colors.black54),
								),
							  ),
							),

					  // Movable photo
					  Positioned(
						left: position.dx,
						top: position.dy,
						child: selectedPhotoWidget(),
					  ),
					],
				  ),
				),
			  ),
			  // Photo selection
			  Expanded(
				flex: 1,
				child: ListView.builder(
				  scrollDirection: Axis.horizontal,
				  itemCount: photoList.length,
				  itemBuilder: (context, index) {
					return GestureDetector(
					  onTap: () {
						setState(() {
						  selectedPhoto = photoList[index];
						});
					  },
					  child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Image.asset(
						  photoList[index],
						  width: 100,
						  height: 100,
						  fit: BoxFit.cover,
						),
					  ),
					);
				  },
				),
			  ),
				Padding(
				  padding: const EdgeInsets.only(bottom: 16, top: 16),
				  child: Center(
					child: autoWidthBtn(
					  text: 'PLACE ORDER',
					  width: screenWidth,
					  onPress: homeController.isLoading.value
						? null
						: () {
							if (_formKey.currentState!.validate()) {
							  homeController.wallPhotoOrder(
							  );
							} else {
							}
						  },
					  
					  /*() {
						// Directly navigate to the next page
						print('Navigating to: ${Routes.WISHLIST_CREATE}');
						Get.toNamed('/wishlist-create');
					  },*/
					),
				  ),
				),
				const SizedBox(height: 20),
			],
		  ),
	  ),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }

  // Widget to display the selected photo
  Widget selectedPhotoWidget() {
    return Image.asset(
      selectedPhoto,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
  }
}
