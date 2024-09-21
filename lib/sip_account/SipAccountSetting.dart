import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:isalescrm/sip_account/SIPCredential.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../constants/Constants.dart';
import 'SipAccountStatus.dart';

/*
  Activity name : SipAccountSetting
  Project name : iSalesCRM Mobile App
  Developer : Eng. M A Mazedul Islam
  Designation : Senior Mobile App Developer at iHelpBD Dhaka, Bangladesh.
  Email : mazedulislam4970@gmail.com
  Description : Added SIP Account
*/

class SipAccountSetting extends StatefulWidget {
  const SipAccountSetting({Key? key}) : super(key: key);

  @override
  State<SipAccountSetting> createState() => _SipAccountSettingState();
}

class _SipAccountSettingState extends State<SipAccountSetting> {
  TextEditingController prefixController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getDialerPrefix();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SIP Account Setting"),
        centerTitle: true,

        // New Changed background color

        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //         colors: [Colors.teal,Colors.blue,Colors.blue,Colors.teal]),
        //   ),
        // ),

        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        automaticallyImplyLeading: true,

        actions: [
          // IconButton(
          //   icon: const Icon(Icons.add,size: 30,color: Colors.white,),
          //   // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const SIPCredential())),
          // ),
          const SizedBox(width: 10)
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
          children: [extensionAndStatus(), dialerPrefix()],
        ),
      ),
    );
  }

  Widget extensionAndStatus() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        //New Changed  Card er border
        shape: RoundedRectangleBorder(
          //<-- 1. SEE HERE
          side: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(13.0),
        ),
        elevation: 0,
        shadowColor: Colors.white,

        child: ListTile(
          title: Text(SipAccountStatus.extension),
          // trailing: SipAccountStatus.sipAccountStatus?
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromRGBO(0, 255, 0, 1),
            ),
          ),
          // Container(
          //       width: 20,
          //       height: 20,
          //       margin: const EdgeInsets.only(right: 10),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20),
          //         color: const Color.fromRGBO(100, 100, 100, 01),
          //       ),
          //
          //     )
        ),
      ),
    );
  }

  Widget dialerPrefix() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          //<-- 1. SEE HERE
          side: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        shadowColor: Colors.grey,
        child: ListTile(
          title: const Text("Dialer Prefix"),
          trailing: SizedBox(
              width: 100,
              child: TextField(
                controller: prefixController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    // border: InputBorder.none,
                    hintText: "eg. 1, 2"),
                onChanged: (value) => setDialerPrefix(value),
              )),
        ),
      ),
    );
  }

  void setDialerPrefix(prefix) async {
    //  var ref = await SharedPreferences.getInstance();
    //ref.setString("dialerPrefix", prefix);
  }

  Future getDialerPrefix() async {
    //   var ref = await SharedPreferences.getInstance();
    // String? dialerPrefix = ref.getString("dialerPrefix");
    if (dialerPrefix != null) {
      //     prefixController.text = dialerPrefix;
    } else {
      prefixController.text = "";
    }
  }
}
