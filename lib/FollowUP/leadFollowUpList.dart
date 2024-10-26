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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4.0),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ExpansionTile(
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    childrenPadding: const EdgeInsets.all(10),
                                    leading: const CircleAvatar(
                                      backgroundColor: Color(0x300D6EFD),
                                      child: Icon(Icons.business,
                                          color: Colors.blue),
                                    ),
                                    trailing: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.blue),
                                    title: Text(
                                      followUpList[index]['company_name']
                                              ['company_name'] ??
                                          'Unknown',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.label_outline,
                                                size: 16, color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Status: ${getStatusText(followUpList[index]['status'])}",
                                              style: TextStyle(
                                                  color: getStatusColor(
                                                      followUpList[index]
                                                          ['status'])),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: 16, color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              followUpList[index]
                                                      ['next_followup_date'] ??
                                                  'No Next Follow Up Date',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow(
                                                    Icons.subject,
                                                    followUpList[index]
                                                            ['subject'] ??
                                                        'No Subject'),
                                                const SizedBox(height: 8),
                                                _buildInfoRow(
                                                    Icons.phone,
                                                    followUpList[index]
                                                            ['phone_number'] ??
                                                        'No Phone No.'),
                                                const SizedBox(height: 8),
                                                _buildInfoRow(
                                                    Icons.person,
                                                    followUpList[index]
                                                                ['assign_name']
                                                            ['name'] ??
                                                        'No Assign'),
                                                const SizedBox(height: 8),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              const Text("More Details"),
                                              const SizedBox(height: 8),
                                              _buildActionButton(
                                                  Icons.visibility,
                                                  Colors.blue,
                                                  'View', () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FollowUpOverview(
                                                              followUpId:
                                                                  followUpList[
                                                                          index]
                                                                      ['id'])),
                                                );
                                              }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // divider

                              // const Divider(
                              //   height: 3,
                              //   thickness: 0.2,
                              //   indent:
                              //       20, // empty space to the leading edge of divider.
                              //   endIndent: 20,
                              // ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
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
