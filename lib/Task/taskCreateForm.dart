import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:untitled1/components/Dropdowns/companyNameDropDown.dart';
import 'package:untitled1/resourses/app_colors.dart';
import '../FollowUP/followUpType.dart';
import '../Lead/LeadOwnerDropdown.dart';
import '../NotificationService/sendNotification.dart';
import '../components/CustomProgress.dart';
import '../components/Dropdowns/taskTypeDropdown.dart';
import 'allTaskListScreen.dart';

class TaskCreateForm extends StatefulWidget {
  const TaskCreateForm({Key? key}) : super(key: key);

  @override
  State<TaskCreateForm> createState() => _TaskCreateFormState();
}

class _TaskCreateFormState extends State<TaskCreateForm> {
  final _formKey = GlobalKey<FormState>();

  final _companyName = TextEditingController();

  final _subject = TextEditingController();

  final _description = TextEditingController();

  final _contactNumber = TextEditingController();

  final _currentLocation = TextEditingController();

  TextEditingController startDateTimeController = TextEditingController();

  TextEditingController endDateTimeController = TextEditingController();

  late String dateTimePicker;

  String? currentUserId; // Add this variable

  // Position? position;

  // List<Placemark>? placeMark;

  /// this is automtic location set very good working
  // Future<void> getCurrentLocation() async {
  //   try {
  //     Position newPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //
  //     List<Placemark> placeMark =
  //     await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);
  //
  //     Placemark pMark = placeMark[0];
  //
  //     String completeAddress =
  //         '${pMark.subThoroughfare ?? ''} ${pMark.thoroughfare ?? ''}, '
  //         '${pMark.locality ?? ''}, ${pMark.administrativeArea ?? ''} '
  //         '${pMark.postalCode ?? ''}, ${pMark.country ?? ''}';
  //
  //         _currentLocation.text = completeAddress.trim();
  //   } catch (e) {
  //     print("Error getting location: $e");
  //   }
  // }

  // bool isLoading = false; // Loading state
  //
  // Future<void> _getCurrentLocation() async {
  //   setState(() {
  //     isLoading = true; // Show loading indicator
  //   });
  //
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Check if location service is enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Location services are disabled.")));
  //     return;
  //   }
  //
  //   // Check for permission
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Location permissions are permanently denied.")));
  //           return;
  //     }
  //   }
  //
  //   // Get current position
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //
  //     // Get address from latitude and longitude
  //     List<Placemark> placemarks =
  //     await placemarkFromCoordinates(position.latitude, position.longitude);
  //     if (placemarks.isNotEmpty) {
  //       Placemark pMark = placemarks[0];
  //       String completeAddress =
  //           '${pMark.subThoroughfare ?? ''} ${pMark.thoroughfare ?? ''}, '
  //           '${pMark.locality ?? ''}, ${pMark.administrativeArea ?? ''} '
  //           '${pMark.postalCode ?? ''}, ${pMark.country ?? ''}';
  //
  //       setState(() {
  //          _currentLocation.text = completeAddress; // Set full address
  //          isLoading = false; // Hide loading indicator
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error getting location: $e")));
  //   }
  // }

  /// good work
  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Check if location service is enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return;
  //   }

