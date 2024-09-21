import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../Lead/LeadAssociateDropdown.dart';
import '../Lead/LeadOwnerDropdown.dart';
import '../components/CustomProgress.dart';

import '../resourses/resourses.dart';
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

  bool validatePhoneNumber(String phoneNumber) {
    return RegExp(r'^[0-9]{11}$').hasMatch(phoneNumber);
  }

  // API call and send data to server

  Future sendDataToServer() async {
    CustomProgress customProgress = CustomProgress(context);

    if (!validatePhoneNumber(_contactNumber.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number must be 11 digits.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
      "lead_id": "1910",
      "user_id": userId,
      "creator_user_id": userId,
      "followup_type_id": FollowupType.followUpType.toString(),
      "subject": _subject.text,
      "phone_number": _contactNumber.text,
      "next_followup_date": dateTimeController.text,
      "description": _description.text,
      "associate_user_id": "",
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
      customProgress.hideDialog();
      _companyName.clear();
      _subject.clear();
      _description.clear();
      _contactNumber.clear();
      dateTimeController.clear();

      // Reset dropdowns to their initial state
      setState(() {
        FollowupType.followUpType =
            null; // Assuming this is the dropdown variable
        Owner.ownerId = null; // Assuming this is the dropdown
      });

      print('Response Body: ${response.body}');

      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Success",
        desc: "Your info saved successfully",
        customHeader: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: R.appColors.buttonColor,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 50,
          ),
        ),
        btnOkColor: R.appColors.buttonColor,
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else {
      customProgress.hideDialog();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Column(
            children: [
              Text("Error", style: TextStyle(color: Colors.red)),
              Text("Please select Owner and Follow Up Type",
                  style: TextStyle(color: Colors.red, fontSize: 13)),
            ],
          ),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Follow UP Create Form"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                formField(
                    "Company Name", _companyName, 'Please enter company name'),
                dropDownRow("Owner", LeadOwnerDropDown()),
                dropDownRow("Associate", LeadAssociateDropDown()),
                dropDownRow("Follow Up Type", const FollowUpTypeDropdown()),
                formField("Subject", _subject, 'Please enter subject'),
                dateField("Next Follow Up Date", dateTimeController),
                phoneNumberField(),
                formField(
                    "Description", _description, 'Please enter description'),
                const SizedBox(
                  height: 7,
                ),
                buttonRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formField(
      String label, TextEditingController controller, String errorText,
      {String hintText = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: R.appColors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
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
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  hintText: hintText.isNotEmpty ? hintText : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // followUpTypeDropdown

  Widget dropDownRow(String label, Widget dropDown) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          // Wrapping the dropdown in Expanded to avoid overflow

          Expanded(
            flex: 3,
            child: dropDown,
          ),
        ],
      ),
    );
  }

  Widget dateField(String label, TextEditingController dateTimeController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
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
                      color: R.appColors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextFormField(
                  controller: dateTimeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Next Follow up date is required";
                    }
                    return null;
                  },
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: "Pick a date",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text('Contact Number*',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _contactNumber,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (!validatePhoneNumber(value)) {
                    return 'Phone number must be 11 digits';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  hintText: '017***',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// cancle button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedButton(
            width: 100,
            text: "Cancel",
            color: R.appColors.grey,
            pressEvent: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: "Warning",
                desc: "Please take a good look",
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  Navigator.pop(context);
                },
              ).show();
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
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
            backgroundColor: R.appColors.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
