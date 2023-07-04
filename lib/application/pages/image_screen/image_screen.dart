import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_watermark/application/application.dart';
import 'package:flutter_watermark/utils/utils.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    super.key,
    required this.path,
    this.centerWatermark = false,
    this.imageWatermark = false,
  });

  final String path;
  final bool centerWatermark;
  final bool imageWatermark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Image.file(File(path)),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.blue),
              ),
              onPressed: () {
                Loading.show(context);
                Future.delayed(const Duration(seconds: 1), () {
                  waterMarkImage(
                    path: path,
                    centerWatermark: centerWatermark,
                    imageWatermark: imageWatermark,
                  );
                }).then((value) => Loading.hide(context));
              },
              child: const Text(
                'Add watermark',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
