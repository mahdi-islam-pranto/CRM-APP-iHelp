/// very good working
// import 'package:awesome_dialog/awesome_dialog.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
// import 'package:untitled1/sip_account/SipDialPad.dart';
// import '../components/CustomAlertDialog.dart';
// import '../progress_indicator/CustomProgressIndicator.dart';
// import 'SIPConfiguration.dart';
// import 'SipAccountStatus.dart';
//
// class SIPCredential extends StatefulWidget {
//   const SIPCredential({Key? key}) : super(key: key);
//
//   @override
//   State<SIPCredential> createState() => SIPCredentialState();
// }
//
// // Make the state class public by renaming it
// class SIPCredentialState extends State<SIPCredential> {
//   TextEditingController sipID = TextEditingController();
//   TextEditingController sipDomain =
//   TextEditingController(text: "114.130.69.205:25067");
//   TextEditingController sipPassword = TextEditingController();
//   String serverMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     SIPConfiguration.messageStream.listen((message) {
//       setState(() {
//         serverMessage = message;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     SIPConfiguration.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         systemOverlayStyle:
//         const SystemUiOverlayStyle(statusBarColor: Colors.blue,
//         ),
//         title: const Text("SIP Credential"),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.all(10),
//         child: ListView(
//           children: [
//             const SizedBox(height: 30),
//             Card(
//               elevation: 0.5,
//               child: TextField(
//                   controller: sipID,
//                   maxLines: 1,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "SIP User ID",
//                       hintText: "096xxxxxxxx")),
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 0.5,
//               child: TextField(
//                   controller: sipPassword,
//                   obscureText: true,
//                   maxLines: 1,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Password",
//                       hintText: "eg. @e#%wsfh")),
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 0.5,
//               child: TextField(
//                   controller: sipDomain,
//                   maxLines: 1,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "SIP Server",
//                       hintText: "sip host")),
//             ),
//             const SizedBox(height: 45),
//             Center(
//               child: Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 color: Colors.blue,
//                 child: AnimatedButton(
//                   color: Colors.blue,
//                   width: 150,
//                   text: 'Save',
//                   pressEvent: () async {
//                     if (sipID.text.isEmpty) {
//                       CustomAlertDialog.showAlert(
//                           "Sip User ID field is required!", context);
//                       return;
//                     }
//                     if (sipDomain.text.isEmpty) {
//                       CustomAlertDialog.showAlert(
//                           "Sip server field is required!", context);
//                       return;
//                     }
//                     if (sipPassword.text.isEmpty) {
//                       CustomAlertDialog.showAlert(
//                           "Password field is required!", context);
//                       return;
//                     }
//
//                     SIPConfiguration.config(sipID.text, sipDomain.text,
//                         sipPassword.text, true, context);
//
//                     CustomProgressIndicator progress =
//                     CustomProgressIndicator(context);
//                     progress.showDialog("Please wait..",
//                         SimpleFontelicoProgressDialogType.threelines);
//
//                     Future.delayed(const Duration(seconds: 4), () {
//                       progress.hideDialog();
//                       checkAccountStatus(SipAccountStatus.sipAccountStatus);
//                     });
//
//                     // // navigate to sip account setting page
//                     // Navigator.pushReplacement(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => const SipAccountSetting()));
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void checkAccountStatus(bool isAccountRegistered) {
//     if (isAccountRegistered) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text(
//             "Registation Sucessfully",
//             style: TextStyle(color: Colors.green, fontSize: 20),
//           ),
//           content: Text(serverMessage,
//               style: const TextStyle(fontSize: 16, color: Colors.green)),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SipDialPad()));
//               },
//               child: const Text('Ok'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Server message"),
//           content: Text(serverMessage,
//               style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Ok'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:untitled1/resourses/app_colors.dart';
import '../components/CustomAlertDialog.dart';
import '../progress_indicator/CustomProgressIndicator.dart';
import 'SIPConfiguration.dart';
import 'SipAccountStatus.dart';
import 'SipDialPad.dart';

class SIPCredential extends StatefulWidget {
  const SIPCredential({Key? key}) : super(key: key);

  @override
  State<SIPCredential> createState() => _SIPCredentialState();
}

class _SIPCredentialState extends State<SIPCredential> {
  final TextEditingController sipID = TextEditingController();

  final TextEditingController sipDomain = TextEditingController(text: "114.130.69.205:25067");
  final TextEditingController sipPassword = TextEditingController();
  String serverMessage = '';
  bool _isPasswordVisible = false;

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
      backgroundColor: formBackgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.chevron_left,size: 25,color: Colors.blue,)),

        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          "SIP Credentials",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeaderText(),
              const SizedBox(height: 40),
              _buildInputField(
                controller: sipID,
                label: "SIP User ID",
                hint: "Enter your SIP ID (e.g., 096xxxxxxxx)",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildInputField(
                controller: sipDomain,
                label: "SIP Server",
                hint: "Enter server address",
                icon: Icons.dns_outlined,
              ),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Please enter your SIP credentials to continue",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: sipPassword,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelText: "Password",
          hintText: "Enter your password",
          hintStyle: const TextStyle(color: Colors.black26),
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: _handleSave,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Save Credentials",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleSave() async {
    if (sipID.text.isEmpty) {
      CustomAlertDialog.showAlert("SIP User ID field is required!", context);
      return;
    }
    if (sipDomain.text.isEmpty) {
      CustomAlertDialog.showAlert("SIP server field is required!", context);
      return;
    }
    if (sipPassword.text.isEmpty) {
      CustomAlertDialog.showAlert("Password field is required!", context);
      return;
    }

    SIPConfiguration.config(
      sipID.text,
      sipDomain.text,
      sipPassword.text,
      true,
      context,
    );

    CustomProgressIndicator progress = CustomProgressIndicator(context);
    progress.showDialog(
      "Please wait...",
      SimpleFontelicoProgressDialogType.threelines,
    );

    Future.delayed(const Duration(seconds: 4), () {
      progress.hideDialog();
      checkAccountStatus(SipAccountStatus.sipAccountStatus);
    });
  }

  void checkAccountStatus(bool isAccountRegistered) {
    if (isAccountRegistered) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Registration Successful",
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
          content: Text(
            serverMessage,
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SipDialPad()),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Registration Failed",
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
          content: Text(
            serverMessage,
            style: const TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
  }
}