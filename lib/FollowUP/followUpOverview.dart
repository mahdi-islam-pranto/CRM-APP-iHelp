import 'dart:convert';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        // toolbarHeight: 112.62,
        title: const Text(
          "Follow Up Details",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.blue,
          ),
          onPressed: () {
            // got to previous screen
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const FollowUpList();
            }));
          },
        ),
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
            : followUpDetails == null
                ? const Center(child: Text("Follow-up not found"))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // top section
                          Center(
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0x300D6EFD),
                                  radius: 50,
                                  child: Icon(
                                    Icons.follow_the_signs_rounded,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  followUpDetails?.companyName?.companyName ??
                                      "N/A",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  followUpDetails?.subject ?? "No subject",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Phone: ${followUpDetails?.phoneNumber ?? "N/A"}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // follow up info section
                          Card(
                            color: Colors.blue[100],
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text("Follow-up Information",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                      "Follow-up Type: ${followUpDetails?.followUpName?.name ?? "N/A"}"),
                                  Text(
                                      "Status: ${followUpDetails?.followUpStatus?.name ?? "N/A"}"),
                                  Text(
                                      "Next Follow-up Date: ${followUpDetails?.nextFollowupDate ?? "N/A"}"),
                                  Text(
                                    "Created At: ${DateFormat.yMd().add_jm().format(DateTime.parse(followUpDetails?.createdAt ?? "N/A"))}",
                                  ),
                                  // Text(
                                  //     "Created At: ${followUpDetails?.createdAt ?? "N/A"}"),
                                  // returns: 2024-02-29T12:49:43.000000Z
                                ],
                              ),
                            ),
                          ),
                          // assigned users section
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
                                  Text(
                                      "Assign to: ${followUpDetails?.assignName?.name ?? "N/A"}"),
                                  Text(
                                      "Creator: ${followUpDetails?.creatorName?.name ?? "N/A"}"),
                                  Text(
                                      "Associates: ${followUpDetails?.associates?.map((e) => e.name).join(", ") ?? "N/A"}"),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          // description section
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text("Description",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  followUpDetails?.description ??
                                      "No description available",
                                ),
                              ),
                            ),
                          ),
                          // buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                                    // Implement delete functionality
                                  },
                                  child: const Text(
                                    "DELETE ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 11),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(164, 52),
                                    maximumSize: const Size(181, 52),
                                    backgroundColor: buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                  ),
      ),
    );
  }
}
