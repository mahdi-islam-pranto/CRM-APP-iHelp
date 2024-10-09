import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeadIndustryData {
  final String category;
  final int count;

  LeadIndustryData({
    required this.category,
    required this.count,
  });

  factory LeadIndustryData.fromJson(Map<String, dynamic> json) {
    return LeadIndustryData(
      category: json['categories'],
      count: json['data'],
    );
  }
}

Future<List<LeadIndustryData>> fetchLeadIndustryData() async {
  // Retrieve token from SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("token");

  final response = await http.post(
    Uri.parse('https://crm.ihelpbd.com/api/crm-lead-industry-dashboard'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: {
      'user_id': '3',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<String> categories = List<String>.from(jsonResponse['categories']);
    List<int> data = List<int>.from(jsonResponse['data']);

    List<LeadIndustryData> leadIndustryData = [];
    for (int i = 0; i < categories.length; i++) {
      leadIndustryData
          .add(LeadIndustryData(category: categories[i], count: data[i]));
    }
    return leadIndustryData;
  } else {
    throw Exception('Failed to load lead industry data');
  }
}
