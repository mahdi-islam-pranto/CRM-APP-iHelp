import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleCallPopup extends StatelessWidget {
  final String phoneNumber;

  const SimpleCallPopup({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Unknown Contact Text
          Text(
            'Unknown Contact',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),

          // Phone Number
          Text(
            phoneNumber,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 20),

          // Call Back Button
          ElevatedButton.icon(
            onPressed: () async {
              final Uri uri = Uri.parse('tel:$phoneNumber');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
              Get.back();
            },
            icon: Icon(Icons.call),
            label: Text('Call Back'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
