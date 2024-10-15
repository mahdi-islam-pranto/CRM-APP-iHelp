import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Dashboard/dashboard.dart';

import 'package:untitled1/screens/leadDetailsTabs.dart';
import 'package:http/http.dart' as http;

import '../Dashboard/bottom_navigation_page.dart';
import '../Lead/leadCreateform.dart';
import '../Models/LeadListModel.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  bool isLoading = true;
  bool isLoadingMore = false;
  int page = 1;
  final int pageSize = 10; // Number of items to load per page
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  List<LeadListModel> totalLeadList = [];
  bool hasMoreLeads = true; // Flag to check if more leads are available

  @override
  void initState() {
    super.initState();
    getLeadList(page);
  }

  // fetch leads from API with pagination
  Future<void> getLeadList(int page) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    if (!isLoadingMore) setState(() => isLoadingMore = true);

    final response = await http.post(
      Uri.parse("https://crm.ihelpbd.com/api/crm-lead-data-show"),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '',
        'end_date': '',
        'user_id_search': userId,
        'session_user_id': "",
        'lead_pipeline_id': '',
        'lead_source_id': '',
        'searchData': '',
        'is_type': '0',
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
          totalLeadList.addAll(leadJsonList
              .map((json) => LeadListModel.fromJson(json))
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
    if (!isLoadingMore && hasMoreLeads && totalLeadList.isNotEmpty) {
      page++;
      await getLeadList(page);
    }
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      // Show loading animation
      isLoading = true;

      // Reset the page and total lead list
      page = 1;
      totalLeadList.clear();
    });

    await getLeadList(page);

    setState(() {
      // Hide loading animation
      isLoading = false;
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
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
          child: const Text('ALL LEADS'),
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
                color: Colors.blue,
                size: 50,
              ),
            )
          : totalLeadList.isEmpty
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
                  child: SmartRefresher(
                    onLoading: _onLoading,
                    enablePullDown: true,
                    enablePullUp: true,
                    header: const WaterDropHeader(
                      waterDropColor: Colors.blue,
                    ),
                    onRefresh: refreshData,
                    controller: _refreshController,
                    child: ListView.builder(
                      itemCount: totalLeadList.length + (hasMoreLeads ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == totalLeadList.length) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.blue,
                                size: 50,
                              ),
                            ),
                          );
                        } else {
                          final lead = totalLeadList[index];
                          return _buildListItem(lead);
                        }
                      },
                    ),
                  ),
                ),
    );
  }

  Map<int, bool> state = {};
  // showing Lead List item
  Widget _buildListItem(LeadListModel lead) {
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
                  Icons.person_2_outlined,
                  color: Colors.blue,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon(
                //   Icons.remove_red_eye_rounded,
                //   color: Colors.grey[400],
                // ),
                SizedBox(width: spacing),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
            title: Text(
              lead.companyName ?? 'Unknown',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // lead.assignName?.name ?? 'Unknown',
                  lead.name ?? 'No name',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                    SizedBox(width: spacing),
                    Text(
                      // lead.assignName?.name ?? 'Unknown',
                      lead.phoneNumber ?? 'No Phone',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.blue[400],
                      ),
                    ),
                  ],
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
                        // Email
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: spacing),
                            Text(
                              lead.email ?? 'No Email',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        // Lead Pipeline
                        Row(
                          children: [
                            Icon(
                              Icons.dns_outlined,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: spacing),
                            Text(
                              lead.leadPipelineName!.name.toString() ??
                                  'No Pipeline',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        // User
                        Row(
                          children: [
                            Icon(
                              Icons.person_add_alt_1_outlined,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: spacing),
                            Text(
                              lead.assignName?.name ?? 'No Assignee',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        // Other details
                        Row(
                          children: [
                            Icon(
                              Icons.more_horiz,
                              color: Colors.grey[700],
                            ),
                            SizedBox(
                              width: spacing,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerLeft),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LeadDetailsTabs(leadId: lead.id),
                                    ));
                              },
                              child: Text(
                                'More Details',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 3,
          thickness: 0.2,
          indent: 20, // empty space to the leading edge of divider.
          endIndent: 20,
        ),
      ],
    );
  }

  Widget _createLead() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LeadCreateForm()),
          );
        },
        heroTag: "CreateLead",
        tooltip: 'Create Lead',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _viewLeads() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.grey[300],
        onPressed: () {
          // Add navigation to your view leads screen here
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavigationPage()),
          );
        },
        heroTag: "ViewLeads",
        tooltip: 'View Leads',
        child: const Icon(Icons.home),
      ),
    );
  }
}
