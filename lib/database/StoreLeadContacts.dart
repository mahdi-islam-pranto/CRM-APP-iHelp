// import 'dart:convert';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitled1/contacts/model/ContactsModel.dart';
// import '../Contacts/model/ContactsModel.dart';
// import 'DBHandler.dart';
//
// class StoreLeadContacts {
//   static Future fetch() async {
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
//
//     final data = jsonDecode(reply);
//
//     // Closed request
//     httpClient.close();
//     List<ContactsModel> contactsList = [];
//
//     if (data["status"].toString().contains("200")) {
//       var contacts = json.decode(reply)["data"];
//
//       for (var element in contacts) {
//         contactsList.add(ContactsModel.fromMap(element));
//       }
//
//       await DBHandler.instance.storeLeadContacts(contactsList.cast<ContactsModel>());
//       //await DBHandler.instance.leadContacts();
//     }
//   }
// }
