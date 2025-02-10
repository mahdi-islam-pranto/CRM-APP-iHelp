import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatelessWidget {
  final String phoneNumber;

  const ContactInfo({Key? key, required this.phoneNumber}) : super(key: key);

  Future<void> _makePhoneCall(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contact info",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.call, color: Colors.blue),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(phoneNumber, style: const TextStyle(fontSize: 16)),
                    const Text("Mobile", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            onPressed: () => _makePhoneCall(phoneNumber),
          ),
        ],
      ),
    );
  }
}
