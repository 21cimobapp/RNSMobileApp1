import 'dart:async';
import 'package:ciPatientApp/data_models/AppointmentDetails.dart';
//import 'package:ciPatientApp/src/pages/doctorInfo.dart';
//import 'package:ciPatientApp/src/pages/ViewDocuments.dart';
//import 'package:ciPatientApp/src/pages/ViewAppointments.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:ciPatientApp/src/pages/call.dart';
import 'package:ciPatientApp/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:ciPatientApp/src/pages/doctorInfo.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:ciPatientApp/src/pages/ChatMain.dart';

//import 'package:ciPatientApp/firebase/auth/phone_auth/authservice.dart';

final List<String> imgList = [
  'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.unsplash.com/photo-1578496480240-32d3e0c04525?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80',
  'https://images.pexels.com/photos/127873/pexels-photo-127873.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
  'https://images.pexels.com/photos/139398/thermometer-headache-pain-pills-139398.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
  'https://images.pexels.com/photos/4386513/pexels-photo-4386513.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
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

class HomePageDoctor extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageDoctor> {
  int _current = 0;
  List<AppointmentDetails> apptList = List<AppointmentDetails>();
  var isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: globals.appMainColor,

        // floatingActionButton: FloatingActionButton(
        //   foregroundColor: globals.appTextColor,
        //   backgroundColor: globals.appSecondColor,
        //   elevation: 0,
        //   child: Icon(Icons.chat),
        //   onPressed: () {
        //     return Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => ChatMain()));
        //   },
        // ),
        body: Column(
          children: <Widget>[
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
            DoctorsTile(),
          ],
        ),
      ),
    );
  }
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

class DoctorsTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoctorsTileState();
}

class DoctorsTileState extends State<DoctorsTile> {
  /// create a channelController to retrieve text value
  List<AppointmentDetails> apptList = List<AppointmentDetails>();
  final _channelController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointments1(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
            color: Colors.white),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Appointments",
                  style: Theme.of(context).textTheme.headline6.apply(
                        color: Color(0xff0b1666),
                        fontWeightDelta: 2,
                      ),
                ),
                (globals.loginUserType == "DOCTOR")
                    ? FlatButton(
                        child: Text(
                          "View All", //
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => ViewAppointments(),
                          //     ),
                          //   );
                        },
                      )
                    : Center()
              ],
            ),
            Expanded(
                child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () => getAppointments1(DateTime.now()),
                    child: ListView.builder(
                        itemCount: apptList?.length,
                        itemBuilder: (BuildContext context, int i) => ListTile(
                              onTap: () {
                                //showDoctorInfo(apptList[i]);
                              },
                              leading: GestureDetector(
                                child: Container(
                                  //padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: globals.loginUserType == "PATIENT"
                                      ? getDoctorPhoto(i)
                                      : getPatientPhoto(i),
                                ),
                              ),
                              title: Text("${getApptTitle(i)}"),
                              subtitle: Text("${getApptTime(i)}"),
                              trailing: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1),
                                        color: Colors.indigo,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: IconButton(
                                        constraints: BoxConstraints.tight(
                                            Size.fromWidth(40)),
                                        icon: Icon(Icons.video_call),
                                        tooltip: "Video call",
                                        color: Colors.white,
                                        onPressed: () => joinCall(apptList[i]),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1),
                                        color: Colors.indigo,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: IconButton(
                                        constraints: BoxConstraints.tight(
                                            Size.fromWidth(40)),
                                        icon: Icon(Icons.attachment),
                                        tooltip: "Documents",
                                        color: Colors.white,
                                        onPressed: () => {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // RaisedButton(
                              //   child: Text("Join Call"),
                              //   onPressed: () => joinCall(apptList[i]),
                              //   //onPressed: () {},
                              //   color: Colors.orangeAccent,
                              //   textColor: Colors.white,
                              //   padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                              //   splashColor: Colors.grey,
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(30.0)),
                              // ),
                            ))))

