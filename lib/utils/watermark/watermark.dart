import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:image/image.dart' as ui;

import '../utils.dart';

Future<void> waterMarkPDF({
  required String path,
  bool? centerWatermark = false,
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

      //Get image data
      //File imageFile = File('assets/images/watermark.png');
      //Uint8List imagebytes = await imageFile.readAsBytes();

      // ByteData imageFile =
      //     await rootBundle.load('assets/images/watermark.png');
      // Uint8List imagebytes = imageFile.buffer
      //     .asUint8List(imageFile.offsetInBytes, imageFile.lengthInBytes);

      // String imageBase64 = base64.encode(imagebytes);

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

      //Draw the watermark text to the desired position over the PDF page with red color

      if (centerWatermark!) {
        graphics.drawString(
          'Confidential',
          font,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
            -size.width / 2,
            -size.height / 2,
            size.width,
            size.height,
          ),
        );
      } else {
        graphics.drawString(
          'Confidential',
          font,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
            -size.width / 2,
            -size.height / 2,
            size.width,
            size.height,
          ),
        );

        graphics.drawString(
          'Confidential',
          font,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
            -size.width / 3,
            -size.height * 2,
            size.width,
            size.height,
          ),
        );

        graphics.drawString(
          'Confidential',
          font,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
            -size.width / 3,
            -size.height * 3.5,
            size.width,
            size.height,
          ),
        );

        graphics.drawString(
          'Confidential',
          font,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
            -size.width / 1.5,
            size.height,
            size.width,
            size.height,
          ),
        );

        graphics.drawString(
          'Confidential',
          font,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
            -size.width / 2,
            size.height * 2.5,
            size.width,
            size.height,
          ),
        );
      }

      // graphics.drawImage(PdfBitmap.fromBase64String(imageBase64),
      //     Rect.fromLTWH(-size.width, -size.height, size.width, size.height));

      //Restore the graphics
      graphics.restore();
    }

    //Save the document
    List<int> bytes = await document.save();

    //Dispose the document
    document.dispose();

    //Save the file and launch/download
    SaveFile.saveAndLaunchFile(bytes, path.split('/').last);
  }
}

Future<Uint8List> waterMarkImage(
    {required String path, bool? centerWaterMark = false}) async {
  try {
    Uint8List inputBytes = File(path).readAsBytesSync();
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
      if (centerWaterMark!) {
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

      return watermarkedBytes;
    }
    return inputBytes;
  } catch (e) {
    throw Exception('Error when watermark!');
  }
}
