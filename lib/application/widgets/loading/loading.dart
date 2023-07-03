import 'package:flutter/material.dart';

class Loading {
  static void show(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
