import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/firebase_options.dart';
import 'dependency_injection.dart';
import 'splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
//new
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  navigatorKey;

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  HttpOverrides.global = MyHttpOverrides();

  try {
    requestPermissions();

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

/// neew for incoming call


    // NotificationHandler.initialize();
  } catch (e, tr) {
    log("Error :::: => ${e.toString()}");
    tr.printError();
  }

  runApp(const MyApp());
  DependencyInjection.init();
}

Future<void> requestPermissions() async {
  print('request::::::: ${Permission.contacts}');
  await Permission.contacts.request();
  await Permission.systemAlertWindow.request();
}



Future<void> _firebaseMassageingBackgroundHandeler(
    RemoteMessage massage) async {
  print(":::::::::::::::::::::::::: ${massage.notification?.title.toString()}");
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.light),
          useMaterial3: true,
          fontFamily: 'Inter18',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
