import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../resourses/resourses.dart';

// Class to hold the static pipeline ID
class SelectedPipeline {
  static int? pipelineId;
}

class LeadPipelineScreen extends StatefulWidget {
  @override
  _LeadPipelineScreenState createState() => _LeadPipelineScreenState();
}

class _LeadPipelineScreenState extends State<LeadPipelineScreen> {
  List<dynamic> _pipelineList = [];
  String? _selectedPipelineName;
  int? _selectedPipelineId;

  @override
  void initState() {
    super.initState();
    _fetchLeadPipeline();
  }

  // Fetch the lead pipeline data from the API
  Future<void> _fetchLeadPipeline() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    final response = await http.get(
      Uri.parse('https://crm.ihelpbd.com/api/crm-lead-pipeline'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _pipelineList = responseData['data'];
      });
    } else {
      print('Failed to fetch lead pipeline');
    }
  }

  // Handle pipeline selection from the dropdown
  void _onPipelineSelected(dynamic selectedPipeline) {
    setState(() {
      _selectedPipelineName = selectedPipeline['name'];
      _selectedPipelineId = selectedPipeline['id'];
      // Store the selected pipeline ID in the static variable
      SelectedPipeline.pipelineId = _selectedPipelineId;
    });

    // Print the selected pipeline ID stored in the static variable
    print('Selected Pipeline ID (static): ${SelectedPipeline.pipelineId}');
  }

  @override
  Widget build(BuildContext context) {
    return _pipelineList.isNotEmpty
        ? DropdownButtonFormField<dynamic>(
            decoration: const InputDecoration(
              labelText: 'Select Pipeline',
              border: OutlineInputBorder(),
            ),
            items: _pipelineList.map((pipeline) {
              return DropdownMenuItem<dynamic>(
                value: pipeline,
                child: Text(pipeline['name']),
              );
            }).toList(),
            onChanged: _onPipelineSelected,
            value: _selectedPipelineName != null
                ? _pipelineList.firstWhere(
                    (pipeline) => pipeline['name'] == _selectedPipelineName)
                : null,
            hint: const Text('Select Lead Pipeline'),
          )
        : R.appSpinKits.spinKitFadingCube;
  }
}
