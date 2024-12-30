import 'package:flutter/material.dart';
import 'package:picturesourcesomerset/config/app_color.dart';


class CustomModal extends StatelessWidget {
  final Widget content;
  final String title;
  final Function onClose;

  CustomModal({
    required this.content,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                GestureDetector(
                  onTap: () => onClose(),
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Flexible(
              child: SingleChildScrollView(
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
