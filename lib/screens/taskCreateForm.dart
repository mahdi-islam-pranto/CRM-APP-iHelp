import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Lead/LeadPipeLineAPI.dart';
import '../components/Dropdowns/taskTypeDropdown.dart';
import '../resourses/resourses.dart';

class TaskCreateForm extends StatefulWidget {
  const TaskCreateForm({Key? key}) : super(key: key);

  @override
  State<TaskCreateForm> createState() => _LeadCreateFormState();
}

class _LeadCreateFormState extends State<TaskCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _description = TextEditingController();
  var startTimeController = TextEditingController();
  //  final _website = TextEditingController();
  // final _facebookPage = TextEditingController();
  // final _facebookPageLike = TextEditingController();
  // final _contactName = TextEditingController();
  // final _primaryEmail = TextEditingController();
  // final _designation = TextEditingController();
  // final _address = TextEditingController();
  // final _remarks = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Task"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // company name *
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Company Name*',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: R.appColors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _companyName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter company name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            hintText: 'Enter company',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Task Type Dropdown

                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Task Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Tasktypedropdown(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                //Select Date time

                // Start date and time

                Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text("Start Date",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              startTimeController.text =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: R.appColors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: TextFormField(
                            controller: startTimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  setState(() {
                                    startTimeController.text =
                                        "${DateTime.now().day}";
                                  });
                                });
                              }
                              return null;
                            },
                            enabled: false,
                            decoration: const InputDecoration(
                              hintText: "Pick a date",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// cancle and save button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // cancle
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedButton(
                          width: 100,
                          text: "Cancle",
                          color: R.appColors.grey,
                          pressEvent: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.topSlide,
                              showCloseIcon: true,
                              title: "Warning",
                              desc: "Please take a good look",
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();
                          }),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // save
                    AnimatedButton(
                      width: 100,
                      text: "Save",
                      color: R.appColors.buttonColor,
                      pressEvent: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        String userId = sharedPreferences.getString("id") ?? "";
                        print("userId  : ${userId}");

                        print("start date    $startTimeController");

                        if (_formKey.currentState!.validate()) {}
                      },
                    )
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
