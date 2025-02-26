import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import 'package:untitled1/resourses/app_colors.dart';

import '../Lead/LeadAssociateDropdown.dart';
import '../Lead/LeadOwnerDropdown.dart';

import '../NotificationService/sendNotification.dart';
import '../components/CustomProgress.dart';

import '../components/Dropdowns/companyNameDropDown.dart';

import 'FollowUPListScreen.dart';
import 'followUpType.dart';

class FollowUpCreate extends StatefulWidget {
  const FollowUpCreate({Key? key}) : super(key: key);

  @override
  State<FollowUpCreate> createState() => _FollowUpCreateState();
}

class _FollowUpCreateState extends State<FollowUpCreate> {
  final _formKey = GlobalKey<FormState>();
  final _companyName = TextEditingController();
  final _subject = TextEditingController();
  final _description = TextEditingController();
  final _contactNumber = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  late String dateTimePicker;

  String? currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  // method to get the current user ID
  Future<void> getCurrentUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = sharedPreferences.getString("id");
      print("Current User ID: $currentUserId");
    });
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

  void associateHandelDeviceToken(String assiciateDeviceToken) {
    setState(() {
      associateSelectedDeviceToken = assiciateDeviceToken;
      print("associate selected token:$associateSelectedDeviceToken");
    });
  }

  // API call and send data to server

  Future sendDataToServer() async {
    CustomProgress customProgress = CustomProgress(context);

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

    String url = 'https://crm.ihelpbd.com/api/crm-create-follow-up';

    Map body = {
      "lead_id": CompanyName.companyId.toString(),
      "user_id": Owner.ownerId.toString(),
      "creator_user_id": userId,
      "followup_type_id": FollowupType.followUpType.toString(),
      "subject": _subject.text,
      "phone_number": _contactNumber.text,
      "next_followup_date": dateTimeController.text,
      "description": _description.text,
      "associate_user_id": Associate.selectedAssociateIds.join(','), // Correct format
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

    print('Response Status: ${response.statusCode}');

    customProgress.hideDialog();

    if (response.statusCode == 200) {
      _companyName.clear();
      _subject.clear();
      _description.clear();
      _contactNumber.clear();
      dateTimeController.clear();

      // Reset dropdowns to their initial state
      setState(() {
        FollowupType.followUpType = null;
        Owner.ownerId = null;
      });

      print('Response Body: ${response.body}');

      // Send notification
      if (selectedDeviceToken.isNotEmpty) {
        SendNotificationService.sendNotificationUsingApi(
          token: selectedDeviceToken,
          title: "New Follow Up Created",
          body: "You are assigned to a new follow up! Please check",
          data: {'screen': 'followup'},
        );
        print("selected device token: $selectedDeviceToken");
      } else {
        print("Device token is empty");
      }

      // Save notification to Firebase Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('notification')
          .doc()
          .set({
        'title': "New Follow Up Created ",
        'body': "You are assigned to a new follow up! Please check",
        'isRead': false,
        'created_at': DateTime.now(),
      });

      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Success",
        desc: "Your follow-up was created successfully",
        customHeader: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[600],
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 50,
          ),
        ),
        btnOkColor: Colors.blue[600],
        btnCancelOnPress: () {
          Navigator.of(context).pop();
        },
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FollowUpList()),
          );
        },
      ).show();
    } else {
      // Parse response and show error message
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String errorMessage = responseData['data']['message'] ?? "An error occurred";
        List<dynamic> errors = responseData['data']['errors'] ?? [];

        String fullErrorMessage = errorMessage;
        if (errors.isNotEmpty) {
          fullErrorMessage += "\n- ${errors.join("\n- ")}";
        }

        print("API Error: $fullErrorMessage");

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error", style: TextStyle(color: Colors.red)),
            content: Text(fullErrorMessage, style: const TextStyle(fontSize: 14)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      } catch (e) {
        print("Error parsing response: $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
        ));
      }
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
              "Create Follow Up",
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
                      dropDownRow("Company Name", CompanyNameDropdown()),
                      const SizedBox(height: 10),
                      formField("Subject", _subject, 'Please enter subject'),
                      const SizedBox(height: 10),
                      dropDownRow(
                          "Owner",
                          LeadOwnerDropDown(
                            userId: currentUserId,
                            onDeviceTokenReceived: handleDeviceToken,
                          )),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Associate",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                      // Multiple drop down
                      MultiLeadAssociateDropDown(
                        onDeviceTokensReceived:
                            (List<String> assiciateDeviceToken) {
                          // Handle the list of device tokens here
                          print(
                              'Selected device tokens: $assiciateDeviceToken');
                        },
                        initialValues: ['Sk Nayeem', 'Pranto'], // Optional
                      ),
                      const SizedBox(height: 12),

                      dropDownRow(
                          "Follow Up Type", const FollowUpTypeDropdown()),
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

// dropdown widget
  // Widget dropDownRow(String label, Widget dropDown) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: Text(label,
  //               style:
  //                   const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  //         ),
  //         // Wrapping the dropdown in Expanded to avoid overflow

  //         Expanded(
  //           flex: 3,
  //           child: dropDown,
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 52),
            maximumSize: Size(MediaQuery.of(context).size.width * 0.45, 52),
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
        SizedBox(width: MediaQuery.of(context).size.width * 0.06),
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
            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 52),
            maximumSize: Size(MediaQuery.of(context).size.width * 0.45, 52),
            backgroundColor: buttonColor,

            // backgroundColor: const Color(0xFF007AFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Create",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }
}
