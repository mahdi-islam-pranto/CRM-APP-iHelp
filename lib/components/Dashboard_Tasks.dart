import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardTasks extends StatelessWidget {
  const DashboardTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 173,
        width: 340,
        child: SafeArea(
          child: Scrollbar(
            interactive: true,
            child: ListView.builder(
              itemCount: 5,
              reverse: false,
              //  itemCount: pendingTaskList.length,
              itemBuilder: (context, index) {
                // followUpModel leadModel =
                // followUpModel.fromMap(pendingTaskList[index]);
                return SafeArea(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 0.3,
                        color:
                            Color.fromRGBO(146, 156, 235, 100), //<-- SEE HERE
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      tileColor:
                          // Color.fromRGBO(164, 255, 238, 0.2),
                          Colors.white,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                                // leadModel.company.toString(),
                                "iHelpBD",
                                style: TextStyle(
                                    color:
                                        const Color.fromRGBO(11, 82, 69, 0.8),
                                    fontSize: 14.sp)),
                          ),
                          // SizedBox(
                          //   height: 1.h,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "+88 01733-364274",
                              // leadModel.number.toString(),
                              style: TextStyle(fontSize: 13.sp),
                            ),
                          ),
                          // SizedBox(
                          //   height: 1.h,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "2024-12-05  4:30 pm",
                              // leadModel.createDate.toString(),
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 12.sp),
                            ),
                          ),
                        ],
                      ),
                      trailing: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(77, 155, 206, 203),
                        child: IconButton(
                          icon: const Icon(
                            Icons.call,
                            size: 25,
                          ),
                          color: Colors.green,
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             DemoFollowUp(
                            //               companyName: leadModel
                            //                   .company
                            //                   .toString(),
                            //               phoneNumber: leadModel
                            //                   .number
                            //                   .toString(),
                            //               followupDate: leadModel
                            //                   .followup_date
                            //                   .toString(),
                            //             )));
                          },
                        ),
                      ),
                      onTap: () {
                        // StaticVariable.followupmodel = leadModel;
                        // StaticVariable.currentPageIndex = 0;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => DetailsTask(),
                        //     ));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
