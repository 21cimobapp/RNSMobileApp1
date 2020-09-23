//import 'package:ciPatientApp/data_models/AppointmentDetails.dart';
//import 'package:ciPatientApp/src/pages/call.dart';
import 'package:ciPatientApp/src/utils/settings.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:ciPatientApp/src/pages/Index.dart';
//import 'package:ciPatientApp/src/pages/UserSelection.dart';
import 'package:ciPatientApp/utils/constants.dart';
import 'package:ciPatientApp/globals.dart' as globals;
//import 'package:ciPatientApp/intro_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ciPatientApp/src/utils/UserDatabaseUtil.dart';
import 'package:ciPatientApp/data_models/userdata.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:ciPatientApp/src/pages/get_phone.dart';

class StartScreen extends StatefulWidget {
  final bool firstTimeLogin;

  const StartScreen({Key key, this.firstTimeLogin}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  FirebaseUser mCurrentUser;
  UserDatabaseUtil userDatabase;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future onSelectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    //FlutterRingtonePlayer.stop();
  }

  Future<void> _showSoundUriNotification(msg) async {
    // this calls a method over a platform channel implemented within the example app to return the Uri for the default
    // alarm sound and uses as the notification sound
    //String alarmUri = await platform.invokeMethod('getAlarmUri');
    //final x = UriAndroidNotificationSound(alarmUri);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'uri channel id', 'uri channel name', 'uri channel description',
        //  sound: x,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        globals.loginUserType == "Doctor" ? 'VIDEO CALL' : 'VIDEO CALL',
        globals.loginUserType == "Doctor"
            ? 'Patient has Joined the video call'
            : 'Doctor has Joined the video call',
        platformChannelSpecifics);
  }

  // showNotification(msg) async {

  //   //String alarmUri = await platform.invokeMethod('getAlarmUri');
  //   //AndroidNotificationSound a= UriAndroidNotificationSound(alarmUri);

  //   var android = new AndroidNotificationDetails(
  //     'channelId',
  //     'channelName',
  //     'channelDescription', //,sound:a,
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     playSound: true,

  //   );
  //   var ios = new IOSNotificationDetails(sound: "slow_spring_board.aiff");
  //   var platform1 = new NotificationDetails(android, ios);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Call Started',
  //     'Mesage: $msg',
  //     platform1,
  //     payload: 'Custom_Sound',
  //   );
  // }

  @override
  void initState() {
    super.initState();
    userDatabase = UserDatabaseUtil();
    userDatabase.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    var SelectNotification;
    // flutterLocalNotificationsPlugin.initialize(initSettings,SelectNotification: onSelectNotification);

    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android, ios),
        onSelectNotification: onSelectNotification);

    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    // );

    FirebaseAuth.instance.currentUser().then((res) {
      print("Results : $res");

      if (res != null) {
        loadIndexPage(res);
      } else {
        loadLogin(context);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => PhoneAuthGetPhone()),
        // );
      }
    });
  }

  updateLocalDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    if (_loginUserType() != "") {
      prefs.setString('loginUserType', globals.loginUserType);
    } else {
      final key = 'loginUserType';
      final value = prefs.getString(key) ?? "";
      globals.loginUserType = value;
    }

    if (_loginUserType() != "") {
      prefs.setString('personCode', globals.personCode);
    } else {
      final key = 'personCode';
      final value = prefs.getString(key) ?? "";
      globals.personCode = value;
    }
  }

  updateUserToDatabase(FirebaseUser res) async {
    String msgToken;
    await _firebaseMessaging.getToken().then((val) {
      msgToken = val;
    });

    var user = UserData(globals.personCode, res.phoneNumber, res.phoneNumber,
        msgToken, globals.loginUserType);

    await userDatabase.deleteUserByMobile(user.mobileNumber);

    await userDatabase.addUser(user);
  }

  loadLogin(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loginUserType', "PATIENT");
    globals.loginUserType = 'PATIENT';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PhoneAuthGetPhone()),
    );
  }

  loadIndexPage(res) async {
    await updateLocalDatabase();
    print("Inside loadIndex : ${res.phoneNumber}");
    if (_loginUserType() == "DOCTOR") {
      await getDcotorDetails(res.phoneNumber);
    } else {
      await getPatientDetails(res.phoneNumber);
    }

    if (widget.firstTimeLogin == true) {
      await updateUserToDatabase(res);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IndexPage()),
    );
  }

  String _loginUserType() {
    if (globals.loginUserType != null) {
      return globals.loginUserType;
    } else
      return '';
  }

  String _getUserData(type) {
    if (globals.user != null) {
      return globals.user[0][type];
    } else
      return '';
  }

  Future<bool> getPatientDetails(phoneNumber) async {
    print("Inside API phNo: $phoneNumber");
    print("cut phno : ${phoneNumber.substring(3)}");
    return await http.post(
        Uri.encodeFull(
            'http://43.252.88.147/RNSMobAppAPI/Patient/mapp_GetPatientRegDetails'),
        body: {"MobileNumber": "${phoneNumber.substring(3)}"},
        headers: {"Accept": "application/json"}).then((http.Response response) {
            print("Response : ${response.body}");
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        var extractdata = jsonDecode(response.body)['patientDetails'];
        List data = extractdata as List;
        globals.user = data;
        print("Data : $extractdata");
        if (data != null) {
          globals.personCode = data[0]["PersonCode"];
          globals.personName = data[0]["FullName"];
        }

        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> getDcotorDetails(phoneNumber) async {
    return await http.post(
        Uri.encodeFull(
            'http://www.21ci.com/MobileAppEx/Doctors/mapp_GetDoctorDetails'),
        body: {"MobileNumber": "$phoneNumber"},
        headers: {"Accept": "application/json"}).then((http.Response response) {
      //      print(response.body);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        var extractdata = jsonDecode(response.body)['DcotorDetails'];
        List data = extractdata as List;
        globals.user = data;
        if (data != null) {
          globals.personCode = data[0]["PersonCode"];
          globals.personName = data[0]["PersonFullName"];
        }

        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        title: new Text(
          'Welcome To VideoConnect!!',
          style: new TextStyle(
              color: globals.appTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),
        image: Image.asset(Assets.firebase, fit: BoxFit.scaleDown),
        //backgroundColor: globals.appMainColor,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("21CI"),
        loaderColor: Colors.red);
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        //...top circlular image part,
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
