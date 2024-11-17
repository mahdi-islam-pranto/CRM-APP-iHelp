import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../resourses/app_colors.dart';
import 'LeadCreateAPI.dart';
import 'LeadPipeLineAPI.dart';

class LeadCreateForm extends StatefulWidget {
  const LeadCreateForm({Key? key}) : super(key: key);

  @override
  State<LeadCreateForm> createState() => _LeadCreateFormState();
}

class _LeadCreateFormState extends State<LeadCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyName = TextEditingController();
  final _contactNumber = TextEditingController();
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
        backgroundColor: formBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          // toolbarHeight: 112.62,
          title: const Text(
            "CREATE  LEAD",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          // Responsive Container Padding
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.025),

// Responsive Form Container
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width * 1,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // company name

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Company Name",
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
                          controller: _companyName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter company name";
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

                  const SizedBox(
                    height: 15,
                  ),

                  // Contact Number

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Contact Number',
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
                            controller: _contactNumber,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              hintText: 'Ex: 01610 681903',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // Lead PipeLine

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Lead Pipeline",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                      LeadPipelineScreen(),
                    ],
                  ),

                  /// cancle and save button
                  const SizedBox(
                    height: 40,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // cancle
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.4, 52),
                            maximumSize: Size(
                                MediaQuery.of(context).size.width * 0.45, 52),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.065),
                      // save
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width * 0.4, 52),
                          maximumSize: Size(
                              MediaQuery.of(context).size.width * 0.45, 52),
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Create Lead",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          String userId =
                              sharedPreferences.getString("id") ?? "";
                          print("userId  : ${userId}");

                          if (_formKey.currentState!.validate()) {
                            LeadCreateAPI leadCreateAPI =
                                LeadCreateAPI(context);
                            leadCreateAPI.sendDataToServer(
                              int.parse(userId),
                              _companyName.text,
                              _contactNumber.text,
                              SelectedPipeline.pipelineId as int,
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              "",
                              int.parse(userId),
                              "",
                              0,
                              "",
                              "",
                            );
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
