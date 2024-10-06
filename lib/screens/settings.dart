import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../Dashboard/bottom_navigation_page.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18, // Replace with the desired custom icon
          ),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const BottomNavigationPage();
              },
              curve: Curves.fastOutSlowIn,
              duration: const Duration(seconds: 1),
            );
          },
        ),
        centerTitle: true,
      ),
    );
  }
}
