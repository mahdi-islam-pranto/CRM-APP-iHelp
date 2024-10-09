import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../API/api_url.dart';
import '../Dashboard/bottom_navigation_page.dart';
import '../Notification/notification_service.dart';
import '../components/CustomProgress.dart';

import '../resourses/app_colors.dart';
import '../resourses/resourses.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<UserLoginScreen> {
  late String email, password;
  late int userId;

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: backgroundColor,
              body: Stack(
                children: <Widget>[
                  // background image
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Image.asset(
                      'assets/images/union.png', // Update with your image path
                      width: MediaQuery.of(context).size.width / 2.5,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // forms and footer
                  Align(alignment: Alignment.center, child: _buildContainer()),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildInventor(),
                  )
                ],
              ))),
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                        color: const Color(0xFF232440),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                _buildEmailRow(),
                const SizedBox(height: 20),
                _buildPasswordRow(),

                // save password & forget password

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // save password
                    _buildSavePassword(),

                    // forget password
                    _buildForgetPassword()
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailRow() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6E6E82)),
          ),

          const SizedBox(
            height: 5,
          ),

          // Email form
          Form(
            key: emailKey,
            child: Container(
              height: 55.78,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  fillColor: const Color(0xFFF8F6F8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Container(
      height: 88.32,
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6E6E82)),
          ),

          // password form
          Form(
            key: passwordKey,
            child: Container(
              height: 55.78,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscured,
                focusNode: textFieldFocusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  hintText: 'At least 8 characters',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  fillColor: const Color(0xFFF8F6F8),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 24,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () {},
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  var _savePassword = false;
  Widget _buildSavePassword() {
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.blue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: _savePassword,
          onChanged: (value) {
            setState(() {
              _savePassword = value!;
            });
          },
        ),
        Text(
          "Save Password",
          style: TextStyle(
            color: R.appColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 52,
          width: 310,
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(164, 52),
              maximumSize: const Size(181, 52),
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              if (emailKey.currentState!.validate() &&
                  passwordKey.currentState!.validate()) {
                login();
              }
            },
            child: Text(
              "Log In",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: TextButton(
            onPressed: () {
              var url = Uri.parse("https://ihelpbd.com");
            },
            child: RichText(
              text: TextSpan(children: [
                const TextSpan(
                  text: 'Design & development by ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "iHelpBD",
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit?.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> login() async {
    var loginApiError = "";
    CustomProgress customProgress = CustomProgress(context);
    customProgress.showDialog(
        "Please wait", SimpleFontelicoProgressDialogType.spinner);

    try {
      // API URL
      String url = 'https://crm.ihelpbd.com/api/crm-app-login';

      // For testing purposes, use a static device token
      String deviceToken = await NotificationServices().getDeviceToken();

      if (deviceToken.isEmpty) {
        // Handle the case where the token couldn't be fetched
        customProgress.hideDialog();
        showErrorDialog(
            "Device token could not be retrieved. Please try again.");
        return;
      }

      print("User login device token: $deviceToken");

      // Send POST request
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
          'device_id': deviceToken,
        },
      );

      // Parse response
      var data = jsonDecode(response.body);

      print("Response data: $data");

      // Check response status
      if (response.statusCode == 200 && data['status'] == "200") {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        if (data['data'] != null && data['data']['token'] != null) {
          // Store token and other info
          sharedPreferences.setString("token", data['data']['token']);
          sharedPreferences.setBool("loginStatus", true);
          sharedPreferences.setString("name", data['data']['user']['name']);
          sharedPreferences.setString("email", email);
          sharedPreferences.setString("password", password);
          sharedPreferences.setString(
              "id", data['data']['user']['id'].toString());
          sharedPreferences.setString(
              "user_role", data['data']['user']['designation'].toString());

          // Print login details for debugging
          print("Email: $email");
          print("Password: $password");
          print("User Name: ${data['data']['user']['name']}");
          print("User ID: ${data['data']['user']['id']}");
          print("Token: ${data['data']['token']}");
          print("Message: ${data['message']}");

          // Hide progress
          customProgress.hideDialog();

          // Navigate to dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()),
          );
        } else {
          throw Exception("Invalid response structure");
        }
      } else {
        throw Exception(data['message'] ?? "Unknown error occurred");
      }
    } catch (e) {
      customProgress.hideDialog();
      showErrorDialog("Login failed: ${e.toString()}");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
