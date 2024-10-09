import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/FollowUP/followUpOverview.dart';
import 'package:untitled1/Models/followUpModel.dart';
import 'package:untitled1/resourses/app_colors.dart';
import '../Dashboard/bottom_navigation_page.dart';
import 'followUpCreateForm.dart';
import '../resourses/resourses.dart';

import 'package:http/http.dart' as http;

import 'leadFollowUpCreate.dart';

class LeadFollowUpList extends StatefulWidget {
  final int leadId;

  const LeadFollowUpList({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadFollowUpList> createState() => _LeadFollowUpListState();
}

class _LeadFollowUpListState extends State<LeadFollowUpList> {
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
        'start_date': '',
        'end_date': '',
        'user_id': userId,
        'session_user_id': userId,
        'followup_type_id': '',
        'status': '',
        'lead_id': '${widget.leadId}',
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
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarRadius =
        screenWidth * 0.05; // Adjust radius based on screen width
    double iconSize =
        screenWidth * 0.05; // Adjust icon size based on screen width
    double spacing = screenWidth * 0.02; // Adjust spacing based on screen width

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
                                  color: Colors.blue,
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
                                  // leading: const Padding(
                                  //   padding: EdgeInsets.only(right: 10),
                                  //   child: CircleAvatar(
                                  //     backgroundColor: Color(0x300D6EFD),
                                  //     radius: 26,
                                  //     child: Icon(
                                  //       size: 26,
                                  //       Icons.person_2_outlined,
                                  //       color: Colors.blue,
                                  //     ),
                                  //   ),
                                  // ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Icon(
                                      //   Icons.remove_red_eye_rounded,
                                      //   color: Colors.grey[400],
                                      // ),
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
                                  subtitle: Column(
                                    children: [
                                      // status
                                      Row(
                                        children: [
                                          const Text("Status: "),
                                          const SizedBox(width: 5),
                                          // status
                                          Text(
                                            followUpList[index]['status'] == '1'
                                                ? 'Solved'
                                                : followUpList[index]
                                                            ['status'] ==
                                                        '2'
                                                    ? 'Pending'
                                                    : followUpList[index]
                                                                ['status'] ==
                                                            '3'
                                                        ? 'Working Progress'
                                                        : 'Cancel' ??
                                                            'Type Unknown',
                                            style: TextStyle(
                                              color: Colors.blue[600],
                                            ),
                                          ),
                                        ],
                                      ),

                                      // next follow up date

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 10),
                                          // phone
                                          Text(
                                            followUpList[index]
                                                    ['next_followup_date'] ??
                                                'No Next Follow Up Date',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.blue[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // inside tile datas
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, top: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // follow up type
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.merge_type_outlined,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                  SizedBox(width: spacing),

                                                  // follow up type
                                                  Text(
                                                    'Follow up type',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: Colors.grey[900],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: spacing),
                                              // phone
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: Colors.grey[700],
                                                  ),
                                                  SizedBox(width: spacing),
                                                  // phone
                                                  Text(
                                                    followUpList[index]
                                                            ['phone_number'] ??
                                                        'No Phone No.',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: Colors.grey[900],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: spacing,
                                              ),
                                              // assign to
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .person_add_alt_1_outlined,
                                                    color: Colors.grey[700],
                                                  ),
                                                  SizedBox(width: spacing),
                                                  Text(
                                                    followUpList[index]
                                                                ['assign_name']
                                                            ['name'] ??
                                                        'No Assign',
                                                    style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontSize: 13.sp),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: spacing,
                                              ),

                                              // Other details
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.more_horiz,
                                                    color: Colors.grey[700],
                                                  ),
                                                  SizedBox(
                                                    width: spacing,
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minimumSize:
                                                            Size(50, 30),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        alignment: Alignment
                                                            .centerLeft),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FollowUpOverview(
                                                            followUpId:
                                                                followUpList[
                                                                        index]
                                                                    ['id'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'More Details',
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // const Spacer(),
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   children: [
                                          //     CircleAvatar(
                                          //       radius: 20,
                                          //       backgroundColor:
                                          //           Colors.green[100],
                                          //       child: IconButton(
                                          //         onPressed: () {},
                                          //         icon: const Icon(
                                          //           Icons.call,
                                          //           color: Colors.green,
                                          //           size: 20,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     const SizedBox(width: 10),
                                          //     CircleAvatar(
                                          //       radius: 20,
                                          //       backgroundColor:
                                          //           Colors.blue[100],
                                          //       child: IconButton(
                                          //         onPressed: () {},
                                          //         icon: const Icon(
                                          //           Icons.dialer_sip_outlined,
                                          //           color: Colors.blue,
                                          //           size: 20,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
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
        backgroundColor: Colors.blue[400],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LeadFollowUpCreate()),
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
        backgroundColor: Colors.grey[300],
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
