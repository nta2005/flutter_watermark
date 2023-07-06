import 'package:flutter/material.dart';

class Alert {
  static void show(
    BuildContext context, {
    String title = 'AlertDialog Title',
    String content = 'AlertDialog Description',
    String titleCancel = 'CANCEL',
    String titleOk = 'OK',
    Function? pressCancel,
    Function? pressOk,
  }) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'OK');
              if (pressOk != null) {
                await Future.delayed(
                  const Duration(milliseconds: 100),
                  () => pressOk(),
                );
              }
            },
            child: Text(titleOk),
          ),
          TextButton(
            onPressed: () {
              pressCancel != null && pressCancel();
              Navigator.pop(context, 'CANCEL');
            },
            child: Text(titleCancel),
          ),
        ],
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
