import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:marquee/marquee.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:untitled1/database/DBHandler.dart';
import 'package:untitled1/screens/totalLeadList.dart';
import 'package:untitled1/sip_account/CallUI.dart';
import 'package:untitled1/sip_account/SipAccountStatus.dart';
import 'package:untitled1/sip_account/call_logs/CallLogDetails.dart';
import 'package:untitled1/sip_account/call_logs/CallLogsModel.dart';

import '../Contacts/contact_details.dart';

class LeadContacts extends StatefulWidget {
  const LeadContacts({
    Key? key,
  }) : super(key: key);

  @override
  State<LeadContacts> createState() => _LeadContactsState();
}

class _LeadContactsState extends State<LeadContacts> {
  TextEditingController digitsController = TextEditingController();

  TextEditingController searchController = TextEditingController();

  List<String> numberDigits = [];
  bool isLoading = true;

  int cursorCurrentIndex = 0;

  bool isDialPadShowing = true;

  String? callerName;
  List<dynamic> allContacts = [];
  // Stores all contacts
  List<dynamic> filteredContacts = []; // Stores filtered contacts
  String searchKey = "";
  bool isSearch = false;
  List<Contact> contactList = [];

  List<Contact> filterContactList = [];

  Future<void> getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      getContactsTabView(isSearch);
    } else {
      setState(() {
        isLoading = false;
      });
      showAlertDialog();
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Allow Permission"),
          content:
              const Text("Please allow Contact permission to view contacts"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => openAppSettings(), child: const Text("OK")),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    //callerName = widget.callerName;
    getContacts();
    searchController.addListener(filterContacts);

    super.initState();
  }

  void filterContacts() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filterContactList = contactList
          .where((contact) =>
              (contact.displayName ?? "").toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    digitsController.clear();

    numberDigits.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;

    // if (widget.phoneNumber.isNotEmpty) {
    //
    //   for (int i = 0; i < widget.phoneNumber.length; i++) {
    //     numberDigits.add(widget.phoneNumber[i]);
    //     setDigitInList();
    //   }
    // }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          // drawer: DrawerMenu(),
          appBar: AppBar(
            elevation: 0,
            leadingWidth: 65,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
// remove previous route
//                   Navigator.removeRoute(context, MaterialPageRoute(builder: (context) => CallUI(phoneNumber: "", callerName: ""),));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeadListScreen(),
                        ));
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: Colors.blue,
                  ),
                  tooltip: 'Back',
                ),
              ),
            ),
            centerTitle: true,
            title: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: searchContacts(),
            ),
            actions: [
              // SIP Account Status
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: SipAccountStatus.sipAccountStatus
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.green.shade500,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 50,
                                child: Marquee(
                                  text: SipAccountStatus.extension,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.green.shade700,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 20.0,
                                  velocity: 30.0,
                                  pauseAfterRound: const Duration(seconds: 1),
                                  accelerationDuration:
                                      const Duration(seconds: 1),
                                  accelerationCurve: Curves.easeInOutCubic,
                                  decelerationDuration:
                                      const Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: !isDialPadShowing,
            child: FloatingActionButton(
              child: Container(
                width: 60,
                height: 60,
                child: const Icon(Icons.dialpad, size: 30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.blue,
                      Color(0xff85C1E9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                setState(() {
                  //set
                  if (isDialPadShowing) {
                    isDialPadShowing = false;
                  } else if (!isDialPadShowing) {
                    isDialPadShowing = true;
                  }
                });
              },
            ),
          ),

          ///body very good work
          body: Column(
            children: [
              //Call logs and Contacts tap
              const TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.history),
                      text: "History",
                    ),
                    Tab(
                      icon: Icon(Icons.people_alt_outlined),
                      text: "Contacts",
                    ),
                  ]),

              const SizedBox(height: 5),

              //Tab pages
              Expanded(
                child: TabBarView(children: [
                  //Display call logs
                  getCallLogs(),
                  //Display Phone contacts
                  getContactsTabView(isSearching),
                ]),
              ),
              // DialPad
              getDialPad(),
            ],
          )),
    );
  }

  Future<bool> onBackPressed() async {
    if (isDialPadShowing) {
      setState(() {
        isDialPadShowing = false;
      });
      return false;
    } else {
      // Show exit confirmation dialog
      bool? exitConfirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Don't exit
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Exit
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );

      // If user confirmed exit, close the app
      if (exitConfirmed ?? false) {
        SystemNavigator.pop(); // This will close the app
        return true;
      }

      return false;
    }
  }

  ///new good work
  Widget getDialPad() {
    return Visibility(
      visible: isDialPadShowing,
      child: Container(
        padding: const EdgeInsets.all(16),
        // Option 1: Soft Blue Theme
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 246, 246, 244),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),

        /// good work
        child: Column(
          children: [
            TextField(
              autofocus: true,
              toolbarOptions: const ToolbarOptions(
                copy: true,
                cut: true,
                selectAll: true,
                paste: true,
              ),
              controller: digitsController,
              keyboardType: TextInputType.none,
              textAlign: TextAlign.center,
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(fontSize: 35, color: Colors.black),
              onTap: () {
                cursorCurrentIndex = digitsController.selection.base.offset;
              },
              // Add this handler
              onChanged: (value) {
                setState(() {
                  // Update numberDigits list to match the new text
                  numberDigits = value.split('');
                  // Preserve cursor position
                  final cursorPosition = digitsController.selection.baseOffset;
                  digitsController.selection = TextSelection.fromPosition(
                      TextPosition(offset: cursorPosition));
                });
              },
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                // for (var i = 1; i <= 9; i++) _buildDialButton(i.toString()),
                _buildDialButton('1'),
                _buildDialButton('2'),
                _buildDialButton('3'),
                _buildDialButton('4'),
                _buildDialButton('5'),
                _buildDialButton('6'),
                _buildDialButton('7'),
                _buildDialButton('8'),
                _buildDialButton('9'),
                _buildDialButton('*'),
                _buildDialButton('0'),
                _buildDialButton('#'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.backspace, Colors.red, () {
                  if (digitsController.text.isNotEmpty) {
                    final cursorPosition =
                        digitsController.selection.baseOffset;

                    if (cursorPosition > 0) {
                      setState(() {
                        // Remove the digit at cursor position - 1
                        numberDigits.removeAt(cursorPosition - 1);
                        // Update text field maintaining cursor position
                        setDigitInList(cursorPosition - 1);
                      });
                    }
                  }
                }),

                _buildActionButton(Icons.call, Colors.green, () {
                  // Implement call functionality
                  if (digitsController.text.isNotEmpty &&
                      SipAccountStatus.sipAccountStatus) {
                    Navigator.pop(context);

                    String name = callerName.toString().trim().isEmpty
                        ? "Unknown"
                        : callerName.toString().trim();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallUI(
                          phoneNumber: digitsController.text.trim(),
                          callerName: name,
                        ),
                      ),
                    );
                  }
                }),

                // Close
                _buildActionButton(Icons.close, Colors.grey, () {
                  setState(() {
                    isDialPadShowing = false;
                  });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialButton(String digit) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () => _onDigitPressed(digit),
        borderRadius: BorderRadius.circular(15),
        // keyboard design old but good work
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [],
          ),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onLongPress: () {
          setState(() {
            numberDigits.clear();
            setDigitInList();
          });
        },
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [],
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  void _onDigitPressed(String digit) {
    setState(() {
      final cursorPosition = digitsController.selection.baseOffset;
      // If cursor is at valid position
      if (cursorPosition >= 0) {
        // Insert the digit at cursor position in numberDigits list
        numberDigits.insert(cursorPosition, digit);

        // Update the text and cursor position
        setDigitInList(cursorPosition + 1); // Pass the new cursor position
      } else {
        // Fallback for when no cursor position (append to end)
        numberDigits.add(digit);
        setDigitInList(numberDigits.length);
      }
    });
  }

  void setDigitInList([int? cursorPosition]) {
    String number = numberDigits.join();
    digitsController.text = number;

    // Set cursor to specified position or end of text
    final newPosition = cursorPosition ?? number.length;
    digitsController.selection =
        TextSelection.fromPosition(TextPosition(offset: newPosition));
  }

  Widget searchContacts() {
    return TextField(
        // controller: searchController,
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: "Search contacts ...",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search_outlined)),
        onChanged: (keyword) {
          if (keyword.isNotEmpty) {
            setState(() {
              searchKey = keyword;
              isSearch = true;
            });
          } else {
            setState(() {
              isSearch = false;
            });
          }
          //searchContact(keyword);
        });
  }

  Widget getCallLogs() {
    return FutureBuilder(
        future: isSearch
            ? DBHandler.instance.getDialPadSearch(searchKey)
            : DBHandler.instance.getCallLogs(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: SizedBox(height: 50, child: CircularProgressIndicator()),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                CallLogsModel callLogsModel =
                    CallLogsModel.fromMap(snapshot.data[index]);

                if (callLogsModel.date == null) {
                  return null;
                }

                return TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                  ),
                  onPressed: () {
                    setState(() {
                      isDialPadShowing = true;
                    });

                    //reset previous number
                    numberDigits = [];

                    //Get current caller name
                    callerName = callLogsModel.name.toString();

                    // //reset previous digitsController
                    digitsController.clear();

                    //set cursorCurrentIndex of number field to 0
                    cursorCurrentIndex = 0;

                    for (int i = 0;
                        i < callLogsModel.phoneNumber.toString().trim().length;
                        i++) {
                      numberDigits
                          .add(callLogsModel.phoneNumber.toString().trim()[i]);
                      setDigitInList();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                    child: Card(
                      elevation: 0.5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        //margin: const EdgeInsets.only(top: 5),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Text(
                                  callLogsModel.name
                                              .toString()
                                              .trim()
                                              .isEmpty ||
                                          RegExp(r'^[0-9]+$').hasMatch(
                                              callLogsModel.name
                                                  .toString()
                                                  .trim())
                                      ? 'Unknown'
                                      : callLogsModel.name.toString().trim(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (callLogsModel.type
                                        .toString()
                                        .contains("Missed"))
                                      const Icon(Icons.call_missed,
                                          color: Colors.redAccent)
                                    else if (callLogsModel.type
                                        .toString()
                                        .contains("Incoming"))
                                      const Icon(
                                        Icons.call_received,
                                        color: Colors.grey,
                                        size: 10,
                                      )
                                    else
                                      const Icon(
                                        Icons.call_made_outlined,
                                        color: Colors.blue,
                                        size: 15,
                                      ),
                                    Text(callLogsModel.phoneNumber.toString()),
                                  ],
                                ),
                                Text(
                                  callLogsModel.date.toString().substring(
                                      0,
                                      callLogsModel.date
                                          .toString()
                                          .indexOf(" ")),
                                  style: const TextStyle(fontSize: 11),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(callLogsModel.time.toString()),
                                const SizedBox(width: 6),

                                //call history button
                                IconButton(
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: Colors.blue[200],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CallLogDetails(
                                                      contactName: callLogsModel
                                                          .name
                                                          .toString(),
                                                      contactNumber:
                                                          callLogsModel
                                                              .phoneNumber
                                                              .toString())));
                                    })
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }

// showing get contact
  Widget getContactsTabView(isSearching) {
    bool isSearching = searchController.text.isNotEmpty;

    return FutureBuilder(
        future: getPhoneContacts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: SizedBox(height: 50, child: CircularProgressIndicator()),
            );
          }

          return ListView.builder(
              semanticChildCount: snapshot.data.length,
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                if (snapshot.data[index].phones.isEmpty) {
                  return const Text("Unknown");
                }

                // var phones = snapshot.data[index].phones.first.normalizedNumber;
                var phones = snapshot.data[index].phones.first.number;
                var photo = snapshot.data[index].photo;
                var name = snapshot.data[index].displayName;

                return ListTile(
                  title: Text(name),
                  subtitle: Text(phones.toString()),
                  leading: photo != null
                      ? CircleAvatar(radius: 45, child: Image.memory(photo))
                      : CircleAvatar(
                          backgroundColor:
                              Color.fromRGBO(118, 137, 246, 0.4470588235294118),
                          radius: 45,
                          child: Text(
                            name[0],
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactsDetails(
                                clientName: snapshot.data[index].displayName,
                                companyName: "Phone Contact",
                                phoneNumber: phones.toString())));
                  },
                );
              });
        });
  }

  Future<List<dynamic>> getPhoneContacts() async {
    var temp = await FlutterContacts.getContacts(
        withProperties: true, withThumbnail: true, withPhoto: true);

    // tempContactList = temp;

    return temp;
  }
}
