import 'dart:io';
import 'package:flutter/material.dart';

class ImgContainer extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickImage;
  final bool isContentFocused;

  const ImgContainer({
    super.key,
    required this.imagePath,
    required this.onPickImage,
    required this.isContentFocused,
  });

  @override
  Widget build(BuildContext context) {
    double targetHeight = (isContentFocused || imagePath == null) ? 120 : 300;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      color: Color(0xFFC9C3CD),
      width: double.infinity,
      height: targetHeight,
      child: imagePath == null
          ? Center(
              heightFactor: 0.5,
              child: ElevatedButton(
                onPressed: onPickImage,
                style: ElevatedButton.styleFrom(
                  elevation: 0, // Remove harsh shadows
                  backgroundColor: Color.fromARGB(199, 135, 134, 134),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.all(12),
                  overlayColor: Color.fromARGB(255, 255, 255, 255),
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 203, 203, 203),
                  size: 25,
                ),
              ),
            )
          : Image.file(File(imagePath!), fit: BoxFit.cover),
    );
  }
}
