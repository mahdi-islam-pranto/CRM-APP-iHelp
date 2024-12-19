import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/FollowUP/FollowUPListScreen.dart';

import 'package:untitled1/screens/totalLeadList.dart';
import 'package:http/http.dart' as http;

import '../API/api_url.dart';
import '../Task/allPendingTask.dart';
import '../screens/opportunityList.dart';

class DashboardCounter extends StatefulWidget {
  const DashboardCounter({super.key});

  @override
  State<DashboardCounter> createState() => _DashboardCounterState();
}

class _DashboardCounterState extends State<DashboardCounter> {
  int totalLeadCount = 0;
  int totalPendingFollowupCount = 0;
  int totalPendingTaskCount = 0;
  int totalOpportunityCount = 0;

  // fetch counts from API
  fetchCounts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    final response = await http.post(
      Uri.parse(ApiUrls.dashboardCounterUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'user_id': userId,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        totalLeadCount = data["data"][0]['count'];
        totalOpportunityCount = data["data"][1]['count'];
        totalPendingFollowupCount = data["data"][2]['count'];
        totalPendingTaskCount = data["data"][3]['count'];
      });
      // print count data
      print("counter data from API: ${data["data"][0]}");
    } else {
      throw Exception('Failed to load lead counts');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Define relative sizes based on screen dimensions
    final double containerHeight1 = screenHeight * 0.2;
    final double containerHeight2 = screenHeight * 0.14;
    final double containerHeight3 = screenHeight * 0.14;
    final double containerHeight4 = screenHeight * 0.2;
    final double containerWidth = screenWidth * 0.43;
    final double iconSize = screenHeight * 0.04;
    final double textSize = screenHeight * 0.022;

    // default text style for dashboard counter
    TextStyle defaultTextStyleForCounter = TextStyle(
      color: Colors.white,
      fontSize: textSize,
      fontWeight: FontWeight.bold,
      shadows: const [
        Shadow(
          offset: Offset(2.0, 2.0), // Horizontal and vertical offset
          blurRadius: 2.0, // Blur effect
          color: Colors.black26, // Shadow color
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.00,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1st coloum
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeadListScreen(),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFA9FFEA), Color(0xFF00B388)],
                    ),
                  ),
                  height: containerHeight1,
                  width: containerWidth,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.leaderboard,
                            shadows: const [
                              Shadow(
                                offset: Offset(
                                    2.0, 2.0), // Horizontal and vertical offset
                                blurRadius: 2.0, // Blur effect
                                color: Colors.black12, // Shadow color
                              ),
                            ],
                            color: Colors.white,
                            size: iconSize),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Total Leads",
                                style: defaultTextStyleForCounter),
                            Text(
                              "$totalLeadCount",
                              style: defaultTextStyleForCounter,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FollowUpList(),
                      ));
                },
                child: Container(
                  height: containerHeight2,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFA0BC), Color(0xFFFF1B5E)],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.follow_the_signs,
                            shadows: const [
                              Shadow(
                                offset: Offset(
                                    2.0, 2.0), // Horizontal and vertical offset
                                blurRadius: 2.0, // Blur effect
                                color: Colors.black12, // Shadow color
                              ),
                            ],
                            color: Colors.white,
                            size: iconSize),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Follow Ups",
                              style: defaultTextStyleForCounter,
                            ),
                            Text(
                              "$totalPendingFollowupCount",
                              style: defaultTextStyleForCounter,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(width: screenWidth * 0.05),

          // 2nd col
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OpportunityListScreen(),
                      ));
                },
                child: Container(
                  height: containerHeight3,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFD29D), Color(0xFFFF9E2D)],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.lightbulb_outline_sharp,
                            shadows: const [
                              Shadow(
                                offset: Offset(
                                    2.0, 2.0), // Horizontal and vertical offset
                                blurRadius: 2.0, // Blur effect
                                color: Colors.black12, // Shadow color
                              ),
                            ],
                            color: Colors.white,
                            size: iconSize),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Opportunities",
                              style: defaultTextStyleForCounter,
                            ),
                            Text(
                              "$totalOpportunityCount",
                              style: defaultTextStyleForCounter,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PendingTaskListScreen(),
                      ));
                },
                child: Container(
                  height: containerHeight4,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFB1EEFF), Color(0xFF29BAE2)],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.task,
                            shadows: const [
                              Shadow(
                                offset: Offset(
                                    2.0, 2.0), // Horizontal and vertical offset
                                blurRadius: 2.0, // Blur effect
                                color: Colors.black12, // Shadow color
                              ),
                            ],
                            color: Colors.white,
                            size: iconSize),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Pending Tasks",
                                textAlign: TextAlign.center,
                                style: defaultTextStyleForCounter),
                            Text("$totalPendingTaskCount",
                                style: defaultTextStyleForCounter),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
