import 'package:flutter/material.dart';

import '../sip_account/CallUI.dart';

class SipCallButton extends StatefulWidget {
  final String phoneNumber;
  final String callerName;
  const SipCallButton(
      {Key? key, required this.phoneNumber, required this.callerName})
      : super(key: key);

  @override
  _SipCallButtonState createState() => _SipCallButtonState();
}

class _SipCallButtonState extends State<SipCallButton> {
  double _iconOffset = 0.0; // Initial position

  void _onTapDown() {
    setState(() => _iconOffset = 5.0); // Moves icon down
  }

  void _onTapUp() {
    setState(() => _iconOffset = 0.0); // Moves icon back up
    // Navigate to CallUI
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallUI(
          phoneNumber: widget.phoneNumber.trim(),
          callerName: widget.callerName.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTapDown: (_) => _onTapDown(),
          onTapUp: (_) => _onTapUp(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform:
                Matrix4.translationValues(0, _iconOffset, 0), // Moves up/down
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade700.withOpacity(0.1), // Light background
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.dialer_sip_outlined,
              size: 18,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "No Number",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade800,
          ),
        ),
      ],
    );
  }
}
