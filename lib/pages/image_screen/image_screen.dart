import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_watermark/utils/constants.dart';
import 'package:flutter_watermark/utils/save_file.dart'
    if (dart.library.html) 'package:flutter_watermark/utils/save_file_web.dart';
import 'package:image_watermark/image_watermark.dart';
import 'dart:developer' as dev;
import 'package:image/image.dart' as ui;

class ImageScreen extends StatefulWidget {
  const ImageScreen({
    super.key,
    required this.path,
    this.centerWaterMark = false,
  });

  final String path;
  final bool? centerWaterMark;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  String imagePath = '';
  Uint8List? image;

  @override
  void initState() {
    waterMarkImage();
    super.initState();
  }

  Future<void> waterMarkImage() async {
    dev.log(widget.path);
    Uint8List inputBytes = File(widget.path).readAsBytesSync();
    Uint8List watermarkedBytes;

    final decodedImage = await decodeImageFromList(inputBytes);

    var stringWidth = 0;
    var stringHeight = 0;

    final font = ui.arial_48;

    final chars = waterMarkText.codeUnits;

    for (var c in chars) {
      final ch = font.characters[c]!;
      stringWidth += ch.xadvance;
      if (ch.height + ch.yoffset > stringHeight) {
        stringHeight = ch.height + ch.yoffset;
      }
    }

    int xPos = (decodedImage.width).round() - (stringWidth).round();

    if (inputBytes.isNotEmpty) {
      if (widget.centerWaterMark!) {
        watermarkedBytes = await ImageWatermark.addTextWatermarkCentered(
          imgBytes: inputBytes,
          watermarktext: waterMarkText,
          color: Colors.white,
        );
      } else {
        watermarkedBytes = await ImageWatermark.addTextWatermark(
          imgBytes: inputBytes,
          watermarkText: waterMarkText,
          color: Colors.white,
          dstX: xPos - 30,
          dstY: 30,
        );
      }

      if (watermarkedBytes.isNotEmpty) {
        setState(() => image = watermarkedBytes);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: image == null
                  ? const CircularProgressIndicator()
                  : Image.memory(image!),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              onPressed: () {
                SaveFile.saveAndLaunchFile(image!, widget.path.split('/').last);
              },
              child: const Text(
                'Save file',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
