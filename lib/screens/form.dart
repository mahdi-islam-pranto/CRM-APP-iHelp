import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Dashboard/bottom_navigation_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lead create form"),
        leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18, // Replace with the desired custom icon
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>BottomNavigationPage(),));
        },
      ),
        centerTitle: true,
      ),

      body:  SingleChildScrollView(
        child: Column(children: [
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: Text("Subject:")),
                  height: 40,
                  width: 120,
                  color: Colors.white,
                ),
              ),
              ///form
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: TextFormField(
                    decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        labelText: 'subject',
                        hintText: "dd/mm/yy HH:MM ",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_month_outlined),
                            onPressed: () {
                              // pickDate();
                            })),
                  )),
                  height: 40,
                  width: 210,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: Text("Due date & time :")),
                  height: 40,
                  width: 120,
                  color: Colors.white,
                ),
              ),
              ///form
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: TextFormField(
                    decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        labelText: "Date & time *",
                        hintText: "dd/mm/yy HH:MM ",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_month_outlined),
                            onPressed: () {
                              // pickDate();
                            })),
                  )),
                  height: 40,
                  width: 210,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),

          Row(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: Text("Status :")),
                  height: 40,
                  width: 120,
                  color: Colors.white,
                ),
              ),
              ///form
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: TextFormField(
                    decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        labelText: "status",
                        hintText: "dd/mm/yy HH:MM ",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_month_outlined),
                            onPressed: () {
                              // pickDate();
                            })),
                  )),
                  height: 40,
                  width: 210,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: Text("Priority :")),
                  height: 40,
                  width: 120,
                  color: Colors.white,
                ),
              ),
              ///form
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  child: Center(child: TextFormField(
                    decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        labelText: "Next Follow Up date *",
                        hintText: "dd/mm/yy HH:MM ",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_month_outlined),
                            onPressed: () {
                              // pickDate();
                            })),
                  )),
                  height: 40,
                  width: 210,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.h,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){}, child: Text("Cancle")),
              SizedBox(
                width: 25.h,
              ),
              ElevatedButton(onPressed: (){}, child: Text("Save",style: TextStyle(color: Colors.green),)),
            ],)
        ],),
      ),

    );
  }
}
