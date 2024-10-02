import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../resourses/app_colors.dart';
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
      Associate.associateId = _selectedPipelineId;
    });

    print('Selected associate ID (static): ${Associate.associateId}');
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
              menuMaxHeight: 400,
              isExpanded: true,
              hint: Text(
                "Select Member",
                style: TextStyle(color: Colors.grey[400]),
              ),
              // dropdownColor: Color(0xFFF8F6F8),
              icon: const Icon(Icons.keyboard_arrow_down_sharp,
                  size: 30, color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
              decoration: const InputDecoration(
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
