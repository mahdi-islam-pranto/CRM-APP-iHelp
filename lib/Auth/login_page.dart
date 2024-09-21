import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:untitled1/Dashboard/bottom_navigation_page.dart';
import 'package:untitled1/components/CustomProgress.dart';
import '../API/api_url.dart';
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
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: R.appColors.buttonColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLogo(),
                _buildContainer(),
                _buildInventor(),
              ],
            )
          ],
        ),
      )),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'iCRM',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ],
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
            decoration: const BoxDecoration(
              color: Colors.white,
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
                        color: R.appColors.grey,
                      ),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                _buildForgetPassword(),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: emailKey,
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
              prefixIcon: Icon(
                Icons.email,
                color: R.appColors.buttonColor,
              ),
              labelText: 'E-mail'),
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: passwordKey,
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
            prefixIcon: Icon(
              Icons.lock,
              color: R.appColors.buttonColor,
            ),
            labelText: 'Password',
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
              child: GestureDetector(
                onTap: _toggleObscured,
                child: Icon(
                  _obscured
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
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
          child: Text(
            "Forgot Password?",
            style: TextStyle(
              color: R.appColors.grey,
            ),
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
          height: 1.4 * (MediaQuery.of(context).size.height / 22),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
              R.appColors.buttonColor,
            )),
            onPressed: () {
              if (emailKey.currentState!.validate() &&
                  passwordKey.currentState!.validate()) {
                login();
              }
            },
            child: Text(
              "Login",
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
                TextSpan(
                  text: 'Developed by ',
                  style: TextStyle(
                    color: const Color.fromRGBO(38, 35, 38, 0.4470588235294118),
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "iHelpBD",
                  style: TextStyle(
                    color: R.appColors.buttonColor,
                    fontSize: MediaQuery.of(context).size.height / 40,
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
      String url = ApiUrls.loginUrl;

      // Send POST request
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      // Parse response
      var data = jsonDecode(response.body);

      print("Response data: $data");

      // Check response status
      if (response.statusCode == 200) {
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


          // Print email, password, and token
          print("Email: ${email}");
          print("Password: ${password}");
          print("User Name: ${data['data']['user']['name']}");
          print("User ID: ${data['data']['user']['id']}");
          print("Token: ${data['data']['token']}");
          print("Message: ${data['message']}");

          // Store the API error message
          loginApiError = data['message'];

          // Hide progress
          customProgress.hideDialog();

          // Navigate to dashboard
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return const BottomNavigationPage();
            },
            animationType: DialogTransitionType.fadeScale,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          customProgress.hideDialog();
          showErrorDialog("Login failed: Invalid credentials or no token.");
        }
      } else {
        customProgress.hideDialog();
        showErrorDialog("Login failed: ${data['message'] ?? 'Unknown error.'}");
      }
    } catch (e) {
      customProgress.hideDialog();
      showErrorDialog("Invalid Email And Password");
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
