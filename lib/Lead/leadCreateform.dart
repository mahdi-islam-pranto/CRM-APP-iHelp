import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 112.62,
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 784.8.h,
          width: 400.w,
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
                              hintText: '+8801610-681903',
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

                  // Contact Number *
                  // Row(
                  //   children: [
                  //     const Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: EdgeInsets.only(right: 8.0),
                  //         child: Text('Contact Number*',
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //             )),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 2,
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(8),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey.withOpacity(0.5),
                  //               spreadRadius: 1,
                  //               blurRadius: 0,
                  //               offset: const Offset(0, 0),
                  //             ),
                  //           ],
                  //         ),
                  //         child: TextFormField(
                  //           controller: _contactNumber,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return 'Please enter phone number';
                  //             }
                  //             return null;
                  //           },
                  //           decoration: InputDecoration(
                  //             contentPadding: const EdgeInsets.symmetric(
                  //                 vertical: 10, horizontal: 15),
                  //             hintText: '017...',
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //               borderSide: BorderSide.none,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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

                  /// show all fields
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(8),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.5),
                  //         spreadRadius: 1,
                  //         blurRadius: 0,
                  //         offset: const Offset(0, 0),
                  //       ),
                  //     ],
                  //   ),
                  //   child: ExpansionTile(
                  //     title: Text(
                  //       'Show all fields',
                  //       style: TextStyle(color: R.appColors.grey),
                  //     ),
                  //     children: [
                  //       Column(
                  //         children: [
                  //           SizedBox(height: 2,),
                  //           // website
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('website',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _website,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter website';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           //Facebook Page
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Facebook Page',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _facebookPage,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter a facebook page';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           //Facebook Page Like
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Facebook Page Like',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _facebookPageLike,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter a facebook page like';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //          // Contact Name
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Contact Name',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _contactName,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter a contact name';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           //Primary Email
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Primary Email',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _primaryEmail,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter a primary email';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           //Designation
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Designation',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _designation,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter your designation';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //           // Industry Type
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Industry*',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadIndustryDropDown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           //Associate
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Associate*',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadAssociateDropDown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //           //Lead Source
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Lead Source*',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadSourceDropDown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           // Lead Pipeline
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Lead Pipeline *',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadPipelineDropdown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //           //Lead Priority
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Lead Priority *',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadPriorityDropdown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //           //Lead Rating
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Lead Rating *',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadRatingDropdown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //           // Lead Area
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Lead Area *',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadAreaDropdown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //           //District
                  //
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('District *',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: LeadDistrictDropdown(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           //Address
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Address',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _address,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter your address';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //
                  //           //Remarks
                  //           Row(
                  //             children: [
                  //               const Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: EdgeInsets.only(right: 8.0),
                  //                   child: Text('Remarks',
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       )),
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: Colors.grey.withOpacity(0.5),
                  //                         spreadRadius: 1,
                  //                         blurRadius: 0,
                  //                         offset: const Offset(0, 0),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   child: TextFormField(
                  //                     controller: _remarks,
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return 'Please enter remark';
                  //                       }
                  //                       return null;
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       contentPadding: const EdgeInsets.symmetric(
                  //                           vertical: 10, horizontal: 15),
                  //                       hintText: '',
                  //                       border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.circular(8),
                  //                         borderSide: BorderSide.none,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

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
                            minimumSize: const Size(164, 52),
                            maximumSize: const Size(181, 52),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
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
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          )),
                      const SizedBox(
                        width: 11,
                      ),
                      // save
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(164, 52),
                          maximumSize: const Size(181, 52),
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Save",
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
