// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../sip_account/SipDialPad.dart';
// import 'ContactsDetails.dart';
// import 'model/ContactsModel.dart';
//
// /*
//   Activity name : ContactsList
//   Project name : iSalesCRM Mobile App
//   Developer : Eng. M A Mazedul Islam
//   Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
//   Email : mazedulislam4970@gmail.com
//   Description : Display Contacts list
// */
//
// class ContactsList extends StatefulWidget {
//   const ContactsList({Key? key}) : super(key: key);
//
//   @override
//   State<ContactsList> createState() => _ContactsListState();
// }
//
// class _ContactsListState extends State<ContactsList> {
//   //search keyword controller
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchContactsList();
//   }
//
//   //Contact list
//   List contactsList = [];
//   bool isLoading = false;
//   bool isSearching = false;
//
//   void fetchContactsList() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     //Show progress dialog
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//
//     //Get user data from local device
//     String token = sharedPreferences.getString("token").toString();
//
//     String url = "https://crm.ihelpbd.com/crm/api/crm/contact_list.php";
//
//     HttpClient httpClient = HttpClient();
//
//     HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//
//     // content type
//     request.headers.set('content-type', 'application/json');
//     request.headers.set('token', token);
//
//     //Get response
//     HttpClientResponse response = await request.close();
//     String reply = await response.transform(utf8.decoder).join();
//     final data = jsonDecode(reply);
//
//     // Closed request
//     httpClient.close();
//
//     if (data["status"].toString().contains("200")) {
//       final item = json.decode(reply)["data"];
//
//       setState(() {
//         try {
//           contactsList = item;
//           isLoading = false;
//         } catch (e) {
//           isLoading = true;
//         }
//       });
//     } else {
//       contactsList = [];
//       isLoading = false;
//     }
//   }
//
//   //Search Contact list
//   List searchContactsList = [];
//   bool isSearchLoading = false;
//   void fetchSearchContactsList() async {
//     setState(() {
//       isSearchLoading = true;
//       searchContactsList.clear();
//     });
//
//     //Show progress dialog
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//
//     //Get user data from local device
//     String token = sharedPreferences.getString("token").toString();
//
//     String url = "https://crm.ihelpbd.com/crm/api/crm/contact_search.php";
//
//     HttpClient httpClient = HttpClient();
//
//     HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//
//     // content type
//     request.headers.set('content-type', 'application/json');
//     request.headers.set('token', token);
//
//     //body
//     Map<String, String> body = {"searchKey": searchController.text.toString()};
//
//     request.add(utf8.encode(json.encode(body)));
//
//     //Get response
//     HttpClientResponse response = await request.close();
//     String reply = await response.transform(utf8.decoder).join();
//     final data = jsonDecode(reply);
//
//     // Closed request
//     httpClient.close();
//
//     if (data["status"].toString().contains("200")) {
//       final item = json.decode(reply)["data"];
//
//       setState(() {
//         try {
//           searchContactsList = item;
//           isSearchLoading = false;
//         } catch (e) {
//           isSearchLoading = true;
//         }
//       });
//     } else {
//       searchContactsList = [];
//       isSearchLoading = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appbar
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         systemOverlayStyle:
//             const SystemUiOverlayStyle(statusBarColor: Colors.blue),
//
//         //Search text field
//         title: Container(
//             height: 35,
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             decoration: BoxDecoration(
//                 color: Colors.white70, borderRadius: BorderRadius.circular(5)),
//             child: searchContacts()),
//         automaticallyImplyLeading: true,
//
//         actions: [
//           // Searching button
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   isSearching = true;
//                   fetchSearchContactsList();
//                 });
//               },
//               icon: const Icon(Icons.search_outlined))
//         ],
//       ),
//
//       //Floating button
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.deepPurpleAccent.shade400,
//         foregroundColor: Colors.white,
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const SipDialPad(
//                         phoneNumber: "01770554970",
//                         callerName: 'Unknown',
//                       )));
//         },
//         child: const Icon(Icons.dialpad),
//       ),
//
//       // Check search or not then return a listview
//       body: isSearching ? getSearchContactsListBody() : getContactsListBody(),
//     );
//   }
//
//   //Return contact listview
//   Widget getContactsListBody() {
//     if (contactsList.contains(null) || isLoading) {
//       return const Center(
//           child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//       ));
//     }
//
//     return Scrollbar(
//       child: ListView.builder(
//         itemCount: contactsList.length,
//         itemBuilder: (BuildContext context, int index) {
//           ContactsModel contactsModel =
//               ContactsModel.fromMap(contactsList[index]);
//
//           return Container(
//               margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
//               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.white54,
//                   border: Border.all(color: Colors.blueAccent)),
//               child: TextButton(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const CircleAvatar(
//                       child: Icon(Icons.person_outline_outlined),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     if (contactsModel.clientName.toString().length < 4)
//                       Text(contactsModel.phoneNumber.toString())
//                     else if (contactsModel.clientName.toString().length > 32)
//                       Text(
//                           "${contactsModel.clientName.toString().substring(0, 30)}...")
//                     else
//                       Text(contactsModel.clientName.toString()),
//                   ],
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ContactsDetails(
//                               clientName: contactsModel.clientName.toString(),
//                               companyName: contactsModel.companyName.toString(),
//                               phoneNumber:
//                                   contactsModel.phoneNumber.toString())));
//                 },
//               ));
//         },
//       ),
//     );
//   }
//
//   //Return search contact listview
//   Widget getSearchContactsListBody() {
//     if (searchContactsList.contains(null) || isSearchLoading) {
//       return const Center(
//           child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//       ));
//     }
//
//     return Scrollbar(
//       child: ListView.builder(
//         itemCount: searchContactsList.length,
//         itemBuilder: (BuildContext context, int index) {
//           ContactsModel contactsModel =
//               ContactsModel.fromMap(searchContactsList[index]);
//
//           return Container(
//               margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
//               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.white54,
//                   border: Border.all(color: Colors.blueAccent)),
//               child: TextButton(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const CircleAvatar(
//                       child: Icon(Icons.person_outline_outlined),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     if (contactsModel.clientName.toString().length < 4)
//                       Text(contactsModel.phoneNumber.toString())
//                     else if (contactsModel.clientName.toString().length > 32)
//                       Text(
//                           "${contactsModel.clientName.toString().substring(0, 30)}...")
//                     else
//                       Text(contactsModel.clientName.toString()),
//                   ],
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ContactsDetails(
//                               clientName: contactsModel.clientName.toString(),
//                               companyName: contactsModel.companyName.toString(),
//                               phoneNumber:
//                                   contactsModel.phoneNumber.toString())));
//                 },
//               ));
//         },
//       ),
//     );
//   }
//
//   //Search field
//   Widget searchContacts() {
//     return TextField(
//       controller: searchController,
//       maxLines: 1,
//       decoration: const InputDecoration(
//         hintText: "Search a contact...",
//         border: InputBorder.none,
//       ),
//       onChanged: (value) {
//         //provide realtime search list for every character change
//         fetchSearchContactsList();
//         setState(() {
//           isSearching = true;
//         });
//
//         if (searchController.text.isEmpty) {
//           setState(() {
//             isSearching = false;
//           });
//         }
//       },
//     );
//   }
// }
