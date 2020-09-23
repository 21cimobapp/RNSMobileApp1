import 'package:flutter/material.dart';
import '../utils/settings.dart';
import 'package:ciPatientApp/globals.dart' as globals;
import 'package:ciPatientApp/data_models/AppointmentDetails.dart';
import 'package:intl/intl.dart';

class InfoPopup extends StatefulWidget {
  /// non-modifiable channel name of the page
  //final int userID;
  final AppointmentDetails appt;

  /// Creates a call page with given channel name.
  const InfoPopup({Key key, this.appt}) : super(key: key);

  @override
  _InfoPopupState createState() => _InfoPopupState();
}

class _InfoPopupState extends State<InfoPopup> {
  final themeColor = Color(0xfff5a623);
  final primaryColor = Color(0xff203152);
  final greyColor = Color(0xffaeaeae);
  final greyColor2 = Color(0xffE8E8E8);

  //final _peerMessageController = TextEditingController();
  final _channelMessageController = TextEditingController();

  final _infoStrings = <String>[];

  bool _isLogin = false;
  bool _isOtherUserOnline = false;
  bool _isInChannel = false;
  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  @override
  void dispose() {
    try {
      super.dispose();
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  // void _createClient() async {
  //   globals.clientRTM = await AgoraRtmClient.createInstance(APP_ID);
  //   globals.clientRTM.onMessageReceived = (AgoraRtmMessage message, String peerId) {
  //     _log("Peer msg:" + message.text);
  //   };
  //   globals.clientRTM.onConnectionStateChanged = (int state, int reason) {
  //     // _log('Connection state changed: ' +
  //     //     state.toString() +
  //     //     ', reason: ' +
  //     //     reason.toString());
  //     if (state == 5) {
  //       globals.clientRTM.logout();
  //       _log('Logout.');
  //       setState(() {
  //         _isLogin = false;
  //       });
  //     }
  //   };
  // }

  // void _loginToChatService() async {
  //   String userId = globals.loginUserType == "PATIENT"
  //       ? widget.appt.PatientCode
  //       : widget.appt.DoctorCode;

  //   try {
  //     await globals.clientRTM.login(null, userId);
  //     //_log('Connected : ' + userId);
  //     setState(() {
  //       _isLogin = true;
  //     });
  //   } catch (errorCode) {
  //     _log('Connetion error: ' + errorCode.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //      "",
        //     style: Theme.of(context).textTheme.headline6.apply(
        //           color: Color(0xff0b1666),
        //           fontWeightDelta: 2,
        //         ),
        //   ),
        //   actions: <Widget>[],
        //   backgroundColor: globals.appMainColor,
        // ),
        body: Column(children: <Widget>[
      Container(
        padding: EdgeInsets.all(15.0),
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Text(
              "Chat",
              style: Theme.of(context).textTheme.headline5.apply(
                    color: Color(0xff0b1666),
                    fontWeightDelta: 2,
                  ),
            ),
          ],
        ),
      ),
      _showStatus(),
      _buildInfoList(),
      _buildSendChannelMessage(),
    ]));
  }

  Widget _showStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        getOtherUserStatus(),
        Container(
          alignment: Alignment.center,
          child: Text(
            globals.isLogin ? "Connected" : "Offline",
            style: TextStyle(color: Colors.white),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          //width: 200.0,
          decoration: BoxDecoration(
              color: globals.isLogin ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(right: 10.0),
        ),
      ],
    );
  }

  getOtherUserStatus() {
    if (_isOtherUserOnline == true) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          globals.loginUserType == "PATIENT"
              ? "DOCTOR CONNECTED"
              : "PATIENT CONNECTED",
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        //width: 200.0,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.only(right: 10.0),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text(
          globals.loginUserType == "PATIENT" ? "DOCTOR" : "PATIENT",
          style: TextStyle(color: Colors.grey),
        ),
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        //width: 200.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.only(right: 10.0),
      );
    }
  }

  Widget _buildSendChannelMessage() {
    //if (!_isLogin || !_isInChannel) {
    //  return Container();
    //}
    return Row(children: <Widget>[
      SizedBox(
        width: 10,
      ),
      new Expanded(
          child: new TextField(
              controller: _channelMessageController,
              decoration: InputDecoration(hintText: 'Type a message'))),
      new OutlineButton(
        child: Text('Send', style: textStyle),
        onPressed: () {},
      )
    ]);
  }

  // Widget _buildSendPeerMessage() {
  //   if (!_isLogin) {
  //     return Container();
  //   }
  //   return Row(children: <Widget>[
  //     SizedBox(width: 10,),
  //     new Expanded(
  //         child: new TextField(
  //             controller: _peerMessageController,
  //             decoration: InputDecoration(hintText: 'Type a message'))),
  //     new OutlineButton(
  //       child: Text('Send', style: textStyle),
  //       onPressed: _toggleSendPeerMessage,
  //     )
  //   ]);
  // }

  // void _toggleSendPeerMessage() async {
  //   String peerUid = globals.loginUserType == "PATIENT"
  //       ? widget.appt.DoctorCode
  //       : widget.appt.PatientCode;
  //   if (peerUid.isEmpty) {
  //     //_log('Please input peer user id to send message.');
  //     return;
  //   }

  //   String text = _peerMessageController.text;
  //   if (text.isEmpty) {
  //     //_log('Please input text to send.');
  //     return;
  //   }

  //   try {
  //     AgoraRtmMessage message = AgoraRtmMessage.fromText(text);
  //     _log(message.text);
  //     await globals.clientRTM.sendMessageToPeer(peerUid, message, false);
  //     _peerMessageController.clear();
  //     //_log('Send peer message success.');
  //   } catch (errorCode) {
  //     //_log('Send peer message error: ' + errorCode.toString());
  //     _peerMessageController.clear();
  //   }
  // }

  Widget _buildInfoList() {
    return Flexible(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemExtent: 50,
              itemBuilder: (context, i) => formatMessage(_infoStrings[i]),
              itemCount: _infoStrings.length,
              reverse: true,
            )));
  }

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }

  formatMessage(msg) {
    if (msg.toString().contains("Channel msg:")) {
      return Container(
          //height: 100,
          width: MediaQuery.of(context).size.width,
          //color: globals.appMainColor,
          child: Column(children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              //Container(width: 35.0),
              Material(
                child: Image.asset(
                  globals.loginUserType == "PATIENT"
                      ? "assets/doctor_defaultpic.png"
                      : "assets/patient_defaultpic.png",
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        msg.toString().replaceFirst("Channel msg:", ""),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        " " + DateFormat("H:m a").format(DateTime.now()),
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                //width: 250.0,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(left: 10.0),
              )
            ])
          ]));
    } else {
      return Container(
          //height: 100,
          //color: globals.appMainColor,
          child: Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Container(
            //height: 100,
            child: Row(
              children: <Widget>[
                Text(
                  msg.toString(),
                  style: TextStyle(color: primaryColor),
                ),
                Text(
                  " " + DateFormat("H:m a").format(DateTime.now()),
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                )
              ],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            //width: 250,

            decoration: BoxDecoration(
                color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
            //margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
            margin: EdgeInsets.only(bottom: false ? 20.0 : 10.0, right: 10.0),
          )
        ])
      ]));
    }
  }
}
