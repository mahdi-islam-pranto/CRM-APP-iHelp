import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/resourses/app_colors.dart';

import '../Dashboard/bottom_navigation_page.dart';
import '../Dashboard/dashboard.dart';
import '../resourses/resourses.dart';

class ContactServices extends StatefulWidget {
  const ContactServices({super.key});

  @override
  State<ContactServices> createState() => _ContactServicesState();
}

class _ContactServicesState extends State<ContactServices> {
  bool isLoading = true;
  // contact list
  List<Contact> contactList = [];
  // search controller
  TextEditingController searchController = TextEditingController();

  // filter contacts
  List<Contact> filterContactList = [];

  @override
  void initState() {
    super.initState();

    getContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }

  getContacts() async {
    // first check contact permission
    var status = await Permission.contacts.status;
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print("Permission granted");
      // loading contacts

      // get contacts
      List<Contact> _contacts = (await ContactsService.getContacts()).toList();

      setState(() {
        contactList = _contacts;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }

    if (await Permission.contacts.isPermanentlyDenied) {
      openAppSettings();
    }

    if (await Permission.contacts.isDenied) {
      return showAlertDialog();
    }

// You can request multiple permissions at once.
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.contacts,
    // ].request();
  }

  // serch contacts

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contactList);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName!.toLowerCase();

        return contactName.contains(searchTerm);
      });
    }
    setState(() {
      filterContactList = _contacts;
    });
  }

  String sanitizeString(String? value) {
    if (value == null) {
      return "Unknown";
    }
    return value.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          bottom: const TabBar(
              dividerHeight: 0,
              indicatorPadding: EdgeInsets.only(bottom: 10),
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              tabs: [
                Tab(
                  child: Text(
                    "Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "History",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ]),
          backgroundColor: Colors.white,
          // toolbarHeight: 112.62,
          title: const Text(
            "CONTACTS",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.blue,
            ),
            onPressed: () {
              // got to previous screen
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const BottomNavigationPage();
              }));
            },
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.blue,
                      size: 50,
                    ))
                  : Column(
                      children: [
                        // search bar
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                          ),
                          child: TextFormField(
                            controller: searchController,
                            cursorColor: Colors.blue,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  )),
                              labelText: "Search",
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        // contact list
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: isSearching == true
                                  ? filterContactList.length
                                  : contactList.length,
                              itemBuilder: (context, index) {
                                Contact contact = isSearching == true
                                    ? filterContactList[index]
                                    : contactList[index];

                                if (contactList.isNotEmpty) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(sanitizeString(
                                            contact.displayName)),
                                        subtitle: contact.phones!.isNotEmpty
                                            ? Text(sanitizeString(contact
                                                .phones!
                                                .elementAt(0)
                                                .value))
                                            : const Text("No phone number"),
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              const Color(0x300D6EFD),
                                          radius: 30,
                                          child: Text(
                                            sanitizeString(contact.initials()),
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // IconButton(
                                            //   icon: const Icon(Icons.call,
                                            //       color: Colors.green),
                                            //   onPressed: () {
                                            //     // Add your first call icon functionality here
                                            //   },
                                            // ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.call,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                // Add your second call icon functionality here
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      // divider
                                      const Divider(
                                        height: 3,
                                        thickness: 0.2,
                                        indent:
                                            20, // empty space to the leading edge of divider.
                                        endIndent: 20,
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Text("No contacts found"),
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
            ),

            // history

            Container(
              color: Colors.white,
              child: const Center(
                child: Text("History"),
              ),
            )
          ],
        ),
      ),
    );
  }

  // show permision dialog

  showAlertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Allow Permission"),
          content:
              const Text("Please allow Contact permission to view contacts"),
          actions: <Widget>[
            TextButton(
              child: const Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
