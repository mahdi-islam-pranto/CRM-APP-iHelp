import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as launcher;

import 'SipCallButton.dart';

class ContactInformationCard extends StatelessWidget {
  final String phoneNumber;
  final String callerName;
  final String email;

  const ContactInformationCard({
    Key? key,
    required this.phoneNumber,
    required this.callerName,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with Icon
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 10),
                Text(
                  "Contact Information",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // calling

          Row(
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
                  child: Icon(Icons.call, size: 18, color: Colors.green),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              // Phone Number with SIP Call Button
              SipCallButton(
                phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
                callerName: callerName,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Email
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Icon(Icons.email, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    email.isNotEmpty ? email : 'N/A',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
