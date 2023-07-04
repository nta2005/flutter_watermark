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
          children: [
            ...renderButton(),
          ],
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
        return addWatermarkToPDF(
          context,
          path: pdf[1],
          centerWatermark: true,
          isPreview: isPreview,
        );

      case 'remotePDF':
        return addWatermarkToPDF(
          context,
          path: pdfRemotes[0],
          imageWatermark: true,
          isPreview: isPreview,
        );

      case 'localImage':
        return addWatermarkToImage(
          context,
          path: images['jpg']!,
          centerWatermark: true,
          isPreview: isPreview,
        );

      case 'remoteImage':
        return addWatermarkToImage(
          context,
          path: imageRemotes[0],
          imageWatermark: true,
          isPreview: isPreview,
        );

      default:
        throw Exception('Unknown button type: $type');
    }
  }
}
