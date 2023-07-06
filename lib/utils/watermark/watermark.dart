import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_watermark/assets/assets.dart';
import 'package:flutter_watermark/utils/utils.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:image/image.dart' as ui;

Future<void> waterMarkPDF({
  required String path,
  bool centerWatermark = false,
  bool imageWatermark = false,
}) async {
  List<int> inputBytes = File(path).readAsBytesSync();

  if (inputBytes.isNotEmpty) {
    //Load the PDF document.
    PdfDocument document = PdfDocument(inputBytes: inputBytes);

    for (int i = 0; i < document.pages.count; i++) {
      //Get first page from document
      PdfPage page = document.pages[i];

      //Get page size
      Size pageSize = page.getClientSize();

      //Set a standard font
      PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 120);

      //Measure the text
      Size size = font.measureString('Confidential');

      //Create PDF graphics for the page
      PdfGraphics graphics = page.graphics;

      if (imageWatermark) {
        size = graphics.clientSize;
      }

      //Get image data
      //File imageFile = File('assets/images/watermark.png');
      //Uint8List imagebytes = await imageFile.readAsBytes();

      ByteData imageFile = await rootBundle.load(images['png']!);
      Uint8List imagebytes =
          imageFile.buffer.asUint8List(imageFile.offsetInBytes, imageFile.lengthInBytes);

      String imageBase64 = base64.encode(imagebytes);

      //Calculate the center point
      double x = pageSize.width / 2;
      double y = pageSize.height / 2;

      //Save the graphics state for the watermark text
      graphics.save();

      //Tranlate the transform with the center point.
      graphics.translateTransform(x, y);

      //Set transparency level for the text
      graphics.setTransparency(0.25);

      //Rotate the text to -40 Degree
      graphics.rotateTransform(-40);

      if (imageWatermark) {
        graphics.rotateTransform(40);
      }

      //Draw the watermark text to the desired position over the PDF page with red color
      if (centerWatermark && !imageWatermark) {
        pdfDrawStringCenter('Confidential', graphics, font, size);
      } else if (!centerWatermark && !imageWatermark) {
        pdfDrawStringFull('Confidential', graphics, font, size);
      } else {
        graphics.drawImage(
          PdfBitmap.fromBase64String(imageBase64),
          Rect.fromLTWH(
            -graphics.clientSize.width / 2,
            -graphics.clientSize.height / 2,
            graphics.clientSize.width,
            graphics.clientSize.height,
          ),
        );
      }

      //Restore the graphics
      graphics.restore();
    }

    //Save the document
    List<int> bytes = await document.save();

    //Dispose the document
    document.dispose();

    //Save the file and launch/download
    SaveFile.saveAndLaunchFile(bytes, handleFileName(path));
  }
}

Future<void> waterMarkImage({
  required String path,
  bool centerWatermark = false,
  bool imageWatermark = false,
}) async {
  try {
    Uint8List inputBytes = File(path).readAsBytesSync();

    ByteData data = await rootBundle.load(images['logo']!);

    Uint8List watermarkBytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    Uint8List? watermarkedBytes;

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
      if (centerWatermark && !imageWatermark) {
        watermarkedBytes = await ImageWatermark.addTextWatermarkCentered(
          imgBytes: inputBytes,
          watermarktext: waterMarkText,
          color: Colors.white,
        );
      } else if (!centerWatermark && !imageWatermark) {
        watermarkedBytes = await ImageWatermark.addTextWatermark(
          imgBytes: inputBytes,
          watermarkText: waterMarkText,
          color: Colors.white,
          dstX: xPos - 30,
          dstY: 30,
        );
      } else {
        int imgSize = 250;
        int xPos = (decodedImage.width).round() - (imgSize).round();
        int yPos = -(imgSize * 0.35).round();

        watermarkedBytes = await ImageWatermark.addImageWatermark(
          originalImageBytes: inputBytes,
          waterkmarkImageBytes: watermarkBytes,
          imgHeight: imgSize,
          imgWidth: imgSize,
          dstX: xPos + (imgSize * 0.07).round(),
          dstY: yPos,
        );

        if (centerWatermark) {
          xPos = (decodedImage.width / 2).round() - (imgSize / 2).round();
          yPos = (decodedImage.height / 2).round() - (imgSize / 2).round();
          watermarkedBytes = await ImageWatermark.addImageWatermark(
            originalImageBytes: inputBytes,
            waterkmarkImageBytes: watermarkBytes,
            imgHeight: imgSize,
            imgWidth: imgSize,
            dstX: xPos,
            dstY: yPos,
          );
        }
      }

      SaveFile.saveAndLaunchFile(watermarkedBytes, handleFileName(path));
    }
  } catch (e) {
    throw Exception('Error when watermark: $e');
  }
}
