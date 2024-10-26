import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FollowUP/followUpOverview.dart';

import '../Task/taskDetailsPage.dart';
import 'package:http/http.dart' as http;

class DashboardFollowUps extends StatefulWidget {
  const DashboardFollowUps({Key? key}) : super(key: key);

  @override
  State<DashboardFollowUps> createState() => _DashboardFollowUpsState();
}

class _DashboardFollowUpsState extends State<DashboardFollowUps> {
  // all follow ups list
  List followUpList = [];

  @override
  void initState() {
    super.initState();
    getFollowUpList();
  }

  getFollowUpList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    String startDate = DateFormat('yyyy-MM-dd').format(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));

    String endDate = DateFormat('yyyy-MM-dd').format(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));

    print("Start date task $startDate");

    final response = await http.post(
      Uri.parse("https://crm.ihelpbd.com/api/crm-follow-up-list"),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '',
        'end_date': '',
        'user_id': userId,
        'session_user_id': userId,
        'followup_type_id': '',
        'status': '',
        'lead_id': '',
        'next_followup_date': '',
      },
    );

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return followUpList = data['data'];
    } else {
      throw Exception('Failed to load follow ups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: FutureBuilder(
        future: getFollowUpList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blue,
              size: 40,
            ));
          } else if (snapshot.hasError) {
            // return Center(child: Text('Error: ${snapshot.error}'));
            return const Center(child: Text('Fetching follow ups failed'));
          } else if (snapshot.hasData && snapshot.data != null) {
            return Scrollbar(
              thickness: 10,
              trackVisibility: true,
              child: ListView.builder(
                itemCount: followUpList.length > 5 ? 5 : followUpList.length,
                itemBuilder: (context, index) {
                  print(followUpList.length);
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
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
                            followUpList[index]['company_name']
                                    ['company_name'] ??
                                'Unknown',
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
                                "subject: " + followUpList[index]['subject'] ??
                                    'No Subject',
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
                                    followUpList[index]['assign_name']
                                            ['name'] ??
                                        'No Assign',
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
                                getStatusText(followUpList[index]['status']),
                                style: TextStyle(
                                    color: getStatusColor(
                                        followUpList[index]['status']),
                                    fontSize: 12.sp),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                color: Colors.blue[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(followUpList[index]
                                          ['next_followup_date'] ??
                                      'No Next Follow Up Date'),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FollowUpOverview(
                                      followUpId: followUpList[index]['id'])),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 50.sp,
                    color: Colors.blueGrey[200],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'No follow ups for today',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.blueGrey[200],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Create a new follow up!',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.blueGrey[200],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

String getStatusText(String status) {
  switch (status) {
    case '1':
      return 'Solved';
    case '2':
      return 'Pending';
    case '3':
      return 'Working Progress';
    default:
      return 'Cancel';
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case '1':
      return Colors.green;
    case '2':
      return Colors.orange;
    case '3':
      return Colors.blue;
    default:
      return Colors.red;
  }
}
