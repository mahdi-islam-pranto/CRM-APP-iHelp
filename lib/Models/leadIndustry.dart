import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadIndustryData {
  final int id;
  final String name;
  final String isActive;

  LeadIndustryData({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory LeadIndustryData.fromJson(Map<String, dynamic> json) {
    return LeadIndustryData(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
    );
  }
}

Future<List<LeadIndustryData>> fetchLeadIndustryData() async {
  // Retrieve token from SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("token");

  final response = await http.get(
    Uri.parse('https://crm.ihelpbd.com/api/crm-lead-industry'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['data'];
    return jsonResponse.map((data) => LeadIndustryData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load lead industry data');
  }
}
