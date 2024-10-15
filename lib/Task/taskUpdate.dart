import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import 'package:untitled1/components/Dropdowns/taskTypeDropdown.dart';
import 'package:untitled1/Lead/LeadOwnerDropdown.dart';

import 'package:untitled1/resourses/app_colors.dart';

import '../Models/taskListModel.dart';
import '../components/CustomProgress.dart';

class TaskUpdateForm extends StatefulWidget {
  final int taskId;
  final Data taskDetails;
  final int leadId;

  const TaskUpdateForm(
      {Key? key,
      required this.taskId,
      required this.taskDetails,
      required this.leadId})
      : super(key: key);

  @override
  _TaskUpdateFormState createState() => _TaskUpdateFormState();
}

class _TaskUpdateFormState extends State<TaskUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _subjectController =
        TextEditingController(text: widget.taskDetails.subject);
    _descriptionController =
        TextEditingController(text: widget.taskDetails.description);
    _startDateTimeController =
        TextEditingController(text: widget.taskDetails.startTime);
    _endDateTimeController =
        TextEditingController(text: widget.taskDetails.endTime);

    // Set initial values for dropdowns

    // CompanyName.CompanyName.companyId = widget.taskDetails.companyName?.id;
    SelectedPipeline.taskTypeId = widget.taskDetails.taskName?.id;
    Owner.ownerId = widget.taskDetails.assignName?.id;

    // Convert the status name to the corresponding value
    _selectedStatus = _getStatusValue(widget.taskDetails.taskStatus?.name);
  }

  String? _getStatusValue(String? statusName) {
    switch (statusName) {
      case "Solved":
        return "1";
      case "Pending":
        return "2";
      case "Working in Progress":
        return "3";
      case "Canceled":
        return "4";
      default:
        return null;
    }
  }

  String _getStatusName(String value) {
    switch (value) {
      case "1":
        return "Solved";
      case "2":
        return "Pending";
      case "3":
        return "Working in Progress";
      case "4":
        return "Canceled";
      default:
        return "Unknown";
    }
  }

  List<DropdownMenuItem<String>> get statusDropdownItems {
    return [
      const DropdownMenuItem(value: "1", child: Text("Solved")),
      const DropdownMenuItem(value: "2", child: Text("Pending")),
      const DropdownMenuItem(value: "3", child: Text("Working in Progress")),
      const DropdownMenuItem(value: "4", child: Text("Canceled")),
    ];
  }

  Future<void> updateTask() async {
    CustomProgress customProgress = CustomProgress(context);

    customProgress.showDialog(
        "Please wait", SimpleFontelicoProgressDialogType.spinner);

    // API code
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String userId = sharedPreferences.getString("id") ?? "";

    String url = 'https://crm.ihelpbd.com/api/crm-update-task';

    Map<String, dynamic> body = {
      "id": widget.taskId.toString(),
      "user_id": userId,
      "lead_id": widget.leadId.toString(),
      "creator_user_id": userId,
      "task_type_id": SelectedPipeline.taskTypeId.toString(),
      "start_time": _startDateTimeController.text,
      "end_time": _endDateTimeController.text,
      "subject": _subjectController.text,
      "description": _descriptionController.text,
      "status": _selectedStatus,
      "associate_user_id": "",
      "reminder_time": "",
    };

    print('Sending request with body: ${jsonEncode(body)}');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print('Request Headers: ${response.request?.headers}');
    print('Request URL: ${response.request?.url}');
    print('Response Status: ${response.statusCode}');

    print(widget.leadId.toString());

    if (response.statusCode == 200) {
      // hide progress dialog
      customProgress.hideDialog();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.blue,
            animation: AlwaysStoppedAnimation(BorderSide.strokeAlignCenter),
            content: Text('Task updated successfully')),
      );
      Navigator.pop(context, true); // Return true to indicate successful update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              // 'Failed to update task. Error: ${response.body}'
              "Failed to update task. Check all fields"),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Update Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // company name

                const SizedBox(height: 8),

                // task status field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Task Status",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: backgroundColor,
                        value: _selectedStatus,
                        items: statusDropdownItems,
                        hint: Text(
                          "task's current status",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_sharp,
                            size: 30, color: Colors.blue),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        },
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF8F6F8)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
                          fillColor: Color(0xFFF8F6F8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // task type dropdown

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Task Type",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Tasktypedropdown(
                        initialValue: widget.taskDetails.taskName?.name),
                  ],
                ),

                const SizedBox(height: 16),
                // task title
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Task Title",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _subjectController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a Title";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          fillColor: Color(0xFFF8F6F8),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 16),

                // task Assign
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Assign To",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    LeadOwnerDropDown(
                      onDeviceTokenReceived: (String token) {},
                      initialValue: widget.taskDetails.assignName?.name,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // start date

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text("Start Date",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    // const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(
                              widget.taskDetails.startTime ??
                                  DateTime.now().toString()),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _startDateTimeController.text =
                                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          });
                        }
                        if (pickedDate == null) {
                          setState(() {
                            _startDateTimeController.text =
                                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"; // set current date
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: TextFormField(
                          readOnly: true,
                          controller: _startDateTimeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Start Date is required";
                            }
                            return null;
                          },
                          enabled: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            fillColor: Color(0xFFF8F6F8),
                            hintText: 'Select Date',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // end date field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text("End Date",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    // const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(
                              widget.taskDetails.endTime ??
                                  DateTime.now().toString()),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _endDateTimeController.text =
                                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          });
                        }
                        if (pickedDate == null) {
                          setState(() {
                            _endDateTimeController.text =
                                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"; // set current date
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: TextFormField(
                          readOnly: true,
                          controller: _endDateTimeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Start Date is required";
                            }
                            return null;
                          },
                          enabled: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            fillColor: Color(0xFFF8F6F8),
                            hintText: 'Select Date',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // task description
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Put a Description about this task";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          fillColor: Color(0xFFF8F6F8),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// cancle button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(164, 52),
                        maximumSize: const Size(181, 52),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // update button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateTask();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(164, 52),
                        maximumSize: const Size(181, 52),
                        backgroundColor: buttonColor,

                        // backgroundColor: const Color(0xFF007AFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Update Task",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
