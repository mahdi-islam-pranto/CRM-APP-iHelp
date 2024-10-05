import 'package:flutter/material.dart';
import 'package:untitled1/Lead/leadCreateform.dart';

import '../Contacts/contact_services.dart';
import '../FollowUP/FollowUPListScreen.dart';
import '../FollowUP/followUplistPageForTest.dart';
import '../Task/allTaskListScreen.dart';
import '../resourses/app_colors.dart';
import '../resourses/resourses.dart';

import '../screens/leadDetailsTabs.dart';
import '../screens/totalLeadList.dart';

import '../screens/settings.dart';
import 'dashboard.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int mycurrentIndex = 2;
  PageController _pageController = PageController(initialPage: 2);

  List<Widget> pages = [
    // const Settings(),
    const Settings(),
    const FollowUpList(),
    const NewDashboard(),
    const LeadListScreen(),
    const TaskListScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            mycurrentIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: R.appColors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            currentIndex: mycurrentIndex,
            onTap: (index) {
              setState(() {
                _pageController.jumpToPage(index);
                mycurrentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.contact_page_outlined),
                  label: "Lead Details"),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.contacts), label: "Contacts"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.follow_the_signs), label: "Followup"),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.leaderboard), label: "Lead"),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"),
            ],
          ),
        ),
      ),
    );
  }
}
