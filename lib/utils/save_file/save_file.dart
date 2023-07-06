import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    try {
      //Get directory path
      String dir = '/storage/emulated/0/Download';

      if (!Platform.isAndroid) {
        dir = (await getDownloadsDirectory())!.path;
      }

      // Check directory path
      if (!await Directory(dir).exists()) {
        await Directory(dir).create();
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
