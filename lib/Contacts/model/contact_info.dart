import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactInfo extends StatelessWidget {
  final String phoneNumber;

  const ContactInfo({Key? key, required this.phoneNumber}) : super(key: key);

  // Future<void> _makePhoneCall(String number) async {
  //   final Uri callUri = Uri(scheme: 'tel', path: number);
  //   if (await canLaunchUrl(callUri)) {
  //     await launchUrl(callUri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $number';
  //   }
  // }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  if (phoneNumber != 'No Phone No.') {
                    final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: phoneNumber,
                    );
                    try {
                      if (await launcher.canLaunchUrl(phoneUri)) {
                        await launcher.launchUrl(phoneUri);
                      } else {
                        print('Could not launch $phoneUri');
                      }
                    } catch (e) {
                      print('Error launching phone app: $e');
                    }
                  }
                },
                child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Color.fromRGBO(229, 248, 235, 1.0),
                    child: Icon(Icons.call, size: 18, color: Colors.green)),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(phoneNumber, style: const TextStyle(fontSize: 16)),
                  const Text("Mobile", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
