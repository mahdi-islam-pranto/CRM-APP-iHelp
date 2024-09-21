// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animated_button/flutter_animated_button.dart';
// import 'package:isalescrm/progress_indicator/CustomProgressIndicator.dart';
// import 'package:isalescrm/sip_account/SipAccountSetting.dart';
// import 'package:isalescrm/sip_account/SipAccountStatus.dart';
// import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
// import '../alert_dialog/CustomAlertDialg.dart';
// import '../constants/Constants.dart';
// import 'SIPConfiguration.dart';
//
// /*
//   Activity name : SIPCredential
//   Project name : iSalesCRM Mobile App
//   Developer    : Eng. Sk Nayeem Ur Rahman
//   Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
//   Email : nayeemdeveloperbd@gmail.com
// */
//
// class SIPCredential extends StatefulWidget {
//   const SIPCredential({Key? key}) : super(key: key);
//
//   @override
//   State<SIPCredential> createState() => _SIPCredentialState();
// }
// class _SIPCredentialState extends State<SIPCredential> {
//   TextEditingController sipUserID = TextEditingController();
//   TextEditingController sipServer = TextEditingController();
//   TextEditingController sipPassword = TextEditingController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//   //GradientAppBar gradientAppBar = GradientAppBar();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.cyan,
//         // flexibleSpace: Container(
//         //   decoration: const BoxDecoration(
//         //     gradient: LinearGradient(
//         //         begin: Alignment.centerLeft,
//         //         end: Alignment.centerRight,
//         //         colors: [Colors.teal,Colors.blue,Colors.blue,Colors.teal]),
//         //   ),
//         // ),
//         systemOverlayStyle:
//             const SystemUiOverlayStyle(statusBarColor: primaryColor),
//         title: const Text("SIP Credential"),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.all(10),
//         child: ListView(
//           children: [
//             const SizedBox(
//               height: 30,
//             ),
//
//             // SIP User ID
//             Card(
//               elevation: 2,
//               child: TextField(
//                    controller: sipUserID,
//                    maxLines: 1,
//                    decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "SIP User ID",
//                       hintText: "096xxxxxxxx")),
//             ),
//
//             // New Changed Text Filed  //nayeem
//
//             // shape: RoundedRectangleBorder( //<-- 1. SEE HERE
//             //   side: BorderSide(
//             //     color: Colors.blue,
//             //     width: 0.5,
//             //   ),
//             //   borderRadius: BorderRadius.circular(15.0),
//             // ),
//
//             // child: TextField(
//             //   controller: sipUserID,
//             //   maxLines: 1,
//             //   decoration: InputDecoration(
//             //     enabledBorder: OutlineInputBorder(
//             //       borderSide:
//             //       BorderSide(
//             //      color: Colors.blue,
//             //      width: 0.5,
//             //    ), //<-- SEE HERE
//             //       borderRadius: BorderRadius.circular(10.0),
//             //     ),
//
//             //       labelText: "SIP User ID",
//             //       hintText: "096xxxxxxxx"
//             //   ),
//             // ),
//             //
//
//             const SizedBox(
//               height: 20,
//             ),
//
//             //SIP Server
//             Card(
//               elevation: 2,
//               child: TextField(
//                   controller: sipServer,
//                   maxLines: 1,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "SIP Server",
//                       hintText: "sip host")),
//             ),
//
//             const SizedBox(
//               height: 20,
//             ),
//
//             //SIP Account Password
//             Card(
//               elevation: 2,
//               child: TextField(
//                   controller: sipPassword,
//                   obscureText: true,
//                   maxLines: 1,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Password",
//                       hintText: "eg. @e#%wsfh")),
//             ),
//
//             //Save SIP account
//
//             const SizedBox(
//               height: 45,
//             ),
//
//             //Animated Button //Changed design     Nayeem Developer : Phone : 01733364274
//
//             Center(
//               child: Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 color: Colors.blue,
//                 child: AnimatedButton(
//                   width: 150,
//                   text: 'Save',
//                   isReverse: true,
//                   selectedTextColor: Colors.blue,
//                   transitionType: TransitionType.LEFT_TO_RIGHT,
//                   // textStyle: submitTextStyle,
//                   // backgroundColor: Colors.green,
//                   //  backgroundColor: Color.fromRGBO(55, 155, 155, 1.0),
//                   backgroundColor:
//                       Color.fromRGBO(106, 129, 224, 0.4470588235294118),
//                   borderRadius: 15,
//                   borderWidth: 2,
//
//                   onPress: () async {
//                     if (sipUserID.text.isEmpty) {
//                       CustomAlertDialog.showAlert(
//                           "Sip User ID field is required!", context);
//                       return;
//                     }
//                     if (sipServer.text.isEmpty) {
//                       CustomAlertDialog.showAlert(
//                           "Sip server field is required!", context);
//                       return;
//                     }
//
//                     if (sipPassword.text.isEmpty) {
//                       CustomAlertDialog.showAlert(
//                           "Password field is required!", context);
//                       return;
//                     }
//
//                     SIPConfiguration.config(
//                         sipUserID.text, sipServer.text, sipPassword.text, true);
//
//                     CustomProgressIndicator progress =
//                         CustomProgressIndicator(context);
//                     progress.showDialog("Please wait..",
//                         SimpleFontelicoProgressDialogType.threelines);
//
//                     Future.delayed(const Duration(seconds: 4), () {
//                       progress.hideDialog();
//                       checkAccountStatus(SipAccountStatus.sipAccountStatus);
//                     });
//                   },
//                 ),
//               ),
//             ),
//
//             //  SizedBox(height: 10,),
//             //
//             // Column(
//             //    children: <Widget>[
//             //     AnimatedButton(
//             //         width: 150,
//             //         text: 'Animated',
//             //         isReverse: true,
//             //         selectedTextColor: Colors.blue,
//             //         transitionType: TransitionType.LEFT_TO_RIGHT,
//             //         // textStyle: submitTextStyle,
//             //         backgroundColor: Colors.blueAccent,
//             //         borderColor: Colors.white,
//             //         borderRadius: 15,
//             //         borderWidth: 1,
//             //
//             //         onPress: (){
//             //
//             //       })
//             //    ],
//             //  ),
//
//             // Mazed vai
//             // ElevatedButton(
//             //
//             //    style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue,elevation: 3),
//             //    child: const SizedBox(child: Center(child: Text("Save",style: TextStyle(fontSize: 18),))),
//             //    onPressed: () async {
//             //
//             //      //SIPConfiguration.config("09643207254","59.152.98.66:5060", "zQBaqA5mCnKdqa5w",SIPCredentialStatus);
//             //     // SIPConfiguration.config("9999","103.204.81.13:5060", "ihelp1234",sipAccountStatus);
//             //
//             //
//             //      if(sipUserID.text.isEmpty){
//             //        CustomAlertDialog.showAlert("Sip User ID field is required!",context);
//             //        return;
//             //      }
//             //      if(sipServer.text.isEmpty){
//             //        CustomAlertDialog.showAlert("Sip server field is required!",context);
//             //        return;
//             //      }
//             //
//             //      if(sipPassword.text.isEmpty){
//             //        CustomAlertDialog.showAlert("Password field is required!",context);
//             //        return;
//             //      }
//             //
//             //      SIPConfiguration.config(sipUserID.text, sipServer.text, sipPassword.text,true);
//             //
//             //      CustomProgressIndicator progress = CustomProgressIndicator(context);
//             //      progress.showDialog("Please wait..", SimpleFontelicoProgressDialogType.threelines);
//             //
//             //      Future.delayed(const Duration(seconds: 4),(){
//             //        progress.hideDialog();
//             //        checkAccountStatus(SipAccountStatus.sipAccountStatus);
//             //      });
//             //
//             //    },
//             //  ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void checkAccountStatus(bool isAccountRegistered) {
//     if (isAccountRegistered) {
//       Navigator.of(context).pop();
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => const SipAccountSetting()));
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Server message"),
//           content: const Text("Invalid Sip credential",
//               style: TextStyle(fontSize: 16, color: Colors.redAccent)),
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
//   }
// }
