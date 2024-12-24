import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:untitled1/FollowUP/FollowUPListScreen.dart';
import 'package:untitled1/FollowUP/followUpCreateForm.dart';
import 'package:untitled1/Lead/leadCreateform.dart';
import 'package:untitled1/NotificationService/notificationPage.dart';
import 'package:untitled1/Task/allTaskListScreen.dart';
import 'package:untitled1/Task/taskCreateForm.dart';
import 'package:untitled1/screens/totalLeadList.dart';

import '../Contacts/contact_services.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                    ),

                    //2nd column

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // contacts
                        // Material(
                        //   color: Colors.transparent,
                        //   child: InkWell(
                        //     onTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   const ContactServices()));
                        //     },
                        //     child: Container(
                        //       height: MediaQuery.of(context).size.height * 0.19,
                        //       width: MediaQuery.of(context).size.width * 0.435,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(14),
                        //         color: const Color.fromARGB(50, 127, 201, 231),
                        //       ),
                        //       child: Center(
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             // contacts
                        //             Container(
                        //               height: 62,
                        //               width: 61,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(14),
                        //                 color: const Color.fromARGB(
                        //                     200, 127, 201, 231),
                        //               ),
                        //               child: const Center(
                        //                 child: Icon(
                        //                   Icons.contact_page_outlined,
                        //                   color: Colors.white,
                        //                   size: 35,
                        //                 ),
                        //               ),
                        //             ),
                        //             const SizedBox(height: 10),
                        //             const Text("Contacts",
                        //                 style: TextStyle(fontSize: 14))
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // const SizedBox(height: 16),

                        // create lead
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
                                            200, 129, 232, 158),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.person_add_alt_1_outlined,
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
                                            200, 129, 232, 158),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.create_new_folder_outlined,
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
