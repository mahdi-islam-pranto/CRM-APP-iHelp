import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeadSourceData {
  final int id;
  final String name;
  final String isActive;
  final String isDelete;

  LeadSourceData({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isDelete,
  });

  factory LeadSourceData.fromJson(Map<String, dynamic> json) {
    return LeadSourceData(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      isDelete: json['is_delete'],
    );
  }
}

Future<List<LeadSourceData>> fetchLeadSourceData() async {
  // Retrieve token from SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("token");

  final response = await http.get(
    Uri.parse(
        'https://crm.ihelpbd.com/api/crm-lead-source'), // Update with the correct API endpoint
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['data'];
    return jsonResponse.map((data) => LeadSourceData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load lead source data');
  }
}
