import 'dart:convert';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Dashboard/bottom_navigation_page.dart';
import '../Models/taskListModel.dart';
import 'taskCreateForm.dart';
import 'taskDetailsPage.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
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
      // print("########Response task data: $data");
      return TaskListModel.fromJson(data);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: <Widget>[
          _createTask(),
          _viewTasks(),
        ],
        colorStartAnimation: Colors.white,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close,
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => const BottomNavigationPage(),
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
          child: const Text('All Tasks'),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined, color: Colors.black87),
          ),
        ],
      ),
      body: FutureBuilder<TaskListModel>(
        future: _taskListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blue,
                size: 50,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.data!.length,
              itemBuilder: (context, index) {
                var task = snapshot.data!.data![index];
                return _buildTaskItem(task);
              },
            );
          } else {
            return Center(
                child: Text(
              'No tasks available',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ));
          }
        },
      ),
    );
  }

  Widget _buildTaskItem(Data task) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskOverview(taskId: task.id!.toInt())));
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            // Each task row
            Container(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.companyName?.companyName ?? 'No Company',
                          style: const TextStyle(fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Status: ${task.taskStatus?.name ?? 'Unknown'}"),
                        Row(
                          children: [
                            const Icon(Icons.manage_accounts_rounded,
                                color: Colors.blue, size: 16),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                task.assignName?.name ?? 'Unassigned',
                                style: TextStyle(color: Colors.blue[400]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // right side column

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(task.taskName?.name ?? 'No Task Name'),
                      Card(
                        color: Colors.blue[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(task.endTime ?? 'No End Time'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 0.5),
          ],
        ),
      ),
    );
  }

  Widget _createTask() {
    return FloatingActionButton(
      backgroundColor: Colors.blue[400],
      heroTag: "btn1",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TaskCreateForm()),
        );
      },
      tooltip: 'Create Task',
      child: const Icon(Icons.add),
    );
  }

  Widget _viewTasks() {
    return FloatingActionButton(
      backgroundColor: Colors.grey[300],
      heroTag: "btn2",
      onPressed: () {},
      tooltip: 'View Tasks',
      child: const Icon(Icons.visibility),
    );
  }
}
