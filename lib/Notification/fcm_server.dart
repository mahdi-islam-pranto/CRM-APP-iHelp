import 'dart:convert';
import 'package:http/http.dart' as http;

class FCMService {
  /// good working for notification
  // static  Future<void> sendNotification() async {
  //   final String serverKey = 'ya29.a0AcM612zjwSj_R-J8t8LCFSr9zangOXjoqGdVhqX4Gx5yrPFxy1AsUrHVokxjkPKZ3Y5hK-uIFEKPKm4pyWBnoXTq2dDu4RJWMzikUqBXD5RfCTS_QhViM1d5OgRMlb0gfdKO-WovuJt0tfh0QjF1H1ld0Zlf3FgPlEb-U7hgaCgYKASMSARISFQHGX2MifwVkXmHtMmfRzHHdlFkf4Q0175';
  //   String deviceToken = await NotificationServices().getDeviceToken();
  //
  //
  //   final url = 'https://fcm.googleapis.com/v1/projects/icrm-d567c/messages:send';
  //
  //
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $serverKey',
  //   };
  //
  //   final body = jsonEncode({
  //     "message": {
  //       "token": deviceToken, // Send notification to this specific device
  //       "notification": {
  //         "title": "Pending task available",
  //         "body": "Please Solved it",
  //       },
  //       "data": {
  //         "story_id": "story_12345",
  //       },
  //     }
  //   });
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Notification sent successfully!');
  //     } else {
  //       print('Failed to send notification. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }

  static const String _serverKey =
      'ya29.a0AcM612x23_ZZ3o_4Jd2Tn0RGImGtEY9NNoYP-SJ0Szdy2SAgTFa4HoPyYQTJ-vkseRGGqG5qvoIYZ3L4V797_uaTpxRLpxxqRG9IXkBWYbUXr-ocY1hkX9K9-x5s497spgWBk7TLl1e4K8fzMgnNJ6RSysPl7ritVKJhmaFBaCgYKASwSARISFQHGX2Mi14L8LMhOJsxa_un9WGesKg0175';
  static Future<void> sendNotification({
    required String title, // Notification title
    required String body, // Notification body
    required String storyId, // Data payload (custom)
    String? deviceToken, // Token can be passed, or fetched if null
  }) async {
    // Fetch the device token if not provided
    //deviceToken ??= await NotificationServices().getDeviceToken();

    final url = 'https://fcm.googleapis.com/v1/projects/ihelpcrm/messages:send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_serverKey',
    };

    final payload = {
      "message": {
        "token": deviceToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "story_id": storyId,
        },
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
