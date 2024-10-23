import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../resourses/app_colors.dart';
import '../resourses/resourses.dart';

class FollowupType {
  static int? followUpType;
}

class FollowUpTypeDropdown extends StatefulWidget {
  final String? initialValue;
  const FollowUpTypeDropdown({Key? key, this.initialValue}) : super(key: key);

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
        if (widget.initialValue != null) {
          final initialPipeline = _pipelineList.firstWhere(
            (pipeline) => pipeline['name'] == widget.initialValue,
            orElse: () => null,
          );
          if (initialPipeline != null) {
            _onPipelineSelected(initialPipeline);
          }
        }
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
              menuMaxHeight: 500,
              hint: Text(
                "Select Follow Up Type",
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
