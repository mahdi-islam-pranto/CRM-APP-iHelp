import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../CallUI.dart';
import '../../database/DBHandler.dart';
import 'CallLogDetailsModel.dart';

class CallLogDetails extends StatefulWidget {
  const CallLogDetails({
    Key? key,
    required this.contactName,
    required this.contactNumber,
  }) : super(key: key);

  final String contactName;
  final String contactNumber;

  @override
  State<CallLogDetails> createState() => _CallLogDetailsState();
}

class _CallLogDetailsState extends State<CallLogDetails> {
  List<Map<String, dynamic>> callHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    fetchCallHistory();
    super.initState();
  }

  Future<void> fetchCallHistory() async {
    setState(() {
      isLoading = true;
    });

    callHistory.clear();
    final item = await DBHandler.instance.getCallHistory(widget.contactNumber);

    setState(() {
      callHistory = item;
      isLoading = false;
    });
  }

  void _showDeleteConfirmationDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Clear Call History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete all call history for this contact?',
          style: TextStyle(color: Colors.black54),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() {
                callHistory = [];
              });
              await DBHandler.instance.deleteCallHistory(widget.contactNumber);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue[700]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.contactName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              widget.contactNumber,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Text(
              "Call History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildCallHistoryList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[600],
        elevation: 4,
        onPressed: () {
          Navigator.pop(context);
          //Call action
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CallUI(
                phoneNumber: widget.contactNumber,
                callerName: widget.contactName,
              ),
            ),
          );
        },
        child: const Icon(Icons.call, color: Colors.white),
      ),
    );
  }

  Widget _buildCallHistoryList() {
    if (callHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call_end_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No call history found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Any calls with this contact will show up here",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: callHistory.length,
      itemBuilder: (BuildContext context, int index) {
        CallLogDetailsModel call = CallLogDetailsModel.fromMap(callHistory[index]);

        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: _getCallTypeColor(call.type.toString()).withOpacity(0.2),
              radius: 20,
              child: _getCallTypeIcon(call.type.toString()),
            ),
            title: Text(
              call.type.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "${call.date} at ${call.time}",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDuration(call.duration.toString()),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                if (call.duration.toString() != "00:00")
                  Text(
                    "Duration",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getCallTypeIcon(String type) {
    switch (type) {
      case "Missed":
        return const Icon(Icons.call_missed_rounded, color: Colors.red, size: 22);
      case "Outgoing":
        return const Icon(Icons.call_made_rounded, color: Colors.green, size: 22);
      default: // Incoming
        return const Icon(Icons.call_received_rounded, color: Colors.blue, size: 22);
    }
  }

  Color _getCallTypeColor(String type) {
    switch (type) {
      case "Missed":
        return Colors.red;
      case "Outgoing":
        return Colors.green;
      default: // Incoming
        return Colors.blue;
    }
  }

  String _formatDuration(String duration) {
    if (duration == "00:00") {
      return "Missed Call";
    }
    return duration;
  }
}