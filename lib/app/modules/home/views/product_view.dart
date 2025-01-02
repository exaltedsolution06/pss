import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/bullet_list.dart';

class ProductView extends StatefulWidget {
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
//class ProductView extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController reviewController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _reviewFocusNode = FocusNode();

	Future<void> _captureAndNavigate(BuildContext context) async {
	  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

	  if (photo != null) {
		File photoFile = File(photo.path);
		
		// Check if the file exists
		if (photoFile.existsSync()) {
		  // Navigate with the photo file
		  Get.toNamed('/wallphotoview', arguments: photoFile);
		} else {
		  Get.snackbar("Error", "Captured photo does not exist.");
		}
	  } else {
		Get.snackbar("Error", "No photo captured.");
	  }
	}
	final List<String> imageUrls = [
		Appcontent.pss1,
		Appcontent.pss2,
		Appcontent.pss3,
		Appcontent.pss4,
	];
	
	int _selectedStars = 0; // Tracks the selected star rating
	
  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
		child: Form(
           key: _formKey,
			child: Column(
			  crossAxisAlignment: CrossAxisAlignment.start,
			  children: [
				Padding(
				  padding: const EdgeInsets.all(16.0),
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  Text(
						"057BU-F",
						style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-semibold'),
					  ),
					  Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
						  Text("DEER", style: TextStyle(fontSize: 14, fontFamily: 'Urbanist-Regular')),
						  Text("Artist BUSTAMONTE", style: TextStyle(fontSize: 14, fontFamily: 'Urbanist-Regular')),
						],
					  ),
					],
				  ),
				),
				CarouselSlider(
				  options: CarouselOptions(
					height: 300.0,
					autoPlay: true,
					enlargeCenterPage: true,
				  ),
				  items: imageUrls.map((imageUrl) {
					return Builder(
					  builder: (BuildContext context) {
						return Image.asset(
						  imageUrl,
						  fit: BoxFit.cover,
						  width: double.infinity,
						);
					  },
					);
				  }).toList(),
				),
				const SizedBox(height: 10),
				Padding(
				  padding: const EdgeInsets.all(16.0),
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							GestureDetector(
							  onTap: () => _captureAndNavigate(context),
							  child: Stack(
								clipBehavior: Clip.none, // To allow the underline to be positioned outside the bounds of the text
								children: [
								  Text(
									"View on Wall",
									textAlign: TextAlign.left,
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.purple,
									),
								  ),
								  Positioned(
									bottom: -1, // Adjust this value to control the space between text and underline
									left: 0,
									right: 0,
									child: Container(
									  height: 1, // Thickness of the underline
									  color: AppColor.purple, // Same color as the text
									),
								  ),
								],
							  ),
							),

							Text("Rs. 25", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold')),
							GestureDetector(
							  onTap: () {
								//Get.toNamed(Routes.YOUR_TARGET_PAGE); // Replace with your desired route
							  },
							  child: Row(
								mainAxisSize: MainAxisSize.min, // Adjust the width of the row to fit its children
								children: [
								  Icon(
									Icons.add_box, // Use the desired icon
									color: AppColor.purple,
								  ),
								  SizedBox(width: 8), // Adds space between the icon and the text
								  Text(
									"Add to cart",
									textAlign: TextAlign.right,
									style: TextStyle(
									  fontSize: 16,
									  color: AppColor.purple,
									),
								  ),
								],
							  ),
							),
						],
					  ),
					  const SizedBox(height: 20),
					  const Text(
						"EXCLUSIVE SILK SCREEN ENHANCED w/GEL BRUSHSTROKES AND COLOR ACCENTS",
						style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', fontWeight: FontWeight.bold),
					  ),
					  const SizedBox(height: 10),
						Padding(
							padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									customBulletList(
									  items: [
										'Moulding: BW8004',
										'Moulding Description: 2 DK KNOTTY PINE, ROUNDED w/STEPS (9) (B)',
										'Dimensions: 75 3/8 x 49 3/8',
									  ],
									  bulletColor: AppColor.BlackGreyscale,
									  bulletSize: 6.0,
									  bulletPadding: 12.0, // Adjust this value as needed
									  bulletOffset: 7.0, // Fine-tune this value to align the bullet with the first line
									  textStyle: TextStyle(fontSize: 14, color: AppColor.BlackGreyscale, fontFamily: 'Urbanist-Regular'),
									),
								],
							),
						),
					  //const SizedBox(height: 20),
					],
				  ),
				),
				Padding(
					padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
					child: Column(
					  crossAxisAlignment: CrossAxisAlignment.start,
					  children: [
						// Top Section: Average Rating and Star Ratings
						Row(
						  crossAxisAlignment: CrossAxisAlignment.start,
						  children: [
							// Average Rating
							Column(
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									Row(
										mainAxisSize: MainAxisSize.min, // Adjust the width of the row to fit its children
										children: [
											Text(
											  "4.4",
											  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
											),
											SizedBox(width: 8), // Adds space between the icon and the text
											Icon(
												Icons.star, // Use the desired icon
												color: Colors.amber,
												size: 30,
											),
										],
									),
									Text(
										"923 Ratings\n"
										"and 257 Reviews",
										style: TextStyle(color: Colors.grey),
									),			
								],
							),
							// Divider
							Container(
							  width: 1,
							  height: 100,
							  margin: EdgeInsets.symmetric(horizontal: 16),
							  color: Colors.grey[300],
							),
							// Rating Summary
							Expanded(
							  child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
								  // Rating Distribution
								  Column(
									children: List.generate(5, (index) {
									  final labels = ["5", "4", "3", "2", "1"];
									  final percentages = [0.67, 0.20, 0.07, 0.00, 0.02];
									  return Row(
										children: [
											Text(labels[index]),
											SizedBox(width: 8),
											Icon(
												Icons.star, // Use the desired icon
												color: Colors.amber,
												size: 14,
											),
											SizedBox(width: 8),
										  Expanded(
											child: LinearProgressIndicator(
											  value: percentages[index],
											  backgroundColor: Colors.grey[200],
											  color: Colors.amber,
											),
										  ),
										  SizedBox(width: 8),
										  Text("${(percentages[index] * 100).toInt()}%"),
										],
									  );
									}),
								  ),
								],
							  ),
							),
						  ],
						),
						SizedBox(height: 24),
						// Give a Review Section
						Row(
						  children: [
							IconButton(
							  onPressed: () {},
							  icon: Icon(Icons.close),
							),
							SizedBox(width: 8),
							Text(
							  "Give a Review",
							  style: TextStyle(fontSize: 24, fontFamily: 'Urbanist-semibold'),
							),
						  ],
						),
						Row(
						  children: List.generate(
							5,
							(index) => IconButton(
							  onPressed: () {
								setState(() {
								  _selectedStars = index + 1; // Update selected star
								});
							  },
							  icon: Icon(
								Icons.star,
								color: index < _selectedStars ? Colors.amber : Colors.grey,
								size: 32,
							  ),
							),
						  ),
						),
						SizedBox(height: 6),
						if (_selectedStars > 0)
						  Text(
							"You selected $_selectedStars star(s)",
							style: TextStyle(fontSize: 16, color: Colors.black),
						  ),
					  ],
					),
				),
				Padding(
				  padding: const EdgeInsets.all(16.0),
				  child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  const Text(
						"Detail Review",
						style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-semibold'),
					  ),

					  const SizedBox(height: 10),
						ConstrainedBox(
							constraints: const BoxConstraints(minHeight: 74, maxHeight: 150),
							child: textAreaFieldDynamic(
							  text: 'Write a Review',
							  width: screenWidth,
							  controller: reviewController,
							  focusNode: _reviewFocusNode,
							  validator: (value) {
								if (value == null || value.isEmpty) {
								  return 'Message cannot be blank';
								}
								if (value.length < 10) {
								  return 'Your post must contain more than 10 characters.';
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
						const SizedBox(height: 10),
						autoWidthBtn(
							text: 'Send Review',
							width: screenWidth, // Ensure screenWidth is defined
							onPress: () {},
						),
					  /*ElevatedButton(
						onPressed: () {
						  if (reviewController.text.isNotEmpty) {
							// Submit review
						  } else {
							Get.snackbar("Error", "Please write a review before submitting.");
						  }
						},
						style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
						child: const Text("Send Review"),
					  ),*/
					],
				  ),
				),
			  ],
			),
		),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }
}
