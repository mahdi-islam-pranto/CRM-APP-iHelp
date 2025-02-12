import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/FollowUP/FollowUPListScreen.dart';

import '../Task/allTaskListScreen.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  // Add this method to get the current user ID
  Future<void> getCurrentUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = sharedPreferences.getString("id");
      print("Current User ID: $currentUserId");
    });
  }

// get the formatted timestamp
  String formatTimestamp(Timestamp timestamp) {
    var format = new DateFormat('dd/MM/yyyy  HH:mm a');
    return format.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18,color: Colors.blue,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text("Notifications"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(currentUserId)
            .collection('notification')
            // .where('isSale', isEqualTo: true)
            .where('creted_at',
                isGreaterThan: Timestamp.fromDate(
                    DateTime.now().subtract(const Duration(days: 7))))
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No notifications found!"),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String docId = snapshot.data!.docs[index].id;
                return GestureDetector(
                  onTap: () async {
                    // update the isRead field and if followup to go follow up page, if task to go task page

                    print("Docid => $docId");
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(currentUserId)
                        .collection('notifications')
                        .doc(docId);

                    print("Title => ${snapshot.data!.docs[index]['title']}");
                    if (snapshot.data!.docs[index]['title'] ==
                        "New Task Created ") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaskListScreen()));
                    } else if (snapshot.data!.docs[index]['title'] ==
                        "New Follow Up Created ") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FollowUpList()));
                    }
                    //     .update(
                    //   {
                    //     "isSeen": true,
                    //   },
                    // );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Card(
                      color: snapshot.data!.docs[index]['isRead']
                          ? Colors.white
                          : Colors.white,
                      elevation: snapshot.data!.docs[index]['isRead'] ? 1 : 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0x300D6EFD),
                          child: Icon(snapshot.data!.docs[index]['isRead']
                              ? Icons.done
                              : Icons.notification_add),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data!.docs[index]['title']),
                            Text(
                                formatTimestamp(snapshot.data!.docs[index]
                                        ['creted_at'] ??
                                    "N/A"),
                                style: const TextStyle(color: Colors.blueGrey)),
                            // Text(
                            //     "Created At: ${DateFormat.yMd().add_jm().format(DateTime.parse(snapshot.data!.docs[index]['creted_at'] ?? "N/A"))}"),
                            // Text(snapshot.data!.docs[index]['creted_at']
                            //     .toString()),
                          ],
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['body'],
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
