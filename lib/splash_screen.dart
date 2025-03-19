import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled1/resourses/resourses.dart';

import 'Auth/login_page.dart';
import 'Dashboard/bottom_navigation_page.dart';
import 'resourses/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loginStatus = false;

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: animatedIconShow(),
    );
  }

  // Show animated splash screen with spinner
  Widget animatedIconShow() {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center, // Centers both splash image and spinner
        children: [
          Center(
            child: AnimatedSplashScreen(
              splash: Image.asset("assets/images/ihelp_splash.png"),
              splashTransition: SplashTransition.scaleTransition,
              duration: 1500,
              nextScreen:
                  loginStatus ? BottomNavigationPage() : UserLoginScreen(),
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height *
                0.38, // Position spinner slightly above the bottom edge
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blue,
              size: 50,
            ), // Spinner animation
          ),
          Positioned(
            top: 40,
            right: 20,
            child: _buildTestButton(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildInventor(),
          )
        ],
      ),
    );
  }

  Future<void> isLogin() async {
    try {
      SharedPreferences ref = await SharedPreferences.getInstance();

      setState(() {
        loginStatus = ref.getBool("loginStatus") ?? false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        loginStatus = false;
      });
    }
  }

  Widget _buildTestButton() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed('/call_detection_test');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: const Text('Test Call Detection'),
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
}
