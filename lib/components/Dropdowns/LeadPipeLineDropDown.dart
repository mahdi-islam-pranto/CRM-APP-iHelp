import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeadPipelineDropdown extends StatefulWidget {
  final Function(String)
      onSelected; // Callback function to pass selected pipeline ID

  const LeadPipelineDropdown({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<LeadPipelineDropdown> createState() => _LeadPipelineDropdownState();
}

class _LeadPipelineDropdownState extends State<LeadPipelineDropdown> {
  bool isLoading = true;
  List<LeadData> leadPipelines = [];
  String? selectedPipelineName;
  String selectedPipelineId = "";

  @override
  void initState() {
    super.initState();
    fetchLeadPipelineData();
  }

  Future<void> fetchLeadPipelineData() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("token");

      final response = await http.get(
        Uri.parse('https://crm.ihelpbd.com/api/crm-lead-pipeline'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['data'];
        setState(() {
          leadPipelines = jsonResponse.map<LeadData>((data) {
            return LeadData.fromJson(data);
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load lead pipeline data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching lead pipeline data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              border: OutlineInputBorder(),
              labelText: "Lead pipeline",
            ),
            value: selectedPipelineName,
            onChanged: (String? newValue) {
              setState(() {
                selectedPipelineName = newValue!;
                selectedPipelineId = leadPipelines
                    .firstWhere((pipeline) => pipeline.name == newValue)
                    .id
                    .toString();
              });
              widget.onSelected(
                  selectedPipelineId); // Pass selected ID back to parent
            },
            items: leadPipelines.map<DropdownMenuItem<String>>((LeadData data) {
              return DropdownMenuItem<String>(
                value: data.name,
                child: Text(data.name),
              );
            }).toList(),
          );
  }
}

class LeadData {
  final int id;
  final String name;

  LeadData({required this.id, required this.name});

  factory LeadData.fromJson(Map<String, dynamic> json) {
    return LeadData(
      id: json['id'],
      name: json['name'],
    );
  }
}
