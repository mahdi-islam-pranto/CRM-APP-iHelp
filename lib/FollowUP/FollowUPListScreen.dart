import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Models/followUpModel.dart';
import 'package:untitled1/resourses/app_colors.dart';
import '../Dashboard/bottom_navigation_page.dart';
import '../resourses/resourses.dart';
import 'followUpCreateForm.dart';
import 'package:http/http.dart' as http;

class FollowUpList extends StatefulWidget {
  const FollowUpList({super.key});

  @override
  State<FollowUpList> createState() => _FollowUpListState();
}

class _FollowUpListState extends State<FollowUpList> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  bool isLoading = true;
  bool isLoadingMore = false;
  List followUpList = [];
  int pageNumber = 1;
  final int pageSize = 10;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    getFollowUpList();
  }

  // fetch leads from API with pagination
  Future<void> getFollowUpList() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    final response = await http.post(
      Uri.parse("https://crm.ihelpbd.com/api/crm-follow-up-list"),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '2024-01-01',
        'end_date': '2024-11-01',
        'user_id': userId,
        'session_user_id': userId,
        'followup_type_id': '',
        'status': '',
        'lead_id': '1910',
        'next_followup_date': '',
        'page': pageNumber.toString(),
        'page_size': pageSize.toString(),
      },
    );

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      setState(() {
        if (pageNumber == 1) {
          followUpList = data['data'];
        } else {
          followUpList.addAll(data['data']);
        }

        if (data['data'].length < pageSize) {
          hasMoreData = false;
        } else {
          pageNumber++;
        }
      });
    } else {
      // Handle error
      // You can also show an error message if needed
    }

    setState(() {
      isLoading = false;
      isLoadingMore = false;
    });
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
                _createLead(), // Now we have two FABs
                _viewLeads(),
              ],
              colorStartAnimation: Colors.white,
              colorEndAnimation: Colors.red,
              animatedIconData: AnimatedIcons.menu_close,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const BottomNavigationPage();
              },
              curve: Curves.fastOutSlowIn,
              duration: const Duration(seconds: 1),
            );
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        title: Container(
          height: 35,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('Follow Up List'),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blue,
                size: 50,
              ),
            )
          : followUpList.isEmpty
              ? Center(
                  child: Text(
                    'No follow ups available.',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: followUpList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == followUpList.length) {
                            if (hasMoreData) {
                              getFollowUpList();
                              return Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.red,
                                  size: 50,
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('No more data'),
                              );
                            }
                          }

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: ExpansionTile(
                                  childrenPadding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 0.0,
                                      bottom: 0.0),
                                  leading: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0x300D6EFD),
                                      radius: 26,
                                      child: Icon(
                                        size: 26,
                                        Icons.person_2_outlined,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_rounded,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  ),

                                  //company name
                                  title: Text(
                                    followUpList[index]['company_name']
                                            ['company_name'] ??
                                        'Unknown',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      // phone
                                      Text(
                                        followUpList[index]['phone_number'] ??
                                            'No Phone No.',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.blue[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Email
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.merge_type_outlined,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                  const SizedBox(width: 10),

                                                  // follow up type
                                                  const Text(
                                                    'Follow up type',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xFF242424),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // status
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.pending_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  // status
                                                  Text(
                                                    followUpList[index]
                                                                ['status'] ==
                                                            '1'
                                                        ? 'Solved'
                                                        : followUpList[index][
                                                                    'status'] ==
                                                                '2'
                                                            ? 'Pending'
                                                            : followUpList[index]
                                                                        [
                                                                        'status'] ==
                                                                    '3'
                                                                ? 'Working Progress'
                                                                : 'Cancel' ??
                                                                    'Type Unknown',
                                                    style: TextStyle(
                                                      color: Colors.blue[400],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // assign to
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .person_add_alt_1_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    followUpList[index]
                                                                ['assign_name']
                                                            ['name'] ??
                                                        'No Assign',
                                                    style: TextStyle(
                                                      color: Colors.blue[400],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.green[100],
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.call,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Colors.blue[100],
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.dialer_sip_outlined,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // divider

                              const Divider(
                                height: 3,
                                thickness: 0.2,
                                indent:
                                    20, // empty space to the leading edge of divider.
                                endIndent: 20,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _createLead() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FollowUpCreate()),
          );
        },
        heroTag: "Create Lead",
        tooltip: 'Create Lead',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _viewLeads() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        heroTag: "View Leads",
        tooltip: 'View Leads',
        child: const Icon(Icons.visibility),
      ),
    );
  }
}
