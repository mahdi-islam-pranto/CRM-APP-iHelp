import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      print("notification details");
      print(message.notification!.title);
      print(message.notification!.body);
    });
  }
}
