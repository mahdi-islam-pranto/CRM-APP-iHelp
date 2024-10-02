// full simillar to lead pipeline dropdown

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../resourses/app_colors.dart';
import '../../resourses/resourses.dart';

// Class to hold the static pipeline ID
class SelectedPipeline {
  static int? taskTypeId;
}

class Tasktypedropdown extends StatefulWidget {
  @override
  _TasktypedropdownState createState() => _TasktypedropdownState();
}

class _TasktypedropdownState extends State<Tasktypedropdown> {
  List<dynamic> _pipelineList = [];
  String? _selectedPipelineName;
  int? _selectedtaskTypeId;

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
      Uri.parse('https://crm.ihelpbd.com/api/crm-lead-task-type'),
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
      _selectedtaskTypeId = selectedPipeline['id'];
      // Store the selected pipeline ID in the static variable
      SelectedPipeline.taskTypeId = _selectedtaskTypeId;
    });

    // Print the selected pipeline ID stored in the static variable
    print('Selected taskTypeId ID (static): ${SelectedPipeline.taskTypeId}');
  }

  @override
  Widget build(BuildContext context) {
    return _pipelineList.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: DropdownButtonFormField<dynamic>(
              dropdownColor: backgroundColor,
              validator: (value) =>
                  value == null ? 'task type is required' : null,
              hint: Text(
                "Select task type",
                style: TextStyle(color: Colors.grey[400]),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_sharp,
                  size: 30, color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
              decoration: const InputDecoration(
                // hintText: 'Select Follow Up Type',
                // labelText: 'Select Follow Up Type',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF8F6F8)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
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
            ),
          )
        : R.appSpinKits.spinKitFadingCube;
  }
}
