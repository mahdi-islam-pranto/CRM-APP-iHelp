import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/followUpModel.dart';
import '../resourses/app_colors.dart';
import 'FollowUPListScreen.dart';
import 'followUpUpdate.dart';

// follow up details page

class FollowUpOverview extends StatefulWidget {
  final int followUpId;

  const FollowUpOverview({Key? key, required this.followUpId})
      : super(key: key);

  @override
  State<FollowUpOverview> createState() => _FollowUpOverviewState();
}

class _FollowUpOverviewState extends State<FollowUpOverview> {
  bool isLoading = true;
  Data? followUpDetails;

  @override
  void initState() {
    super.initState();
    getFollowUpDetails();
  }

  Future<void> getFollowUpDetails() async {
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
        'session_user_id': "",
        'followup_type_id': '',
        'status': '',
        'lead_id': '',
        'next_followup_date': '',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      FollowUpModel followUpModel = FollowUpModel.fromJson(data);

      setState(() {
        followUpDetails = followUpModel.data?.firstWhere(
          (followUp) => followUp.id == widget.followUpId,
          orElse: () => Data(),
        );
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   // toolbarHeight: 112.62,
      //   title: const Text(
      //     "Follow Up Details",
      //     style: TextStyle(fontSize: 20),
      //   ),
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back_ios,
      //       size: 18,
      //       color: Colors.blue,
      //     ),
      //     onPressed: () {
      //       // got to previous screen
      //       Navigator.push(context, MaterialPageRoute(builder: (context) {
      //         return const FollowUpList();
      //       }));
      //     },
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

          // task contents

          isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 50,
                  ),
                )
              : followUpDetails == null
                  ? const Center(child: Text("Follow-up not found"))
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
                                    radius: 17,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Follow Up Details",
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

                          // top section
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Center(
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Icon(
                                      Icons.arrow_circle_right_outlined,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      followUpDetails
                                              ?.companyName?.companyName ??
                                          "N/A",
                                      style: const TextStyle(
                                          fontSize: 28, color: Colors.white)),
                                  const SizedBox(height: 5),
                                  Text(
                                    followUpDetails?.subject ?? "No subject",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Phone: ${followUpDetails?.phoneNumber ?? "N/A"}",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // follow up info section
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

                                    // Folow-up Information Section
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
                                              title: Text(
                                                  "Follow-up Information",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                      "Follow-up Type: ${followUpDetails?.followUpName?.name ?? "N/A"}",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                  Text(
                                                      "Status: ${followUpDetails?.followUpStatus?.name ?? "N/A"}",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                  Text(
                                                      "Next Follow-up Date: ${followUpDetails?.nextFollowupDate ?? "N/A"}",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                  Text(
                                                      "Created At: ${DateFormat.yMd().add_jm().format(DateTime.parse(followUpDetails?.createdAt ?? "N/A"))}",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                  // Text(
                                                  //     "Created At: ${followUpDetails?.createdAt ?? "N/A"}"),
                                                  // returns: 2024-02-29T12:49:43.000000Z
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // assigned users section
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
                                                      "Assign to: ${followUpDetails?.assignName?.name ?? "N/A"}",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                  Text(
                                                      "Creator: ${followUpDetails?.creatorName?.name ?? "N/A"}",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                  Text(
                                                      "Associates: ${followUpDetails?.associates?.map((e) => e.name).join(", ") ?? "N/A"}",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // description section
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
                                                child: Text(
                                                    followUpDetails
                                                            ?.description ??
                                                        "No description available",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[700])),
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

                          // buttons
                          // Bottom Section (Optional actions or additional info)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Delete task
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: EdgeInsets.symmetric(
                                      vertical: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.018, // Adjust the vertical padding as needed
                                      horizontal: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.12, // Adjust the horizontal padding as needed
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.03, // Adjust the border radius as needed
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "DELETE",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 11),

                                // update task
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.018, // Adjust the vertical padding as needed
                                      horizontal: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.12, // Adjust the horizontal padding as needed
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.width *
                                            0.03, // Adjust the border radius as needed
                                      ),
                                    ),
                                  ),
                                  child: const Text("UPDATE",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  onPressed: () {
                                    // Implement edit functionality
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FollowUpUpdate(
                                                    leadId: followUpDetails
                                                            ?.leadId ??
                                                        0,
                                                    followUpId:
                                                        widget.followUpId,
                                                    followUpDetails:
                                                        followUpDetails!)));
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
