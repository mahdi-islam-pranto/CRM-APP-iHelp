import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../resourses/resourses.dart';
import '../static_variable/static_variable.dart';

class Associate {
  static int? associateId;
}

class LeadAssociateDropDown extends StatefulWidget {
  @override
  _LeadSourceDropDownState createState() => _LeadSourceDropDownState();
}

class _LeadSourceDropDownState extends State<LeadAssociateDropDown> {
  List<dynamic> _pipelineList = [];
  String? _selectedPipelineName;
  int? _selectedPipelineId;

  @override
  void initState() {
    super.initState();
    fetchLeadAssociateData();
  }

  // Fetch the lead associate data from the API
  Future<void> fetchLeadAssociateData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    final response = await http.get(
      Uri.parse('https://crm.ihelpbd.com/api/crm-user'),
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
      print('Failed to fetch Owner');
    }
  }

  void _onPipelineSelected(dynamic selectedPipeline) {
    setState(() {
      _selectedPipelineName = selectedPipeline['name'];
      _selectedPipelineId = selectedPipeline['id'];
      // Store the selected pipeline ID in the static variable
      Associate.associateId = _selectedPipelineId;
    });

    // Print the selected pipeline ID stored in the static variable
    print('Selected associate ID (static): ${Associate.associateId}');
  }

  @override
  Widget build(BuildContext context) {
    return _pipelineList.isNotEmpty
        ? DropdownButtonFormField<dynamic>(
            decoration: InputDecoration(
              labelText: 'Select Associate',
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
            hint: Text('Select Associate'),
          )
        : R.appSpinKits.spinKitFadingCube;
  }
}
