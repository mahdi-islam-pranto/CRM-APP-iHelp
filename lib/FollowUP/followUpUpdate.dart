import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/Lead/LeadAssociateDropdown.dart' as Associates;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:untitled1/Models/followUpModel.dart';

import 'package:untitled1/resourses/app_colors.dart';

import '../Lead/LeadAssociateDropdown.dart';
import '../Lead/LeadOwnerDropdown.dart';

import '../Notification/fcm_server.dart';
import '../components/CustomProgress.dart';

import '../components/Dropdowns/companyNameDropDown.dart';

import 'FollowUPListScreen.dart';
import 'followUpOverview.dart';
import 'followUpType.dart';

class FollowUpUpdate extends StatefulWidget {
  final int leadId;
  final int followUpId;
  final Data followUpDetails;
  const FollowUpUpdate(
      {Key? key,
      required this.leadId,
      required this.followUpId,
      required this.followUpDetails})
      : super(key: key);

  @override
  State<FollowUpUpdate> createState() => _FollowUpUpdateState();
}

class _FollowUpUpdateState extends State<FollowUpUpdate> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _company;
  late TextEditingController _subject;
  late TextEditingController _description;
  late TextEditingController _contactNumber;
  late TextEditingController dateTimeController;
  late String dateTimePicker;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _subject = TextEditingController(text: widget.followUpDetails.subject);
    _description =
        TextEditingController(text: widget.followUpDetails.description);
    _contactNumber =
        TextEditingController(text: widget.followUpDetails.phoneNumber);
    dateTimeController =
        TextEditingController(text: widget.followUpDetails.nextFollowupDate);

    // Set initial values for dropdowns

    Owner.ownerId = widget.followUpDetails.assignName?.id;
    // associate
    // Associates.Associate.associateId = widget.followUpDetails.associates;
    FollowupType.followUpType = widget.followUpDetails.followupTypeId;

    // Convert the status name to the corresponding value
    _selectedStatus =
        _getStatusValue(widget.followUpDetails.followUpStatus?.name);
  }

  // selected status

  String? _getStatusValue(String? statusName) {
    switch (statusName) {
      case "Solved":
        return "1";
      case "Pending":
        return "2";
      case "Working in Progress":
        return "3";
      case "Canceled":
        return "4";
      default:
        return null;
    }
  }

  String _getStatusName(String value) {
    switch (value) {
      case "1":
        return "Solved";
      case "2":
        return "Pending";
      case "3":
        return "Working in Progress";
      case "4":
        return "Canceled";
      default:
        return "Unknown";
    }
  }

  List<DropdownMenuItem<String>> get statusDropdownItems {
    return [
      const DropdownMenuItem(value: "1", child: Text("Solved")),
      const DropdownMenuItem(value: "2", child: Text("Pending")),
      const DropdownMenuItem(value: "3", child: Text("Working in Progress")),
      const DropdownMenuItem(value: "4", child: Text("Canceled")),
    ];
  }

  bool validatePhoneNumber(String phoneNumber) {
    return RegExp(r'^[0-9]{11}$').hasMatch(phoneNumber);
  }

