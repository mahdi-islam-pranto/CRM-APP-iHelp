import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../resourses/resourses.dart';

class FollowupType {
  static int? followUpType;
}

class FollowUpTypeDropdown extends StatefulWidget {
  const FollowUpTypeDropdown({Key? key}) : super(key: key);

  @override
  State<FollowUpTypeDropdown> createState() => _FollowUpTypeDropdownState();
}

class _FollowUpTypeDropdownState extends State<FollowUpTypeDropdown> {
  List<dynamic> _pipelineList = [];
  String? _selectedPipelineName;
  int? _selectedPipelineId;

  @override
  void initState() {
    super.initState();
    _followUpType();
  }

  // Fetch the followuptype data from the API
  Future<void> _followUpType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    final response = await http.get(
      Uri.parse('https://crm.ihelpbd.com/api/crm-lead-followup-type'),
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

  // Handle followuptype selection from the dropdown
  void _onPipelineSelected(dynamic selectedPipeline) {
    setState(() {
      _selectedPipelineName = selectedPipeline['name'];
      _selectedPipelineId = selectedPipeline['id'];
      // Store the selected pipeline ID in the static variable
      FollowupType.followUpType = _selectedPipelineId;
    });

    // Print the selected pipeline ID stored in the static variable
    print('Selected follow type ID (static): ${FollowupType.followUpType}');
  }

  @override
  Widget build(BuildContext context) {
    return _pipelineList.isNotEmpty
        ? DropdownButtonFormField<dynamic>(
            decoration: const InputDecoration(
              labelText: 'Select Type',
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
            hint: const Text('Select Follow Up Type'),
          )
        : R.appSpinKits.spinKitFadingCube;
  }
}
