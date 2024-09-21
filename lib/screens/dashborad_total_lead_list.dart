import 'package:flutter/material.dart';

import 'package:untitled1/screens/details_total_list.dart';

class DashboardTotalLeadList extends StatefulWidget {
  const DashboardTotalLeadList({Key? key}) : super(key: key);

  @override
  State<DashboardTotalLeadList> createState() => _DashboardTotalLeadListState();
}

class _DashboardTotalLeadListState extends State<DashboardTotalLeadList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lead Details"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18, // Replace with the desired custom icon
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Total Lead'),
              Tab(text: 'Pending Lead'),
              Tab(text: 'Today Lead'),
              Tab(text: 'Next 3 days Lead'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              // Content for the Contacts tab
              /// total lead
              DetailsTotalLeadList(),
              DetailsTotalLeadList(),
              DetailsTotalLeadList(),
              DetailsTotalLeadList(),
            ],
          ),
        ),
      ),
    );
  }
}
