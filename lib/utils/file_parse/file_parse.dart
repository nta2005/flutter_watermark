import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../utils.dart';

class FileParse {
  static Future<File> parse(String path) async {
    Completer<File> completer = Completer();

    try {
      if (!path.startsWith('http')) {
        final file = await fromAsset(path);
        completer.complete(file);
      } else {
        final file = await fromInternet(path);
        completer.complete(file);
      }
    } catch (e) {
      throw Exception('Error parsing file: $e');
    }

    return completer.future;
  }

  static Future<File> fromAsset(String asset) async {
    Completer<File> completer = Completer();

    String filename = File(asset).name;

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file: $e');
    }
    return completer.future;
  }

  static Future<File> fromInternet(String url) async {
    Completer<File> completer = Completer();

    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing internet file: $e');
    }

    return completer.future;
  }
}