// notification
  String selectedDeviceToken = "";
  String associateSelectedDeviceToken = "";

  // assign
  void handleDeviceToken(String deviceToken) {
    setState(() {
      selectedDeviceToken = deviceToken;
      print("selected token:$selectedDeviceToken");
    });
  }

  // void associateHandelDeviceToken(String assiciateDeviceToken) {
  //   setState(() {
  //     associateSelectedDeviceToken = assiciateDeviceToken;
  //     print("selected Associate device / multiple device token:$associateSelectedDeviceToken");
  //
  //   });
  // }

  void associateHandleDeviceToken(List<String> associateDeviceTokens) {
    setState(() {
      if (associateDeviceTokens.isNotEmpty) {
        associateSelectedDeviceToken =
            associateDeviceTokens.join(", "); // Store tokens
      } else {
        associateSelectedDeviceToken = "No token received"; // Debugging case
      }
      print("✅ Final Selected Associate Tokens: $associateSelectedDeviceToken");
    });
  }

  // API call and send data to server

  Future sendDataToServer() async {
    CustomProgress customProgress = CustomProgress(context);

    // if (!validatePhoneNumber(_contactNumber.text)) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Phone number must be 11 digits.'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }

    customProgress.showDialog(
        "Please wait", SimpleFontelicoProgressDialogType.spinner);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String userId = sharedPreferences.getString("id") ?? "";

    if (token == null || token.isEmpty) {
      customProgress.hideDialog();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Token not found. Please log in again.'),
      ));
      return;
    }
    print("Token: $token");

    String url = 'https://crm.ihelpbd.com/api/crm-update-follow-up';

    Map body = {
      "id": widget.followUpId.toString(),
      "user_id": userId,
      "lead_id": widget.leadId.toString(),
      "followup_type_id": FollowupType.followUpType.toString(),
      "subject": _subject.text,
      "phone_number": _contactNumber.text,
      "next_followup_date": dateTimeController.text,
      "description": _description.text,
      "associate_user_id": Associates.Associate.selectedAssociateIds.toString(),
      "followup_status": _selectedStatus.toString(),
      "creator_user_id": userId,
    };

    print('Sending request with body: ${jsonEncode(body)}');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print('Request Headers: ${response.request?.headers}');
    print('Request URL: ${response.request?.url}');
    print('Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      // hide progress dialog
      customProgress.hideDialog();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.blue,
            animation: AlwaysStoppedAnimation(BorderSide.strokeAlignCenter),
            content: Text('Follow-up updated successfully')),
      );

      // go back to the follow up overview page with updated data

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FollowUpOverview(
                    followUpId: widget.followUpId,
                  )));

      // Navigator.pop(context, true); // Return true to indicate successful update

      print('Response Body: ${response.body}');

      // send notification
      // if (selectedDeviceToken.isNotEmpty) {
      //   FCMService.sendNotification(
      //       deviceToken: selectedDeviceToken,
      //       title: "Reminder",
      //       body: "FollowUp Available ! Please Solved FollowUp",
      //       storyId: "story_12345");
      //   print("selected device token: $selectedDeviceToken");
      // } else {
      //   print("Device token is empty");
      // }
      // if (associateSelectedDeviceToken.isNotEmpty) {
      //   FCMService.sendNotification(
      //       deviceToken: associateSelectedDeviceToken,
      //       title: "Reminder",
      //       body: "FollowUp Available ! Please Solved FollowUp",
      //       storyId: "story_12345");
      //   print("selected associate device token: $associateSelectedDeviceToken");
      // } else {
      //   print("Device token is empty");
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              // 'Failed to update task. Error: ${response.body}'
              "Failed to update follow-up. Check all fields"),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: formBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            // toolbarHeight: 80,
            title: const Text(
              "Update Follow Up",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            // Responsive Container Padding
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025),

