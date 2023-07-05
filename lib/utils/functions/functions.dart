import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watermark/application/application.dart';
import 'package:flutter_watermark/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;

export 'pdf_draw.dart';

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
  final file = path.split('/').last;

  final name = file.split('.').first;

  final ext = file.split('.').last;

  final now = DateFormat('dd_MM_yyyy_HHmmss').format(DateTime.now()).toString();

  final nameHandle = '${name}_$now.$ext';

  dev.log('File: $nameHandle');

  return nameHandle;
}

checkStoragePermission() async {
  PermissionStatus status;
  if (Platform.isAndroid) {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    if ((info.version.sdkInt) >= 33) {
      status = await Permission.manageExternalStorage.request();
      status = await Permission.photos.request();
      status = await Permission.videos.request();
    } else {
      status = await Permission.storage.request();
    }
  } else {
    status = await Permission.storage.request();
  }

  dev.log('Permission Status: $status');

  switch (status) {
    case PermissionStatus.denied:
      openAppSettings();
      return false;
    case PermissionStatus.granted:
      return true;
    case PermissionStatus.restricted:
      openAppSettings();
      return false;
    case PermissionStatus.limited:
      return true;
    case PermissionStatus.permanentlyDenied:
      openAppSettings();
      return false;
    default:
      openAppSettings();
      return false;
  }
}
