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

  // fetch specific lead details
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

      // Find the specific lead that matches the leadId
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
      // Handle error
      setState(() {
        isLoading = false;
      });
      // You can also show an error message if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blue,
                size: 50,
              ),
            )
          : leadDetails == null
              ? const Center(child: Text("Lead not found"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Section
                        Center(
                          child: Column(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0x300D6EFD),
                                radius: 50,
                                child: Icon(
                                  Icons.person_2_outlined,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                leadDetails?.companyName ?? "N/A",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                leadDetails?.name ?? "No lead name",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Phone: ${leadDetails?.phoneNumber ?? "N/A"}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Email: ${leadDetails?.email ?? "N/A"}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Lead Information Section
                        Card(
                          color: Colors.blue[100],
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text("Lead Information",
                                style: Theme.of(context).textTheme.titleLarge),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                    "Lead Pipeline: ${leadDetails?.leadPipelineName?.name ?? "N/A"}"),
                                Text(
                                    "Lead Area: ${leadDetails?.leadAreasName?['name'] ?? "N/A"}"),
                                Text(
                                    "Lead Source: ${leadDetails?.leadSourceName?['name'] ?? "N/A"}"),
                                Text(
                                    "Created At: ${DateFormat.yMd().add_jm().format(DateTime.parse(leadDetails?.leadPipelineName?.createdAt ?? "N/A"))} "),
                              ],
                            ),
                          ),
                        ),

                        // Assign Users Section
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text("Assigned Users",
                                style: Theme.of(context).textTheme.titleLarge),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                    "Assign to: ${leadDetails?.assignName?.name ?? "N/A"}"),
                                Text(
                                    "Associates: ${leadDetails?.associates?.isNotEmpty == true ? leadDetails!.associates!.map((e) => e.name).join(", ") : "N/A"}"),
                              ],
                            ),
                          ),
                        ),

                        // Description Section
                        // Card(
                        //   margin: const EdgeInsets.symmetric(vertical: 10),
                        //   child: ListTile(
                        //     title: Text("Description",
                        //         style: Theme.of(context).textTheme.titleLarge),
                        //     subtitle: const Padding(
                        //       padding: EdgeInsets.only(top: 10.0),
                        //       child: Text(
                        //         "This is a detailed description of the lead. Here you can provide more information about the lead and any other relevant details that might be useful.",
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // Bottom Section (Optional actions or additional info)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Delete lead
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
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "DELETE LEAD",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 11),

                              // update lead
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(164, 52),
                                  maximumSize: const Size(181, 52),
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("EDIT LEAD",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
