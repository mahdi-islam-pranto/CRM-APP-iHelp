import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:'
    'permission_handler/permission_handler.dart';

class ContactServices extends StatefulWidget {
  const ContactServices({super.key});

  @override
  State<ContactServices> createState() => _ContactServicesState();
}

class _ContactServicesState extends State<ContactServices> {
  bool isLoading = true;
  List<Contact> contactList = [];
  List<Contact> filterContactList = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> callHistory = [];

  @override
  void initState() {
    super.initState();
    getContacts();
    searchController.addListener(filterContacts);
  }

  Future<void> getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      loadContacts();
    } else {
      setState(() {
        isLoading = false;
      });
      showAlertDialog();
    }
  }

  Future<void> loadContacts() async {
    try {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contactList = contacts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching contacts: $e");
    }
  }

  void filterContacts() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      filterContactList = contactList
          .where((contact) => (contact.displayName ?? "").toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("CONTACTS"),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Contacts"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildContactsTab(isSearching),
            buildCallHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget buildContactsTab(bool isSearching) {
    List<Contact> displayList = isSearching ? filterContactList : contactList;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                Contact contact = displayList[index];
                return ListTile(
                  title: Text(contact.displayName ?? "Unknown"),
                  subtitle: contact.phones.isNotEmpty
                      ? Text(contact.phones.first.number)
                      : const Text("No phone number"),
                  leading: CircleAvatar(
                    child: Text(contact.displayName?[0] ?? "?"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCallHistoryTab() {
    return callHistory.isEmpty
        ? const Center(child: Text("No Call History"))
        : ListView.builder(
      itemCount: callHistory.length,
      itemBuilder: (context, index) {
        var history = callHistory[index];
        return ListTile(
          title: Text(history["name"] ?? "Unknown"),
          subtitle: Text("${history["number"]} • ${history["time"]}"),
          leading: const Icon(Icons.phone, color: Colors.green),
        );
      },
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Allow Permission"),
          content: const Text("Please allow Contact permission to view contacts"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(onPressed: () => openAppSettings(), child: const Text("OK")),
          ],
        );
      },
    );
  }
}
