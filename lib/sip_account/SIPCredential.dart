import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:untitled1/sip_account/SipDialPad.dart';
import '../components/CustomAlertDialog.dart';
import '../progress_indicator/CustomProgressIndicator.dart';
import 'SIPConfiguration.dart';
import 'SipAccountStatus.dart';

class SIPCredential extends StatefulWidget {
  const SIPCredential({Key? key}) : super(key: key);

  @override
  State<SIPCredential> createState() => SIPCredentialState();
}

// Make the state class public by renaming it
class SIPCredentialState extends State<SIPCredential> {
  TextEditingController sipID = TextEditingController();
  TextEditingController sipDomain =
  TextEditingController(text: "114.130.69.205:25067");
  TextEditingController sipPassword = TextEditingController();
  String serverMessage = '';

  @override
  void initState() {
    super.initState();
    SIPConfiguration.messageStream.listen((message) {
      setState(() {
        serverMessage = message;
      });
    });
  }

  @override
  void dispose() {
    SIPConfiguration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        systemOverlayStyle:
        const SystemUiOverlayStyle(statusBarColor: Colors.blue,
        ),
        title: const Text("SIP Credential"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Card(
              elevation: 0.5,
              child: TextField(
                  controller: sipID,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "SIP User ID",
                      hintText: "096xxxxxxxx")),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0.5,
              child: TextField(
                  controller: sipPassword,
                  obscureText: true,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "eg. @e#%wsfh")),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0.5,
              child: TextField(
                  controller: sipDomain,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "SIP Server",
                      hintText: "sip host")),
            ),
            const SizedBox(height: 45),
            Center(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blue,
                child: AnimatedButton(
                  width: 150,
                  text: 'Save',
                  pressEvent: () async {
                    if (sipID.text.isEmpty) {
                      CustomAlertDialog.showAlert(
                          "Sip User ID field is required!", context);
                      return;
                    }
                    if (sipDomain.text.isEmpty) {
                      CustomAlertDialog.showAlert(
                          "Sip server field is required!", context);
                      return;
                    }
                    if (sipPassword.text.isEmpty) {
                      CustomAlertDialog.showAlert(
                          "Password field is required!", context);
                      return;
                    }

                    SIPConfiguration.config(sipID.text, sipDomain.text,
                        sipPassword.text, true, context);

                    CustomProgressIndicator progress =
                    CustomProgressIndicator(context);
                    progress.showDialog("Please wait..",
                        SimpleFontelicoProgressDialogType.threelines);

                    Future.delayed(const Duration(seconds: 4), () {
                      progress.hideDialog();
                      checkAccountStatus(SipAccountStatus.sipAccountStatus);
                    });

                    // // navigate to sip account setting page
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const SipAccountSetting()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkAccountStatus(bool isAccountRegistered) {
    if (isAccountRegistered) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Registation Sucessfully",
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
          content: Text(serverMessage,
              style: const TextStyle(fontSize: 16, color: Colors.green)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SipDialPad()));
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Server message"),
          content: Text(serverMessage,
              style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
          actions: <Widget>[
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
  }
}