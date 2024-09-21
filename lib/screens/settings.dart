import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../Dashboard/bottom_navigation_page.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18, // Replace with the desired custom icon
          ),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return BottomNavigationPage();
              },
              curve: Curves.fastOutSlowIn,
              duration: Duration(seconds: 1),
            );
          },
        ),
        centerTitle: true,
      ),
    );
  }
}
