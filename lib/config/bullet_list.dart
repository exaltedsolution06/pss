import 'package:flutter/material.dart';

Widget customBulletList({
  required List<String> items,
  Color bulletColor = Colors.black,
  double bulletSize = 8.0,
  double bulletPadding = 16.0, // Space between the bullet and the text
  double bulletOffset = 0.0, // Adjust vertical alignment of the bullet
  TextStyle? textStyle,
}) {
  return ListView(
    shrinkWrap: true, // Ensures ListView takes up only the space it needs
    padding: EdgeInsets.zero,
    children: items.map((item) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
          children: [
            // Use Align with a Transform to fine-tune the bullet position
            Align(
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: Offset(0, bulletOffset), // Adjust the bullet position
                child: Container(
                  width: bulletSize,
                  height: bulletSize,
                  child: CustomPaint(
                    painter: BulletPainter(
                      color: bulletColor,
                      size: bulletSize,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: bulletPadding), // Space between the bullet and the text
            Expanded(
              child: Text(
                item,
                style: textStyle ?? TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

class BulletPainter extends CustomPainter {
  final Color color;
  final double size;

  BulletPainter({
    required this.color,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the bullet in the middle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // Centered position
      this.size / 2, // Radius of the bullet
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
