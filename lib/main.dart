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
import 'package:untitled1/test-pages/background_service_test_page.dart';
import 'package:untitled1/widgets/system_overlay_widget.dart';
import 'package:untitled1/services/call_detection_service.dart';
import 'package:untitled1/Models/LeadListModel.dart';
import 'Task/leadTaskCreateForm.dart';
import 'FollowUP/leadFollowUpCreate.dart';
import 'dependency_injection.dart';
import 'screens/leadDetailsTabs.dart';
import 'splash_screen.dart';

// Import placeholder pages for lead details and creation
// Replace these with your actual lead pages when available

class LeadCreatePage extends StatelessWidget {
  const LeadCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final phoneNumber = args?['phoneNumber'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Create Lead')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Phone Number: $phoneNumber',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Back'),
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
        home: const ServiceInitializer(
          child: SplashScreen(),
        ),
        getPages: [
          GetPage(
            name: '/call_detection_test',
            page: () => const CallDetectionTestPage(),
          ),
          GetPage(
            name: '/background_service_test',
            page: () => const BackgroundServiceTestPage(),
          ),
          GetPage(
            name: '/lead/details',
            page: () {
              final args = Get.arguments as Map<String, dynamic>?;
              final leadId = args?['id'] ?? 0;
              return LeadDetailsTabs(leadId: leadId);
            },
          ),
          GetPage(
            name: '/lead/create',
            page: () => const LeadCreatePage(),
          ),
          GetPage(
            name: '/tasks/create',
            page: () {
              final args = Get.arguments as Map<String, dynamic>?;
              final leadId = args?['leadId'] ?? 0;
              return LeadTaskCreateForm(leadId: leadId);
            },
          ),
          GetPage(
            name: '/followups/create',
            page: () {
              final args = Get.arguments as Map<String, dynamic>?;
              final leadId = args?['leadId'] ?? 0;
              return LeadFollowUpCreate(leadId: leadId);
            },
          ),
          GetPage(
            name: '/lead/update-pipeline',
            page: () {
              final args = Get.arguments as Map<String, dynamic>?;
              final leadId = args?['leadId'] ?? 0;
              return LeadDetailsTabs(
                  leadId:
                      leadId); // Navigate to lead details for pipeline update
            },
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
          final phoneNumber = intent['phone_number'] as String? ?? '';
          // Show SystemOverlayWidget first, then navigate to lead details
          _showSystemOverlayForLead(leadId, phoneNumber,
              defaultAction: 'view_details');
        } else if (action == 'add_lead' && intent.containsKey('phone_number')) {
          final phoneNumber = intent['phone_number'] as String;
          Get.toNamed('/lead/create', arguments: {'phoneNumber': phoneNumber});
        } else if (action == 'create_task' && intent.containsKey('lead_id')) {
          final leadId = intent['lead_id'] as int;
          final phoneNumber = intent['phone_number'] as String? ?? '';
          // Show SystemOverlayWidget first, then navigate to task creation
          _showSystemOverlayForLead(leadId, phoneNumber,
              defaultAction: 'create_task');
        } else if (action == 'create_followup' &&
            intent.containsKey('lead_id')) {
          final leadId = intent['lead_id'] as int;
          final phoneNumber = intent['phone_number'] as String? ?? '';
          // Show SystemOverlayWidget first, then navigate to follow-up creation
          _showSystemOverlayForLead(leadId, phoneNumber,
              defaultAction: 'create_followup');
        } else if (action == 'update_pipeline' &&
            intent.containsKey('lead_id')) {
          final leadId = intent['lead_id'] as int;
          final phoneNumber = intent['phone_number'] as String? ?? '';
          // Show SystemOverlayWidget first, then navigate to pipeline update
          _showSystemOverlayForLead(leadId, phoneNumber,
              defaultAction: 'update_pipeline');
        }
      }
    } catch (e) {
      print('Error handling initial intent: $e');
    }
  }

  // Show SystemOverlayWidget for a specific lead
  Future<void> _showSystemOverlayForLead(int leadId, String phoneNumber,
      {String? defaultAction}) async {
    try {
      final callDetectionService = Get.find<CallDetectionService>();

      // Find the lead by ID
      final lead = callDetectionService.leads.firstWhere(
        (lead) => lead.id == leadId,
        orElse: () => LeadListModel(
          id: leadId,
          // company name
          companyName: 'Unknown Company',
          phoneNumber: phoneNumber,
          associates: [],
        ),
      );

      // Show the SystemOverlayWidget as a bottom sheet
      Get.bottomSheet(
        SystemOverlayWidget(lead: lead),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
      );

      // If there's a default action, perform it after a short delay
      if (defaultAction != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          // Close the SystemOverlayWidget first
          if (Get.isBottomSheetOpen == true) {
            Get.back();
          }

          switch (defaultAction) {
            case 'view_details':
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => LeadDetailsTabs(leadId: leadId),
                ),
              );
              break;
            case 'create_task':
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => LeadTaskCreateForm(leadId: leadId),
                ),
              );
              break;
            case 'create_followup':
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => LeadFollowUpCreate(leadId: leadId),
                ),
              );
              break;
            case 'update_pipeline':
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => LeadDetailsTabs(leadId: leadId),
                ),
              );
              break;
          }
        });
      }
    } catch (e) {
      print('Error showing system overlay for lead: $e');
      // Fallback to direct navigation if overlay fails
      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => LeadDetailsTabs(leadId: leadId),
        ),
      );
    }
  }
}
