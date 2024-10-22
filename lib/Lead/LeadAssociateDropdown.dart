import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/resourses/app_colors.dart';

import '../resourses/resourses.dart';

class Associate {
  static int? associateId;
}

class LeadAssociateDropDown extends StatefulWidget {
  final Function(String) onDeviceTokenReceived;
  final String? initialValue;

  const LeadAssociateDropDown({
    Key? key,
    required this.onDeviceTokenReceived,
    this.initialValue,
  }) : super(key: key);

  @override
  State<LeadAssociateDropDown> createState() => _LeadAssociateDropDownState();
}

class _LeadAssociateDropDownState extends State<LeadAssociateDropDown> {
  // instance of associate
  // Associate associate = Associate();

  List<dynamic> _pipelineList = [];
  String? _selectedPipelineName;
  int? _selectedPipelineId;
  String? _selectedDeviceId;

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
        // Associate.associateId = responseData['data'][0]['id'];

        if (widget.initialValue != null) {
          final initialOwner = _pipelineList.firstWhere(
            (owner) => owner['name'] == widget.initialValue,
            orElse: () => null,
          );
          if (initialOwner != null) {
            _onPipelineSelected(initialOwner);
          }
        }
      });
    } else {
      print('Failed to fetch Owner');
    }
  }

  void _onPipelineSelected(dynamic selectedPipeline) {
    setState(() {
      _selectedPipelineName = selectedPipeline['name'];
      _selectedPipelineId = selectedPipeline['id'];
      _selectedDeviceId = selectedPipeline['device_id']; // Extract device_id

      Associate.associateId = _selectedPipelineId;

      print("Selected name: $_selectedPipelineName");
      print("Selected device_id: $_selectedDeviceId");

      widget.onDeviceTokenReceived(_selectedDeviceId ?? '');
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
              menuMaxHeight: 5000,
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
                  child: Text('${pipeline['name']}'),
                  //child: Text('${pipeline['name']} (Device ID: ${pipeline['device_id']})'),
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
