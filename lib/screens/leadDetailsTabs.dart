import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../Dashboard/bottom_navigation_page.dart';
import '../Lead/leadOverview.dart';
import '../resourses/app_colors.dart';

class LeadDetailsTabs extends StatefulWidget {
  const LeadDetailsTabs({super.key});

  @override
  State<LeadDetailsTabs> createState() => _LeadDetailsTabsState();
}

class _LeadDetailsTabsState extends State<LeadDetailsTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          bottom: const TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              dividerHeight: 0,
              dividerColor: Colors.blue,
              indicatorPadding: EdgeInsets.only(bottom: 10),
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              tabs: [
                // lead Overview
                Tab(
                  child: Text(
                    "Overview",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                // lead follow up
                Tab(
                  child: Text(
                    "Follow up",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                // lead task
                Tab(
                  child: Text(
                    "Task",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                // lead note
                Tab(
                  child: Text(
                    "Note",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                // checklist
                Tab(
                  child: Text(
                    "Check List",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                // history
                Tab(
                  child: Text(
                    "History",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ]),
          backgroundColor: Colors.white,
          // toolbarHeight: 112.62,
          title: const Text(
            "Lead Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                return const BottomNavigationPage();
              }));
            },
          ),
        ),
        body: TabBarView(
          children: [
            // overview
            LeadOverview(),

            // Followup

            Container(
              color: Colors.white,
              child: const Center(
                child: Text("Follow up"),
              ),
            ),

            // Task

            Container(
              color: Colors.white,
              child: const Center(
                child: Text("task"),
              ),
            ),

            // Note
            Container(
              color: Colors.white,
              child: const Center(
                child: Text("note"),
              ),
            ),

            // Checklist
            Container(
              color: Colors.white,
              child: const Center(
                child: Text("checklist"),
              ),
            ),

            // History
            Container(
              color: Colors.white,
              child: const Center(
                child: Text("History"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
