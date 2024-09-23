import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:untitled1/resourses/app_colors.dart';

// Custom Progress indicator

class CustomProgress {
  late SimpleFontelicoProgressDialog progressDialog;
  BuildContext context;

  CustomProgress(this.context);

  // Show progress
  void showDialog(
      String message, SimpleFontelicoProgressDialogType type) async {
    progressDialog = await SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: true);
    progressDialog.show(
        message: message, type: type, indicatorColor: Colors.blue);
  }

  // hide progress
  void hideDialog() async {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
