import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/screens/totalLeadList.dart';
import '../FollowUP/leadFollowUpList.dart';
import '../Lead/leadOverview.dart';
import '../Lead/leadTaskList.dart';
import '../resourses/app_colors.dart';

class LeadDetailsTabs extends StatefulWidget {
  final int leadId;
  const LeadDetailsTabs({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadDetailsTabs> createState() => _LeadDetailsTabsState();
}

class _LeadDetailsTabsState extends State<LeadDetailsTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        // backgroundColor: Colors.grey[50],
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: const TabBar(
              // tabAlignment: TabAlignment.start,
              // isScrollable: true,
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
                // Tab(
                //   child: Text(
                //     "Note",
                //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                //   ),
                // ),
                // // checklist
                // Tab(
                //   child: Text(
                //     "Check List",
                //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                //   ),
                // ),
                // // history
                // Tab(
                //   child: Text(
                //     "History",
                //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                //   ),
                // ),
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
                return const LeadListScreen();
              }));
            },
          ),
        ),
        body: TabBarView(
          children: [
            // overview
            Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: LeadOverview(leadId: widget.leadId)),

            // Followup

            LeadFollowUpList(leadId: widget.leadId),

            // Task

            LeadTaskListScreen(leadId: widget.leadId),

            // Note
            // Container(
            //   color: Colors.white,
            //   child: const Center(
            //     child: Text("note"),
            //   ),
            // ),

            // // Checklist
            // Container(
            //   color: Colors.white,
            //   child: const Center(
            //     child: Text("checklist"),
            //   ),
            // ),

            // // History
            // Container(
            //   color: Colors.white,
            //   child: const Center(
            //     child: Text("History"),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
