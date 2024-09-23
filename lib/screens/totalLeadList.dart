import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/screens/leadDetailsTabs.dart';
import 'package:http/http.dart' as http;

import '../Dashboard/bottom_navigation_page.dart';
import '../Lead/leadCreateform.dart';
import '../Models/LeadListModel.dart';

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
        'session_user_id': userId,
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
                  child: ListView.builder(
                    itemCount: totalLeadList.length + (hasMoreLeads ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == totalLeadList.length) {
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
                        final lead = totalLeadList[index];
                        return _buildListItem(lead);
                      }
                    },
                  ),
                ),
    );
  }

  // showing Lead List item
  Widget _buildListItem(LeadListModel lead) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarRadius =
        screenWidth * 0.05; // Adjust radius based on screen width
    double iconSize =
        screenWidth * 0.05; // Adjust icon size based on screen width
    double spacing = screenWidth * 0.02; // Adjust spacing based on screen width

    return Card(
      elevation: 0.5,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllLeadList(),
              ));
        },
        child: ExpansionTile(
          title: Text(
            lead.companyName ?? 'Unknown',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: const Color.fromRGBO(73, 72, 72, 1.0)),
          ),
          subtitle: Text(
            lead.assignName?.name ?? 'Unknown',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: const Color.fromRGBO(18, 22, 92, 100),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    lead.phoneNumber ?? 'No Phone',
                    style: const TextStyle(
                      color: Color.fromRGBO(18, 22, 92, 100),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.call,
                            color: Colors.green,
                            size: iconSize,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing),
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.phone_disabled,
                            color: Colors.red,
                            size: iconSize,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing),
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.mark_email_read,
                            color: Colors.blue,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Pipeline:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  lead.leadPipelineName?.name ?? 'Unknown',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // FAB button for lead creation
  Widget _createLead() {
    return FloatingActionButton(
      heroTag: "btn1",
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LeadCreateForm(),
            ));
      },
      tooltip: 'Create Lead',
      child: const Icon(Icons.add),
    );
  }

  // FAB button to view leads
  Widget _viewLeads() {
    return FloatingActionButton(
      heroTag: "btn2",
      onPressed: () {},
      tooltip: 'View Leads',
      child: const Icon(Icons.visibility),
    );
  }
}
