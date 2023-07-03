import 'package:flutter/material.dart';
import 'application/application.dart';
import 'assets/assets.dart';
import 'utils/utils.dart';

class App extends StatefulWidget {
  const App({super.key, this.isPreview = false});

  final bool? isPreview;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonText(
              title: 'Local PDF',
              onPress: () {
                String localPDF = pdf[1];
                pdfPath(localPDF);
              },
            ),
            ButtonText(
              title: 'Remote PDF',
              onPress: () {
                String remotePDF = pdfRemotes[0];
                pdfPath(remotePDF);
              },
            ),
            ButtonText(
              title: 'Image Local',
              onPress: () {
                String? localImage = images['jpg'];
                imagePath(localImage!);
              },
            ),
            ButtonText(
              title: 'Image Online',
              onPress: () {
                String remoteImage = imageRemotes[0];
                imagePath(remoteImage);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pdfPath(String path) async {
    // String localPDF = pdf[1];
    // String remotePDF = pdfRemotes[0];

    Loading.show(context);

    await FileParse.parse(path).then((value) {
      if (widget.isPreview!) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(path: value.path),
          ),
        );
      } else {
        waterMarkPDF(path: value.path);
      }
    }).then((value) => Loading.hide(context));
  }

  Future<void> imagePath(String path) async {
    // String? localImage = images['jpg'];
    // String remoteImage = imageRemotes[0];

    String fileName = path.split('/').last;

    Loading.show(context);

    await FileParse.parse(path).then((value) {
      waterMarkImage(path: value.path).then((image) => {
            if (widget.isPreview!)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageScreen(image: image),
                  ),
                ),
              }
            else
              {SaveFile.saveAndLaunchFile(image, fileName)}
          });
    }).then((value) => Loading.hide(context));
  }
}
