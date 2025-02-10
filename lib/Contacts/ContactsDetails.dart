import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../sip_account/CallUI.dart';
import 'contact_info.dart';


/*

  Activity name : ContactsDetails
  Project name : iSalesCRM Mobile App
  Developer : Eng. Sk Nayeem Ur Rahaman
  Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
  Email : nayeemdeveloperbd@gmail.com
  Description : Display Contacts Details

*/

class ContactsDetails extends StatefulWidget {
  const ContactsDetails(
      {Key? key,
        required this.clientName,
        required this.companyName,
        required this.phoneNumber})
      : super(key: key);

  final String clientName;
  final String companyName;
  final String phoneNumber;

  @override
  State<ContactsDetails> createState() => _ContactsDetailsState();
}

class _ContactsDetailsState extends State<ContactsDetails> {
  @override
  Widget build(BuildContext context) {
    String contactName;
    try {
      //Check client name is null or not
      contactName = widget.clientName.toString().length > 2
          ? widget.clientName.toString().trim()
          : "Unknown";
    } catch (e) {
      contactName = "Unknown";
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.blue),
          automaticallyImplyLeading: true),
      body: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),

          //First latter of Customer name
          Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    contactName[0],
                    style: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold),
                  ))),

          //Name of customer
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
              child: Text(
                contactName,
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
          //Name of customer
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                // "(${widget.companyName.toString().trim()})",
                "(${widget.phoneNumber.toString().trim()})",

                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.normal),
              )),

          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Call button
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.dialer_sip_outlined,
                        size: 30,
                      ),
                      color: Colors.blue.shade700,
                      onPressed: () {
                        //Make call
                        // Voip24hSdkMobile.callModule.call(widget.contactsModel.phoneNumber.toString());

                        //switch to CallUI screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CallUI(
                                    phoneNumber:
                                    widget.phoneNumber.toString().trim(),
                                    callerName:
                                    widget.clientName.toString().trim())));
                      },
                    ),
                    const Text(
                      "Call",
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),

                //SMS button
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.message_outlined,
                        size: 30,
                      ),
                      color: Colors.blue.shade700,
                      onPressed: () {},
                    ),
                    const Text(
                      "SMS",
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Container(
          //   margin: const EdgeInsets.all(10),
          //   padding: const EdgeInsets.all(10),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         "Contact info",
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       const SizedBox(height: 20),
          //       TextButton(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 const Icon(Icons.call),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(widget.phoneNumber.toString()),
          //                     const Text("Mobile"),
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ],
          //         ),
          //         onPressed: () async {
          //           // await FlutterPhoneDirectCaller.callNumber(
          //           //     widget.phoneNumber.toString());
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          ContactInfo(phoneNumber: widget.phoneNumber,),
        ],
      ),
    );
  }
}