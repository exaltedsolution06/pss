import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picturesourcesomerset/config/app_contents.dart';
import 'package:picturesourcesomerset/config/common_bottom_navigation_bar.dart';
import 'package:picturesourcesomerset/app/modules/home/views/product_view.dart';

class SelectedCategory extends StatelessWidget {
  final String title;

  SelectedCategory({required this.title});

  final List<Map<String, String>> categoryItems = [
    {
      "image": Appcontent.pss1,
      "title": "Cityscapes",
      "description": "Skyscrapers, Lights, Motion, Streets, Energy.",
    },
    {
      "image": Appcontent.pss2,
      "title": "Florals",
      "description": "Light, Composition, Moment, Focus, Perspective.",
    },
    {
      "image": Appcontent.pss3,
      "title": "Coastal",
      "description": "Beaches, Waves, Sunset, Nature, Tranquility.",
    },
    {
      "image": Appcontent.pss4,
      "title": "Silhouettes",
      "description": "Shadows, Forms, Creativity, Simplicity.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Display the title passed as an argument
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2 / 3, // Adjust for image proportions
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return CategoryItemCard(
              image: item['image']!,
              title: item['title']!,
              description: item['description']!,
              onTap: () {
                print("clicked!!!");
                Get.to(() => ProductView());
              },
            );
          },
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }
}

class CategoryItemCard extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onTap;

  const CategoryItemCard({
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  _CategoryItemCardState createState() => _CategoryItemCardState();
}

class _CategoryItemCardState extends State<CategoryItemCard> {
  bool isWishlisted = false; // State to toggle wishlist

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Text and Wishlist Icon
            Positioned(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            // Wishlist Icon with Opacity Background
            Positioned(
              top: 8.0,
              right: 8.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isWishlisted = !isWishlisted; // Toggle state
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent background
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: isWishlisted ? Colors.red : Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
