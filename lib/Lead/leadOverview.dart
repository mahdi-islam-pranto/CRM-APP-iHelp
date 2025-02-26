import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/widget/lead_details_cotact_information.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/LeadListModel.dart';

class LeadOverview extends StatefulWidget {
  final int leadId;

  const LeadOverview({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadOverview> createState() => _LeadOverviewState();
}

// Function to launch URL in phone app
void urlLauncher(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
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
        'user_id_search':userId,
        'session_user_id':userId,
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
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        radius: 30,
                        child: const Icon(
                          Icons.person_2_outlined,
                          size: 40,
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

                            // contact information
                            Expanded(
                              child: ContactInformationCard(
                                phoneNumber: leadDetails?.phoneNumber ?? 'N/A',
                                callerName: leadDetails?.companyName?? 'N/A',
                                email: leadDetails?.email ?? 'N/A',
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


            ],
          ),
        ),
      ],
    );
  }
}