// FutureBuilder(
//                     future: getAppointments1(),
//                     builder: (BuildContext context, AsyncSnapshot snapshot) {
//                       if (!snapshot.hasData) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       } else {
//                         return ListView.builder(
//                           itemCount: snapshot.data.length,
//                           itemBuilder: (BuildContext context, int i) {
//                             return ListTile(
//                               onTap: () {},
//                               leading: Container(
//                                 //padding: EdgeInsets.all(5.0),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(5.0),
//                                 ),
//                                 child: Image.network(
//                                     globals.apptList[i]["DoctorPhoto"]),
//                               ),
//                               title: Text("${snapshot.data[i]["DoctorName"]}"),
//                               subtitle:
//                                   Text("${snapshot.data[i]["DepartmentName"]}"),
//                               trailing: RaisedButton(
//                                 child: Text("Join Call"),
//                                 onPressed: () => joinCall(snapshot.data[i]),
//                                 //onPressed: () {},
//                                 color: Colors.orangeAccent,
//                                 textColor: Colors.white,
//                                 padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
//                                 splashColor: Colors.grey,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30.0)),
//                               ),
//                             );
//                           },
//                         );
//                       }
//                     })))
          ],
        ),
      ),
    );
  }

  // showDoctorInfo(a) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => DoctorsInfo(
  //                 appt: a,
  //               )));
  // }

  String getApptTime(i) {
    return DateFormat('dd MMM yyyy')
            .format(apptList[i].PortalAppointmentDateTime) +
        ' ' +
        apptList[i].SlotName;
  }

  String getApptTitle(i) {
    if (globals.loginUserType == "DOCTOR") {
      return apptList[i].PatientName;
    } else {
      return apptList[i].DoctorName;
    }
  }

  Image getDoctorPhoto(i) {
    if (apptList[i].DoctorPhoto == "") {
      return Image.asset("assets/doctor_defaultpic.png");
    } else {
      return Image.memory(base64Decode(apptList[i].DoctorPhoto));
    }
  }

  Image getPatientPhoto(i) {
    if (apptList[i].DoctorPhoto == "") {
      return Image.asset("assets/patient_defaultpic.png");
    } else {
      return Image.memory(base64Decode(apptList[i].DoctorPhoto));
    }
  }

  getAppointments1(date) async {
    print(apptList);
    await getAppointments(date).then((value) => apptList = value);

    setState(() {
      apptList = apptList;
    });
  }

  Future<List<AppointmentDetails>> getAppointments(date) async {
    List<AppointmentDetails> a = List<AppointmentDetails>();
    var phoneNumber = _getUserData("MobileNumber");

    String url;
    if (_loginUserType() == "DOCTOR") {
//      url = "http://www.21ci.com/MobileAppEx/Doctors/mapp_ViewAppointment";
    } else {
//      url = "http://www.21ci.com/MobileAppEx/Patient/mapp_ViewAppointment";
    }

    print("getAppointments()");
    return await http.post(Uri.encodeFull(url), body: {
      "token": "$phoneNumber",
      "DataType": "SUMMARY1",
      "AppointmentDate": "$date",
      "ReferenceNumber": "1"
    }, headers: {
      "Accept": "application/json"
    }).then((http.Response response) {
      //      print(response.body);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        var notesJson = json.decode(response.body);
        //  ImageData = base64.encode(response.bodyBytes);
        for (var notejson in notesJson) {
          a.add(AppointmentDetails.fromJson(notejson));
        }
        return a;
        // if (p.status == 1) {
        //   globals.loginUser=p;
        // } else {
        //   return null;
        // }
      } else {
        return null;
      }
    });
  }

  String _loginUserType() {
    if (globals.loginUserType != null) {
      return globals.loginUserType;
    } else
      return '';
  }

  joinCall(channelName) async {
    onJoin(channelName).then((value) => null);
  }

  Future<void> onJoin(appList) async {
    // update input validation
    setState(() {});

    // await for camera and mic permissions before pushing video page
    //await _handleCameraAndMic();
    // push video page with given channel name
    //var phoneNumber = _getUserData("MobileNumber");

    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CallPage(
    //       //userID:phoneNumber,
    //       appt: appList,
    //     ),
    //   ),
    // );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

class DoctorsTile1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoctorsTileState1();
}

class DoctorsTileState1 extends State<DoctorsTile1> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => DoctorsInfo()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xffFFEEE0), borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.asset(
                "assets/doctor_pic.png",
                height: 50,
              ),
            ),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dr. Stefeni Albert",
                      style: TextStyle(color: Color(0xffFC9535), fontSize: 17),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Heart Speailist",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "@ 8:00 PM",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Container(
                  //color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

                  child: RaisedButton(
                    child: Text("Join Call"),
                    onPressed: onJoin,
                    color: Colors.orangeAccent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    splashColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {});

    // await for camera and mic permissions before pushing video page
    // await _handleCameraAndMic();
    // // push video page with given channel name
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CallPage(
    //         //channelName: '21ci',
    //         ),
    //   ),
    // );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
