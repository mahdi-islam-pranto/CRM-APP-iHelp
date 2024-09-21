import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Auth/login_page.dart';
import 'package:untitled1/sip_account/SipAccountSetting.dart';

import '../Auth/logout.dart';
import '../Models/leadPipeline.dart';
import '../Models/menuItem.dart';
import '../Models/menuItems.dart';
import '../components/DashboardCounter.dart';
import '../components/Dashboard_Tasks.dart';

import '../components/LeadPipelineChart.dart';
import '../components/LeadSourceChart.dart';
import '../components/leadIndustryChart.dart';
import '../screens/form.dart';

class NewDashboard extends StatefulWidget {
  const NewDashboard({Key? key}) : super(key: key);

  @override
  State<NewDashboard> createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  late Future<Map<String, dynamic>> futureLeadData;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    futureLeadData = fetchLeadPipelineData();
  }

  String? username;
  String? email;
  String? role;

  /// fetch user name and email from SP
  _loadUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString("name");
      email = sharedPreferences.getString("email");
      role = sharedPreferences.getString("user_role");
      print("object ################# $username++$email+$role");
    });
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          // Navigate to another page when the "Image" button is pressed
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Create",
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.black)),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle lead btton click
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return const FormPage();
                                  },
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(seconds: 1),
                                );

                                // Add your lead button logic here
                              },
                              child: const Text('Lead'),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle task button click
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return const FormPage();
                                  },
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(seconds: 1),
                                );
                              },
                              child: const Text('Task'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            curve: Curves.fastOutSlowIn,
            duration: const Duration(seconds: 1),
          );
        },
        heroTag: "",
        tooltip: '',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget sipDailpad() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context, PageTransition(child: SipAccountSetting(),
          //   type: PageTransitionType.leftToRight,
          //   duration: Duration(milliseconds:400),
          //   inheritTheme: true,
          // ));

          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return const SipAccountSetting();
            },
            curve: Curves.fastOutSlowIn,
            duration: const Duration(seconds: 1),
          );
        },
        heroTag: "Sip Call",
        tooltip: 'Sip Call',
        child: const Icon(
          Icons.dialer_sip_outlined,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget Clients() {
    return Container(
      child: const InkWell(
        // onTap: () => Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => NewDashboard())),
        child: FloatingActionButton(
          onPressed: null,
          heroTag: "Clients",
          tooltip: 'Clients',
          child: Icon(
            Icons.manage_accounts,
          ),
        ),
      ),
    );
  }

  Widget Opportunity() {
    return Container(
      child: const InkWell(
        // onTap: () => Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => NewDashboard())),
        child: FloatingActionButton(
          onPressed: null,
          heroTag: "Opportunity",
          tooltip: 'Opportunity',
          child: Icon(Icons.ac_unit_outlined),
        ),
      ),
    );
  }

  Widget repport() {
    return Container(
      child: const InkWell(
        // onTap: () => Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => NewDashboard())),
        child: FloatingActionButton(
          onPressed: null,
          heroTag: "Report",
          tooltip: 'Report',
          child: Icon(Icons.report),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// App's Top section with user name and logout button
                Center(
                  child: Container(
                    width: 330.w,
                    height: 80.h,
                    color: Colors.white,
                    child: Column(
                      children: [
                        // User Name and user detail in APP top section
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "Hi, $username",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: const Color.fromRGBO(18, 22, 92, 100),
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              email.toString(),
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color.fromRGBO(153, 153, 153, 100),
                              ),
                            ),

                            ///tra
                            trailing: PopupMenuButton<DropMenuItem>(
                              color: Colors.green[50],
                              position: PopupMenuPosition.under,
                              padding: const EdgeInsets.only(
                                  right: 15, top: 10, bottom: 10),
                              icon: Image.asset(
                                "assets/images/person.png",
                                color: Colors.blueGrey,
                                fit: BoxFit.cover,
                                width: 25.w,
                              ),
                              itemBuilder: (context) => [
                                ...MenuItems.itemsFirst.map(buildItem).toList(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                /// All Containers with Total lead number, Total user, etc
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: DashboardCounter(),
                ),

                /// Today Task
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Text(
                        "Today's Tasks",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: const Color.fromRGBO(17, 23, 93, 100),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                            size: 25.sp,
                          )),
                    )
                  ],
                ),

                /// Show Tasks as a List of data and Contact

                const DashboardTasks(),

                SizedBox(
                  height: 28.h,
                ),

                /// Analaytic
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Text(
                        "Analytics",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: const Color.fromRGBO(17, 23, 93, 100),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20.h,
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Text(
                        "Lead PipeLine: ",
                        style: TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromRGBO(17, 23, 93, 100),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 40.h,
                ),

                // Lead Pipeline Chart Show

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: futureLeadData, // Use futureLeadData here
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> categories =
                            List<String>.from(snapshot.data!['categories']);
                        List<int> values =
                            List<int>.from(snapshot.data!['data']);
                        List<LeadPipelineData> leadData = List.generate(
                          categories.length,
                          (index) => LeadPipelineData(
                            orderNo: index + 1,
                            value: values[index].toDouble(),
                          ),
                        );

                        return Column(
                          children: [
                            LeadPipelineChart(
                                data: leadData, categories: categories),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),

                SizedBox(
                  height: 20.h,
                ),

                // Lead Industry Chart Show

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Text(
                        "Lead Industry: ",
                        style: TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromRGBO(17, 23, 93, 100),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20.h,
                ),

                //Lead Industry Chart

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: LeadIndustryChart(),
                ),

                SizedBox(
                  height: 40.h,
                ),

                // Lead Source Chart

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 26, bottom: 20),
                      child: Text(
                        "Lead Source: ",
                        style: TextStyle(
                            fontSize: 17.sp,
                            color: const Color.fromRGBO(17, 23, 93, 100),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                LeadSourceChart(),

                // Other Widgets in Dashboard
              ],
            ),
          ),
        ),

        // floating action button
        floatingActionButton: Stack(
          children: [
            Positioned(
              // left: 25,
              //  bottom: 650,
              // bottom: 30,
              child: AnimatedFloatingActionButton(
                key: key,
                fabButtons: <Widget>[
                  add(),
                  sipDailpad(),
                  Clients(),
                  Opportunity(),
                  repport(),
                ],
                colorStartAnimation: Colors.white,
                colorEndAnimation: Colors.red,
                animatedIconData: AnimatedIcons.menu_close,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit?.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserLoginScreen())),
                child: const Text('Log out'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // popup menu for log out and exit

  PopupMenuItem<DropMenuItem> buildItem(DropMenuItem item) => PopupMenuItem(
        value: item,
        child: showDropDownData(item),
      );

  Widget showDropDownData(DropMenuItem item) {
    if (item.text == "Sign Out") {
      return Row(
        children: [
          Icon(item.icon, color: Colors.black, size: 20.sp),
          SizedBox(width: 12.w),
          TextButton(
            child: Text(item.text),
            onPressed: () {
              Logout log = Logout(context);
              log.logout();
            },
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80.h,
          width: 80.w,
          child: Image.asset("assets/images/person.png", color: Colors.grey),
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              username ?? "User Name",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 10.w), // Space between username and role
            Text(
              role ?? "User Role",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          email ?? "user@example.com",
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal),
        ),
        Container(
          height: 1.h,
          color: Colors.grey,
          margin: const EdgeInsets.only(top: 20),
        ),
      ],
    );
  }
}
