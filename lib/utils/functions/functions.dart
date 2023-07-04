import 'package:flutter/material.dart';
import 'package:flutter_watermark/application/application.dart';
import 'package:flutter_watermark/utils/utils.dart';
import 'package:intl/intl.dart';

Future<void> addWatermarkToPDF(
  BuildContext context, {
  required String path,
  bool centerWatermark = false,
  bool imageWatermark = false,
  bool isPreview = false,
}) async {
  Loading.show(context);

  await FileParse.parse(path).then((value) {
    if (isPreview) {
      navigate(
        context,
        PDFScreen(path: value.path, centerWatermark: centerWatermark),
      );
    } else {
      waterMarkPDF(
        path: value.path,
        centerWatermark: centerWatermark,
        imageWatermark: imageWatermark,
      );
    }
  }).then((value) => Loading.hide(context));
}

Future<void> addWatermarkToImage(
  BuildContext context, {
  required String path,
  bool centerWatermark = false,
  bool imageWatermark = false,
  bool isPreview = false,
}) async {
  Loading.show(context);

  await FileParse.parse(path).then((value) {
    if (isPreview) {
      navigate(
        context,
        ImageScreen(
          path: value.path,
          centerWatermark: centerWatermark,
          imageWatermark: imageWatermark,
        ),
      );
    } else {
      waterMarkImage(
        path: value.path,
        centerWatermark: centerWatermark,
        imageWatermark: imageWatermark,
      );
    }
  }).then((value) => Loading.hide(context));
}

Future<void> navigate(BuildContext context, Widget page) async {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  });
}

String handleFileName(String path) {
  final fileName = path.split('/').last;

  final first = fileName.split('.').first;

  final last = fileName.split('.').last;

  final now = DateTime.now();

  final nowFormat = DateFormat('yyyy_MM_dd_HHmmss').format(now).toString();

  return '${first}_$nowFormat.$last';
}
