import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile.dart';

class IncomingCallUi extends StatefulWidget {
  final String IncomingPhoneNumber;
  final String IncomingCallerName;

  const IncomingCallUi({
    Key? key,
    required this.IncomingPhoneNumber, // Correct initialization
    required this.IncomingCallerName, // Correct initialization
  }) : super(key: key);

  @override
  State<IncomingCallUi> createState() => _IncomingCallUiState();
}

class _IncomingCallUiState extends State<IncomingCallUi> {
  var callStatus = "Calling...";
  bool callAdd = false;
  bool callRecord = false;
  bool callTransfer = false;
  bool callMute = false;
  bool speaker = false;
  Timer? callTimer;
  int callTimerDuration = 0;
  bool isCallHangUp = false;
  bool isCallConnected = false;

  //Recorder is ready or not
  bool isRecording = false;

  int callRecordDuration = 0;
  Timer? recordingTimer;
  final recorder = Record();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blue, Colors.black54],
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
                widget.IncomingCallerName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            //Recipient phone number
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              child: Text(
                widget.IncomingPhoneNumber,
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
                      if (callStatus.contains("Forbidden")) {
                        Voip24hSdkMobile.callModule.hangup();
                      } else {
                        Voip24hSdkMobile.callModule.hangup();
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    ));
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
}
