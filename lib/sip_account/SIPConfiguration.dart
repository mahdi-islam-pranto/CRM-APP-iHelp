// import 'dart:convert';
//
// import 'package:isalescrm/sip_account/SipAccountStatus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:voip24h_sdk_mobile/callkit/model/sip_configuration.dart';
// import 'package:voip24h_sdk_mobile/callkit/utils/sip_event.dart';
// import 'package:voip24h_sdk_mobile/callkit/utils/transport_type.dart';
// import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile.dart';
//
// class SIPConfiguration {
//   static config(
//       String sipID, String sipDomain, String sipPassword, bool status) {
//     //SIP even handling
//
//     var sipConfiguration = SipConfigurationBuilder(
//             extension: sipID, domain: sipDomain, password: sipPassword)
//         .setKeepAlive(true)
//          .setPort(5060)
//         .setTransport(TransportType.Udp)
//         .build();
//
//     Voip24hSdkMobile.callModule.initSipModule(sipConfiguration);
//
//     Voip24hSdkMobile.callModule.eventStreamController.stream.listen((event) {
//       switch (event['event']) {
//         case SipEvent.AccountRegistrationStateChanged:
//           var body = event['body'];
//
//           print(body);
//
//           if (body["message"].toString().contains("Registration successful")) {
//             status = true;
//
//             SipAccountStatus.sipAccountStatus = true;
//             SipAccountStatus.extension = sipID;
//
//             storeSipCredential(sipID, sipDomain, sipPassword);
//           } else {
//             SipAccountStatus.sipAccountStatus = false;
//           }
//       }
//     });
//   }
//
//   static Future<void> storeSipCredential(
//       String sipID, String sipDomain, String sipPassword) async {
//     var ref = await SharedPreferences.getInstance();
//     ref.setString("sipID", sipID);
//     ref.setString("sipDomain", sipDomain);
//     ref.setString("sipPassword", sipPassword);
//   }
// }
