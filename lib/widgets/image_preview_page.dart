import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatelessWidget {
  const ImagePreviewPage({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PhotoView(
            enableRotation: true,
            backgroundDecoration: BoxDecoration(color: Get.theme.canvasColor),
            imageProvider: NetworkImage(imagePath),
            loadingBuilder: (_, __) {
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
