import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/firebase_options.dart';
import 'package:untitled1/services/service_initializer.dart';
import 'package:untitled1/test-pages/call_detection_test_page.dart';
import 'dependency_injection.dart';
import 'splash_screen.dart';

// Import placeholder pages for lead details and creation
// Replace these with your actual lead pages when available
class LeadDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final leadId = args?['id'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text('Lead Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lead ID: $leadId', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class LeadCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final phoneNumber = args?['phoneNumber'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Create Lead')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Task Create Page
class TaskCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final leadId = args?['leadId'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text('Create Task')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Task for Lead ID: $leadId',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Follow-Up Create Page
class FollowUpCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final leadId = args?['leadId'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text('Create Follow-Up')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Follow-Up for Lead ID: $leadId',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Lead Pipeline Update Page
class LeadPipelineUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final leadId = args?['leadId'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text('Update Pipeline')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Update Pipeline for Lead ID: $leadId',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  HttpOverrides.global = MyHttpOverrides();

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
    // NotificationHandler.initialize();
  } catch (e, tr) {
    log("Error :::: => ${e.toString()}");
    tr.printError();
  }

  runApp(const MyApp());
  DependencyInjection.init();
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
        home: ServiceInitializer(
          child: const SplashScreen(),
        ),
        getPages: [
          GetPage(
            name: '/call_detection_test',
            page: () => const CallDetectionTestPage(),
          ),
          GetPage(
            name: '/lead/details',
            page: () => LeadDetailsPage(),
          ),
          GetPage(
            name: '/lead/create',
            page: () => LeadCreatePage(),
          ),
          GetPage(
            name: '/tasks/create',
            page: () => TaskCreatePage(),
          ),
          GetPage(
            name: '/followups/create',
            page: () => FollowUpCreatePage(),
          ),
          GetPage(
            name: '/lead/update-pipeline',
            page: () => LeadPipelineUpdatePage(),
          ),
        ],
        onInit: () {
          // Handle deep linking from the overlay
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleInitialIntent();
          });
        },
      ),
    );
  }

  // Handle the initial intent when the app is opened from the overlay
  Future<void> _handleInitialIntent() async {
    try {
      final intent =
          await const MethodChannel('com.example.untitled1/call_detection')
              .invokeMethod<Map<dynamic, dynamic>>('getInitialIntent');

      if (intent != null && intent.containsKey('action')) {
        final action = intent['action'] as String;

        if (action == 'view_lead' && intent.containsKey('lead_id')) {
          final leadId = intent['lead_id'] as int;
          Get.toNamed('/lead/details', arguments: {'id': leadId});
        } else if (action == 'add_lead' && intent.containsKey('phone_number')) {
          final phoneNumber = intent['phone_number'] as String;
          Get.toNamed('/lead/create', arguments: {'phoneNumber': phoneNumber});
        } else if (action == 'create_task' && intent.containsKey('lead_id')) {
          final leadId = intent['lead_id'] as int;
          // Navigate to the task creation screen with the lead ID
          Get.toNamed('/tasks/create', arguments: {'leadId': leadId});
        } else if (action == 'create_followup' &&
            intent.containsKey('lead_id')) {
          final leadId = intent['lead_id'] as int;
          // Navigate to the follow-up creation screen with the lead ID
          Get.toNamed('/followups/create', arguments: {'leadId': leadId});
        } else if (action == 'update_pipeline' &&
            intent.containsKey('lead_id')) {
          final leadId = intent['lead_id'] as int;
          // Navigate to the pipeline update screen with the lead ID
          Get.toNamed('/lead/update-pipeline', arguments: {'leadId': leadId});
        }
      }
    } catch (e) {
      print('Error handling initial intent: $e');
    }
  }
}
