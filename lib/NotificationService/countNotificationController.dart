import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  String? currentUserId;
  var notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentUserId();
    fetchNotificationCount();
  }

  //

  void getCurrentUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    currentUserId = sharedPreferences.getString("id");
    print("currentUserId => $currentUserId");
  }

  void fetchNotificationCount() {
    FirebaseFirestore.instance
        .collection("notifications")
        .doc(currentUserId)
        .collection('notification')
        .where("isRead", isEqualTo: false)
        .snapshots()
        .listen(
      (QuerySnapshot querySnapshot) {
        notificationCount.value = querySnapshot.docs.length;
        print("Notification lenghth => ${notificationCount.value}");
        print("Notification lenghth2 => ${querySnapshot.docs.length}");
        update();
      },
    );
  }
}
