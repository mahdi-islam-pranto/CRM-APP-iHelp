import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Auth/login_page.dart';
import 'package:untitled1/FollowUP/followUpCreateForm.dart';
import 'package:untitled1/Lead/leadCreateform.dart';
import 'package:untitled1/Task/taskCreateForm.dart';
import 'package:untitled1/resourses/app_colors.dart';
import 'package:untitled1/sip_account/SipAccountSetting.dart';

import '../Auth/logout.dart';
import '../Contacts/contact_services.dart';
import '../Models/leadPipeline.dart';
import '../Models/menuItem.dart';
import '../Models/menuItems.dart';
import '../Notification/notification_service.dart';
import '../Task/todayTaskList.dart';
import '../components/DashboardCounter.dart';
import '../components/DashboardFollowUps.dart';
import '../components/Dashboard_Tasks.dart';

import '../components/LeadPipelineChart.dart';

import '../components/leadIndustryChart.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewDashboard extends StatefulWidget {
  const NewDashboard({Key? key}) : super(key: key);

  @override
  State<NewDashboard> createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  late Future<Map<String, dynamic>> futureLeadData;

  static NotificationServices notificationServices = NotificationServices();

  // carousal controller
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    futureLeadData = fetchLeadPipelineData();
    //notification
    notificationServices.requestNotificationPermissin();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenRefresh();
    notificationServices.isTokenRefresh();

    /// Device Token
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token : ${value}');
        print(value);
      }
    });
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
        backgroundColor: Colors.blue[400],
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("CREATE NEW",
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[100],
                              ),
                              onPressed: () {
                                // Handle lead btton click
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return const LeadCreateForm();
                                  },
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(seconds: 1),
                                );

                                // Add your lead button logic here
                              },
                              child: const Text('Lead',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[100],
                              ),
                              onPressed: () {
                                // Handle task button click
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return const TaskCreateForm();
                                  },
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(seconds: 1),
                                );
                              },
                              child: const Text(
                                'Task',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // new row

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[100],
                              ),
                              onPressed: () {
                                // Handle task button click
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return const FollowUpCreate();
                                  },
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(seconds: 1),
                                );
                              },
                              child: const Text(
                                'Follow Up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 15,
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
    return FloatingActionButton(
      backgroundColor: Colors.grey[300],
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
        color: Colors.black,
      ),
    );
  }

  Widget Contacts() {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ContactServices())),
      child: FloatingActionButton(
        backgroundColor: Colors.grey[300],
        onPressed: null,
        heroTag: "Clients",
        tooltip: 'Clients',
        child: const Icon(
          Icons.contact_page,
        ),
      ),
    );
  }

  Widget notifications() {
    return InkWell(
      // onTap: () => Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => NewDashboard())),
      child: FloatingActionButton(
        backgroundColor: Colors.grey[300],
        onPressed: null,
        heroTag: "Opportunity",
        tooltip: 'Opportunity',
        child: const Icon(Icons.notifications),
      ),
    );
  }

  Widget repport() {
    return const InkWell(
      // onTap: () => Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => NewDashboard())),
      child: FloatingActionButton(
        onPressed: null,
        heroTag: "Report",
        tooltip: 'Report',
        child: Icon(Icons.report),
      ),
    );
  }

  CarouselSliderController carouselSliderController =
      CarouselSliderController();

  // today value
  Object todayValue = '1';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// App's Top section with user name and logout button
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
                    width: ScreenUtil().setWidth(330),
                    height: ScreenUtil().setHeight(80),
                    // width: 330.w,
                    // height: 80.h,
                    color: backgroundColor,
                    child: Column(
                      children: [
                        // User Name and user detail in APP top section
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 8,
                            ),
                            title: Text(
                              "Hi, ${username?.split(' ')[0]}",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: const Color(0xFF2C3131),
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              email.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF707070),
                              ),
                            ),

                            ///trailing
                            trailing: PopupMenuButton<DropMenuItem>(
                              color: Colors.blue[50],
                              position: PopupMenuPosition.under,
                              padding: const EdgeInsets.only(
                                  right: 0, top: 10, bottom: 10),
                              icon: Image.asset(
                                "assets/images/person.png",
                                color: Colors.blueGrey,
                                fit: BoxFit.cover,
                                width: 33.w,
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

                // Carousel with dashbpard counter & two charts (with dot indicator)
                // Carousel Section

                Container(
                  child: Column(
                    children: [
                      CarouselSlider(
                        carouselController: carouselSliderController,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          // screenutil height

                          height: 257.h,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          // enlargeCenterPage: true,
                          // aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: [
                          // Dashboard Counter Section
                          const DashboardCounter(),

                          // Lead Pipeline Chart Card
                          // Lead Pipeline Chart Show

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: futureLeadData, // Use futureLeadData here
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<String> categories = List<String>.from(
                                      snapshot.data!['categories']);
                                  List<int> values =
                                      List<int>.from(snapshot.data!['data']);
                                  List<LeadPipelineData> leadData =
                                      List.generate(
                                    categories.length,
                                    (index) => LeadPipelineData(
                                      orderNo: index + 1,
                                      value: values[index].toDouble(),
                                    ),
                                  );

                                  return Column(
                                    children: [
                                      const Center(
                                        child: Text(
                                          "Lead Pipeline",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF2C3131),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      LeadPipelineChart(
                                          data: leadData,
                                          categories: categories),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text("Couldn't Generate Chart");
                                  // return Text("${snapshot.error}");
                                }
                                return Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                  color: Colors.blue,
                                  size: 40,
                                ));
                              },
                            ),
                          ),

                          // Lead Industry Chart Card

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Lead Industry",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                LeadIndustryChart(),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Dot Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.blue
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// All Containers with Total lead number, Total user, etc
                // const Padding(
                //   padding: EdgeInsets.only(bottom: 6),
                //   child: DashboardCounter(),
                // ),

                /// Today Task
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // if today value is 1
                      if (todayValue == '1')
                        Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Text(
                            "Today's Tasks",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: const Color(0xFF2C3131),
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                      // if today value is 2
                      if (todayValue == '2')
                        Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Text(
                            "Today's Follow Ups",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: const Color(0xFF2C3131),
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                      // drop down button
                      Padding(
                        padding: const EdgeInsets.only(right: 22),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                          customButton: const Icon(
                            Icons.grid_view,
                            size: 28,
                            color: Colors.blue,
                          ),
                          items: const [
                            DropdownMenuItem<String>(
                              value: '1',
                              child: Text(
                                "Today Tasks",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            // divider
                            // DropdownMenuItem<Divider>(
                            //   enabled: false,
                            //   child: Divider(),
                            // ),
                            DropdownMenuItem<String>(
                              value: '2',
                              child: Text(
                                "Today Follow Ups",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              todayValue = value!;
                            });

                            print(todayValue);
                          },

                          // dropdown style
                          dropdownStyleData: DropdownStyleData(
                            direction: DropdownDirection.left,
                            width: 180,
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            offset: const Offset(0, 8),
                          ),

                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                          ),
                        )),
                      )

                      // see all task button
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: Row(
                      //     children: [
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       const TodayTaskListScreen()));
                      //         },
                      //         child: Row(
                      //           children: [
                      //             Text(
                      //               "See All",
                      //               style: TextStyle(
                      //                   color: Colors.grey, fontSize: 12.sp),
                      //             ),
                      //             Icon(
                      //               Icons.chevron_right,
                      //               color: Colors.grey,
                      //               size: 25.sp,
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),

                /// Show Tasks as a List of data and Contact

                // if today value is 1
                if (todayValue == '1') const DashboardTasks(),

                if (todayValue == '2') const DashboardFollowUps(),

                SizedBox(
                  height: 28.h,
                ),

                /// Analaytic
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Text(
                        "Analytics",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: const Color(0xFF2C3131),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 22.h,
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Text(
                        "Lead PipeLine ",
                        style: TextStyle(
                            fontSize: 17.sp,
                            color: const Color(0xFF2C3131),
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
                        return const Text("Couldn't Generate Chart");
                        // return Text("${snapshot.error}");
                      }
                      return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blue,
                        size: 40,
                      ));
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
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Lead Industry: ",
                        style: TextStyle(
                            fontSize: 17.sp,
                            color: const Color(0xFF2C3131),
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

                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 26, bottom: 20),
                //       child: Text(
                //         "Lead Source: ",
                //         style: TextStyle(
                //             fontSize: 17.sp,
                //             color: const Color.fromRGBO(17, 23, 93, 100),
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ],
                // ),

                // LeadSourceChart(),

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
                  Contacts(),
                  notifications(),
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
