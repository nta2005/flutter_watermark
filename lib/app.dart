import 'package:flutter/material.dart';
import 'application/application.dart';
import 'assets/assets.dart';
import 'utils/utils.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isPreview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: renderButton(),
        ),
      ),
    );
  }

  List<Widget> renderButton() {
    return buttons.map((item) {
      return ButtonText(
        title: item['title']!,
        onPress: () {
          handleButtonType(item['type']!);
        },
      );
    }).toList();
  }

  Future<void> handleButtonType(String type) {
    switch (type) {
      case 'localPDF':
        return addWatermarkToPDF(path: pdf[1], centerWatermark: true);

      case 'remotePDF':
        return addWatermarkToPDF(path: pdfRemotes[0]);

      case 'localImage':
        return addWatermarkToImage(path: images['jpg']!, centerWatermark: true);

      case 'remoteImage':
        return addWatermarkToImage(path: imageRemotes[0]);

      default:
        throw Exception('Unknown button type: $type');
    }
  }

  Future<void> addWatermarkToPDF({
    required String path,
    bool? centerWatermark = false,
  }) async {
    Loading.show(context);

    await FileParse.parse(path).then((value) {
      if (isPreview) {
        navigate(PDFScreen(path: value.path, centerWatermark: centerWatermark));
      } else {
        waterMarkPDF(path: value.path, centerWatermark: centerWatermark);
      }
    }).then((value) => Loading.hide(context));
  }

  Future<void> addWatermarkToImage(
      {required String path, bool? centerWatermark = false}) async {
    Loading.show(context);

    await FileParse.parse(path).then((value) {
      if (isPreview) {
        navigate(
          ImageScreen(path: value.path, centerWatermark: centerWatermark),
        );
      } else {
        waterMarkImage(path: value.path, centerWatermark: centerWatermark);
      }
    }).then((value) => Loading.hide(context));
  }

  Future<void> navigate(Widget page) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    });
  }
}
