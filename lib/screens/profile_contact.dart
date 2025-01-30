import 'package:flutter/material.dart';
import 'package:untitled1/Dashboard/bottom_navigation_page.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Contacts"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18, // Replace with the desired custom icon
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return BottomNavigationPage();
                },

              );            },
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Contacts'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content for the Contacts tab
           Column(children: [

             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                 title: Text("Sk Nayeem Ur Rahman"),
                 subtitle: Text("01733-364274",),
                 leading: CircleAvatar(child: Icon(Icons.manage_accounts)),
                 trailing: Icon(Icons.phone,color: Colors.green,),

               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                 title: Text("Sk Nayeem Ur Rahman"),
                 subtitle: Text("01733-364274",),
                 leading: CircleAvatar(child: Icon(Icons.manage_accounts)),
                 trailing: Icon(Icons.phone,color: Colors.green,),

               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                 title: Text("Sk Nayeem Ur Rahman"),
                 subtitle: Text("01733-364274",),
                 leading: CircleAvatar(child: Icon(Icons.manage_accounts)),
                 trailing: Icon(Icons.phone,color: Colors.green,),

               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                 title: Text("Sk Nayeem Ur Rahman"),
                 subtitle: Text("01733-364274",),
                 leading: CircleAvatar(child: Icon(Icons.manage_accounts)),
                 trailing: Icon(Icons.phone,color: Colors.green,),

               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                 title: Text("Sk Nayeem Ur Rahman"),
                 subtitle: Text("01733-364274",),
                 leading: CircleAvatar(child: Icon(Icons.manage_accounts)),
                 trailing: Icon(Icons.phone,color: Colors.green,),

               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                 title: Text("Sk Nayeem Ur Rahman"),
                 subtitle: Text("01733-364274",),
                 leading: CircleAvatar(child: Icon(Icons.manage_accounts)),
                 trailing: Icon(Icons.phone,color: Colors.green,),

               ),
             ),

           ],),

            Column(children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Outgoing call"),
                  subtitle: Text("Mon,10.25",),
                  leading: CircleAvatar(child: Icon(Icons.outbond)),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Outgoing call"),
                  subtitle: Text("Mon,10.25",),
                  leading: CircleAvatar(child: Icon(Icons.outbond)),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Outgoing call"),
                  subtitle: Text("Mon,10.25",),
                  leading: CircleAvatar(child: Icon(Icons.outbond)),

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Outgoing call"),
                  subtitle: Text("Mon,10.25",),
                  leading: CircleAvatar(child: Icon(Icons.outbond)),

                ),
              ),

            ],),  // Content for the History tab

          ],
        ),
      ),
    );
  }
}
