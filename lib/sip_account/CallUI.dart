// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:record/record.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:voip24h_sdk_mobile/callkit/utils/sip_event.dart';
// import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile.dart';
// import '../database/DBHandler.dart';
// import 'SipDialPad.dart';
//
// /*
//   Activity name : CallUI
//   Project name : iSalesCRM Mobile App
//   Developer : Eng. Sk Nayeem Ur Rahman
//   Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
//   Email : nayeemdeveloperbd@gmail.com
//   Description : Manages SIP call like (call record, transfer, mute, speaker and call add etc)
// */
//
// class CallUI extends StatefulWidget {
//   const CallUI({Key? key, required this.phoneNumber, required this.callerName})
//       : super(key: key);
//
//   final String phoneNumber;
//   final String callerName;
//   @override
//   State<CallUI> createState() => _CallUIState();
// }
//
// class _CallUIState extends State<CallUI> {
//   bool callAdd = false;
//   bool callRecord = false;
//   bool callTransfer = false;
//   bool callMute = false;
//   bool speaker = false;
//
//   var callStatus = "Calling...";
//   Timer? callTimer;
//   int callTimerDuration = 0;
//
//   bool isCallHangUp = false;
//   bool isCallConnected = false;
//
//   //Recorder is ready or not
//   bool isRecording = false;
//
//   int callRecordDuration = 0;
//   Timer? recordingTimer;
//   final recorder = Record();
//
//   static const overlayChannel = MethodChannel("com.ihelpbd.isalescrm/overlay");
//
//   @override
//   void initState() {
//     // for incoming
//     // Check if it's an incoming call
//     if (Voip24hSdkMobile.callModule.getCallId() != null) {
//       print("####################### Incoming call");
//       // It's an incoming call, so we don't need to make a new call
//       isCallConnected = true;
//       startCallTimer();
//     }
//
//     // TODO: implement initState
//
//     //Store current log history
//     storeCallLog();
//
//     //Call state listener
//     sipCallStateListener();
//
//     //Initialize recorder
//     initRecorder();
//
//     super.initState();
//   }
//
//   // Checking call status
//   void checkCallStatus(BuildContext context, String callStatus) {
//     if (callStatus.contains("Forbidden")) {
//       // Show alert dialog when call is forbidden
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             title: Row(
//               children: [
//                 Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "Call Failed",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             content: const Text(
//               "Your call was rejected due to a forbidden status. Please check your SIP settings or try again later.",
//               style: TextStyle(fontSize: 15),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context), // Close dialog
//                 child: const Text(
//                   "OK",
//                   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       // Hang up the call if status is not forbidden
//       Voip24hSdkMobile.callModule.hangup();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(
//         colors: [Colors.black, Colors.blue],
//         begin: Alignment.bottomLeft,
//         end: Alignment.topRight,
//       )),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 60, 0, 50),
//         child: ListView(
//           children: [
//             //Call Status
//             Text(
//               callStatus,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: callStatus.contains("Forbidden")
//                       ? Colors.redAccent
//                       : Colors.white,
//                   fontSize: 16),
//             ),
//
//             //Recipient name
//             Padding(
//               padding: const EdgeInsets.only(top: 50),
//               child: Text(
//                 widget.callerName,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white, fontSize: 30),
//               ),
//             ),
//             //Recipient phone number
//             Padding(
//               padding: const EdgeInsets.only(top: 2, bottom: 10),
//               child: Text(
//                 widget.phoneNumber,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//
//             //Recipient photo
//             CircleAvatar(
//               radius: 70,
//               child: ClipOval(
//                 child: Image.asset(
//                   "assets/images/person.png",
//                   height: 150,
//                   width: 150,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: const [
//                       Icon(
//                         Icons.add,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                       Text(
//                         "Add Call",
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: const [
//                       Icon(
//                         Icons.video_call,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                       Text(
//                         "Video Call",
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     ],
//                   ),
//
//                   //Recording button
//                   Column(
//                     children: [
//                       IconButton(
//                         color: isRecording ? Colors.redAccent : Colors.grey,
//                         icon: Icon(isRecording ? Icons.stop : Icons.circle),
//                         onPressed: () async {
//                           if (isRecording) {
//                             await stop();
//                           } else {
//                             await startRecord();
//                           }
//                         },
//                       ),
//                       isRecording
//                           ? buildCallRecordTImer()
//                           : const Text(
//                               "Record",
//                               style: TextStyle(color: Colors.grey),
//                             )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       Icon(
//                         Icons.transform,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                       Text(
//                         "Transfer",
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           callMute ? Icons.mic_outlined : Icons.mic_off_rounded,
//                           size: 40,
//                         ),
//                         color: callMute ? Colors.white : Colors.grey,
//                         onPressed: () {
//                           if (!callMute) {
//                             setState(() {
//                               callMute = true;
//
//                               Voip24hSdkMobile.callModule.toggleMic().then(
//                                   (value) => {print(value)},
//                                   onError: (error) => {print(error)});
//                             });
//                           } else if (callMute) {
//                             setState(() {
//                               callMute = false;
//
//                               Voip24hSdkMobile.callModule.toggleMic().then(
//                                   (value) => {print(value)},
//                                   onError: (error) => {print(error)});
//                             });
//                           }
//                         },
//                       ),
//                       const Text(
//                         "Mute",
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           speaker ? Icons.volume_up_outlined : Icons.volume_off,
//                           size: 40,
//                         ),
//                         color: speaker ? Colors.white : Colors.grey,
//                         onPressed: () {
//                           if (!speaker) {
//                             setState(() {
//                               speaker = true;
//                               Voip24hSdkMobile.callModule.toggleSpeaker().then(
//                                   (value) => {print(value)},
//                                   onError: (error) => {print(error)});
//                             });
//                           } else if (speaker) {
//                             setState(() {
//                               speaker = false;
//                               Voip24hSdkMobile.callModule.toggleSpeaker().then(
//                                   (value) => {print(value)},
//                                   onError: (error) => {print(error)});
//                             });
//                           }
//                         },
//                       ),
//                       const Text(
//                         "Speaker",
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             //hangup call button
//             Center(
//               child: Container(
//                 height: 70,
//                 width: 70,
//                 margin: const EdgeInsets.only(top: 40),
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.all(Radius.circular(35)),
//                 ),
//                 child: IconButton(
//                     color: Colors.white,
//                     icon:
//                         const Icon(Icons.phone, size: 40, color: Colors.white),
//                     onPressed: () {
//                       checkCallStatus(context, callStatus);
//                       //  if (callStatus.contains("Forbidden")) {
//                      //    // storeCallLogDetails(" ");
//                      //    Navigator.pop(context);
//                      //    // Navigator.push(
//                      //    //     context,
//                      //    //     MaterialPageRoute(
//                      //    //         builder: (context) => const SipDialPad()));
//                      //  } else {
//                      //    Voip24hSdkMobile.callModule.hangup();
//                      //
//                      //
//                      //    //Navigator.pop(context);
//                      // //   Navigator.push(context, MaterialPageRoute(builder: (context) => SipDialPad(),));
//                      //  }
//                     }),
//
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
//
//   //Call state
//   Future<void> sipCallStateListener() async {
//     //String dialerPrefix = await getDialerPrefix();
//
//     try {
//       String phoneNumber = widget.phoneNumber;
//
//       if (phoneNumber.length == 11) {
//         //make a call
//         Voip24hSdkMobile.callModule.call("$phoneNumber");
//         print("Phone number : $phoneNumber");
//       } else if (phoneNumber.length <= 10) {
//         setState(() {
//           callStatus = "Forbidden";
//         });
//
//         return;
//       } else {
//         phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), "");
//
//         if (phoneNumber.length == 11) {
//           Voip24hSdkMobile.callModule.call("$phoneNumber");
//           print("Phone number : $phoneNumber");
//         } else if (phoneNumber.length == 13) {
//           phoneNumber = phoneNumber.substring(2, 13);
//
//           //make a call
//           Voip24hSdkMobile.callModule.call("$phoneNumber");
//           print("Phone number : $phoneNumber");
//         } else {
//           setState(() {
//             callStatus = "Forbidden";
//           });
//           print("Phone number : $phoneNumber");
//           return;
//         }
//       }
//
//       //Voip listener
//       Voip24hSdkMobile.callModule.eventStreamController.stream.listen((event) {
//         switch (event['event']) {
//           case SipEvent.Ring:
//             try {
//               setState(() {
//                 callStatus = "Ringing...";
//               });
//             } catch (e) {}
//
//             break;
//
//           case SipEvent.Up:
//           case SipEvent.Connected:
//             //set Call timer
//             if (!isCallConnected) {
//               isCallConnected = true;
//
//               startCallTimer();
//             }
//             break;
//
//           case SipEvent.Error:
//           case SipEvent.Hangup:
//             print(" sip errors : $event['body']");
//
//             if (!isCallHangUp) {
//               // overlayPopUp();
//
//               isCallHangUp = true;
//
//               if (isRecording) {
//                 stop();
//               }
//
//               if (event['event'] == SipEvent.Hangup) {
//                 //get call duration
//                 int callDuration = event["body"]["duration"] as int;
//
//                 log("Hangup body : $callDuration");
//
//                 //check call duration is greater than 0
//                 if (callDuration > 0) {
//                   try {
//                     //Convert millisecond to second
//                     int second = callDuration ~/ 1000;
//                     //Convert second to minutes
//                     int minutes = second ~/ 60;
//                     //Convert second
//                     second = (second % 60);
//
//                     //Send data to database
//                     storeCallLogDetails("${minutes}m ${second}s");
//                   } catch (e) {
//                     log("Errors :${e.toString()} ");
//                   }
//                 } else {
//                   storeCallLogDetails(" ");
//                 }
//               } else {
//                 storeCallLogDetails(" ");
//               }
//
//               Navigator.pop(context);
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const SipDialPad(
//                          )));
//             }
//
//             break;
//         }
//       });
//     } catch (e) {
//       log("FS:<--- Call errors${e.toString()}");
//     }
//   }
//
//   Future<void> storeCallLog() async {
//     await DBHandler.instance.insertANewRecord({
//       "phone_number": widget.phoneNumber,
//       "name": widget.callerName.contains("Unknown")
//           ? widget.phoneNumber
//           : widget.callerName,
//     });
//   }
//
//   Future<void> storeCallLogDetails(String duration) async {
//     String callType = "Outgoing";
//
//     DateTime today = DateTime.now();
//     TimeOfDay timeOfDay = TimeOfDay.now();
//
//     String date =
//         "${numberFormat(today.day)}/${numberFormat(today.month)}/${numberFormat(today.year)}";
//     String time = timeOfDay.format(context);
//
//     await DBHandler.instance.updateLastCallLogs(
//         {"type": callType, "date": "$date $time", "time": time},
//         widget.phoneNumber);
//
//     await DBHandler.instance.insertACallHistory({
//       "type": callType,
//       "date": date,
//       "time": time,
//       "duration": duration,
//       "phone_number": widget.phoneNumber,
//     });
//   }
//
//   //Start recorder
//   Future startRecord() async {
//     try {
//       if (await recorder.hasPermission()) {
//         // We don't do anything with this but printing
//         final isSupported = await recorder.isEncoderSupported(
//           AudioEncoder.aacLc,
//         );
//         if (kDebugMode) {
//           print('${AudioEncoder.aacLc.name} supported: $isSupported');
//         }
//
//         await recorder.start();
//         callRecordDuration = 0;
//
//         startRecordTimer();
//       }
//     } catch (e) {
//       log("FS:<--- start record : ${e.toString()}");
//     }
//   }
//
//   void startRecordTimer() {
//     recordingTimer?.cancel();
//
//     recordingTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       setState(() => callRecordDuration++);
//     });
//   }
//
//   Widget buildCallRecordTImer() {
//     final String minutes = numberFormat(callRecordDuration ~/ 60);
//     final String seconds = numberFormat(callRecordDuration % 60);
//
//     return Text(
//       '$minutes : $seconds',
//       style: const TextStyle(color: Colors.red),
//     );
//   }
//
//   //
//   // String recordNumberFormat(int number) {
//   //   String numberStr = number.toString();
//   //   if (number < 10) {
//   //     numberStr = '0$numberStr';
//   //   }
//   //   return numberStr;
//   // }
//
//   void startCallTimer() {
//     callTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       setState(() {
//         callTimerDuration++;
//
//         final String minutes = numberFormat(callTimerDuration ~/ 60);
//         final String seconds = numberFormat(callTimerDuration % 60);
//
//         callStatus = "$minutes:$seconds";
//       });
//     });
//   }
//
//   String numberFormat(int number) {
//     String numberStr = number.toString();
//     if (number < 10) {
//       numberStr = '0$numberStr';
//     }
//     return numberStr;
//   }
//
//   //Stop recorder
//   Future stop() async {
//     try {
//       if (recordingTimer!.isActive) {
//         recordingTimer?.cancel();
//       }
//
//       callRecordDuration = 0;
//
//       final path = await recorder.stop();
//
//       if (path != null) {
//         log("FS:<--- Recorded audio file : $path");
//       }
//     } catch (e) {
//       log("FS:<--- stop recorder : ${e.toString()}");
//     }
//   }
//
//   //Recorder initialization
//   Future initRecorder() async {
//     try {
//       recorder.onStateChanged().listen((recordState) {
//         switch (recordState) {
//           case RecordState.record:
//             setState(() => isRecording = true);
//             break;
//
//           case RecordState.stop:
//             setState(() => isRecording = false);
//             break;
//
//           case RecordState.pause:
//             setState(() => isRecording = false);
//             break;
//         }
//       });
//     } catch (e) {
//       log("FS:<--- initRecorder : ${e.toString()}");
//     }
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//
//     //Voip24hSdkMobile.callModule.eventStreamController.close();
//     recordingTimer?.cancel();
//     callTimer?.cancel();
//     recorder.dispose();
//
//     super.dispose();
//   }
//
//   void overlayPopUp() async {
//     try {
//       await overlayChannel.invokeMethod("overlayPopUp",
//           {"phoneNumber": widget.phoneNumber, "callerName": widget.callerName});
//     } catch (e) {
//       log("OverlayPopUp call errors : ${e.toString()}");
//     }
//   }
//
//   Future<String> getDialerPrefix() async {
//     var ref = await SharedPreferences.getInstance();
//     String? dialerPrefix = ref.getString("dialerPrefix");
//     if (dialerPrefix != null) {
//       return dialerPrefix;
//     } else {
//       return "";
//     }
//   }
// }
import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Contacts/contact_services.dart';
import 'package:untitled1/Lead/LeadSipDialPad.dart';
import 'package:voip24h_sdk_mobile/callkit/utils/sip_event.dart';
import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile.dart';
import '../database/DBHandler.dart';
import 'SipDialPad.dart';

/*
  Activity name : CallUI
  Project name : iSalesCRM Mobile App
  Developer : Eng. Sk Nayeem Ur Rahman
  Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
  Email : nayeemdeveloperbd@gmail.com
  Description : Manages SIP call like (call record, transfer, mute, speaker and call add etc)
*/

class CallUI extends StatefulWidget {
  const CallUI({Key? key, required this.phoneNumber, required this.callerName})
      : super(key: key);

  final String phoneNumber;
  final String callerName;
  @override
  State<CallUI> createState() => _CallUIState();
}

class _CallUIState extends State<CallUI> {
  bool callAdd = false;
  bool callRecord = false;
  bool callTransfer = false;
  bool callMute = false;
  bool speaker = false;

  var callStatus = "Calling...";
  Timer? callTimer;
  int callTimerDuration = 0;

  bool isCallHangUp = false;
  bool isCallConnected = false;

  //Recorder is ready or not
  bool isRecording = false;

  int callRecordDuration = 0;
  Timer? recordingTimer;
  final recorder = Record();

  static const overlayChannel = MethodChannel("com.ihelpbd.isalescrm/overlay");

  @override
  void initState() {
    // for incoming
    // Check if it's an incoming call
    if (Voip24hSdkMobile.callModule.getCallId() != null) {
      print("####################### Incoming call");
      // It's an incoming call, so we don't need to make a new call
      isCallConnected = true;
      startCallTimer();
    }

    // TODO: implement initState

    //Store current log history
    storeCallLog();

    //Call state listener
    sipCallStateListener();

    //Initialize recorder
    initRecorder();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.black, Colors.blue],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      )),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 50),
        child: ListView(
          children: [
            //Call Status
            Text(
              callStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: callStatus.contains("Forbidden")
                      ? Colors.redAccent
                      : Colors.white,
                  fontSize: 16),
            ),

            //Recipient name
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                widget.callerName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            //Recipient phone number
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              child: Text(
                widget.phoneNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            //Recipient photo
            CircleAvatar(
              radius: 70,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/person.png",
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.grey,
                      ),
                      Text(
                        "Add Call",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(
                        Icons.video_call,
                        size: 40,
                        color: Colors.grey,
                      ),
                      Text(
                        "Video Call",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),

                  //Recording button
                  Column(
                    children: [
                      IconButton(
                        color: isRecording ? Colors.redAccent : Colors.grey,
                        icon: Icon(isRecording ? Icons.stop : Icons.circle),
                        onPressed: () async {
                          if (isRecording) {
                            await stop();
                          } else {
                            await startRecord();
                          }
                        },
                      ),
                      isRecording
                          ? buildCallRecordTImer()
                          : const Text(
                              "Record",
                              style: TextStyle(color: Colors.grey),
                            )
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.transform,
                        size: 40,
                        color: Colors.grey,
                      ),
                      Text(
                        "Transfer",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          callMute ? Icons.mic_outlined : Icons.mic_off_rounded,
                          size: 40,
                        ),
                        color: callMute ? Colors.white : Colors.grey,
                        onPressed: () {
                          if (!callMute) {
                            setState(() {
                              callMute = true;

                              Voip24hSdkMobile.callModule.toggleMic().then(
                                  (value) => {print(value)},
                                  onError: (error) => {print(error)});
                            });
                          } else if (callMute) {
                            setState(() {
                              callMute = false;

                              Voip24hSdkMobile.callModule.toggleMic().then(
                                  (value) => {print(value)},
                                  onError: (error) => {print(error)});
                            });
                          }
                        },
                      ),
                      const Text(
                        "Mute",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          speaker ? Icons.volume_up_outlined : Icons.volume_off,
                          size: 40,
                        ),
                        color: speaker ? Colors.white : Colors.grey,
                        onPressed: () {
                          if (!speaker) {
                            setState(() {
                              speaker = true;
                              Voip24hSdkMobile.callModule.toggleSpeaker().then(
                                  (value) => {print(value)},
                                  onError: (error) => {print(error)});
                            });
                          } else if (speaker) {
                            setState(() {
                              speaker = false;
                              Voip24hSdkMobile.callModule.toggleSpeaker().then(
                                  (value) => {print(value)},
                                  onError: (error) => {print(error)});
                            });
                          }
                        },
                      ),
                      const Text(
                        "Speaker",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
            ),

            //hangup call button
            Center(
              child: Container(
                height: 70,
                width: 70,
                margin: const EdgeInsets.only(top: 40),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
                child: IconButton(
                    color: Colors.white,
                    icon:
                        const Icon(Icons.phone, size: 40, color: Colors.white),
                    onPressed: () {
                      Voip24hSdkMobile.callModule.hangup();

                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LeadContacts()));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeadContacts(),
                          ));

                      // if (callStatus.contains("Forbidden")) {
                      //   storeCallLogDetails(" ");
                      //   Navigator.pop(context);
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const SipDialPad()));
                      // } else {
                      //   Voip24hSdkMobile.callModule.hangup();
                      //   //Navigator.pop(context);
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => SipDialPad(),));
                      // }
                    }),
              ),
            )
          ],
        ),
      ),
    ));
  }

  //Call state
  Future<void> sipCallStateListener() async {
    //String dialerPrefix = await getDialerPrefix();

    try {
      String phoneNumber = widget.phoneNumber;

      if (phoneNumber.length == 11) {
        //make a call
        Voip24hSdkMobile.callModule.call("$phoneNumber");
        print("Phone number : $phoneNumber");
      } else if (phoneNumber.length <= 10) {
        setState(() {
          callStatus = "Forbidden";
        });

        return;
      } else {
        phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), "");

        if (phoneNumber.length == 11) {
          Voip24hSdkMobile.callModule.call("$phoneNumber");
          print("Phone number : $phoneNumber");
        } else if (phoneNumber.length == 13) {
          phoneNumber = phoneNumber.substring(2, 13);

          //make a call
          Voip24hSdkMobile.callModule.call("$phoneNumber");
          print("Phone number : $phoneNumber");
        } else {
          setState(() {
            callStatus = "Forbidden";
          });
          print("Phone number : $phoneNumber");
          return;
        }
      }

      //Voip listener
      Voip24hSdkMobile.callModule.eventStreamController.stream.listen((event) {
        switch (event['event']) {
          case SipEvent.Ring:
            try {
              setState(() {
                callStatus = "Ringing...";
              });
            } catch (e) {}

            break;

          case SipEvent.Up:
          case SipEvent.Connected:
            //set Call timer
            if (!isCallConnected) {
              isCallConnected = true;

              startCallTimer();
            }
            break;

          case SipEvent.Error:
          case SipEvent.Hangup:
            print(" sip errors : $event['body']");

            if (!isCallHangUp) {
              // overlayPopUp();

              isCallHangUp = true;

              if (isRecording) {
                stop();
              }

              if (event['event'] == SipEvent.Hangup) {
                //get call duration
                int callDuration = event["body"]["duration"] as int;

                log("Hangup body : $callDuration");

                //check call duration is greater than 0
                if (callDuration > 0) {
                  try {
                    //Convert millisecond to second
                    int second = callDuration ~/ 1000;
                    //Convert second to minutes
                    int minutes = second ~/ 60;
                    //Convert second
                    second = (second % 60);

                    //Send data to database
                    storeCallLogDetails("${minutes}m ${second}s");
                  } catch (e) {
                    log("Errors :${e.toString()} ");
                  }
                } else {
                  storeCallLogDetails(" ");
                }
              } else {
                storeCallLogDetails(" ");
              }

              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SipDialPad()));
            }

            break;
        }
      });
    } catch (e) {
      log("FS:<--- Call errors${e.toString()}");
    }
  }

  Future<void> storeCallLog() async {
    await DBHandler.instance.insertANewRecord({
      "phone_number": widget.phoneNumber,
      "name": widget.callerName.contains("Unknown")
          ? widget.phoneNumber
          : widget.callerName,
    });
  }

  Future<void> storeCallLogDetails(String duration) async {
    String callType = "Outgoing";

    DateTime today = DateTime.now();
    TimeOfDay timeOfDay = TimeOfDay.now();

    String date =
        "${numberFormat(today.day)}/${numberFormat(today.month)}/${numberFormat(today.year)}";
    String time = timeOfDay.format(context);

    await DBHandler.instance.updateLastCallLogs(
        {"type": callType, "date": "$date $time", "time": time},
        widget.phoneNumber);

    await DBHandler.instance.insertACallHistory({
      "type": callType,
      "date": date,
      "time": time,
      "duration": duration,
      "phone_number": widget.phoneNumber,
    });
  }

  //Start recorder
  Future startRecord() async {
    try {
      if (await recorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await recorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        await recorder.start();
        callRecordDuration = 0;

        startRecordTimer();
      }
    } catch (e) {
      log("FS:<--- start record : ${e.toString()}");
    }
  }

  void startRecordTimer() {
    recordingTimer?.cancel();

    recordingTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => callRecordDuration++);
    });
  }

  Widget buildCallRecordTImer() {
    final String minutes = numberFormat(callRecordDuration ~/ 60);
    final String seconds = numberFormat(callRecordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  //
  // String recordNumberFormat(int number) {
  //   String numberStr = number.toString();
  //   if (number < 10) {
  //     numberStr = '0$numberStr';
  //   }
  //   return numberStr;
  // }

  void startCallTimer() {
    callTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        callTimerDuration++;

        final String minutes = numberFormat(callTimerDuration ~/ 60);
        final String seconds = numberFormat(callTimerDuration % 60);

        callStatus = "$minutes:$seconds";
      });
    });
  }

  String numberFormat(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }
    return numberStr;
  }

  //Stop recorder
  Future stop() async {
    try {
      if (recordingTimer!.isActive) {
        recordingTimer?.cancel();
      }

      callRecordDuration = 0;

      final path = await recorder.stop();

      if (path != null) {
        log("FS:<--- Recorded audio file : $path");
      }
    } catch (e) {
      log("FS:<--- stop recorder : ${e.toString()}");
    }
  }

  //Recorder initialization
  Future initRecorder() async {
    try {
      recorder.onStateChanged().listen((recordState) {
        switch (recordState) {
          case RecordState.record:
            setState(() => isRecording = true);
            break;

          case RecordState.stop:
            setState(() => isRecording = false);
            break;

          case RecordState.pause:
            setState(() => isRecording = false);
            break;
        }
      });
    } catch (e) {
      log("FS:<--- initRecorder : ${e.toString()}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    //Voip24hSdkMobile.callModule.eventStreamController.close();
    recordingTimer?.cancel();
    callTimer?.cancel();
    recorder.dispose();

    super.dispose();
  }

  void overlayPopUp() async {
    try {
      await overlayChannel.invokeMethod("overlayPopUp",
          {"phoneNumber": widget.phoneNumber, "callerName": widget.callerName});
    } catch (e) {
      log("OverlayPopUp call errors : ${e.toString()}");
    }
  }

  Future<String> getDialerPrefix() async {
    var ref = await SharedPreferences.getInstance();
    String? dialerPrefix = ref.getString("dialerPrefix");
    if (dialerPrefix != null) {
      return dialerPrefix;
    } else {
      return "";
    }
  }
}
