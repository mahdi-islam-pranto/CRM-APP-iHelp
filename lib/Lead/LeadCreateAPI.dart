import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../Dashboard/bottom_navigation_page.dart';
import '../components/CustomProgress.dart';
import 'package:http/http.dart' as http;

import '../resourses/resourses.dart';
import '../screens/totalLeadList.dart';

class LeadCreateAPI {
  final BuildContext context;

  LeadCreateAPI(this.context);

  // Method to validate the phone number
  bool validatePhoneNumber(String phoneNumber) {
    return phoneNumber.length == 11 && RegExp(r'^\d+$').hasMatch(phoneNumber);
  }

  // Send data to API
  Future<void> sendDataToServer(
    int userId,
    String companyName,
    String phoneNumber,
    int leadPipelineId,
    String name,
    String facebookPage,
    String facebookLike,
    String email,
    String designation,
    String companyWebsite,
    String leadIndustryId,
    String leadSourceId,
    String leadPriority,
    String leadRatingId,
    String leadAreaId,
    String districtId,
    String address,
    int creatorUserId,
    String remarks,
    int isType,
    String contactData,
    String associateUserId,
  ) async {
    CustomProgress customProgress = CustomProgress(context);

    // Validate phone number
    if (!validatePhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 2,
          backgroundColor: R.appColors.buttonColor,
          behavior: SnackBarBehavior.floating, // Makes it floating
          shape: RoundedRectangleBorder(
            // Adds border radius
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(10), // Margin around the SnackBar
          content: const Text(
            'Phone number must be 11 digits.',
            style: TextStyle(color: Colors.white), // Custom text style
          ),
        ),
      );
      return;
    }

    customProgress.showDialog(
        "Please wait", SimpleFontelicoProgressDialogType.spinner);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    // Check if token exists and print it
    if (token == null || token.isEmpty) {
      customProgress.hideDialog();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Token not found. Please log in again.'),
      ));
      return;
    }
    print("Token: $token");

    // API URL
    String url = 'https://crm.ihelpbd.com/api/crm-create-lead';

    // Prepare the JSON body
    Map<String, dynamic> body = {
      "user_id": userId,
      "company_name": companyName,
      "lead_pipeline_id": leadPipelineId,
      "phone_number": phoneNumber,
      "name": name,
      "facebook_page": facebookPage,
      "facebook_like": facebookLike,
      "email": email,
      "designation": designation,
      "company_website": companyWebsite,
      "lead_industry_id": leadIndustryId,
      "lead_source_id": leadSourceId,
      "lead_priority": leadPriority,
      "lead_rating_id": leadRatingId,
      "lead_area_id": leadAreaId,
      "district_id": districtId,
      "address": address,
      "creator_user_id": creatorUserId,
      "remarks": remarks,
      "is_type": isType.toString(),
      "contact_data": contactData,
      "associate_user_id": associateUserId,
    };

    // Check for empty required fields
    // var isEmpty;
    // if (userId == 0 || companyName.isEmpty || leadPipelineId.isEmpty || phoneNumber.isEmpty) {
    //   customProgress.hideDialog();
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Please fill in all required fields.'),
    //   ));
    //   return;
    // }

    print('Sending request with body: ${jsonEncode(body)}');

    // Send the request using application/json
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Corrected to JSON
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body), // Sending JSON-encoded body
    );

    // Debugging: Log request and response details
    print('Request Headers: ${response.request?.headers}');
    print('Request URL: ${response.request?.url}');
    print('Request Body: ${jsonEncode(body)}');
    print('Response Status: ${response.statusCode}');
    Map<String, dynamic> responseMessage = json.decode(response.body);
    String responseStatus = responseMessage['status'].toString();

    // Handle the response
    if (responseStatus == "200") {
      print('Response Body: ${response.body}');
      customProgress.hideDialog();
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Success",
        desc: "Your lead created successfully",
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
          Navigator.pop(context);
        },
        btnOkOnPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeadListScreen(),
              ));
        },
      ).show();
    } else {
      customProgress.hideDialog();
      // show dialog with error message

      print('Failed to create lead: ${response.statusCode}');
      print('Response body: ${response}');

      // Parse the error message from the response
      Map<String, dynamic> errorResponse = json.decode(response.body);
      String errorMessage =
          errorResponse['data']['message'] ?? 'Unknown error occurred';

      // if phone number is already taken,

      String errorPhoneMessage =
          errorResponse['data']['errors'].first ?? 'Unknown error occurred';

      // AlertDialog(
      //   title: const Text('Error'),
      //   content: Text(errorPhoneMessage),
      //   actions: [
      //     TextButton(
      //       child: const Text('OK'),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // );

      // Show a SnackBar with the error message

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 2,
          backgroundColor: R.appColors.red,
          behavior: SnackBarBehavior.floating, // Makes it floating
          shape: RoundedRectangleBorder(
            // Adds border radius
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(10), // Margin around the SnackBar
          content: Text(
            'Failed to create lead: $errorPhoneMessage',
            style: const TextStyle(color: Colors.white), // Custom text style
          ),
        ),
      );
    }
  }
}
