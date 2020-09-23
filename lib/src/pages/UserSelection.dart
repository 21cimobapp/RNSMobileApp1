import 'package:flutter/material.dart';
import 'package:ciPatientApp/utils/widgets.dart';
import 'package:ciPatientApp/utils/constants.dart';
import 'package:ciPatientApp/src/pages/get_phone.dart';
import 'package:ciPatientApp/globals.dart' as globals;

class UserSelection extends StatefulWidget {
  final Color cardBackgroundColor = globals.appMainColor;
  final String logo = Assets.firebase;
  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  double _height, _width, _fixedPadding;
  var _isPortrait;
  String userType;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-user-selection");

  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;
    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Card(
                  color: widget.cardBackgroundColor,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: SizedBox(
                      height: _isPortrait ? 600 : 400,
                      width: _width,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
                            Padding(
                              padding: EdgeInsets.all(_fixedPadding),
                              child: PhoneAuthWidgets.getLogo(
                                  logoPath: widget.logo, height: _height * 0.2),
                            ),

                            SizedBox(height: 50.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(width: 10.0),
                                // Expanded(
                                //   child: new GestureDetector(
                                //     onTap: () {
                                //       setState(() {
                                //         userType = "DOCTOR";
                                //       });
                                //     },
                                //     child: Container(
                                //       alignment: Alignment.center,
                                //       height: 100,
                                //       decoration: BoxDecoration(
                                //         color: (userType == "DOCTOR")
                                //             ? Colors.blue
                                //             : Colors.white,
                                //         borderRadius: BorderRadius.only(
                                //             topLeft: Radius.circular(10),
                                //             topRight: Radius.circular(10),
                                //             bottomLeft: Radius.circular(10),
                                //             bottomRight: Radius.circular(10)),
                                //         boxShadow: [
                                //           BoxShadow(
                                //             color: Colors.grey.withOpacity(0.5),
                                //             spreadRadius:
                                //                 (userType == "DOCTOR") ? 5 : 0,
                                //             blurRadius: 7,
                                //             offset: Offset(0,
                                //                 3), // changes position of shadow
                                //           ),
                                //         ],
                                //       ),
                                //       child: Text(
                                //         "Doctor",
                                //         style: TextStyle(
                                //             color: (userType == "DOCTOR")
                                //                 ? Colors.white
                                //                 : Colors.black),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      userType = "DOCTOR";
                                    });
                                  },
                                  child: Container(
                                    child: Container(
                                      margin: EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.asset(
                                                  "assets/doctor_defaultpic.png",
                                                  fit: BoxFit.cover,
                                                  width: 150.0),
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: (userType ==
                                                            "DOCTOR")
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius:
                                                            (userType ==
                                                                    "DOCTOR")
                                                                ? 5
                                                                : 0,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      )
                                                    ],
                                                    // gradient: LinearGradient(
                                                    //   colors: [
                                                    //     Color.fromARGB(
                                                    //         200, 0, 0, 0),
                                                    //     Color.fromARGB(
                                                    //         0, 0, 0, 0)
                                                    //   ],
                                                    //   begin: Alignment
                                                    //       .bottomCenter,
                                                    //   end: Alignment.topCenter,
                                                    // ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    'Doctor',
                                                    style: TextStyle(
                                                      color: (userType ==
                                                              "PATIENT")
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      userType = "PATIENT";
                                    });
                                  },
                                  child: Container(
                                    child: Container(
                                      margin: EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.asset(
                                                  "assets/patient_defaultpic.png",
                                                  fit: BoxFit.cover,
                                                  width: 150.0),
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: (userType ==
                                                            "PATIENT")
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                    // gradient: LinearGradient(
                                                    //   colors: [
                                                    //     Color.fromARGB(
                                                    //         200, 0, 0, 0),
                                                    //     Color.fromARGB(
                                                    //         0, 0, 0, 0)
                                                    //   ],
                                                    //   begin: Alignment
                                                    //       .bottomCenter,
                                                    //   end: Alignment.topCenter,
                                                    // ),
                                                    // borderRadius:
                                                    //     BorderRadius.only(
                                                    //         topLeft:
                                                    //             Radius.circular(
                                                    //                 10),
                                                    //         topRight:
                                                    //             Radius.circular(
                                                    //                 10),
                                                    //         bottomLeft:
                                                    //             Radius.circular(
                                                    //                 10),
                                                    //         bottomRight:
                                                    //             Radius.circular(
                                                    //                 10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius:
                                                            (userType ==
                                                                    "PATIENT")
                                                                ? 5
                                                                : 0,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    'Patient',
                                                    style: TextStyle(
                                                      color: (userType ==
                                                              "PATIENT")
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: new GestureDetector(
                                //     onTap: () {
                                //       setState(() {
                                //         userType = "PATIENT";
                                //       });
                                //     },
                                //     child: Container(
                                //       alignment: Alignment.center,
                                //       height: 100,
                                //       decoration: BoxDecoration(
                                //         color: (userType == "PATIENT")
                                //             ? Colors.blue
                                //             : Colors.white,
                                //         borderRadius: BorderRadius.only(
                                //             topLeft: Radius.circular(10),
                                //             topRight: Radius.circular(10),
                                //             bottomLeft: Radius.circular(10),
                                //             bottomRight: Radius.circular(10)),
                                //         boxShadow: [
                                //           BoxShadow(
                                //             color: Colors.grey.withOpacity(0.5),
                                //             spreadRadius:
                                //                 (userType == "PATIENT") ? 5 : 0,
                                //             blurRadius: 7,
                                //             offset: Offset(0,
                                //                 3), // changes position of shadow
                                //           ),
                                //         ],
                                //       ),
                                //       child: Text(
                                //         "Patient",
                                //         style: TextStyle(
                                //             color: (userType == "PATIENT")
                                //                 ? Colors.white
                                //                 : Colors.black),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                SizedBox(width: 10.0),
                              ],
                            ),

                            SizedBox(height: 100),

                            RaisedButton(
                              elevation: 16.0,
                              onPressed: () {
                                globals.loginUserType = userType;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PhoneAuthGetPhone()),
                                );
                              },
                              //onPressed: verifyCheck,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                      color: widget.cardBackgroundColor,
                                      fontSize: 18.0),
                                ),
                              ),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