  //   // Check for permission
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever) {
  //       return;
  //     }
  //   }

  //   // Get current position
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   try {
  //     // Get address from latitude and longitude
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(position.latitude, position.longitude);
  //     if (placemarks.isNotEmpty) {
  //       Placemark pMark = placemarks[0];
  //       String completeAddress =
  //           '${pMark.subThoroughfare ?? ''} ${pMark.thoroughfare ?? ''}, '
  //           '${pMark.locality ?? ''}, ${pMark.administrativeArea ?? ''} '
  //           '${pMark.postalCode ?? ''}, ${pMark.country ?? ''}';

  //       setState(() {
  //         _currentLocation.text = completeAddress; // Set full address
  //       });
  //     }
  //   } catch (e) {
  //     print("Error getting address: $e");
  //   }
  // }

  /// location
  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Check if location service is enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return;
  //   }
  //
  //   // Check for permission
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever) {
  //       return;
  //     }
  //   }
  //
  //   // Get current position
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   setState(() {
  //     _currentLocation.text = "${position.latitude}, ${position.longitude}"; // Set location
  //   });
  // }

  @override
  void initState() {
    // _getCurrentLocation();
    super.initState();

    // set current date to start date
    startDateTimeController.text =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    getCurrentUserId();
  }

  // method to get the current user ID
  Future<void> getCurrentUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = sharedPreferences.getString("id");
      print("Current User ID: $currentUserId");
    });
  }

  bool validatePhoneNumber(String phoneNumber) {
    return RegExp(r'^[0-9]{11}$').hasMatch(phoneNumber);
  }

  // notification inits

  String selectedDeviceToken = "";
  String associateSelectedDeviceToken = "";

  // assign member device token
  void handleDeviceToken(String deviceToken) {
    setState(() {
      selectedDeviceToken = deviceToken;
      print("selected token:$selectedDeviceToken");
    });
  }

  void associateHandelDeviceToken(String assiciateDeviceToken) {
    setState(() {
      associateSelectedDeviceToken = assiciateDeviceToken;
    });
  }

  // API call and send data to server

  Future sendDataToServer() async {
    CustomProgress customProgress = CustomProgress(context);

    customProgress.showDialog(
        "Please wait", SimpleFontelicoProgressDialogType.spinner);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String userId = sharedPreferences.getString("id") ?? "";

    if (token == null || token.isEmpty) {
      customProgress.hideDialog();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Not found. Please log in again.'),
      ));
      return;
    }
    print("Token: $token");

    String url = 'https://crm.ihelpbd.com/api/crm-create-task';

    Map body = {
      "lead_id": CompanyName.companyId.toString(),
      "user_id": Owner.ownerId.toString(),
      "creator_user_id": userId,
      "task_type_id": SelectedPipeline.taskTypeId.toString(),
      "subject": _subject.text,
      "start_time": startDateTimeController.text,
      "end_time": endDateTimeController.text,
      "location": _currentLocation.text,
      "reminder_time": "",
      "description": _description.text,
      "associate_user_id": "",
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
    print("Response Body: ${response.body.toString()}");
    print('Request URL: ${response.request?.url}');
    print('Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      customProgress.hideDialog();

      _subject.clear();
      _description.clear();
      _contactNumber.clear();
      startDateTimeController.clear();

      // send notification

      if (selectedDeviceToken.isNotEmpty) {
        SendNotificationService.sendNotificationUsingApi(
            token: selectedDeviceToken,
            title: "New Task Created ${_companyName.text}",
            body: "You are assigned to a new task! Please check",
            data: {
              'screen': 'task',
            });
        print("selected device token: $selectedDeviceToken");
      } else {
        print("Device token is empty");
      }

      // save notification to Firebase Firestore database
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('notification')
          .doc()
          .set({
        'title': "New Task Created ",
        'body': "You are assigned to a new task! Please check",
        'isRead': false,
        'creted_at': DateTime.now(),
      });

      // send notification

      // if (associateSelectedDeviceToken.isNotEmpty) {
      //   print("selected associate device token: $associateSelectedDeviceToken");
      // } else {
      //   print("Device token is empty");
      // }

      // Reset dropdowns to their initial state
      setState(() {
        FollowupType.followUpType =
            null; // Assuming this is the dropdown variable
        Owner.ownerId = null; // Assuming this is the dropdown
      });

      print('Response Body: ${response.body}');

      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Success",
        desc: "Your task created successfully",
        customHeader: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[600],
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 50,
          ),
        ),
        btnOkColor: Colors.blue[600],
        btnCancelOnPress: () {
          Navigator.pop(context);
        },
        btnOkOnPress: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TaskListScreen()));
        },
      ).show();
    } else {
      customProgress.hideDialog();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Column(
            children: [
              Text("Task Not Created", style: TextStyle(color: Colors.red)),
              Text("Please Check All the Fields",
                  style: TextStyle(color: Colors.blue, fontSize: 13)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
    // save notification to Firebase Firestore database
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: formBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
            ),
            // toolbarHeight: 80,
            title: const Text(
              "Create New Task",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025),
            // Responsive Form Container
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width * 1,
            // height: 784.8.h,
            // width: 400.w,
            child: Form(
              key: _formKey,
              child: RawScrollbar(
                // thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    // get userid from shared preference

                    children: [
                      //company
                      dropDownRow("Company Name", const CompanyNameDropdown()),
                      const SizedBox(height: 10),

                      // task type
                      dropDownRow(
                        "Task Type",
                        Tasktypedropdown(),
                      ),
                      const SizedBox(height: 12),

                      // task title
                      formField("Task Title", _subject, 'Please enter subject'),
                      const SizedBox(height: 10),

                      // assign to
                      dropDownRow(
                          "Assign Member",
                          LeadOwnerDropDown(
                            // put user id from shared preference
                            userId: currentUserId,
                            onDeviceTokenReceived: handleDeviceToken,
                          )),
                      const SizedBox(height: 12),

                      // start date & end date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: startdateField(
                                "Start Date", startDateTimeController),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.025),
                          Flexible(
                            flex: 1,
                            child: enddateField(
                                "Deadline Date", endDateTimeController),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Location Traking

                      // currentLocationformField("Current Location",
                      //     _currentLocation, 'Please enter location'),

                      descritionFormField("Description", _description,
                          'Please enter description'),
                      const SizedBox(height: 30),
                      buttonRow(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  // Widget currentLocationformField(
  //     String label, TextEditingController controller, String errorText,
  //     {String hintText = ''}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(bottom: 8),
  //         child: Text(
  //           label,
  //           style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
  //         ),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(8),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.1),
  //               blurRadius: 3,
  //               offset: const Offset(0, 1),
  //             ),
  //           ],
  //         ),
  //         child: TextFormField(
  //           controller: _currentLocation,
  //           readOnly: true, // Makes field non-editable
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding:
  //                 EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //             fillColor: Color(0xFFF8F6F8),
  //             filled: true, // Apply fill color
  //             suffixIcon: IconButton(
  //               icon: Icon(Icons.my_location, color: Colors.blue),
  //               onPressed: () async {
  //                 print('clicked');
  //                 await _getCurrentLocation(); // Properly handle async function
  //               },
  //               // onPressed: getCurrentLocation,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget formField(
      String label, TextEditingController controller, String errorText,
      {String hintText = ''}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorText;
                }
                return null;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
              ),
            ),
          )
        ],
      ),
    );
  }

