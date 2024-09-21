import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/CustomProgress.dart';

import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../API/api_url.dart';
import 'login_page.dart';

class Logout {
  BuildContext context;

  Logout(this.context);

  // Logout Method
  Future<void> logout() async {
    try {
      // Show logout alert dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Warning"),
          content: const Text('Do you want to logout?',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Call the logout API and clear preferences
                logoutAPI();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error showing logout dialog: $e");
    }
  }

  // Logout API Method
  Future<void> logoutAPI() async {
    CustomProgress customProgress = CustomProgress(context);
    try {
      customProgress.showDialog(
          "Logging out", SimpleFontelicoProgressDialogType.spinner);

      // Retrieve token from SharedPreferences
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("token");
      //print(token);

      if (token == null) {
        throw Exception("Token not found");
      }

      // API url
      String url = ApiUrls.logoutUrl;

      // Make a POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
          'Cookie': 'XSRF-TOKEN=<your-cookie-here>',
        },
      );

      if (response.statusCode == 200) {
        // Logout success
        sharedPreferences.clear(); // Clear all saved data
        customProgress.hideDialog();
        log("user logged out");

        // Navigate to the login screen or show a success message
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserLoginScreen()));
      } else {
        // Logout failed
        customProgress.hideDialog();
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Logout Error",
              style: TextStyle(color: Colors.green),
            ),
            content: const Text("Failed to log out. Please try again.",
                style: TextStyle(color: Colors.red)),
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
    } catch (e) {
      // Handle exceptions
      customProgress.hideDialog();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Logout Error",
            style: TextStyle(color: Colors.green),
          ),
          content: Text(
            "An error occurred: ${e.toString()}",
            style: const TextStyle(color: Colors.red),
          ),
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

  Future<void> showErrorDialog(String title, String content) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content, style: const TextStyle(color: Colors.red)),
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
