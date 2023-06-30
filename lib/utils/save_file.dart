import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write data
    File file = File('$path/$fileName');
    //Write data
    await file.writeAsBytes(bytes, flush: true);
    //Open the file in mobile
    OpenFilex.open('$path/$fileName');
  }
}
