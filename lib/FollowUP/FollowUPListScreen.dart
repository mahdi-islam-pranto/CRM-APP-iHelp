import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Models/followUpModel.dart';

import '../Dashboard/bottom_navigation_page.dart';
import '../resourses/resourses.dart';
import 'followUpCreateForm.dart';
import 'package:http/http.dart' as http;

class FollowUpList extends StatefulWidget {
  const FollowUpList({super.key});

  @override
  State<FollowUpList> createState() => _FollowUpListState();
}

class _FollowUpListState extends State<FollowUpList> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  bool isLoading = true;
  bool isLoadingMore = false;
  int page = 1;
  final int pageSize = 10; // Number of items to load per page

  List<FollowUpModel> totalFollowUpList = [];
  bool hasMoreLeads = true; // Flag to check if more leads are available

  @override
  void initState() {
    super.initState();
    getFollowUpList(page);
  }

  // fetch leads from API with pagination
  Future<void> getFollowUpList(int page) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    if (!isLoadingMore) setState(() => isLoadingMore = true);

    final response = await http.post(
      Uri.parse("https://crm.ihelpbd.com/api/crm-follow-up-list"),
      headers: {
        'Authorization': 'Bearer $token',
        'user_id': '$userId',
      },
      body: {
        'start_date': '',
        'end_date': '',
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
      List<dynamic> followUpJsonList = data['data'];

      print("follow up api check data $followUpJsonList");

      setState(() {
        isLoading = false;
        isLoadingMore = false;
        if (followUpJsonList.isNotEmpty) {
          followUpJsonList.addAll(followUpJsonList
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Positioned(
            child: AnimatedFloatingActionButton(
              key: key,
              fabButtons: <Widget>[
                _createLead(), // Now we have two FABs
                _viewLeads(),
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
          child: const Text('Follow Up List'),
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
      body: const Center(
        child: Text('Follow Up List'),
      ),
    );
  }

  Widget _createLead() {
    return FloatingActionButton(
      onPressed: () {
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
      heroTag: "Create Follow Up",
      tooltip: 'Create Lead',
      backgroundColor: R.appColors.buttonColor,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ), // Change this color if needed
    );
  }

  Widget _viewLeads() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          // Add your view leads logic here
        },
        heroTag: "View Leads",
        tooltip: 'View Leads',
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.list,
          color: Colors.white,
        ),
      ),
    );
  }
}
