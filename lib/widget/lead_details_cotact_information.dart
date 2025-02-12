import 'package:flutter/material.dart';
import 'package:untitled1/widget/sip_call_button.dart';

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
                    fontSize: 18
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Phone Number with SIP Call Button
          SipCallButton(
            phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
            callerName: callerName,
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
