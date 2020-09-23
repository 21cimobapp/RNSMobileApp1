//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:io';

class SendEmail extends StatefulWidget {
  final String path;
  final File pdf;
  SendEmail({Key key, this.path, this.pdf}) : super(key: key);
  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  TextEditingController _entermailid = TextEditingController();
  

  mail() async {
    // https://support.google.com/accounts/answer/6010255?p=lsa_blocked&hl=en&visit_id=637166894705530050-3789727984&rd=1

    String username = 'rnsmobileapp@gmail.com'; //Your Email;
    String password = 'rns@Admin123'; //Your Email's password;
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      //..recipients.add('ambpab96@gmail.com') //recipent email
      ..recipients.add(_entermailid.text)
      //..ccRecipients.addAll(['anjalihali9@gmail.com', 'anjalihali9@gmail.com']) //cc Recipents emails
      //..bccRecipients.add(Address('anjalihali9@gmail.com')) //bcc Recipents emails
      ..subject = 'Your Lab Report'
      //..attachments.add(FileAttachment(${maildata(filterednotes[index].ServiceRenderNumber)}))
      // ..attachments.add(Attachment(file: File('${maildata(filterednotes[index].ServiceRenderNumber)}')))//subject of the email
      //  ..attachments.add( Attachment(file: maildirectory))
       ..attachments.add(FileAttachment(widget.pdf))
      //  ..attachments.add(Attachment(File:File(fileBits, fileName)))
      ..text = 'Kindly find attached lab report'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);

      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('sendReport');
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      e.toString(); // will show why the email is not sending

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Mail')),
      body: Center(
          child: Column(
        children: <Widget>[
          Text("Enter Receivers EmailID"),
          TextField(
            controller: _entermailid,
            // keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          // Text("Enter Subject"),
          // TextField(
          //   controller: _subjectController,
          //   // keyboardType: TextInputType.emailAddress,
          //   decoration: InputDecoration(
          //     hintText: 'Subject',
          //   ),
          // ),
          // Text("Enter Mail Body"),
          // TextField(
          //   controller: _bodyController,
          //   // keyboardType: TextInputType.emailAddress,
          //   decoration: InputDecoration(
          //     hintText: 'Message',
          //   ),
          // ),
          RaisedButton(
            child: Text('Send Email'),
            color: Colors.green,
            onPressed: () async {
              await mail();
             
              Navigator.pop(context);
               Navigator.pop(context);
              //  Scaffold.of(context).showSnackBar(SnackBar(
              //   content: Text('Mail Sent '),
              //   duration: Duration(seconds: 3),
              // ));
            },
          ),
        ],
      )),
    );
  }
}

// class SendEmail extends StatelessWidget {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _subjectController = TextEditingController();
//   TextEditingController _bodyController = TextEditingController();
//   // _sendEmail() async {
//   //   final String _email = 'mailto:' +
//   //       _emailController.text +
//   //       '?subject=' +
//   //       _subjectController.text +
//   //       '&body=' +
//   //       _bodyController.text;
//   //   try {
//   //     await launch(_email);
//   //   } catch (e) {
//   //     throw 'Could not Call Phone';
//   //   }
//   // }
//   mail() async {
//  // https://support.google.com/accounts/answer/6010255?p=lsa_blocked&hl=en&visit_id=637166894705530050-3789727984&rd=1

//   String username = 'rnsmobileapp@gmail.com'; //Your Email;
//   String password = 'rns@Admin123'; //Your Email's password;
//   // ignore: deprecated_member_use
//   final smtpServer = gmail(username, password);

//   final message = Message()
//     ..from = Address(username)
//     //..recipients.add('ambpab96@gmail.com') //recipent email
//     ..recipient.add(_emailController)
//     //..ccRecipients.addAll(['anjalihali9@gmail.com', 'anjalihali9@gmail.com']) //cc Recipents emails
//     //..bccRecipients.add(Address('anjalihali9@gmail.com')) //bcc Recipents emails
//     //..subject = 'Your Appointment Details ${DateTime.now()}'
//     ..subject = '${_subjectController()}'
//     //..attachments.add(FileAttachment(${maildata(filterednotes[index].ServiceRenderNumber)}))
//     // ..attachments.add(Attachment(file: File('${maildata(filterednotes[index].ServiceRenderNumber)}')))//subject of the email
//     //  ..attachments.add( Attachment(file: maildirectory))
//     ..attachments.add(FileAttachment(widget.pdf))
//    //  ..attachments.add(Attachment(File:File(fileBits, fileName)))
//   ..text = 'Your Appointment Details  .';  //body of the email

//   try {
//     final sendReport = await send(message, smtpServer);

//     print('Message sent: ' + sendReport.toString()); //print if the email is sent
//   } on MailerException catch (e) {
//     print('sendReport');
//     print('Message not sent. \n'+ e.toString()); //print if the email is not sent
//     e.toString();// will show why the email is not sending
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Call Phone from App Example')),
//       body: Center(
//           child: Column(
//         children: <Widget>[
//           TextField(
//             controller: _emailController,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Email',
//             ),
//           ),
//           TextField(
//             controller: _subjectController,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Subject',
//             ),
//           ),
//           TextField(
//             controller: _bodyController,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Message',
//             ),
//           ),
//           RaisedButton(
//             child: Text('Send Email'),
//             color: Colors.red,
//             onPressed: mail(),
//           ),
//         ],
//       )),
//     );
//   }
// }
