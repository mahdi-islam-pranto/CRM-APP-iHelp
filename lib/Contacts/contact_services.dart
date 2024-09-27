import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactServices extends StatefulWidget {
  const ContactServices({super.key});

  @override
  State<ContactServices> createState() => _ContactServicesState();
}

class _ContactServicesState extends State<ContactServices> {
  // contact list
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();

    getContacts();
  }

  getContacts() async {
    // first check contact permission
    var status = await Permission.contacts.status;
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print("Permission granted");
      // loading contacts

      // get contacts
      List<Contact> _contacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();

      setState(() {
        contactList = _contacts;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // contact list
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    Contact contact = contactList[index];

                    if (contactList.isNotEmpty) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(contact.displayName ?? "Unknown"),
                            subtitle:
                                Text(contact.phones!.elementAt(0).value ?? ""),
                            leading: CircleAvatar(),
                            trailing: IconButton(
                              icon: const Icon(Icons.call),
                              onPressed: () {},
                            ),
                          ),

                          // divider
                          const Divider(),
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