// dropdown widget
  // Widget dropDownRow(String label, Widget dropDown) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: Text(label,
  //               style:
  //                   const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  //         ),
  //         // Wrapping the dropdown in Expanded to avoid overflow

  //         Expanded(
  //           flex: 3,
  //           child: dropDown,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget dropDownRow(String label, Widget dropDown) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        dropDown,
      ],
    );
  }

  // start date field

  Widget startdateField(
      String label, TextEditingController dateTimeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        // const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              setState(() {
                dateTimeController.text =
                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              });
            }
            if (pickedDate == null) {
              setState(() {
                dateTimeController.text =
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
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextFormField(
              readOnly: true,
              controller: dateTimeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Start Date is required";
                }
                return null;
              },
              enabled: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
                hintText: 'Select Date',
              ),
            ),
          ),
        ),
      ],
    );
  }

  // End date field

  Widget enddateField(String label, TextEditingController dateTimeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              setState(() {
                var date =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                dateTimeController.text = date;
                print("Date selected: $date");

                // Send notification to assigned member
                // if (selectedDeviceToken.isNotEmpty) {
                //   FCMService.sendNotification(
                //       deviceToken: selectedDeviceToken,
                //       title: "Task Deadline Set",
                //       body:
                //           "A task has been assigned to you with a deadline of $date",
                //       storyId:
                //           "story_${DateTime.now().millisecondsSinceEpoch}");
                //   print(
                //       "Notification sent to device token: $selectedDeviceToken");
                // } else {
                //   print("No device token available for notification");
                // }
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
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextFormField(
              readOnly: true,
              controller: dateTimeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Deadline is required";
                }
                return null;
              },
              enabled: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
                hintText: 'Select Date',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget phoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Contact Number',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
                  offset: const Offset(0, 1), // changes position of shadow
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
                if (!validatePhoneNumber(value)) {
                  return 'Phone number must be 11 digits';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
    );
  }

  Widget descritionFormField(
      String label, TextEditingController controller, String errorText,
      {String hintText = ''}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorText;
                }
                return null;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                fillColor: Color(0xFFF8F6F8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// cancle button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 52),
            maximumSize: Size(MediaQuery.of(context).size.width * 0.45, 52),
            // minimumSize: const Size(164, 52),
            // maximumSize: const Size(181, 52),
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
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),

        //
        ElevatedButton(
          onPressed: () async {
            // AccessFirebase accessTokenFirebase = AccessFirebase();
            // String accessToken = await accessTokenFirebase.getAccessToken();
            // print("Access Token Firebase: $accessToken");
            // if (selectedDeviceToken.isNotEmpty) {
            //   FCMService.sendNotification(
            //       deviceToken: selectedDeviceToken,
            //       title: "Pending task available",
            //       body: "Please solved the task",
            //       storyId: "story_12345");
            //   print("selected device token: $selectedDeviceToken");
            // } else {
            //   print("Device token is empty");
            // }

            if (_formKey.currentState?.validate() == true) {
              // notification
              //  FCMService.sendNotification(
              //        deviceToken: deviceToken,
              //        title: "Pending task available",
              //        body: "Please solved the task",
              //        storyId: "story_12345"
              //  );
              sendDataToServer();
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 52),
            maximumSize: Size(MediaQuery.of(context).size.width * 0.45, 52),
            backgroundColor: buttonColor,

            // backgroundColor: const Color(0xFF007AFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Create Task",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }
}
