import 'dart:convert';

import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/FollowUP/followUpDetailsTab.dart';
import 'package:untitled1/FollowUP/followUpOverview.dart';
import 'package:untitled1/Models/followUpModel.dart';
import 'package:untitled1/resourses/app_colors.dart';
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
  // all follow ups list
  List followUpList = [];
  int pageNumber = 1;
  final int pageSize = 10;
  bool hasMoreData = true;

// search controller
  List filteredFollowUpList = [];

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  bool searchBar = false;

  @override
  void initState() {
    super.initState();
    getFollowUpList();

    // Add listener to search controller
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
        filterFollowUps();
      });
    });
  }

  // filter list for search
  void filterFollowUps() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredFollowUpList = followUpList;
      } else {
        filteredFollowUpList = followUpList.where((followUp) {
          final companyName =
              followUp['company_name']['company_name']?.toLowerCase() ?? '';
          final subject = followUp['subject']?.toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();

          return companyName.contains(query) || subject.contains(query);
        }).toList();
      }
    });
  }

  // fetch leads from API with pagination
  Future<void> getFollowUpList() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

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
        'lead_id': '',
        'next_followup_date': '',
        'page': pageNumber.toString(),
        'page_size': pageSize.toString(),
      },
    );

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      setState(() {
        if (pageNumber == 1) {
          followUpList = data['data'];
        } else {
          followUpList.addAll(data['data']);
        }

        filteredFollowUpList = followUpList; // Add this line

        if (data['data'].length < pageSize) {
          hasMoreData = false;
        } else {
          pageNumber++;
        }
      });
    } else {
      // Handle error
      // You can also show an error message if needed
    }

    setState(() {
      isLoading = false;
      isLoadingMore = false;
    });
  }

  // pull down refresh functions
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      // Show loading animation
      isLoading = true;

      // Reset the page and total lead list

      followUpList.clear();
    });

    await getFollowUpList();

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
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarRadius =
        screenWidth * 0.05; // Adjust radius based on screen width
    double iconSize =
        screenWidth * 0.05; // Adjust icon size based on screen width
    double spacing = screenWidth * 0.02; // Adjust spacing based on screen width

    return Scaffold(
      backgroundColor: Colors.white,
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
          child: const Text('ALL FOLLOW UPS'),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchBar = !searchBar;
              });
            },
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
          : followUpList.isEmpty
              ? Center(
                  child: Text(
                    'No follow ups available.',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    // search bar appears
                    if (searchBar)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    Expanded(
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
                          itemCount: filteredFollowUpList.length +
                              (hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredFollowUpList.length) {
                              if (hasMoreData) {
                                getFollowUpList();
                                return const Center(
                                  child: Text('No more data'),
                                );
                              } else {
                                return const Center(
                                  child: Text('No more data'),
                                );
                              }
                            }

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 4.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      childrenPadding: const EdgeInsets.all(10),
                                      leading: const CircleAvatar(
                                        backgroundColor: Color(0x300D6EFD),
                                        child: Icon(Icons.business,
                                            color: Colors.blue),
                                      ),
                                      trailing: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.blue),
                                      title: Text(
                                        filteredFollowUpList[index]
                                                    ['company_name']
                                                ['company_name'] ??
                                            'Unknown',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.label_outline,
                                                  size: 16, color: Colors.blue),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Status: ${getStatusText(filteredFollowUpList[index]['status'])}",
                                                style: TextStyle(
                                                    color: getStatusColor(
                                                        filteredFollowUpList[
                                                            index]['status'])),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today,
                                                  size: 16, color: Colors.blue),
                                              const SizedBox(width: 8),
                                              Text(
                                                filteredFollowUpList[index][
                                                        'next_followup_date'] ??
                                                    'No Next Follow Up Date',
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildInfoRow(
                                                      Icons.subject,
                                                      filteredFollowUpList[
                                                                  index]
                                                              ['subject'] ??
                                                          'No Subject'),
                                                  const SizedBox(height: 8),
                                                  _buildInfoRow(
                                                      Icons.phone,
                                                      filteredFollowUpList[
                                                                  index][
                                                              'phone_number'] ??
                                                          'No Phone No.'),
                                                  const SizedBox(height: 8),
                                                  _buildInfoRow(
                                                      Icons.person,
                                                      filteredFollowUpList[
                                                                      index][
                                                                  'assign_name']
                                                              ['name'] ??
                                                          'No Assign'),
                                                  const SizedBox(height: 8),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                const Text("More Details"),
                                                const SizedBox(height: 8),
                                                _buildActionButton(
                                                    Icons.visibility,
                                                    Colors.blue,
                                                    'View', () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowUpOverview(
                                                                followUpId:
                                                                    filteredFollowUpList[
                                                                            index]
                                                                        [
                                                                        'id'])),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // divider

                                // const Divider(
                                //   height: 3,
                                //   thickness: 0.2,
                                //   indent:
                                //       20, // empty space to the leading edge of divider.
                                //   endIndent: 20,
                                // ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }

  String getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Solved';
      case '2':
        return 'Pending';
      case '3':
        return 'Working Progress';
      default:
        return 'Cancel';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  Widget _createLead() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FollowUpCreate()),
          );
        },
        heroTag: "Create Lead",
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
          Navigator.pop(context);
        },
        heroTag: "View Leads",
        tooltip: 'View Leads',
        child: const Icon(Icons.visibility),
      ),
    );
  }
}
