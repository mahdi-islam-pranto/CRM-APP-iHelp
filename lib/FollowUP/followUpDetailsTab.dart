import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/FollowUP/FollowUPListScreen.dart';

import 'package:untitled1/screens/totalLeadList.dart';

import '../FollowUP/leadFollowUpList.dart';
import '../Lead/leadOverview.dart';
import '../Lead/leadTaskList.dart';
import '../resourses/app_colors.dart';
import 'followUpOverview.dart';

class FollowUpDetailsTabs extends StatefulWidget {
  final int followUpId;
  const FollowUpDetailsTabs({Key? key, required this.followUpId})
      : super(key: key);

  @override
  State<FollowUpDetailsTabs> createState() => _FollowUpDetailsTabsState();
}

class _FollowUpDetailsTabsState extends State<FollowUpDetailsTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
            "Follow Up Details",
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
                return const FollowUpList();
              }));
            },
          ),
        ),
        body: TabBarView(
          children: [
            // overview
            FollowUpOverview(followUpId: widget.followUpId),

            // Task

            LeadTaskListScreen(leadId: widget.followUpId),

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
