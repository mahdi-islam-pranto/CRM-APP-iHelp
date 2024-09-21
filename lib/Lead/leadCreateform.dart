import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LeadCreateAPI.dart';
import 'LeadPipeLineAPI.dart';
import '../resourses/resourses.dart';

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
        appBar: AppBar(
          title: Text("Lead Create Form"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
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
                            hintText: 'Please enter company name',
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
                  height: 10,
                ),
                // Contact Number *
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Contact Number*',
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
                        child: TextFormField(
                          controller: _contactNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            hintText: '017...',
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
                  height: 15,
                ),

                //lead pipeline*
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('Lead Pipeline*',
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
                        child: LeadPipelineScreen(),
                      ),
                    ),
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

                        if (_formKey.currentState!.validate()) {
                          LeadCreateAPI leadCreateAPI = LeadCreateAPI(context);
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
    );
  }
}
