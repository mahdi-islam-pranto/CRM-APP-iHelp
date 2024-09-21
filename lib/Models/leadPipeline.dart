import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LeadPipelineData {
  final int orderNo;
  final double value;

  LeadPipelineData({required this.orderNo, required this.value});
}

Future<Map<String, dynamic>> fetchLeadPipelineData() async {
  // Retrieve token from SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("token");
  String? userId = sharedPreferences.getString("id");

  // Make the POST request with form data
  final response = await http.post(
    Uri.parse('https://crm.ihelpbd.com/api/crm-lead-pipeline-dashboard'),
    headers: {
      'Authorization': 'Bearer $token', // Use your actual token
    },
    body: {
      'user_id': '$userId',
    },
  );

  print(response);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load lead pipeline data');
  }
}
