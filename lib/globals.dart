library my_prj.globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_callkeep/flutter_callkeep.dart';

List user;
String loginUserType;
String personCode;
String personName;
String msgRTM;
bool isLogin;
Color appMainColor = Color(0xFF128C7E);
Color appTextColor = Colors.white;
Color appSecondColor = Color(0xff4bb17b);
// initCallKeep() async
// {
//    await CallKeep.setup();

// }

// Future<void> answerIncomingCall(context) async {
//     await CallKeep.askForPermissionsIfNeeded(context);
//     final callUUID = '0783a8e5-8353-4802-9448-c6211109af51';

//     await CallKeep.answerIncomingCall(
//         callUUID);
//   }

// Future<void> displayIncomingCall(context) async {
//     await CallKeep.askForPermissionsIfNeeded(context);
//     final callUUID = '0783a8e5-8353-4802-9448-c6211109af51';
//     final number = '+46 70 123 45 67';

//     await CallKeep.displayIncomingCall(
//         callUUID, number, number, HandleType.number,  true);

//   }

// Future<void> _displayCustomIncomingCall(Map<String, dynamic> callData) async {
//     String incomingCallUsername = callData['your.app.id.CALLER_HANDLE'];
//     await CallKeep.displayCustomIncomingCall(
//       'your.app.id',
//       'IncomingCallActivity',
//       icon: 'notification_icon',
//       contentTitle: S().callNotificationTitle(incomingCallUsername),
//       answerText: S().callAnswer,
//       declineText: S().callDecline,
//       extra: callData,
//     );
//   }
