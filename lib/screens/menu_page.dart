import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/FollowUP/FollowUPListScreen.dart';
import 'package:untitled1/FollowUP/followUpCreateForm.dart';
import 'package:untitled1/Lead/leadCreateform.dart';
import 'package:untitled1/NotificationService/notificationPage.dart';
import 'package:untitled1/Task/allTaskListScreen.dart';
import 'package:untitled1/Task/taskCreateForm.dart';
import 'package:untitled1/screens/totalLeadList.dart';
import 'package:untitled1/sip_account/SIPCredential.dart';
import '../sip_account/SipDialPad.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.chevron_left, size: 18,color: Colors.white,)),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            'Menu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // menus Row
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // first column

                    Column(
                      children: [
                        //sip contacts
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SIPCredential()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(114, 236, 215, 248),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            114, 153, 66, 204),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.sip_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Sip Contacts",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Notifications
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              // print server token
                              // GetServerKey getServerToken = GetServerKey();
                              // String FCMserverToken =
                              //     await getServerToken.getServerKey();
                              // print("FCM server token: $FCMserverToken");

                              // send notification
                              // SendNotificationService.sendNotificationUsingApi(
                              //   token:
                              //       "cmMcGzngQAqUwrvVpHQVko:APA91bEwtTJpUJ4LKGJ1XJuhYqDpxJsx4ol4D17b4kDM7j2DrIik11xykg_2C6MCsl_td7mv-y8t6r-7sUxId46koQ_Iq4VvecMe7VlfL3wtgP9XaV-mXbk",
                              //   title: "pranto test notification",
                              //   body: "this is the notificationbody",
                              //   data: {"screen": "followup"},
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage(),
                                ),
                              );
                            },
                            child: Container(
                              // height: 167,
                              // width: 170,
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(50, 133, 143, 233),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            200, 133, 143, 233),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Notifications",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Leads
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black12,
                            onTap: () {
                              // go to leads
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LeadListScreen()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(50, 255, 228, 228),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            200, 231, 125, 125),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.person_2_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Leads",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // tasks
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // go to tasks
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TaskListScreen()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(50, 133, 143, 233),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            200, 133, 143, 233),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.task_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Tasks",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //2nd column

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SipDialPad()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(114, 236, 215, 248),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            255, 138, 228, 184),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.contact_emergency,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("My Contacts",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LeadCreateForm()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(50, 203, 249, 216),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            114, 30, 180, 234),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.leaderboard,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Create Lead",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // create task
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TaskCreateForm()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(200, 255, 239, 235),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            200, 240, 165, 142),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add_task,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Create Task",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // create follow up
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FollowUpCreate()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(50, 203, 249, 216),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            114, 30, 158, 154),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.follow_the_signs,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Create Follow up",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // follow ups
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FollowUpList()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.435,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(50, 255, 228, 228),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 62,
                                      width: 61,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: const Color.fromARGB(
                                            200, 231, 125, 125),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.arrow_circle_right_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Follow Ups",
                                        style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
