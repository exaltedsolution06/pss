import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const CategoryCard({
    required this.image,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded corners for the Card itself
        ),
        child: Stack(
          children: [
            // Image in the background with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0), // Apply rounded corners to the image
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity, // Ensure the image fills the space
              ),
            ),
            // Text overlayed on top of the image
            Positioned(
              bottom: 8.0,  // Position the text near the bottom
              left: 0.0,    // Add some padding from the left
              right: 0.0,   // Add some padding from the right
              child: Container(
                color: Colors.black.withOpacity(0.2), // Semi-transparent background for text
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,  // White color text to contrast with background
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
