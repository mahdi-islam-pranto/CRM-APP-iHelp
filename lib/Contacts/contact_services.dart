// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:googleapis/authorizedbuyersmarketplace/v1.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class ContactServices extends StatefulWidget {
//   const ContactServices({super.key});
//
//   @override
//   State<ContactServices> createState() => _ContactServicesState();
// }
//
// class _ContactServicesState extends State<ContactServices> {
//   bool isLoading = true;
//   List<Contact> contactList = [];
//   List<Contact> filterContactList = [];
//   TextEditingController searchController = TextEditingController();
//   List<Map<String, String>> callHistory = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getContacts();
//     searchController.addListener(() {
//       filterContacts();
//     });
//   }
//
//   Future<void> getContacts() async {
//     var status = await Permission.contacts.status;
//     if (!status.isGranted) {
//       if (await Permission.contacts.request().isGranted) {
//         loadContacts();
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         showAlertDialog();
//       }
//     } else {
//       loadContacts();
//     }
//
//     if (await Permission.contacts.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
//
//
//   Future<void> loadContacts() async {
//     try {
//       // Request permission first
//       var permissionStatus = await Permission.contacts.request();
//       if (permissionStatus.isGranted) {
//         //Iterable<Contact> _contacts = await ontagetContacts();
//         setState(() {
//           //contactList = _contacts.toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         showAlertDialog();
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       debugPrint("Error fetching contacts: $e");
//     }
//   }
//
//   void filterContacts() {
//     List<Contact> _contacts = [];
//     _contacts.addAll(contactList);
//     if (searchController.text.isNotEmpty) {
//       String searchTerm = searchController.text.toLowerCase();
//       _contacts.retainWhere((contact) {
//         String contactName = (contact.displayName ?? "").toLowerCase();
//         return contactName.contains(searchTerm);
//       });
//     }
//     setState(() {
//       filterContactList = _contacts;
//     });
//   }
//
//   void makeCall(String number, String name) async {
//     bool? res = await FlutterPhoneDirectCaller.callNumber(number);
//     if (res == true) {
//       setState(() {
//         callHistory.add({
//           "name": name,
//           "number": number,
//           "time": DateTime.now().toLocal().toString().substring(0, 19),
//         });
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isSearching = searchController.text.isNotEmpty;
//     return DefaultTabController(
//       length: 2,
//       initialIndex: 0,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           bottom: const TabBar(
//             indicatorColor: Colors.blue,
//             labelColor: Colors.blue,
//             tabs: [
//               Tab(
//                 child: Text("Contacts", style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               Tab(
//                 child: Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
//               )
//             ],
//           ),
//           backgroundColor: Colors.white,
//           title: const Text(
//             "CONTACTS",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ),
//           centerTitle: true,
//         ),
//         body: TabBarView(
//           children: [
//             buildContactsTab(isSearching),
//             buildCallHistoryTab(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildContactsTab(bool isSearching) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(8.0),
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
//             child: TextFormField(
//               controller: searchController,
//               cursorColor: Colors.blue,
//               decoration: const InputDecoration(
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue, width: 1.0),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(width: 0.2),
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 ),
//                 labelText: "Search",
//                 floatingLabelStyle: TextStyle(color: Colors.grey),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: isSearching ? filterContactList.length : contactList.length,
//               itemBuilder: (context, index) {
//                 Contact contact = isSearching ? filterContactList[index] : contactList[index];
//
//                 return Column(
//                   children: [
//                     ListTile(
//                       title: Text(contact.displayName ?? "Unknown"),
//                       subtitle: contact.displayName!.isNotEmpty
//                           ? Text(contact.displayName! ?? "No phone number")
//                           : const Text("No phone number"),
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.blue.shade100,
//                         radius: 30,
//                         child: Text(
//                           contact.displayName != null && contact.displayName!.isNotEmpty
//                               ? contact.displayName![0]
//                               : "?",
//                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.call, color: Colors.blue),
//                         onPressed: () {
//                           if (contact.displayName!.isNotEmpty) {
//                             makeCall(contact.displayName!, contact.displayName ?? "Unknown");
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("No phone number available")),
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                     const Divider(height: 3, thickness: 0.2, indent: 20, endIndent: 20),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildCallHistoryTab() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(8.0),
//       child: callHistory.isEmpty
//           ? const Center(child: Text("No Call History"))
//           : ListView.builder(
//         itemCount: callHistory.length,
//         itemBuilder: (context, index) {
//           var history = callHistory[index];
//           return ListTile(
//             title: Text(history["name"] ?? "Unknown"),
//             subtitle: Text("${history["number"]} • ${history["time"]}"),
//             leading: const Icon(Icons.phone, color: Colors.green),
//           );
//         },
//       ),
//     );
//   }
//
//   void showAlertDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Allow Permission"),
//           content: const Text("Please allow Contact permission to view contacts"),
//           actions: <Widget>[
//             TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
//             TextButton(child: const Text("Ok"), onPressed: () => openAppSettings()),
//           ],
//         );
//       },
//     );
//   }
// }