// Responsive Form Container
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width * 1,
            child: Form(
              key: _formKey,
              child: RawScrollbar(
                // thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // all forms

                      // task status field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Follow Up Status",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 3,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: DropdownButtonFormField<String>(
                              dropdownColor: backgroundColor,
                              value: _selectedStatus,
                              items: statusDropdownItems,
                              hint: Text(
                                "current follow-up status",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down_sharp,
                                  size: 30, color: Colors.blue),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              },
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFF8F6F8)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 10),
                                fillColor: Color(0xFFF8F6F8),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const SizedBox(height: 10),
                      formField("Subject", _subject, 'Please enter subject'),
                      const SizedBox(height: 10),

                      dropDownRow(
                          "Owner",
                          LeadOwnerDropDown(
                            initialValue:
                                widget.followUpDetails.assignName?.name,
                            onDeviceTokenReceived: handleDeviceToken,
                          )),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Associate",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),

                      MultiLeadAssociateDropDown(
                        onDeviceTokensReceived: (List<String> tokens) {
                          print(
                              "🟡 Received from Dropdown: $tokens"); // Debug print
                          associateHandleDeviceToken(
                              tokens); // Call the function
                        },
                        initialValues: ['Sk Nayeem', 'Pranto'], // Optional
                      ),

                      const SizedBox(height: 12),

                      dropDownRow(
                          "Follow Up Type",
                          FollowUpTypeDropdown(
                            initialValue:
                                widget.followUpDetails.followUpName?.name,
                          )),
                      const SizedBox(height: 12),
                      dateField("Next Follow Up Date", dateTimeController),
                      const SizedBox(height: 10),
                      phoneNumberField(),
                      const SizedBox(height: 10),
                      descritionFormField("Description", _description,
                          'Please enter description'),
                      const SizedBox(height: 30),
                      buttonRow(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget formField(
      String label, TextEditingController controller, String errorText,
      {String hintText = ''}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorText;
                }
                return null;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget dropDownRow(String label, Widget dropDown) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        dropDown,
      ],
    );
  }

  Widget dateField(String label, TextEditingController dateTimeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        // const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              setState(() {
                dateTimeController.text =
                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextFormField(
              readOnly: true,
              controller: dateTimeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Next Follow up date is required";
                }
                return null;
              },
              enabled: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
                hintText: 'Select Date',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget phoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Contact Number',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              controller: _contactNumber,
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter phone number';
              //   }
              //   if (!validatePhoneNumber(value)) {
              //     return 'Phone number must be 11 digits';
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                hintText: 'Ex: 01610-681903',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget descritionFormField(
      String label, TextEditingController controller, String errorText,
      {String hintText = ''}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorText;
                }
                return null;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// cancle button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.3, 52),
            maximumSize: Size(MediaQuery.of(context).size.width * 0.45, 52),
            // minimumSize: const Size(164, 52),
            // maximumSize: const Size(181, 52),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: () {
            // if (selectedDeviceToken.isNotEmpty) {
            //   FCMService.sendNotification(
            //       deviceToken: selectedDeviceToken,
            //       title: "Reminder",
            //       body: "FollowUp Available ! Please Solved FollowUp",
            //       storyId: "story_12345");
            //   print("selected device token: $selectedDeviceToken");
            // } else {
            //   print("Device token is empty");
            // }
            // if (associateSelectedDeviceToken.isNotEmpty) {
            //   FCMService.sendNotification(
            //       deviceToken: associateSelectedDeviceToken,
            //       title: "Reminder",
            //       body: "FollowUp Available ! Please Solved FollowUp",
            //       storyId: "story_12345");
            //   print(
            //       "selected associate device token: $associateSelectedDeviceToken");
            // } else {
            //   print("Device token is empty");
            // }

            if (_formKey.currentState?.validate() == true) {
              if (Owner.ownerId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    dismissDirection: DismissDirection.endToStart,
                    elevation: 2,
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating, // Makes it floating
                    shape: RoundedRectangleBorder(
                      // Adds border radius
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin:
                        const EdgeInsets.all(10), // Margin around the SnackBar
                    content: const Text(
                      'Please Select Owner',
                      style:
                          TextStyle(color: Colors.white), // Custom text style
                    ),
                  ),
                );
                return;
              }
              if (FollowupType.followUpType == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 2,
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating, // Makes it floating
                    shape: RoundedRectangleBorder(
                      // Adds border radius
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin:
                        const EdgeInsets.all(10), // Margin around the SnackBar
                    content: const Text(
                      'Please Select Follow Up Type',
                      style:
                          TextStyle(color: Colors.white), // Custom text style
                    ),
                  ),
                );
                return;
              }
              sendDataToServer();
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.3, 52),

            maximumSize: Size(MediaQuery.of(context).size.width * 0.45, 52),

            backgroundColor: buttonColor,
            // backgroundColor: const Color(0xFF007AFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Update",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }
}
