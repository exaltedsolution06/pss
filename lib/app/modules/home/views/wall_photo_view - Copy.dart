import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/app/routes/app_pages.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_button.dart';
import 'package:picturesourcesomerset/config/snackbar_helper.dart';

import 'package:picturesourcesomerset/app/modules/home/controllers/home_controller.dart';
import 'package:picturesourcesomerset/app/modules/product/controllers/product_controller.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';

class WallPhotoView extends StatefulWidget {
  @override
  _WallPhotoViewState createState() => _WallPhotoViewState();
}

class _WallPhotoViewState extends State<WallPhotoView> {

	final HomeController homeController = Get.find();
	final ProductController productController = Get.find<ProductController>();
	final CartController cartController = Get.put(CartController());
	
  // Retrieve the captured image from the arguments
  //final File? imageFile = Get.arguments as File?;

  late String selectedPhoto;
  late String selectedPhotoId;
  Offset position = Offset(150, 150); // Default position of photo on the wall

  // List of photo asset paths
  /*final List<String> photoList = [
    Appcontent.pss1,
    Appcontent.pss2,
    Appcontent.pss3,
  ];*/

  @override
  void initState() {
    super.initState();
    
	// Initialize selectedPhoto with the first image from imageUrls if available
	if (productController.productData.value?.fetchedFiles != null &&
		  productController.productData.value!.fetchedFiles!.isNotEmpty) {
		selectedPhoto = productController.productData.value!.fetchedFiles!.first.filePath ?? '';
		selectedPhotoId = productController.productData.value!.fetchedFiles!.first.id ?? '';
	} else {
		selectedPhoto = ''; // Default if no images are available
		selectedPhotoId = ''; // Default if no images are available
	}
  }
  
  // Define a GlobalKey for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
	final double screenWidth = MediaQuery.of(context).size.width;
	
	// Retrieve arguments
    final arguments = Get.arguments ?? {};
    final int productId = arguments['productId'] ?? 0;
    //final File? imageFile = Get.arguments as File?; // Keep the same name
	final File? imageFile = arguments['photoFile'] as File?;

    // Fetch product images dynamically using productId
    productController.fetchProductData(productId);
	
	final productData = productController.productData.value!;
    final imageUrls = productData.fetchedFiles ?? [];
	//print(imageUrls);
	
    return Scaffold(
	  appBar: AppBar(
		title: Text("Wall Photo View", style: TextStyle(fontSize: 20)),
		centerTitle: true,
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
				  itemCount: imageUrls.length,
				  itemBuilder: (context, index) {
					return GestureDetector(
					  onTap: () {
						setState(() {
						  selectedPhoto = imageUrls[index].filePath ?? '';
						  selectedPhotoId = imageUrls[index].id ?? '';
						});
					  },
					  child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Image.network(
						  imageUrls[index].filePath ?? '',
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
				  padding: const EdgeInsets.all(10),
				  child: Center(
					child: autoWidthBtn(
					  text: 'Add to cart',
					  width: screenWidth,
					  /*onPress: homeController.isLoading.value
						? null
						: () {
							if (_formKey.currentState!.validate()) {
							  homeController.wallPhotoOrder(
							  );
							} else {
							}
						  },*/
					  onPress: () async {
						  cartController.addToCart(
							productId,
							selectedPhoto, // Use the selected photo
							selectedPhotoId, // Use the selected photo id
							productData.name,
							productData.price,
						  );
						  print("Add to Cart completed");
						  SnackbarHelper.showSuccessSnackbar(
							title: Appcontent.snackbarTitleSuccess, 
							message: "Item added to cart successfully.",
							position: SnackPosition.BOTTOM, // Custom position
						  );
					  },  
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
    return Image.network(
      selectedPhoto,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
  }
}
