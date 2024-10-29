import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/Models/taskListModel.dart';
import '../resourses/app_colors.dart';
import 'taskUpdate.dart';

class TaskOverview extends StatefulWidget {
  final int taskId;

  const TaskOverview({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskOverview> createState() => _TaskOverviewState();
}

class _TaskOverviewState extends State<TaskOverview> {
  bool isLoading = true;
  Data? taskDetails;

  @override
  void initState() {
    super.initState();
    getTaskDetails();
  }

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
      var data = jsonDecode(response.body);
      TaskListModel taskList = TaskListModel.fromJson(data);

      setState(() {
        taskDetails = taskList.data?.firstWhere(
          (task) => task.id == widget.taskId,
          orElse: () => Data(),
        );
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
      print('Failed to load task details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, size: 18),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      //   backgroundColor: Colors.white,
      //   systemOverlayStyle:
      //       const SystemUiOverlayStyle(statusBarColor: Colors.white),
      //   title: Container(
      //     height: 35,
      //     padding: const EdgeInsets.symmetric(horizontal: 10),
      //     decoration: BoxDecoration(
      //       color: Colors.white70,
      //       borderRadius: BorderRadius.circular(5),
      //     ),
      //     child: const Text('Task Details'),
      //   ),
      // ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/details.png', // Replace with your background image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Task Details Content
          isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
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
                      child: Column(
                        children: [
                          // back button
                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Task Details",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Top Section
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Center(
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Icon(
                                      Icons.task_alt_outlined,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    taskDetails?.companyName?.companyName ??
                                        "No company name",
                                    style: const TextStyle(
                                        fontSize: 28, color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                      taskDetails?.taskName?.name ??
                                          "No Task Type",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      )),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),

                          // task details contents
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.only(
                                top: 10, left: 30, right: 30),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),

                                    // Task Information Section
                                    Card(
                                      elevation: 0.2,
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          // blue line
                                          Container(
                                            width: 3,
                                            height: 60,
                                            color: Colors.blue,
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Text("Task Information",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                      "Task Subject: ${taskDetails?.subject ?? 'N/A'}"),
                                                  Text(
                                                      "Task Status: ${taskDetails?.taskStatus?.name ?? 'N/A'}"),
                                                  Text(
                                                      "Task Start: ${taskDetails?.startTime ?? 'N/A'}"),
                                                  Text(
                                                      "Task End: ${taskDetails?.endTime ?? 'N/A'}"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Assign Users Section
                                    Card(
                                      elevation: 0.2,
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          // blue line
                                          Container(
                                            width: 3,
                                            height: 35,
                                            color: Colors.blue,
                                          ),

                                          Expanded(
                                            child: ListTile(
                                              title: Text("Assigned Users",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                      "Assign to: ${taskDetails?.assignName?.name ?? 'N/A'}"),
                                                  Text(
                                                      "Associates: ${taskDetails?.associates?.map((e) => e.name).join(', ') ?? 'N/A'}"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Description Section
                                    Card(
                                      elevation: 0.2,
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          // blue line
                                          Container(
                                            width: 3,
                                            height: 30,
                                            color: Colors.blue,
                                          ),

                                          Expanded(
                                            child: ListTile(
                                              title: Text("Description",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(taskDetails
                                                        ?.description ??
                                                    "No description available"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                // Delete task
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

                                // update task
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(164, 52),
                                    maximumSize: const Size(181, 52),
                                    backgroundColor: buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("UPDATE TASK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  onPressed: () {
                                    // Implement update task functionality
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskUpdateForm(
                                            leadId: taskDetails?.leadId ?? 0,
                                            taskId: widget.taskId,
                                            taskDetails: taskDetails!),
                                      ),
                                    ).then((updated) {
                                      if (updated == true) {
                                        // Refresh the task details if the update was successful
                                        getTaskDetails();
                                      }
                                    });
                                  },
                                ),
                              ],
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
