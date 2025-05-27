import 'dart:convert';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/API/api_url.dart';
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

  // search function starts
  TextEditingController _searchController = TextEditingController();
  List<Data>? _oldPendingTasks; // New list for old pending tasks
  List<Data>? _filteredTasks;
  List<Data>? _allTasks; // To store all tasks

  var _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _taskListFuture = getTaskList();
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTasks() {
    if (_allTasks != null) {
      setState(() {
        _filteredTasks = _allTasks!.where((task) {
          return task.companyName?.companyName
                  ?.toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ??
              false;
        }).toList();
      });
    }
  }

  // method for filter old pending tasks
  void _filterOldPendingTasks() {
    if (_allTasks != null) {
      final now = DateTime.now();
      _oldPendingTasks = _allTasks!.where((task) {
        // Parse the end time
        DateTime? endTime;
        try {
          endTime = DateTime.parse(task.endTime ?? '');
        } catch (e) {
          return false;
        }

        // Check if task is pending and past its end time
        return task.taskStatus?.name == 'Pending' && endTime.isBefore(now);
      }).toList();

      // Sort by end time (oldest first)
      _oldPendingTasks?.sort((a, b) {
        final aTime = DateTime.parse(a.endTime ?? '');
        final bTime = DateTime.parse(b.endTime ?? '');
        return aTime.compareTo(bTime);
      });
    }
  }

  Future<TaskListModel> getTaskList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    final response = await http.post(
      Uri.parse(ApiUrls.taskListUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '2024-01-01',
        'end_date': '2034-11-01',
        'user_id': userId,
        'session_user_id': userId,
        'status': '',
        'next_task_start_time': '',
        'lead_id': '',
        'task_type_id': '',
      },
    );
    print("Task API status code ${response.statusCode}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print("########Response task data: $data");
      // searched tasks
      _allTasks = TaskListModel.fromJson(data).data;
      _filteredTasks = _allTasks;
      _filterOldPendingTasks();
      return TaskListModel.fromJson(data);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // search bar apperence
  bool searchBar = false;

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
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.blue),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => const BottomNavigationPage(),
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 700),
            );
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: const Text(
          "All Tasks",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchBar = !searchBar;
              });
              // print(searchBar);
            },
            icon: const Icon(Icons.search_outlined, color: Colors.black87),
          ),
        ],
      ),
      body: Column(
        children: [
          // serach bar
          if (searchBar == true)
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  floatingLabelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),

          // New section for old pending overdue tasks
          FutureBuilder<TaskListModel>(
            future: _taskListFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  _oldPendingTasks != null &&
                  _oldPendingTasks!.isNotEmpty) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _isExpanded = !_isExpanded;
                  }),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    margin: const EdgeInsets.only(left: 18, right: 18, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.red[700]),
                              const SizedBox(width: 8),
                              Text(
                                'Overdue Tasks (${_oldPendingTasks!.length})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                child: _isExpanded
                                    ? const Icon(
                                        Icons.keyboard_double_arrow_up_outlined,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons
                                            .keyboard_double_arrow_down_outlined,
                                        color: Colors.red,
                                      ),
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // the overdue tasks list
                        if (_isExpanded)
                          Container(
                            height: _oldPendingTasks!.length > 2
                                ? MediaQuery.of(context).size.height * 0.35
                                : null,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: _oldPendingTasks!.length > 2
                                  ? const AlwaysScrollableScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              itemCount: _oldPendingTasks!.length,
                              itemBuilder: (context, index) {
                                return _buildOverdueTaskItem(
                                    _oldPendingTasks![index]);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // all task list
          Expanded(
            child: FutureBuilder<TaskListModel>(
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
                    // itemCount: snapshot.data!.data!.length,
                    itemCount: _filteredTasks?.length,
                    itemBuilder: (context, index) {
                      // var task = snapshot.data!.data![index];
                      var task = _filteredTasks![index];
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
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Data task) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TaskOverview(taskId: task.id!.toInt())));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ListTile(
                contentPadding: const EdgeInsets.only(bottom: 5, top: 5),
                title: Text(
                  task.companyName?.companyName ?? 'No Company',
                  style: const TextStyle(
                      color: Color(0xFF2C3131),
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //subject
                    // Text(
                    //   task.subject ?? 'No Subject',
                    //   style: TextStyle(
                    //     fontSize: 13.sp,
                    //     color: const Color(0xFF707070),
                    //   ),
                    // ),
                    Text(
                      task.taskName?.name ?? 'No Task Name',
                      style: const TextStyle(
                        color: Color(0xFF707070),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.person_add_alt_1_outlined,
                          size: 15.sp,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          task.assignName?.name ?? 'No Assign Name',
                          style: const TextStyle(
                            color: Color(0xFF707070),
                          ),
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
                          color:
                              getStatusColor(task.taskStatus!.name.toString()),
                          fontSize: 12.sp),
                    ),
                    const SizedBox(width: 5.0),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
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
        ));
  }

  Widget _buildOverdueTaskItem(Data task) {
    final endTime = DateTime.parse(task.endTime ?? '');
    final daysOverdue = DateTime.now().difference(endTime).inDays;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskOverview(taskId: task.id!.toInt()),
          ),
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 255, 247, 247),
        margin: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
        ),
        child: ListTile(
          title: Text(
            task.companyName?.companyName ?? 'No Company',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.taskName?.name ?? 'No Task Name'),
              Text(
                'Overdue by $daysOverdue days',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: Column(
            children: [
              Text(
                task.taskStatus?.name ?? 'No status',
                style: TextStyle(
                    color: getStatusColor(task.taskStatus!.name.toString()),
                    fontSize: 12.sp),
              ),
              const SizedBox(width: 5.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                color: Colors.blue[100],
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(task.endTime ?? 'No End Time'),
                ),
              ),
            ],
          ),
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

  Color getStatusColor(String status) {
    switch (status) {
      case 'Solved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Working Process':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }
}
