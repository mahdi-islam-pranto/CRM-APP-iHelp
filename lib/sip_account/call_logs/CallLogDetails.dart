import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../CallUI.dart';
import '../../database/DBHandler.dart';
import 'CallLogDetailsModel.dart';

/*
  Activity name : CallLogDetails
  Project name : iCRM Mobile App
  Developer : Eng. M A Mazedul Islam
  Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
  Email : mazedulislam4970@gmail.com
  Description : Display the call history for a particular person
*/

class CallLogDetails extends StatefulWidget {
  const CallLogDetails(
      {Key? key, required this.contactName, required this.contactNumber})
      : super(key: key);

  final String contactName;
  final String contactNumber;

  @override
  State<CallLogDetails> createState() => _CallLogDetailsState();
}

class _CallLogDetailsState extends State<CallLogDetails> {
  List<Map<String, dynamic>> callHistory = [];

  @override
  void initState() {
    // TODO: implement initState

    fetchCallHistory();

    super.initState();
  }

  Future<void> fetchCallHistory() async {
    callHistory.clear();

    final item = await DBHandler.instance.getCallHistory(widget.contactNumber);

    setState(() {
      callHistory = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.blue),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.contactName,
                style: const TextStyle(fontWeight: FontWeight.normal)),
            Text("Mobile. ${widget.contactNumber}",
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 13))
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Warning"),
                    content: const Text('Are you sure ?.',
                        style: TextStyle(color: Colors.black)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          setState(() {
                            callHistory = [];
                          });
                          await DBHandler.instance
                              .deleteCallHistory(widget.contactNumber);
                        },
                        child: const Text('Yes'),
                      )
                    ],
                  ),
                );
              })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              color: Colors.white70,
              child: const Text(
                "Call History",
                style: TextStyle(fontSize: 17),
              )),
          Expanded(child: getCallHistory()),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: CircleAvatar(
                radius: 30,
                child: IconButton(
                  icon: const Icon(Icons.call, size: 30),
                  onPressed: () {
                    Navigator.pop(context);

                    //Call action
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallUI(
                                phoneNumber: widget.contactNumber,
                                callerName: widget.contactName)));
                  },
                )),
          )
        ],
      ),
    );
  }

  Widget getCallHistory() {
    if (callHistory.contains(null) || callHistory.isEmpty) {
      return const Center(child: Text("Empty"));
    }

    return ListView.builder(
        itemCount: callHistory.length,
        itemBuilder: (BuildContext context, int index) {
          CallLogDetailsModel callLogDetailsModel =
              CallLogDetailsModel.fromMap(callHistory[index]);

          return Card(
            elevation: 1,
            child: ListTile(
              leading: getCallTypeIcon(callLogDetailsModel.type.toString()),
              title: Text(callLogDetailsModel.type.toString()),
              subtitle: Text(callLogDetailsModel.date.toString() +
                  " " +
                  callLogDetailsModel.time.toString()),
              trailing: Text(callLogDetailsModel.duration.toString()),
            ),
          );
        });
  }

  Widget getCallTypeIcon(String type) {
    switch (type) {
      case "Missed":
        return const Icon(Icons.call_missed, color: Colors.redAccent, size: 20);

      case "Outgoing":
        return const Icon(Icons.call_made_outlined,
            color: Colors.grey, size: 20);

      default:
        return const Icon(Icons.call_received, color: Colors.grey, size: 20);
    }
  }
}
