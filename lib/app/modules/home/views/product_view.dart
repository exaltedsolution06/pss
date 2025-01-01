import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';


class ProductView extends StatelessWidget {
  final List<String> imageUrls = [
    Appcontent.pss1,
    Appcontent.pss2,
    Appcontent.pss3,
	Appcontent.pss4,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
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
							style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
						),
						Row(
						  mainAxisAlignment: MainAxisAlignment.spaceBetween,
						  children: [
							Text(
							  "Left Text",
							  style: TextStyle(fontSize: 14),
							),
							Text(
							  "Right Text",
							  style: TextStyle(fontSize: 14),
							),
						  ],
						),

					],
				),
			),
            // Image Slider
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

            // Product Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
					Row(
					  mainAxisAlignment: MainAxisAlignment.spaceBetween,
					  children: [
						// Left Text
						Expanded(
						  child: Text(
							"Left Text",
							textAlign: TextAlign.left,
							style: TextStyle(fontSize: 16),
						  ),
						),
						// Center Text
						Expanded(
						  child: Text(
							"Center Text",
							textAlign: TextAlign.center,
							style: TextStyle(fontSize: 16),
						  ),
						),
						// Right Text
						Expanded(
						  child: Text(
							"Right Text",
							textAlign: TextAlign.right,
							style: TextStyle(fontSize: 16),
						  ),
						),
					  ],
					),

                  const Text(
                    "057BU-F",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text("Artist: BUSTAMONTE"),
                  const SizedBox(height: 10),
                  const Text(
                    "EXCLUSIVE SILK SCREEN ENHANCED w/GEL BRUSHSTROKES AND COLOR ACCENTS",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "• Moulding: BW8004\n"
                    "• Moulding Description: 2 DK KNOTTY PINE, ROUNDED w/STEPS (9) (B)\n"
                    "• Dimensions: 75 3/8 x 49 3/8",
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Rs. 25",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
					  onPressed: () {
						// Define your action here
					  },
					  style: ElevatedButton.styleFrom(
						backgroundColor: Colors.red, // Use this instead of 'primary'
					  ),
					  child: const Text("Add to Cart"),
					),

                ],
              ),
            ),
            const Divider(),

            // Reviews Section
            Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Reviews",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          const Text(
            "4.4",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("5 "),
                  SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(
                      value: 0.67,
                      color: Colors.red,
                      backgroundColor: Colors.grey[300],
                      minHeight: 8,
                    ),
                  ),
                  const Text(" 67%"),
                ],
              ),
              Row(
                children: [
                  const Text("4 "),
                  SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(
                      value: 0.2,
                      color: Colors.red,
                      backgroundColor: Colors.grey[300],
                      minHeight: 8,
                    ),
                  ),
                  const Text(" 20%"),
                ],
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 20),
      TextFormField(
        maxLines: 3,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Write a Review",
          hintText: "Share your thoughts...",
        ),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Text("Send Review"),
      ),
    ],
  ),
),

          ],
        ),
      ),
	  bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }
}

