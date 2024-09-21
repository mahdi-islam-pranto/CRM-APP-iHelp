import 'package:flutter/material.dart';

import '../FollowUP/FollowUPListScreen.dart';
import '../resourses/resourses.dart';

import '../screens/allTaskListScreen.dart';
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
      backgroundColor: R.appColors.white,
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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            selectedItemColor: Colors.teal,
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
                  icon: Icon(Icons.settings), label: "Setting"),
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
