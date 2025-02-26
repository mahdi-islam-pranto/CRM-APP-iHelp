import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../FollowUP/FollowUPListScreen.dart';
import '../Task/allTaskListScreen.dart';
import '../screens/totalLeadList.dart';
import '../screens/menu_page.dart';
import 'dashboard.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {


  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request permissions first
  }

// Ensure permissions are granted before accessing contacts
  Future<void> _requestPermissions() async {
    await Permission.contacts.request();
    await Permission.storage.request();
    await Permission.phone.request();
    await Permission.microphone.request();
    await Permission.systemAlertWindow.request();
    await Permission.ignoreBatteryOptimizations.request();

    // Check if permission is granted before calling getContacts()
    if (await Permission.contacts.isGranted) {
    } else {
      showAlertDialog(); // Show alert if denied
    }
  }


// Call this when the "My Contacts" button is clicked
  void onMyContactsButtonPressed() async {
    if (await Permission.contacts.isGranted) {
    } else {
      _requestPermissions();
    }
  }



  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Allow Permission"),
          content:
          const Text("Please allow Contact permission to view contacts"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => openAppSettings(), child: const Text("OK")),
          ],
        );
      },
    );
  }


  int mycurrentIndex = 2;
  PageController _pageController = PageController(initialPage: 2);

  List<Widget> pages = [
    // const Settings(),
    const MenuPage(),
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
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 234, 233, 233).withOpacity(0.7),
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
            unselectedItemColor: Colors.black54,
            currentIndex: mycurrentIndex,
            onTap: (index) {
              setState(() {
                _pageController.jumpToPage(index);
                mycurrentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    shadows: [
                      Shadow(
                        offset:
                            Offset(2.0, 2.0), // Horizontal and vertical offset
                        blurRadius: 2.0, // Blur effect
                        color: Colors.black12, // Shadow color
                      ),
                    ],
                  ),
                  label: "Menu"),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.contacts), label: "Contacts"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.follow_the_signs,
                    shadows: [
                      Shadow(
                        offset:
                            Offset(2.0, 2.0), // Horizontal and vertical offset
                        blurRadius: 2.0, // Blur effect
                        color: Colors.black12, // Shadow color
                      ),
                    ],
                  ),
                  label: "Followup"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    shadows: [
                      Shadow(
                        offset:
                            Offset(2.0, 2.0), // Horizontal and vertical offset
                        blurRadius: 2.0, // Blur effect
                        color: Colors.black12, // Shadow color
                      ),
                    ],
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.leaderboard,
                    shadows: [
                      Shadow(
                        offset:
                            Offset(2.0, 2.0), // Horizontal and vertical offset
                        blurRadius: 2.0, // Blur effect
                        color: Colors.black12, // Shadow color
                      ),
                    ],
                  ),
                  label: "Lead"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.task,
                    shadows: [
                      Shadow(
                        offset:
                            Offset(2.0, 2.0), // Horizontal and vertical offset
                        blurRadius: 2.0, // Blur effect
                        color: Colors.black12, // Shadow color
                      ),
                    ],
                  ),
                  label: "Task"),
            ],
          ),
        ),
      ),
    );
  }
}
