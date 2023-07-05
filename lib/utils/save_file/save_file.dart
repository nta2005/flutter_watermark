import 'dart:io';

import 'package:flutter_watermark/utils/functions/functions.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  static Future<void> saveAndLaunch(List<int> bytes, String fileName, {bool public = false}) async {
    try {
      //Get directory path
      String dir = (await getApplicationSupportDirectory()).path;

      if (public) {
        //Check permission
        bool permissionStatus = await checkStoragePermission();

        if (permissionStatus) {
          dir = '/storage/emulated/0/Download';

          if (!Platform.isAndroid) {
            dir = (await getDownloadsDirectory())!.path;
          }

          // Check directory path
          if (!await Directory(dir).exists()) {
            await Directory(dir).create();
          }
        }
      }

      // Create an empty file to write data
      File file = File('$dir/$fileName');
      // Write data
      await file.writeAsBytes(bytes, flush: true);
      // Open the file in mobile
      OpenFilex.open('$dir/$fileName');
    } catch (e) {
      throw Exception('Error when save file: $e');
    }
  }
}
