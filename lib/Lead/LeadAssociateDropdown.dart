//good working associate  dropdown menu
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:untitled1/resourses/app_colors.dart';
//
// import '../resourses/resourses.dart';
//
// class Associate {
//   static int? associateId;
// }
//
// class LeadAssociateDropDown extends StatefulWidget {
//   final Function(String) onDeviceTokenReceived;
//   final String? initialValue;
//
//   const LeadAssociateDropDown({
//     Key? key,
//     required this.onDeviceTokenReceived,
//     this.initialValue,
//   }) : super(key: key);
//
//   @override
//   State<LeadAssociateDropDown> createState() => _LeadAssociateDropDownState();
// }
//
// class _LeadAssociateDropDownState extends State<LeadAssociateDropDown> {
//   // instance of associate
//   // Associate associate = Associate();
//
//   List<dynamic> _pipelineList = [];
//   String? _selectedPipelineName;
//   int? _selectedPipelineId;
//   String? _selectedDeviceId;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLeadAssociateData();
//   }
//
//   Future<void> fetchLeadAssociateData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? token = sharedPreferences.getString("token");
//
//     final response = await http.get(
//       Uri.parse('https://crm.ihelpbd.com/api/crm-user'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       setState(() {
//         _pipelineList = responseData['data'];
//         // Associate.associateId = responseData['data'][0]['id'];
//
//         if (widget.initialValue != null) {
//           final initialOwner = _pipelineList.firstWhere(
//             (owner) => owner['name'] == widget.initialValue,
//             orElse: () => null,
//           );
//           if (initialOwner != null) {
//             _onPipelineSelected(initialOwner);
//           }
//         }
//       });
//     } else {
//       print('Failed to fetch Owner');
//     }
//   }
//
//   void _onPipelineSelected(dynamic selectedPipeline) {
//     setState(() {
//       _selectedPipelineName = selectedPipeline['name'];
//       _selectedPipelineId = selectedPipeline['id'];
//       _selectedDeviceId = selectedPipeline['device_id']; // Extract device_id
//
//       Associate.associateId = _selectedPipelineId;
//       print("Selected name: $_selectedPipelineName");
//       print("Selected device_id: $_selectedDeviceId");
//
//       widget.onDeviceTokenReceived(_selectedDeviceId ?? '');
//     });
//
//     print('Selected associate ID (static): ${Associate.associateId}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _pipelineList.isNotEmpty
//         ? Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 0,
//                   blurRadius: 3,
//                   offset: const Offset(0, 1), // changes position of shadow
//                 ),
//               ],
//             ),
//             child: DropdownButtonFormField<dynamic>(
//               dropdownColor: backgroundColor,
//               menuMaxHeight: 5000,
//               isExpanded: true,
//               hint: Text(
//                 "Select Member",
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//               // dropdownColor: Color(0xFFF8F6F8),
//               icon: const Icon(Icons.keyboard_arrow_down_sharp,
//                   size: 30, color: Colors.blue),
//               borderRadius: BorderRadius.circular(8),
//               decoration: const InputDecoration(
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFFF8F6F8)),
//                 ),
//                 contentPadding:
//                     EdgeInsets.symmetric(vertical: 16, horizontal: 10),
//                 fillColor: Color(0xFFF8F6F8),
//               ),
//               items: _pipelineList.map((pipeline) {
//                 return DropdownMenuItem<dynamic>(
//                   value: pipeline,
//                   child: Text('${pipeline['name']}'),
//                   //child: Text('${pipeline['name']} (Device ID: ${pipeline['device_id']})'),
//                 );
//               }).toList(),
//               onChanged: _onPipelineSelected,
//               value: _selectedPipelineName != null
//                   ? _pipelineList.firstWhere(
//                       (pipeline) => pipeline['name'] == _selectedPipelineName)
//                   : null,
//             ),
//           )
//         : R.appSpinKits.spinKitFadingCube;
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../resourses/resourses.dart';

class Associate {
  static List<int> selectedAssociateIds = [];

}

class MultiLeadAssociateDropDown extends StatefulWidget {
  final Function(List<String>) onDeviceTokensReceived;
  final List<String>? initialValues;

  const MultiLeadAssociateDropDown({
    Key? key,
    required this.onDeviceTokensReceived,
    this.initialValues,
  }) : super(key: key);

  @override
  State<MultiLeadAssociateDropDown> createState() => _MultiLeadAssociateDropDownState();
}

class _MultiLeadAssociateDropDownState extends State<MultiLeadAssociateDropDown> {
  List<dynamic> _pipelineList = [];
  List<dynamic> _selectedPipelines = [];
  List<String> _selectedDeviceIds = [];

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

        if (widget.initialValues != null) {
          for (String initialValue in widget.initialValues!) {
            final initialOwner = _pipelineList.firstWhere(
                  (owner) => owner['name'] == initialValue,
              orElse: () => null,
            );
            if (initialOwner != null) {
              _selectedPipelines.add(initialOwner);
              _selectedDeviceIds.add(initialOwner['device_id'] ?? '');
            }
          }
          _updateAssociateIds();
        }
      });
    } else {
      print('Failed to fetch Owner');
    }
  }

  void _updateAssociateIds() {
    Associate.selectedAssociateIds = _selectedPipelines.map<int>((pipeline) => pipeline['id'] as int).toList();
    widget.onDeviceTokensReceived(_selectedDeviceIds);

    print('Selected associate IDs: ${Associate.selectedAssociateIds}');
    print('Selected device IDs: $_selectedDeviceIds');
  }

  @override
  Widget build(BuildContext context) {
    return _pipelineList.isNotEmpty
        ? Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0,1),
          ),
        ],
      ),
      child: MultiSelectDropdown(
        items: _pipelineList,
        selectedItems: _selectedPipelines,
        onSelectionChanged: (selectedItems) {
          setState(() {
            _selectedPipelines = selectedItems;
            _selectedDeviceIds = selectedItems
                .map<String>((item) => item['device_id'] ?? '')
                .toList();
            _updateAssociateIds();
          });
        },
      ),
    )
        : R.appSpinKits.spinKitFadingCube;
  }
}

class MultiSelectDropdown extends StatelessWidget {
  final List<dynamic> items;
  final List<dynamic> selectedItems;
  final Function(List<dynamic>) onSelectionChanged;

  const MultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final List<dynamic>? results = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return MultiSelectDialog(
              items: items,
              initialSelectedItems: selectedItems,
            );
          },
        );

        if (results != null) {
          onSelectionChanged(results);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: const BoxDecoration(
          color: Color(0xFFF8F6F8),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedItems.isEmpty
                    ? "Select Associate"
                    : selectedItems.map((item) => item['name']).join(", "),
                style: TextStyle(
                  color: selectedItems.isEmpty ? Colors.grey[400] : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_sharp,
                size: 30, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<dynamic> items;
  final List<dynamic> initialSelectedItems;

  const MultiSelectDialog({
    Key? key,
    required this.items,
    required this.initialSelectedItems,
  }) : super(key: key);

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<dynamic> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text("Select Associate",style: TextStyle(fontSize: 18,color: Colors.blue),)),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item['name']),
            onChanged: (bool? checked) {
              setState(() {
                if (checked!) {
                  _selectedItems.add(item);
                } else {
                  _selectedItems.removeWhere((element) =>
                  element['id'] == item['id']);
                }
              });
            },
          )).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context, _selectedItems),
        ),
      ],
    );
  }
}