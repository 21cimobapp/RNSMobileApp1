import 'dart:async';
import 'package:ciPatientApp/data_models/AppointmentDetails.dart';
//import 'package:ciPatientApp/src/ViewAppointmentsPatient.dart';
//import 'package:ciPatientApp/src/pages/appointment/Speciallitylist.dart';
//import 'package:ciPatientApp/src/pages/doctorInfo.dart';
//import 'package:ciPatientApp/src/pages/ViewDocuments.dart';
//import 'package:ciPatientApp/src/pages/ViewAppointments.dart';
import 'package:ciPatientApp/src/pages/PatientReports.dart';
import 'package:ciPatientApp/src/pages/myProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:ciPatientApp/src/pages/call.dart';
import 'package:ciPatientApp/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:agora_rtm/agora_rtm.dart';
import 'package:ciPatientApp/utils/widgets.dart';
//import 'package:ciPatientApp/src/pages/ChatMain.dart';

//import 'package:ciPatientApp/firebase/auth/phone_auth/authservice.dart';
Color myGreen = Color(0xff4bb17b);
final List<String> imgList = [
//  'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
//  'https://images.unsplash.com/photo-1578496480240-32d3e0c04525?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80',
//  'https://images.pexels.com/photos/127873/pexels-photo-127873.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
//  'https://images.pexels.com/photos/139398/thermometer-headache-pain-pills-139398.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
//  'https://images.pexels.com/photos/4386513/pexels-photo-4386513.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
//  'assets/img6.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
//'https://images.unsplash.com/photo-1464982326199-86f32f81b211?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80'
  'assets/img1.jpeg',
  'assets/img2.jpeg',
  'assets/img3.jpeg',
  'assets/img4.jpeg',
  'assets/img5.jpeg',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item) + 1} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class HomePagePatient extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePagePatient> {
  int _current = 0;
  List<AppointmentDetails> apptList = List<AppointmentDetails>();
  var isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future onSelectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    //FlutterRingtonePlayer.stop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    var SelectNotification;
    // flutterLocalNotificationsPlugin.initialize(initSettings,SelectNotification: onSelectNotification);

    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android, ios),
        onSelectNotification: onSelectNotification);

    //   globals.clientRTM.onMessageReceived = (AgoraRtmMessage message, String peerId) {
    //     //_log("Peer msg:" + message.text);
    //     showNotification(message.toString());
    // globals.msgRTM=message.text;
    //   setState(() {
    //     globals.msgRTM=message.text;
    //   });
    // };
  }

  showNotification(msg) async {
    var android = new AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
    );
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Call Started',
      'Mesage: $msg',
      platform,
      payload: ' ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: globals.appMainColor,
        // floatingActionButton: FloatingActionButton(
        //   //foregroundColor: globals.appTextColor,
        //   //backgroundColor: globals.appSecondColor,
        //   elevation: 0,
        //   child: Icon(Icons.chat),
        //   onPressed: () {
        //     return Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => ChatMain()));
        //   },
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Container(
              //     alignment: Alignment.topLeft,
              //     decoration: BoxDecoration(color: Colors.white),
              //     padding: EdgeInsets.all(15.0),
              //     child: Column(children: <Widget>[
              //       Column(
              //           //mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             Text(
              //               "Hello ${_getUserData("FirstName")}",
              //               style: Theme.of(context).textTheme.headline5.apply(
              //                     color: Color(0xff0b1666),
              //                     fontWeightDelta: 2,
              //                   ),
              //             ),
              //             Text(
              //               "Welcome to VideoConnect!!",
              //               style: Theme.of(context).textTheme.headline6.apply(
              //                     color: globals.appMainColor,
              //                     fontWeightDelta: 1,
              //                   ),
              //             )
              //           ]),
              //       Text(
              //           globals.msgRTM == null
              //               ? ""
              //               : globals.msgRTM.split("|")[0],
              //           style: Theme.of(context).textTheme.headline5.apply(
              //                 color: Color(0xff0b1666),
              //                 fontWeightDelta: 2,
              //               )),
              //     ])),
              SizedBox(
                height: 10,
              ),
              Column(children: [
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ]),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * .28,
              //   width: MediaQuery.of(context).size.width,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: <Widget>[
              //       CategoryCard(
              //           title: "My Appointments",
              //           subtitle: "Video call with Doctor",
              //           color: LightColor.green,
              //           lightColor: LightColor.lightGreen),
              //       CategoryCard(
              //           title: "Search Doctor",
              //           subtitle: "Request Appointment",
              //           color: LightColor.skyBlue,
              //           lightColor: LightColor.lightBlue),
              //       CategoryCard(
              //           title: "My Reports",
              //           subtitle: "View your Lab Reports",
              //           color: LightColor.orange,
              //           lightColor: LightColor.lightOrange),
              //       CategoryCard(
              //           title: "My Documents",
              //           subtitle: "View Your Documents",
              //           color: LightColor.green,
              //           lightColor: LightColor.lightGreen),
              //       CategoryCard(
              //           title: "My Profile",
              //           subtitle: "View your Profile",
              //           color: LightColor.skyBlue,
              //           lightColor: LightColor.lightBlue),
              //     ],
              //   ),
              // ),
              Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Padding(padding: EdgeInsets.all(20),),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadMenuPage(context, "REPORTS");
                          },
                          child: MenuCard(
                              title: "My Reports",
                              subtitle: "View Lab Reports",
                              icon: Icons.report,
                              color: LightColor.purple,
                              lightColor: LightColor.purpleLight),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadMenuPage(context, "PROFILE");
                          },
                          child: MenuCard(
                              title: "My Profile",
                              subtitle: "View your Profile",
                              icon: Icons.person,
                              color: LightColor.purple,
                              lightColor: LightColor.purpleLight),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

loadMenuPage(context, menu) {
  switch (menu) {
    //case "APPT":
    // return Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => ViewAppointmentsPatient()));
    case "PROFILE":
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyProfile()));
    // globals.displayIncomingCall(context);
    //return true;
    case "REPORTS":
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientReports()));
    // case "DOCUMENTS":
    //   return Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) =>
    //             ViewDocuments(patientCode: globals.personCode),
    //       ));

    // case "BOOKAPPT":
    //   return Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => Speciallitylist()));

    // return Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => SelectDoctor()));
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.icon,
      @required this.color,
      @required this.lightColor})
      : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color lightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: (MediaQuery.of(context).size.width / 2) - 15,
        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: Colors.black.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 50,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            icon,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(title,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(subtitle,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
