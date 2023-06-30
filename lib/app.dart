import 'package:flutter/material.dart';
import 'package:flutter_watermark/assets/assets.dart';
import 'package:flutter_watermark/utils/file_parse.dart';
import 'package:flutter_watermark/pages/pages.dart';
import 'package:flutter_watermark/utils/watermark.dart';

class App extends StatefulWidget {
  const App({super.key, this.isPreview = false});

  final bool? isPreview;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLoading = true;

  Future<void> pdfLocalPath() async {
    String localPDF = pdf[1];
    await FileParse.fromAsset(localPDF).then((value) {
      if (value.path.isNotEmpty) {
        widget.isPreview!
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFScreen(path: value.path),
                ),
              )
            : addWatermarkToPDF(path: value.path, centerWatermark: true);
      }
    });
  }

  Future<void> pdfRemotePath() async {
    String remotePDF = pdfRemotes[0];
    await FileParse.fromInternet(remotePDF).then((value) {
      if (value.path.isNotEmpty) {
        widget.isPreview!
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFScreen(path: value.path),
                ),
              )
            : addWatermarkToPDF(path: value.path);
      }
    });
  }

  Future<void> imageLocalPath() async {
    String? localImage = images['jpg'];
    await FileParse.fromAsset(localImage!).then((value) {
      if (value.path.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageScreen(path: value.path),
          ),
        );
      }
    });
  }

  Future<void> imageRemotePath() async {
    String remoteImage = imageRemotes[0];
    await FileParse.fromInternet(remoteImage).then((value) {
      if (value.path.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageScreen(path: value.path),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: pdfLocalPath,
              child: const Text("Local PDF"),
            ),
            TextButton(
              onPressed: pdfRemotePath,
              child: const Text("Remote PDF"),
            ),
            TextButton(
              onPressed: imageLocalPath,
              child: const Text("Image Local"),
            ),
            TextButton(
              onPressed: imageRemotePath,
              child: const Text("Image Online"),
            ),
          ],
        ),
      ),
    );
  }
}
