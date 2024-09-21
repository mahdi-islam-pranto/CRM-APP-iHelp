import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled1/resourses/resourses.dart';

import 'Auth/login_page.dart';
import 'Dashboard/bottom_navigation_page.dart';

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
              splash: Image.asset("assets/images/ihelpbd.png"),
              splashTransition: SplashTransition.scaleTransition,
              duration: 1500,
              nextScreen:
                  loginStatus ? BottomNavigationPage() : UserLoginScreen(),
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height *
                0.38, // Position spinner slightly above the bottom edge
            child: R.appSpinKits.spinKitFadingCube, // Spinner animation
          ),
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
}
