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

  List<String> selectedPhotos = [];
  List<String> selectedPhotoIds = [];
  Map<int, Offset> photoPositions = {}; // Stores individual positions for each image

  @override
  void initState() {
    super.initState();
    
    final arguments = Get.arguments ?? {};
    final int productId = arguments['productId'] ?? 0;

    productController.fetchProductData(productId);
  }
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final arguments = Get.arguments ?? {};
    final int productId = arguments['productId'] ?? 0;
    final File? imageFile = arguments['photoFile'] as File?;

    return Scaffold(
      appBar: AppBar(
        title: Text("Wall Photo View", style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Obx(() {
          final productData = productController.productData.value;
          if (productData == null) {
            return Center(child: CircularProgressIndicator());
          }

          final imageUrls = productData.fetchedFiles ?? [];
          final sizeHeight = productData.size_height ?? 0;
          final sizeWidth = productData.size_width ?? 0;

          return Column(
            children: [
              // Wall with selected photos
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Wall background
                    Container(
                      decoration: BoxDecoration(
                        image: imageFile != null
                            ? DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: imageFile == null ? Colors.grey[300] : null,
                      ),
                      child: Center(
                        child: Text(
                          'Your Wall',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
                    ),

                    // Display selected images on the wall (each can move individually)
                    for (int i = 0; i < selectedPhotos.length; i++)
                      Positioned(
                        left: photoPositions[i]?.dx ?? 150, // Default position
                        top: photoPositions[i]?.dy ?? 150,
                        child: Draggable(
                          feedback: selectedPhotoWidget(selectedPhotos[i], i, isDragging: true, sizeHeight: sizeHeight, sizeWidth: sizeWidth),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: selectedPhotoWidget(selectedPhotos[i], i, isDragging: false, sizeHeight: sizeHeight, sizeWidth: sizeWidth),
                          ),
                          /*onDragEnd: (details) {
                            setState(() {
                              photoPositions[i] = Offset(
                                details.offset.dx - MediaQuery.of(context).padding.left,
                                details.offset.dy - AppBar().preferredSize.height,
                              );
                            });
                          },*/
						  onDragEnd: (details) {
							RenderBox stackRenderBox = context.findRenderObject() as RenderBox;
							Offset localPosition = stackRenderBox.globalToLocal(details.offset);

							setState(() {
							  photoPositions[i] = Offset(
								localPosition.dx, 
								localPosition.dy - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
							  );
							});
						  },

                          child: selectedPhotoWidget(selectedPhotos[i], i, isDragging: false, sizeHeight: sizeHeight, sizeWidth: sizeWidth),
                        ),
                      ),
                  ],
                ),
              ),

              // Photo selection list
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final imagePath = imageUrls[index].filePath ?? '';
                    final imageId = imageUrls[index].id ?? '';

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedPhotos.contains(imagePath)) {
                            int removeIndex = selectedPhotos.indexOf(imagePath);
                            selectedPhotos.removeAt(removeIndex);
                            selectedPhotoIds.removeAt(removeIndex);
                            photoPositions.remove(removeIndex); // Remove position data
                          } else {
                            selectedPhotos.add(imagePath);
                            selectedPhotoIds.add(imageId);
                            photoPositions[selectedPhotos.length - 1] = Offset(150, 150);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.network(
                              imagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            if (selectedPhotos.contains(imagePath))
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Icon(Icons.check_circle, color: Colors.green, size: 20),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Add to Cart Button
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: autoWidthBtn(
                    text: 'Add to cart',
                    width: screenWidth,
                    onPress: selectedPhotos.isNotEmpty
                        ? () {
                            for (int i = 0; i < selectedPhotos.length; i++) {
                              cartController.addToCart(
                                productId,
                                selectedPhotos[i], // Image path
                                selectedPhotoIds[i], // Image ID
                                productData.name,
                                productData.price,
                              );
                            }
                            SnackbarHelper.showSuccessSnackbar(
                              title: Appcontent.snackbarTitleSuccess,
                              message: "All selected items added to cart successfully.",
                              position: SnackPosition.BOTTOM,
                            );
                          }
                        : null, // Disable button if no photo is selected
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }

  // Widget to display selected photo on the wall
  /*Widget selectedPhotoWidget(String photo, int index, {bool isDragging = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPhotos.removeAt(index);
          selectedPhotoIds.removeAt(index);
          photoPositions.remove(index);
        });
      },
      child: Stack(
        children: [
          Image.network(
            photo,
            width: isDragging ? 60 : 60,
            height: isDragging ? 60 : 60,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: -5,
            right: -5,
            child: Icon(Icons.cancel, color: Colors.red, size: 20), // Remove icon
          ),
        ],
      ),
    );
  }*/
  Widget selectedPhotoWidget(String photo, int index, {
  bool isDragging = false,
  required int sizeHeight,
  required int sizeWidth,
}) {
	  return GestureDetector(
		onTap: () {
		  setState(() {
			selectedPhotos.removeAt(index);
			selectedPhotoIds.removeAt(index);
			photoPositions.remove(index);
		  });
		},
		child: Container(
		  // Padding so icon can overflow without clipping
		  padding: const EdgeInsets.all(8.0),
		  child: Stack(
			clipBehavior: Clip.none, // Allow overflow
			children: [
			  Container(
				width: sizeWidth.toDouble(),
				height: sizeHeight.toDouble(),
				decoration: BoxDecoration(
				  borderRadius: BorderRadius.circular(4),
				  image: DecorationImage(
					image: NetworkImage(photo),
					fit: BoxFit.cover,
				  ),
				),
			  ),
			  Positioned(
				top: -8,
				right: -8,
				child: Container(
				  decoration: BoxDecoration(
					color: Colors.white,
					shape: BoxShape.circle,
					boxShadow: [
					  BoxShadow(
						color: Colors.black26,
						blurRadius: 4,
						offset: Offset(0, 2),
					  )
					],
				  ),
				  child: Icon(
					Icons.cancel,
					color: Colors.red,
					size: 20,
				  ),
				),
			  ),
			],
		  ),
		),
	  );
  }
}
