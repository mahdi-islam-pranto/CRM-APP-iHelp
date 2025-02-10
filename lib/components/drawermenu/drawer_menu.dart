import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Dashboard/bottom_navigation_page.dart';
import 'package:untitled1/sip_account/SipAccountSetting.dart';
import 'package:untitled1/sip_account/SipDialPad.dart';
import 'package:uuid/uuid.dart';


/*
  Component name : DrawMenu
  Project name : iSalesCRM Mobile App
  Developer : Eng.  Sk Nayeem Ur Rahamn
  Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
  Email : mazedulislam4970@gmail.com
  Description : This component provides the left draw navigation.
*/



class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  late String userName;
  late String userEmail;
  late String userRole;

  bool loadUserInfo = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // New Changed Navigation Drawer   (Nayeem Developer.....01733364274)

      child: Drawer(
        elevation: 5,
        backgroundColor: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 60.w,
                    height: 50.h,
                  ),
                  const SizedBox(
                      child: Center(
                        child: Text(" Contact", style: TextStyle(letterSpacing: 1)),
                      )),
                ],
              ),

              // Navigation drawer er Box decoration

              // decoration: BoxDecoration(
              //   color: Colors.green,
              //   borderRadius: BorderRadius.circular(12),
              // ),
            ),

            // loadUserInfo?Container(
            //   margin: const EdgeInsets.only(top:10,left: 20),
            //
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Text(userName,style:const TextStyle(fontSize: 18)),
            //           Text(" ($userRole)"),
            //         ]
            //       ),
            //       Text(userEmail,style:TextStyle(fontSize: 15,color: Colors.black45))
            //     ],
            //   ),
            // ):const Text("lll"),

            // Simple padding
            // const Padding(
            //   padding: EdgeInsets.only(left: 20, right: 20, top: 0),
            //   child: Divider(
            //     color: Colors.grey,
            //     thickness: 0.5,
            //   ),
            // ),

            ListTile(
              splashColor: Colors.blueGrey,
              title: const Text("Home"),
              leading: const Icon(
                Icons.home,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigationPage()));
              },
            ),

            //iDialer Account menu
            ListTile(
              splashColor: Colors.blueGrey,
              title: const Text("iDialer Account"),
              leading: const Icon(
                Icons.dialer_sip,
                color: Colors.green,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SipAccountSetting()));
              },
            ),

            // Simple padding
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Contact"),
            ),

            // Contacts menu
            // ListTile(
            //   splashColor: Colors.blueGrey,
            //   title: const Text("Contacts"),
            //   leading: const Icon(
            //     Icons.person_rounded,
            //     color: Colors.black,
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const ContactsList()));
            //   },
            // ),

            //Call logs menu
            ListTile(
              splashColor: Colors.blueGrey,
              title: const Text("Call logs"),
              leading: const Icon(
                Icons.history,
                color: Color.fromRGBO(246, 170, 170, 1.0),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  SipDialPad()));
              },
            ),

            // check internet connection

            // ListTile(
            //   splashColor: Colors.blueGrey,
            //   title: const Text("Check Internet"),
            //   leading: const Icon(
            //     Icons.wifi,
            //     color: Color.fromRGBO(246, 170, 170, 1.0),
            //   ),
            //   onTap: () async {
            //     InternetConnectionCheckerPlus.createInstance();
            //     // check internet connection
            //     InternetConnectionCheckerPlus();
            //
            //     if (await InternetConnectionCheckerPlus().hasConnection) {
            //       print("#################You are online##################");
            //       // show an alert dialog
            //       showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           title: const Text("Internet Connection"),
            //           content: const Text("You are online"),
            //           actions: <Widget>[
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //               child: const Text('Ok'),
            //             ),
            //           ],
            //         ),
            //       );
            //     } else {
            //       showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           title: const Text("Internet Connection"),
            //           content:
            //           const Text("You are Offline. No Internet Connection"),
            //           actions: <Widget>[
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //               child: const Text('Ok'),
            //             ),
            //           ],
            //         ),
            //       );
            //     }
            //   },
            // ),

            //Show Deals page
            // ListTile(
            //     splashColor: Colors.blueGrey,
            //     title: const Text(
            //       'Deals',
            //     ),
            //     leading: const Icon(
            //       Icons.handshake,
            //       color: Colors.amber,
            //     ),
            //     onTap: () {}),

            //Show Lead page
            // ListTile(
            //     splashColor: Colors.blueGrey,
            //     title: const Text('Lead'),
            //     leading: const Icon(
            //       Icons.list_alt_outlined,
            //       color: Colors.blueGrey,
            //     ),
            //     onTap: () {
            //       Navigator.pop(context);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const LeadListScreen()));
            //     }),

            //Show Opportunity page
            // ListTile(
            //     splashColor: Colors.blueGrey,
            //     title: const Text('Opportunity'),
            //     leading: const Icon(
            //       Icons.timeline,
            //       color: Colors.brown,
            //     ),
            //     onTap: () {
            //       Navigator.pop(context);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const OpportunityList()));
            //     }),

            // Simple padding
            // const Padding(
            //   padding: EdgeInsets.only(left: 20, right: 20),
            //   child: Divider(
            //     color: grey,
            //     thickness: 0.2,
            //   ),
            // ),

            ///inbox
            // const Padding(
            //   padding: EdgeInsets.only(left: 20),
            //   child: Text("Inbox"),
            // ),

            //Show Conversation page
            // ListTile(
            //     splashColor: Colors.blueGrey,
            //     title: const Text('Conversation'),
            //     leading: const Icon(
            //       Icons.short_text_sharp,
            //       color: Colors.deepPurpleAccent,
            //     ),
            //     onTap: () {}),

            // Simple padding
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
            ),

            // const Padding(
            //   padding: EdgeInsets.only(left: 20),
            //   child: Text("Credential"),
            // ),
            // //Logout from this app
            // ListTile(
            //     splashColor: Colors.blueGrey,
            //     title: const Text('Exit'),
            //     leading: const Icon(
            //       Icons.logout_sharp,
            //       color: Colors.deepOrangeAccent,
            //     ),
            //     onTap: () {
            //       //Logout from this app
            //
            //  //     LogoutAPI(context).logout();
            //     }),
          ],
        ),
      ),
    );
  }

  void getUserInfo() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    userName = ref.getString("username").toString();
    userEmail = ref.getString("email").toString();
    userRole = ref.getString("role").toString();

    if (userName.length >= 17) {
      userName = "${userName.substring(0, 15)}...";

      setState(() {
        loadUserInfo = true;
      });
    }
  }
}