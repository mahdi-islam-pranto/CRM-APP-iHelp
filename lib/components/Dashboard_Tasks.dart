import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/taskListModel.dart';
import '../Task/taskDetailsPage.dart';
import 'package:http/http.dart' as http;

class DashboardTasks extends StatefulWidget {
  const DashboardTasks({Key? key}) : super(key: key);

  @override
  State<DashboardTasks> createState() => _DashboardTasksState();
}

class _DashboardTasksState extends State<DashboardTasks> {
  late Future<TaskListModel> _taskListFuture;

  @override
  void initState() {
    super.initState();
    _taskListFuture = getTaskList();
  }

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
        'session_user_id': '',
        'status': '',
        'next_task_start_time': '',
        'lead_id': '',
        'task_type_id': '',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return TaskListModel.fromJson(data);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: FutureBuilder<TaskListModel>(
        future: _taskListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blue,
              size: 40,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.data!.length > 5
                  ? 5
                  : snapshot.data!.data!.length,
              itemBuilder: (context, index) {
                var task = snapshot.data!.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(bottom: 5, top: 5),
                        title: Text(
                          task.companyName?.companyName ?? 'No Company',
                          style: TextStyle(
                            color: const Color(0xFF2C3131),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.taskName?.name ?? 'No Task Name',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF707070),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_add_alt_1_outlined,
                                  size: 15.sp,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  task.assignName?.name ?? 'No End Time',
                                  style: TextStyle(
                                      color: const Color(0xFF707070),
                                      fontSize: 13.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              task.taskStatus?.name ?? 'No status',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 12.sp),
                            ),
                            Card(
                              color: Colors.blue[100],
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(task.endTime ?? 'No End Time'),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskOverview(taskId: task.id!.toInt()),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text(
              'No tasks available today',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ));
          }
        },
      ),
    );
  }
}
