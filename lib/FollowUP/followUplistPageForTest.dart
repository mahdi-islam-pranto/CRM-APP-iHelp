import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/FollowUP/followUpCreateForm.dart';
import 'package:untitled1/Models/followUpModel.dart';
import 'package:untitled1/resourses/app_colors.dart';
import 'package:untitled1/screens/leadDetailsTabs.dart';
import 'package:http/http.dart' as http;

import '../Dashboard/bottom_navigation_page.dart';
import '../Lead/leadCreateform.dart';
import '../Models/LeadListModel.dart';

class FollowUpListPage extends StatefulWidget {
  const FollowUpListPage({Key? key}) : super();

  @override
  State<FollowUpListPage> createState() => _FollowUpListPageState();
}

class _FollowUpListPageState extends State<FollowUpListPage> {
  bool isLoading = true;
  bool isLoadingMore = false;
  int page = 1;
  final int pageSize = 10; // Number of items to load per page
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  List<FollowUpModel> totalFollowUpList = [];
  bool hasMoreLeads = true; // Flag to check if more leads are available

  @override
  void initState() {
    super.initState();
    getFollowupList(page);
  }

  // fetch leads from API with pagination
  Future<void> getFollowupList(int page) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    if (!isLoadingMore) setState(() => isLoadingMore = true);

    // Make the POST request with form data

    final response = await http.post(
      Uri.parse("https://crm.ihelpbd.com/api/crm-follow-up-list"),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '2024-01-01',
        'end_date': '2024-11-01',
        'user_id': userId,
        'session_user_id': userId,
        'followup_type_id': '',
        'status': '',
        'lead_id': '1910',
        'next_followup_date': '',
        'page': '$page', // Pass the current page number
        'per_page': '$pageSize', // Pass the page size
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      List<dynamic> leadJsonList = data['data'];

      setState(() {
        isLoading = false;
        isLoadingMore = false;
        if (leadJsonList.isNotEmpty) {
          totalFollowUpList.addAll(leadJsonList
              .map((json) => FollowUpModel.fromJson(json))
              .toList());
        } else {
          hasMoreLeads = false; // No more leads to load
        }
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
        isLoadingMore = false;
        hasMoreLeads = false;
      });
      // You can also show an error message if needed
    }
  }

  // Fetch more leads as user scrolls
  Future<void> _loadMoreLeads() async {
    if (!isLoadingMore && hasMoreLeads && totalFollowUpList.isNotEmpty) {
      page++;
      await getFollowupList(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Stack(
        children: [
          Positioned(
            child: AnimatedFloatingActionButton(
              key: key,
              fabButtons: <Widget>[
                _createLead(),
                _viewLeads(), // Added another FAB here
              ],
              colorStartAnimation: Colors.white,
              colorEndAnimation: Colors.red,
              animatedIconData: AnimatedIcons.menu_close,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            showAnimatedDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const BottomNavigationPage();
              },
              curve: Curves.fastOutSlowIn,
              duration: const Duration(seconds: 1),
            );
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        title: Container(
          height: 35,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('Lead List'),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.black,
                size: 50,
              ),
            )
          : totalFollowUpList.isEmpty
              ? Center(
                  child: Text(
                    'No leads available.',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        !isLoadingMore &&
                        hasMoreLeads) {
                      // Ensuring we only load more if there are more leads available
                      _loadMoreLeads();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount:
                        totalFollowUpList.length + (hasMoreLeads ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == totalFollowUpList.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.black,
                              size: 50,
                            ),
                          ),
                        );
                      } else {
                        final lead = totalFollowUpList[index];
                        return _buildListItem(lead);
                      }
                    },
                  ),
                ),
    );
  }

  Map<int, bool> state = {};
  // showing Lead List item
  Widget _buildListItem(FollowUpModel lead) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarRadius =
        screenWidth * 0.05; // Adjust radius based on screen width
    double iconSize =
        screenWidth * 0.05; // Adjust icon size based on screen width
    double spacing = screenWidth * 0.02; // Adjust spacing based on screen width

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 0.0, bottom: 0.0),
            leading: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: Color(0x300D6EFD),
                radius: 26,
                child: Icon(
                  size: 26,
                  Icons.person_2_rounded,
                  color: Colors.blue,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.remove_red_eye_rounded,
                  color: Colors.grey[400],
                ),
                SizedBox(width: spacing),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
            title: Text(
              lead.data?[0].companyName?.name ?? 'Unknown',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
              ),
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.blue,
                  size: 16,
                ),
                SizedBox(width: spacing),
                Text(
                  // lead.assignName?.name ?? 'Unknown',
                  lead.data?[0].phoneNumber ?? 'No Phone',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.blue[400],
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0x300D6EFD),
                              radius: avatarRadius,
                              child: Icon(
                                size: iconSize,
                                Icons.cases_rounded,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.data?[0].companyName?.name ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: spacing),
                                Text(
                                  'Company Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0x300D6EFD),
                              radius: avatarRadius,
                              child: Icon(
                                size: iconSize,
                                Icons.phone_rounded,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.data?[0].phoneNumber ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: spacing),
                                Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0x300D6EFD),
                              radius: avatarRadius,
                              child: Icon(
                                size: iconSize,
                                Icons.business,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.data?[0].phoneNumber ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: spacing),
                                Text(
                                  'Follow Up Type',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0x300D6EFD),
                              radius: avatarRadius,
                              child: Icon(
                                size: iconSize,
                                Icons.calendar_month_rounded,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.data?[0].nextFollowupDate ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: spacing),
                                Text(
                                  'Next Follow Up Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _createLead() {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FollowUpCreate(),
            ),
          );
        },
        heroTag: UniqueKey(),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Create Lead'),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget _viewLeads() {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationPage(),
            ),
          );
        },
        heroTag: UniqueKey(),
        icon: const Icon(Icons.list_alt_outlined),
        label: const Text('Lead List'),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
