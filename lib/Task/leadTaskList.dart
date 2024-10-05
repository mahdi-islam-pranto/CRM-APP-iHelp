import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Dashboard/bottom_navigation_page.dart';
import '../Models/taskListModel.dart';
import 'taskCreateForm.dart';

class LeadTaskListScreen extends StatefulWidget {
  final int leadId;

  const LeadTaskListScreen({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadTaskListScreen> createState() => _LeadTaskListScreenState();
}

final GlobalKey<AnimatedFloatingActionButtonState> key =
    GlobalKey<AnimatedFloatingActionButtonState>();

class _LeadTaskListScreenState extends State<LeadTaskListScreen> {
  // API code
  // fetch task from API
  Future<TaskListModel> getTaskList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    final response = await http.post(
      Uri.parse("https://crm.ihelpbd.com/api/crm-lead-task-list"),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '2024-01-01',
        'end_date': '2025-11-01',
        'user_id': userId,
        'session_user_id': userId,
        'status': '',
        'next_task_start_time': '',
        'lead_id': '${widget.leadId}', // lead id
        'task_type_id': '5',
      },
    );
    // print(response.body.toString());
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      // print("########Response task data: $data");
      return TaskListModel.fromJson(data);
    } else {
      // Handle error
      return TaskListModel.fromJson(data);

      // You can also show an error message if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Stack(
        children: [
          Positioned(
            child: AnimatedFloatingActionButton(
              key: key,
              fabButtons: <Widget>[
                _createLead(),
                _viewLeads(), // Added another FAB here
              ],
              colorStartAnimation: Colors.white,
              colorEndAnimation: Colors.red,
              animatedIconData: AnimatedIcons.menu_close,
            ),
          ),
        ],
      ),

      // body
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getTaskList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 5, left: 20, right: 20),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.data![index].companyName!
                                            .companyName
                                            .toString(),
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Text(
                                          "Status:  ${snapshot.data!.data![index].taskStatus!.name}"),
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.manage_accounts_rounded,
                                              color: Colors.blue),
                                          const SizedBox(width: 5),
                                          Text(
                                            snapshot.data!.data![index]
                                                .assignName!.name
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.blue[400]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(snapshot
                                          .data!.data![index].taskName!.name
                                          .toString()),
                                      Card(
                                          borderOnForeground: true,
                                          shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          color: Colors.blue[100],
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(snapshot
                                                .data!.data![index].endTime
                                                .toString()),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              //

                              const Divider(
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        );
                        // return ListTile(
                        //   title: Text(snapshot
                        //       .data!.data![index].companyName!.companyName
                        //       .toString()),
                        //   subtitle:
                        //       Text(snapshot.data!.data![index].description!),
                        // );
                      },
                    );
                  } else {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blue,
                        size: 50,
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createLead() {
    return FloatingActionButton(
      backgroundColor: Colors.blue[400],
      heroTag: "btn1",
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskCreateForm(),
            ));
      },
      tooltip: 'Create Lead',
      child: const Icon(Icons.add),
    );
  }

  // FAB button to view leads
  Widget _viewLeads() {
    return FloatingActionButton(
      backgroundColor: Colors.grey[300],
      heroTag: "btn2",
      onPressed: () {},
      tooltip: 'View Leads',
      child: const Icon(Icons.visibility),
    );
  }
}
