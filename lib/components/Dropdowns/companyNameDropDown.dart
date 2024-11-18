import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/resourses/app_colors.dart';
import '../../resourses/resourses.dart';

class CompanyName {
  static int? companyId;
}

class CompanyNameDropdown extends StatefulWidget {
  final String? initialValue;
  final int? leadId;

  const CompanyNameDropdown({
    Key? key,
    this.initialValue,
    this.leadId, // Add this to constructor
  }) : super(key: key);

  @override
  _CompanyNameDropdownState createState() => _CompanyNameDropdownState();
}

class _CompanyNameDropdownState extends State<CompanyNameDropdown> {
  List<dynamic> _totalLeadList = [];
  bool isLoading = true;

  String? _selectedCompanyName;
  int? _selectedCompanyId;

  @override
  void initState() {
    super.initState();
    getCompanyName();
  }

  Future<void> getCompanyName() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString("token");
      String? userId = sharedPreferences.getString("id");

      final response = await http.post(
        Uri.parse("https://crm.ihelpbd.com/api/crm-lead-data-show"),
        headers: {
          'Authorization': 'Bearer $token',
          'user_id': '$userId',
        },
        body: {
          'start_date': '',
          'end_date': '',
          'user_id_search': userId,
          'session_user_id': userId,
          'lead_pipeline_id': '',
          'lead_source_id': '',
          'searchData': '',
          'is_type': '0',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _totalLeadList = responseData['data'];

          // If leadId is provided, find and select the matching company
          if (widget.leadId != null) {
            final companyWithLeadId = _totalLeadList.firstWhere(
              (company) => company['id'] == widget.leadId,
              orElse: () => null,
            );

            if (companyWithLeadId != null) {
              _onCompanySelected(companyWithLeadId);
            }
          }
          // Fallback to initialValue if leadId doesn't match
          else if (widget.initialValue != null) {
            final initialCompany = _totalLeadList.firstWhere(
              (company) => company['company_name'] == widget.initialValue,
              orElse: () => null,
            );
            if (initialCompany != null) {
              _onCompanySelected(initialCompany);
            }
          }
        });
      } else {
        print('Failed to fetch Company data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching company data: $e");
    }
  }

  void _onCompanySelected(dynamic selectedCompany) {
    setState(() {
      _selectedCompanyName = selectedCompany['company_name'];
      _selectedCompanyId = selectedCompany['id'];
      // Store the selected pipeline ID in the static variable
      CompanyName.companyId = _selectedCompanyId;
    });

    // Print the selected pipeline ID stored in the static variable
    print('Selected company name (static): ${CompanyName.companyId}');
  }

  @override
  Widget build(BuildContext context) {
    return _totalLeadList.isNotEmpty
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
              isExpanded: false,
              menuMaxHeight: 500,
              dropdownColor: backgroundColor,
              validator: (value) =>
                  value == null ? 'Company name is required' : null,
              hint: Text(
                "Select company name",
                style: TextStyle(color: Colors.grey[400]),
              ),
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
              items: _totalLeadList.map((company) {
                return DropdownMenuItem<dynamic>(
                  value: company,
                  child: Text(company['company_name']),
                );
              }).toList(),
              onChanged: _onCompanySelected,
              value: _selectedCompanyName != null
                  ? _totalLeadList.firstWhere((company) =>
                      company['company_name'] == _selectedCompanyName)
                  : null,
            ),
          )
        : R.appSpinKits.spinKitFadingCube;
  }
}
