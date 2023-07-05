import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void pdfDrawStringCenter(
  String string,
  PdfGraphics graphics,
  PdfFont font,
  Size size,
) {
  graphics.drawString(
    string,
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
}

// Testing
void pdfDrawStringFull(
  String string,
  PdfGraphics graphics,
  PdfFont font,
  Size size,
) {
  graphics.drawString(
    string,
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
    string,
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
    string,
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
    string,
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
    string,
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
