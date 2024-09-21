import 'package:flutter/material.dart';

class CustomAlertDialog {
  static Future<void> showAlert(String message, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Warning"),
        content: Text(message,
            style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
