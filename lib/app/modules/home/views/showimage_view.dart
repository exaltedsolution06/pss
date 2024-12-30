// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenImage extends StatelessWidget {
  String? imageUrl;
  String? tag;

  FullScreenImage({super.key, this.imageUrl, this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: tag ?? "",
                child: Image.network(
                  imageUrl ?? "",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
				  //fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey.shade700),
                  child: const Icon(Icons.close,color: Colors.white,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
