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
import 'package:flutter_html/flutter_html.dart';
import 'package:picturesourcesomerset/app/modules/order_screen/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import 'package:picturesourcesomerset/app/modules/product/models/product_data.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ProductView extends StatefulWidget {
  final String productId;

  ProductView({required this.productId});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.put(CartController());
  final ImagePicker _picker = ImagePicker();
  final TextEditingController reviewController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _reviewFocusNode = FocusNode();
  List<File> fetchedFiles = [];
  late final ObjectDetector _objectDetector;
  String detectionResult = '';

  @override
  void initState() {
    super.initState();
    _objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        classifyObjects: false,
        multipleObjects: true,
        mode: DetectionMode.single,
      ),
    );
    Future.delayed(Duration(milliseconds: 100), () {
      int parsedProductId = int.tryParse(widget.productId) ?? 0;
      productController.fetchProductData(parsedProductId);
      productData = ProductData();
    });
  }

  @override
  void dispose() {
    _objectDetector.close();
    _reviewFocusNode.dispose();
    reviewController.dispose();
    super.dispose();
  }

  late ProductData productData;
  FileData? firstValidFile;

  Future<void> _captureAndNavigate(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      File photoFile = File(photo.path);
      int parsedProductId = int.tryParse(widget.productId) ?? 0;

      if (photoFile.existsSync()) {
        final inputImage = InputImage.fromFile(photoFile);
        final List<DetectedObject> objects = await _objectDetector.processImage(inputImage);

        if (objects.isNotEmpty) {
          String result = '';
          for (var object in objects) {
            final rect = object.boundingBox;
            result += 'Object Detected:\n'
                'Left: ${rect.left.toStringAsFixed(2)}\n'
                'Top: ${rect.top.toStringAsFixed(2)}\n'
                'Width: ${rect.width.toStringAsFixed(2)}\n'
                'Height: ${rect.height.toStringAsFixed(2)}\n\n';
          }
          setState(() {
            detectionResult = result;
          });
        } else {
          setState(() {
            detectionResult = 'No objects detected.';
          });
        }

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
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColor.purple)));
        } else if (productController.productData.value == null) {
          return Center(child: Text("Error loading product data."));
        } else {
          final productData = productController.productData.value!;
          reviewController.text = productData.my_review ?? "";
          firstValidFile = productData.fetchedFiles!.firstWhere(
            (file) => file.filePath != null && file.filePath!.isNotEmpty,
            orElse: () => FileData(filePath: ''),
          );

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => _captureAndNavigate(context),
                      child: Text("View on Wall", style: TextStyle(fontSize: 16, color: AppColor.purple)),
                    ),
                  ),
                  if (detectionResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        detectionResult,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  // Rest of your product details widgets...
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
