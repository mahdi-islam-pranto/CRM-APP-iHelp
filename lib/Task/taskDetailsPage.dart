import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/Models/taskListModel.dart';
import 'package:untitled1/Task/allTaskListScreen.dart';

import '../Dashboard/bottom_navigation_page.dart';
import '../Models/LeadListModel.dart';
import '../resourses/app_colors.dart';

class TaskOverview extends StatefulWidget {
  final int taskId;

  const TaskOverview({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskOverview> createState() => _TaskOverviewState();
}

class _TaskOverviewState extends State<TaskOverview> {
  bool isLoading = true;
  TaskListModel? taskDetails;

  @override
  void initState() {
    super.initState();
    getTaskDetails();
  }

  // fetch specific lead details
  Future<void> getTaskDetails() async {
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
        'session_user_id': '',
        'status': '',
        'next_task_start_time': '',
        'lead_id': '',
        'task_type_id': '',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      List<dynamic> leadJsonList = data['data'];

      // Find the specific lead that matches the leadId
      var matchingTask = leadJsonList.firstWhere(
        (lead) => lead['id'] == widget.taskId,
        orElse: () => null,
      );

      setState(() {
        if (matchingTask != null) {
          taskDetails = TaskListModel.fromJson(matchingTask);
        }
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      // You can also show an error message if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => const TaskListScreen(),
              curve: Curves.fastOutSlowIn,
              duration: const Duration(seconds: 1),
            );
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('Task Details'),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined, color: Colors.black87),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue,
                  size: 50,
                ),
              )
            : taskDetails == null
                ? Center(
                    child: Text(
                    "Task not found",
                    style: TextStyle(fontSize: 17.sp, color: Colors.grey),
                  ))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Section
                          Center(
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0x300D6EFD),
                                  radius: 50,
                                  child: Icon(
                                    Icons.task_alt_outlined,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // company name with task id
                                Text(
                                  "Company Name" ?? "No company name",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Task Type",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Lead Information Section
                          Card(
                            color: Colors.blue[100],
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text("Task Information",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text("Task Subject: "),
                                  Text("Task Status:"),
                                  Text("Task Start: "),
                                  Text("Task End: "),
                                ],
                              ),
                            ),
                          ),

                          // Assign Users Section
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text("Assigned Users",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text("Assign to: "),
                                  Text("Associates: "),
                                ],
                              ),
                            ),
                          ),

                          // Description Section
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text("Description",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              subtitle: const Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "This is a detailed description of the lead. Here you can provide more information about the lead and any other relevant details that might be useful.",
                                ),
                              ),
                            ),
                          ),

                          // Bottom Section (Optional actions or additional info)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Delete lead
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(164, 52),
                                    maximumSize: const Size(181, 52),
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.redAccent, width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "DELETE TASK",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 11),

                                // update lead
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(164, 52),
                                    maximumSize: const Size(181, 52),
                                    backgroundColor: buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("EDIT TASK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
