import 'dart:convert';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/API/api_url.dart';
import 'package:untitled1/resourses/app_colors.dart';
import 'package:untitled1/screens/leadDetailsTabs.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/widget/sip_call_button.dart';
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

  final int pageSize = 10; //// Number of items to load per page

  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();

  List<LeadListModel> totalLeadList = [];

  Set<int> leadIds = {}; // Set to track unique lead IDs

  bool hasMoreLeads = true; // Flag to check if more leads are available

  // search functions
  List<LeadListModel> filteredLeadList = [];

  final TextEditingController _searchController = TextEditingController();

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    getLeadList(page);

    // Add listener to search controller
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
        filterLeads();
      });
    });
  }

  // filter list for search
  void filterLeads() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredLeadList = totalLeadList;
      } else {
        filteredLeadList = totalLeadList.where((lead) {
          final companyName = lead.companyName?.toLowerCase() ?? '';
          final leadPipeline = lead.leadPipelineName?.name.toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();
          return companyName.contains(query) || leadPipeline.contains(query);
        }).toList();
      }
    });
  }

  // fetch leads from API with pagination
  Future<void> getLeadList(int page) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String? userId = sharedPreferences.getString("id");

    if (!isLoadingMore) setState(() => isLoadingMore = true);

    final response = await http.post(
      Uri.parse(ApiUrls.leadListUrl),
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
          for (var json in leadJsonList) {
            LeadListModel lead = LeadListModel.fromJson(json);
            if (!leadIds.contains(lead.id)) {
              leadIds.add(lead.id!);
              totalLeadList.add(lead);
            }
          }
          filterLeads(); // Filter leads after fetching
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
      leadIds.clear(); // Clear the set of lead IDs
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

  // search bar appearance
  bool searchBar = false;

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
            color: Colors.blue,
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const BottomNavigationPage();
              },
            );
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        title: const Text(
          "All Leads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.shade50,
              child: IconButton(
                tooltip: 'Search',
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
                    child: Column(children: [
                      // search bar
                      if (searchBar == true)
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

                      // lead data
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredLeadList.length,
                          itemBuilder: (context, index) {
                            LeadListModel lead = filteredLeadList[index];
                            return Column(
                              children: [
                                // LeadCard(
                                //   lead: lead,
                                //   context: context,
                                // ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Card(
                                    color: formBackgroundColor,
                                    // color: Color.fromRGBO(
                                    //     253, 250, 250, 1.0),
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                          color: Color.fromRGBO(
                                              253, 250, 250, 1.0)),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LeadDetailsTabs(
                                                    leadId: lead.id!),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    lead.companyName ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.money_outlined,
                                                        size: 16,
                                                        color: Colors
                                                            .blue.shade700,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        lead.leadPipelineName
                                                                ?.name ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .blue.shade700,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  lead.assignName?.name ?? "",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SipCallButton(
                                                  phoneNumber: lead.phoneNumber
                                                      .toString(),
                                                  callerName: lead.companyName
                                                      .toString(),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Colors.blue.shade400,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                if (index == filteredLeadList.length - 1 &&
                                    isLoadingMore)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Center(
                                      child: LoadingAnimationWidget
                                          .staggeredDotsWave(
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
    );
  }

  Widget _createLead() {
    return FloatingActionButton(
      backgroundColor: Colors.blue[400],
      heroTag: "btn1",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LeadCreateForm()),
        );
      },
      tooltip: 'Create Task',
      child: const Icon(Icons.add),
    );
  }

  Widget _viewLeads() {
    return FloatingActionButton(
      backgroundColor: Colors.grey[300],
      heroTag: "btn2",
      onPressed: () {},
      tooltip: 'View Tasks',
      child: const Icon(Icons.visibility),
    );
  }
}
