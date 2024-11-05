import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/LeadListModel.dart';
import '../resourses/app_colors.dart';

class LeadOverview extends StatefulWidget {
  final int leadId;

  const LeadOverview({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadOverview> createState() => _LeadOverviewState();
}

class _LeadOverviewState extends State<LeadOverview> {
  bool isLoading = true;
  LeadListModel? leadDetails;

  @override
  void initState() {
    super.initState();
    getLeadDetails();
  }

  Future<void> getLeadDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    final response = await http.post(
      Uri.parse("https://crm.ihelpbd.com/api/crm-lead-data-show"),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '',
        'end_date': '',
        'user_id_search': userId,
        'session_user_id': "",
        'lead_pipeline_id': '',
        'lead_source_id': '',
        'searchData': '',
        'is_type': '0',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      List<dynamic> leadJsonList = data['data'];

      var matchingLead = leadJsonList.firstWhere(
        (lead) => lead['id'] == widget.leadId,
        orElse: () => null,
      );

      setState(() {
        if (matchingLead != null) {
          leadDetails = LeadListModel.fromJson(matchingLead);
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        // Positioned.fill(
        //   child: Image.asset(
        //     'assets/images/details.png',
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // Content
        isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue,
                  size: 50,
                ),
              )
            : leadDetails == null
                ? const Center(
                    child: Text(
                      "Lead not found",
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Top Section with profile
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: Icon(
                                    Icons.person_2_outlined,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  leadDetails?.companyName ?? "N/A",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  leadDetails?.name ?? "No lead name",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),

                        // Details Container
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 30,
                            right: 30,
                            bottom: 20,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Contact Information Section
                                Card(
                                  elevation: 0.2,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 60,
                                        color: Colors.blue,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "Contact Information",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Text(
                                                "Phone: ${leadDetails?.phoneNumber ?? 'N/A'}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                              Text(
                                                "Email: ${leadDetails?.email ?? 'N/A'}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Lead Information Section
                                Card(
                                  elevation: 0.2,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 90,
                                        color: Colors.blue,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "Lead Information",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Text(
                                                "Pipeline: ${leadDetails?.leadPipelineName?.name ?? 'N/A'}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                              Text(
                                                "Area: ${leadDetails?.leadAreasName?['name'] ?? 'N/A'}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                              Text(
                                                "Source: ${leadDetails?.leadSourceName?['name'] ?? 'N/A'}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                              Text(
                                                "Created: ${DateFormat.yMd().add_jm().format(DateTime.parse(leadDetails?.leadPipelineName?.createdAt ?? DateTime.now().toString()))}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Assigned Users Section
                                Card(
                                  elevation: 0.2,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 60,
                                        color: Colors.blue,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "Assigned Users",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Text(
                                                "Assigned to: ${leadDetails?.assignName?.name ?? 'N/A'}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                              Text(
                                                "Associates: ${leadDetails?.associates?.isNotEmpty == true ? leadDetails!.associates!.map((e) => e.name).join(", ") : "N/A"}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
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

                        // Bottom Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.018,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.08,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.03,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "DELETE LEAD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 11),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.018,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.08,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.03,
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "EDIT LEAD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }
}
