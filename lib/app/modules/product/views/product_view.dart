import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/services/api_service.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/app_color.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/common_textfield.dart';
import 'package:picturesourcesomerset/config/bullet_list.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import 'package:picturesourcesomerset/app/modules/product/models/product_data.dart';

class ProductView extends StatefulWidget {
  final String productId;

  //const ProductView({Key? key, required this.productId}) : super(key: key);
  ProductView({required this.productId});
  

  @override
  _ProductViewState createState() => _ProductViewState();
}


class _ProductViewState extends State<ProductView> {
	
	//final ProductController productController = Get.put(ProductController());
	//final ProductController productController = Get.find();
	final ProductController productController = Get.find<ProductController>();
	final CartController cartController = Get.put(CartController());
	
	final ImagePicker _picker = ImagePicker();
	final TextEditingController reviewController = TextEditingController();
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	final FocusNode _reviewFocusNode = FocusNode();
	
	List<File> fetchedFiles = [];  // To hold multiple image/video files

	Future<void> _captureAndNavigate(BuildContext context) async {
	  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

	  if (photo != null) {
		File photoFile = File(photo.path);
		
		int parsedProductId = int.tryParse(widget.productId) ?? 0;
		
		// Check if the file exists
		if (photoFile.existsSync()) {
		  // Navigate with the photo file
		  Get.toNamed('/wallphotoview', arguments: {
			'photoFile': photoFile,
			'productId': parsedProductId,
		  });
		} else {
		  Get.snackbar("Error", "Captured photo does not exist.");
		}
	  } else {
		Get.snackbar("Error", "No photo captured.");
	  }
	}
	late ProductData productData; // Define your productData variable
	
	FileData? firstValidFile;
	
	@override
	void initState() {
		super.initState();
		Future.delayed(Duration(milliseconds: 100), () {
			int parsedProductId = int.tryParse(widget.productId) ?? 0;
			print("Fetching product with ID: $parsedProductId");
			productController.fetchProductData(parsedProductId);
			
			productData = ProductData(); // Initialize it according to your logic
		});	
	}
	@override
	void dispose() {
		_reviewFocusNode.dispose();
		reviewController.dispose();
		super.dispose();
	}	
	//int _selectedStars = 0; // Tracks the selected star rating
	
	@override
	Widget build(BuildContext context) {
		final double screenWidth = MediaQuery.of(context).size.width;
		return Scaffold(
			appBar: AppBar(
				title: Text("Product Details", style: TextStyle(fontSize: 20)),
				centerTitle: true,
			),
			body: Obx(() {
				if (productController.isFetchingData.value) {
					return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple),));	
				} else if (productController.productData.value == null) {
					return Center(child: Text("Error loading product data."));					
				} else {
					final productData = productController.productData.value!;
					var imageUrls = productData.fetchedFiles;
					
					// Set review text
					reviewController.text = productData.my_review ?? "";
					
					firstValidFile = productData.fetchedFiles!.firstWhere(
						(file) => file.filePath != null && file.filePath!.isNotEmpty,
						orElse: () => FileData(filePath: ''), // Provide a default object
					);
					
					return SingleChildScrollView(
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
										productData.product_code,
										style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-semibold'),
									  ),
									  Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
										  Text(productData.category_name, style: TextStyle(fontSize: 14, fontFamily: 'Urbanist-Regular')),
										  Text("Artist ${productData.artist_name}", style: TextStyle(fontSize: 14, fontFamily: 'Urbanist-Regular')),
										],
									  ),
									],
								  ),
								),
								if (productData.fetchedFiles != null && productData.fetchedFiles!.isNotEmpty)
								CarouselSlider(
								  options: CarouselOptions(
									height: 300.0,
									autoPlay: false,
									enlargeCenterPage: true,
								  ),
								  items: productData.fetchedFiles!
									  .where((file) => file.filePath?.isNotEmpty ?? false) // Ensure non-null and non-empty filePath
									  .map((file) {
										return Builder(
										  builder: (BuildContext context) {
											return Image.network(
											  file.filePath ?? '', // Safe to use `!` after filtering
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

											Text(productData.price, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold')),
											GestureDetector(
											  onTap: () {
												cartController.addToCart(productData.product_id, firstValidFile?.filePath ?? '', firstValidFile?.id ?? '', productData.name, productData.price);
												//print("Add to Cart: ${productData.product_id}");
												
												SnackbarHelper.showSuccessSnackbar(
													title: Appcontent.snackbarTitleSuccess, 
													message: "Item added to cart successfully.",
													position: SnackPosition.BOTTOM, // Custom position
												);
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
									  Text(
										productData.name,
										style: TextStyle(fontSize: 16, fontFamily: 'Urbanist-semibold', fontWeight: FontWeight.bold),
									  ),
									  const SizedBox(height: 10),
										Padding(
											padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(
														productData.moulding_description,
														style: TextStyle(fontSize: 14, fontFamily: 'Urbanist-Regular'),
													  ),
													/*customBulletList(
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
													),*/
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
															  productData.average_rating,
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
														"${productData.total_rating} Ratings\n"
														"and ${productData.total_reviews} Reviews",
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
													  final percentages = [productData.percentage_rating_five/100, productData.percentage_rating_four/100, productData.percentage_rating_three/100, productData.percentage_rating_two/100, productData.percentage_rating_one/100];
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
												/*setState(() {
												  _selectedStars = ; // Update selected star
												});*/
												productController.submitRating(index + 1); // Call API function
											  },
											  icon: Icon(
												Icons.star,
												color: index < productController.selectedStars.value ? Colors.amber : Colors.grey,
												size: 32,
											  ),
											),
										  ),
										),
										SizedBox(height: 6),
										if (productController.selectedStars.value > 0)
										  Text(
											"You selected ${productController.selectedStars.value} star(s)",
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
										Obx(() {
										  return autoWidthBtn(
											text: productController.isLoading.value ? 'Sending...' : 'Send Review',
											width: screenWidth,
											onPress: productController.isLoading.value
												? null
												: () {
													if (_formKey.currentState!.validate()) {
														productController.giveReview(
															reviewController.text.trim()
														);
													} else {
														if (_reviewFocusNode.hasFocus) {
															_reviewFocusNode.requestFocus();
														}
													}
												  },
										  );
										}),
									],
								  ),
								),
							  ],
							),
						),
					);
				}
			}),
			bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
		);
	}
}