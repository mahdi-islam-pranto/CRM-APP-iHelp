import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailsTotalLeadList extends StatefulWidget {
  const DetailsTotalLeadList({Key? key}) : super(key: key);

  @override
  State<DetailsTotalLeadList> createState() => _DetailsTotalLeadListState();
}

class _DetailsTotalLeadListState extends State<DetailsTotalLeadList> {
  List<Map<String, String>> leadList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDemoData();
  }

  void _initializeDemoData() {
    // Simulate loading data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        leadList = [
          {
            'customerName': 'Sk Nayeem Ur Rahman',
            'company': 'iHelpBd',
            'phoneNumber': '123-456-7890',
            'assignTo': 'Assign to : Pranto',
          },
          {
            'customerName': 'Sk Nayeem Ur Rahman',
            'company': 'iHelpBd',
            'phoneNumber': '123-456-7890',
            'assignTo': 'Assign to : Pranto',
          },
          {
            'customerName': 'Sk Nayeem Ur Rahman',
            'company': 'iHelpBd',
            'phoneNumber': '123-456-7890',
            'assignTo': 'Assign to : Pranto',
          },
          {
            'customerName': 'Sk Nayeem Ur Rahman',
            'company': 'iHelpBd',
            'phoneNumber': '123-456-7890',
            'assignTo': 'Assign to : Pranto',
          },
          {
            'customerName': 'Jane Smith',
            'company': 'XYZ Corporation',
            'phoneNumber': '987-654-3210',
            'assignTo': 'Bob',
          },
          {
            'customerName': 'Jane Smith',
            'company': 'XYZ Corporation',
            'phoneNumber': '987-654-3210',
            'assignTo': 'Bob',
          },
          {
            'customerName': 'Jane Smith',
            'company': 'XYZ Corporation',
            'phoneNumber': '987-654-3210',
            'assignTo': 'Bob',
          },
          {
            'customerName': 'Jane Smith',
            'company': 'XYZ Corporation',
            'phoneNumber': '987-654-3210',
            'assignTo': 'Bob',
          },
          {
            'customerName': 'Jane Smith',
            'company': 'XYZ Corporation',
            'phoneNumber': '987-654-3210',
            'assignTo': 'Bob',
          },
        ];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.black,
                size: 50,
              ),
            ) // Show loader if data is loading
          : AnimatedList(
              initialItemCount: leadList.length,
              itemBuilder: (context, index, animation) {
                final lead = leadList[index];
                return _buildListItem(lead, animation);
              },
            ),
    );
  }

  Widget _buildListItem(Map<String, String> lead, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 0,
        color: const Color.fromRGBO(252, 250, 253, 1),
        child: InkWell(
          onTap: () {
            //     Navigator.push(context,MaterialPageRoute(builder: (context) => AllLeadList(),));
          },
          child: ExpansionTile(
            title: Text(
              lead['customerName'] ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: const Color.fromRGBO(73, 72, 72, 1.0)),
            ),
            subtitle: Text(
              lead['company'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: const Color.fromRGBO(18, 22, 92, 100),
              ),
            ),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          "01733-364274",
                          style: TextStyle(
                            color: Color.fromRGBO(18, 22, 92, 100),
                          ),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.blue[50],
                          child: IconButton(
                            onPressed: () async {
                              // await FlutterPhoneDirectCaller.callNumber(leadModel!.phoneNumber.toString());
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.blue[50],
                          child: IconButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => LeadDetailsCallUi(
                              //           phoneNumber: leadModel!.phoneNumber.toString(),
                              //           customerName:
                              //           leadModel!.customerName.toString()),
                              //     ));

                              // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              // LeadDetailsCallUi(phoneNumber: leadModel.phoneNumber,customerName: leadModel.customerName,));
                            },
                            icon: const Icon(Icons.dialer_sip_outlined),
                            color: Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Assign To :"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Pranto",
                          style: TextStyle(
                            color: Color.fromRGBO(18, 22, 92, 100),
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
      ),
    );
  }
}
