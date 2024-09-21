import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/dashborad_total_lead_list.dart';

class DashboardCounter extends StatelessWidget {
  const DashboardCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 240,
      color: Colors.white,
      child: Column(
        children: [
          ///web new
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return const DashboardTotalLeadList();
                              },
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(seconds: 1),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              border: const Border(
                                left: BorderSide(
                                  color: Colors.blue,
                                  // Set the color you want for the left border
                                  width:
                                      5.0, // Set the width of the left border
                                ),
                              ),
                            ),
                            height: 100,
                            width: 145,
                            child: const ListTile(
                              title: Text("Total Lead"),
                              subtitle: Text(
                                "100",
                                style: TextStyle(color: Colors.blue),
                              ),
                              trailing: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.leaderboard,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return const DashboardTotalLeadList();
                              },
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(seconds: 1),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 80,
                              //     spreadRadius: 21,
                              //     color: Color.fromRGBO(231, 225, 225, 1.0),
                              //   )
                              // ],
                              border: const Border(
                                left: BorderSide(
                                  color: Colors.pinkAccent,
                                  // Set the color you want for the left border
                                  width:
                                      5.0, // Set the width of the left border
                                ),
                              ),
                            ),
                            height: 100,
                            width: 145,
                            child: const ListTile(
                              title: Text("Total User"),
                              subtitle: Text(
                                "21",
                                style: TextStyle(color: Colors.pinkAccent),
                              ),
                              trailing: CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return const DashboardTotalLeadList();
                              },
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(seconds: 1),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 80,
                              //     spreadRadius: 21,
                              //     color: Color.fromRGBO(231, 225, 225, 1.0),
                              //   )
                              // ],
                              border: const Border(
                                left: BorderSide(
                                  color: Colors.green,
                                  // Set the color you want for the left border
                                  width:
                                      5.0, // Set the width of the left border
                                ),
                              ),
                            ),
                            height: 100,
                            width: 145,
                            child: const ListTile(
                              title: Text("Lead"),
                              subtitle: Text("500"),
                              trailing: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Icon(
                                    Icons.summarize,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return const DashboardTotalLeadList();
                              },
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(seconds: 1),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 80,
                              //     spreadRadius: 21,
                              //     color: Color.fromRGBO(231, 225, 225, 1.0),
                              //   )
                              // ],
                              border: const Border(
                                left: BorderSide(
                                  color: Colors.orange,
                                  // Set the color you want for the left border
                                  width:
                                      5.0, // Set the width of the left border
                                ),
                              ),
                            ),
                            height: 100,
                            width: 145,
                            child: const ListTile(
                              title: Text("Total"),
                              subtitle: Text("100"),
                              trailing: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: Icon(
                                    Icons.call_to_action,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
