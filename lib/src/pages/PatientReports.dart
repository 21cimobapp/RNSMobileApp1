import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ciPatientApp/data_models/PatientReportServices.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ciPatientApp/globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:math';
import 'package:mailer/smtp_server.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../mail.dart';

//import 'package:' as globals;

//Uint8List _bytesImage;
//String ImageData;
//Uint8List _bytesImage=Base64Decoder().convert(ImageData);

class PatientReports extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PatientReportsState();
}

class _PatientReportsState extends State<PatientReports> {
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Patient Reports");
  //String ImageData;

  List<PatientReportServices> _notes = List<PatientReportServices>();
  List<PatientReportServices> filterednotes = List<PatientReportServices>();
  bool issearching = false;

//  var dio=Dio();
File maildirectory;

  Future<List<PatientReportServices>> apiData() async {
    String url =
        "http://43.252.88.147/RNSMobAppAPI/PatientReport/mapp_PatientReports";
    print("PersonCode : ${globals.personCode}");
    var response = await http.post(url, body: {
      "PatientCode": globals.personCode,
      "DateType": "ALL",
    });
    var notes = List<PatientReportServices>();
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body)['patientReports'];
      for (var notejson in notesJson) {
        notes.add(PatientReportServices.fromJson(notejson));
      }
    }
    return notes;
  }

//String _mySelection;
//Widget txt;
  // List data = List();
  // apipdfData() async {
  //   String url = "http://www.21ci.com/MobileAppEx/Report/mapp_ViewAttachment";
  //   var response = await http.post(url, body: {
  //     "type": "REPORT",
  //     "serviceRenderNumber": "ABCRR200000014",
  //   });
  //   var extractdata = jsonDecode(response.body)['Attachment'];
  //   setState(() {
  //     data = extractdata;
  //     // txt=Text(data);
  //   });
  //   print(extractdata);
  // }

//Uint8List.fromList(filterednotes);
//String ImageData;
//Uint8List _bytesImage=Base64Decoder().convert(ImageData);

/*Future<List<DocParameter>> apiData() async {
  String url = "http://7b68e60e.ngrok.io/api/DefaultAPI/GetDocDetails";
  var response = await http.get(url);
  var notes = List<DocParameter>();
  if (response.statusCode == 200) {
    var notesJson = json.decode(response.body);
   //  ImageData = base64.encode(response.bodyBytes);
    for (var notejson in notesJson) {
      notes.add(DocParameter.fromJson(notejson));
    }
  }
  return notes;
}*/
  @override
  void initState() {
    apiData().then((value) {
      setState(() {
        _notes.addAll(value);
        filterednotes.addAll(value);
        getPermission();
      });
    });

    //apipdfData();
    super.initState();
  }
  void getPermission() async{
    print("getPermission");
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  }
  @override
  Widget build(BuildContext context) {
    /* if (ImageData == null)
      return new Container();
    Uint8List bytes = base64.decode(ImageData);
 */
    return Scaffold(
        appBar: AppBar(
          elevation: 20.0,
          backgroundColor: Theme.of(context).primaryColor,
          title: cusSearchBar,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                setState(() {
                  if (this.cusIcon.icon == Icons.search) {
                    this.issearching = true;
                    filterednotes = _notes;
                    this.cusIcon = Icon(Icons.cancel);
                    this.cusSearchBar = TextField(
                      textInputAction: TextInputAction.go,
                      decoration: new InputDecoration(
                        hintText: 'Search here...',
                      ),
                      onChanged: (string) {
                        setState(() {
                          filterednotes = _notes
                              .where((n) => (n.ServiceName.toLowerCase()
                                  .contains(string.toLowerCase())))
                              .toList();
                        });
                      },
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    );
                  } else {
                    this.issearching = false;
                    filterednotes = _notes;
                    this.cusIcon = Icon(Icons.search);
                    this.cusSearchBar = Text("Patient Reports");
                  }
                });
              },
              icon: cusIcon,
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: filterednotes.length,
            itemBuilder: (BuildContext context, int i) => ListTile(
                // leading: Container(

                //     decoration: BoxDecoration(
                //       border: Border.all(color: globals.appMainColor, width: 1),
                //       color: Colors.white,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Icon(Icons.play_arrow)),
                title: Text(
                  filterednotes[i].ServiceName,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    //color: globals.appMainColor
                  ),
                ),
                subtitle: Text(
                  DateFormat('dd MMM yyyy')
                      .format(filterednotes[i].ServiceRequestDate),
                  style: TextStyle(fontSize: 14.0, color: Colors.grey.shade700),
                ),
                trailing: Container(
                    child:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      constraints: BoxConstraints.tight(Size.fromWidth(50)),
                      icon: Image.asset(
                        'assets/images/PDFFile.png',
                        fit: BoxFit.cover,
                      ),
                      tooltip: "Chat",
                      color: Colors.white,
                      onPressed: () =>
//                          {showPDF(filterednotes[i].ServiceRqstNumber)},
                          {showPDFnew(filterednotes[i].AttachmentContent)},
                    ),
                  ),
                          SizedBox(width: 10,),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor, width: 1),
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child:
                            IconButton(
                              constraints: BoxConstraints.tight(Size.fromWidth(50)),
//                              icon: Image.asset(
//                                'assets/images/downloadarrow.png',
//                                fit: BoxFit.cover,
//                              ),
                              icon: Icon(Icons.file_download),
                              tooltip: "Chat",
                              color: Colors.white,
                              
                              onPressed: () async{
                          
                                //shareFile();
//              String path2=
//               await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
//               String fullPath="$path2/mytask.pdf";
//               download2(dio, filterednotes[i].ServiceRenderNumber, fullPath);
//                         print(filterednotes[i].ServiceRenderNumber);
//                         _printDocument();
//                              data(filterednotes[i].ServiceRqstNumber);
                              download(filterednotes[i].AttachmentContent);
//                              Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text('Download Successful'),
//                      duration: Duration(seconds: 3),
//                    )
//                              );
                              },
                              
                            ),
                          ),
                           //  SizedBox(width: 10,),
                          // Container(
                          //   height: 50,
                          //   width: 50,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //         color: Theme.of(context).primaryColor, width: 1),
                          //     color: Colors.green,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child:
                          //   IconButton(
                          //     constraints: BoxConstraints.tight(Size.fromWidth(50)),
                          //     icon: Icon(Icons.mail),
                          //     tooltip: "mail",
                          //     color: Colors.white,
                          //     onPressed: () async{
                          //     mail();
                          //     },
                          //   ),
                          // )
                ]
                        )
                )

            )

        )
        // itemBuilder: (context, index) {
        //   return new GestureDetector(
        //     child:

        //     Container(
        //       child: Card(
        //           elevation: 10.0,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(15.0),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.only(
        //                 top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
        //             child: Row(children: <Widget>[

        //               Column(

        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   SizedBox(width: 100),
        //                   Text(
        //                     filterednotes[index].ServiceName,
        //                     style: TextStyle(
        //                         fontSize: 18.0,
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.purple),
        //                   ),
        //                   Text(
        //                     filterednotes[index].ServiceRenderDate,
        //                     style: TextStyle(
        //                         fontSize: 14.0, color: Colors.grey.shade700),
        //                   ),
        //                 ],
        //               ),

        //               Column(
        //                 children: <Widget>[
        //                   IconButton(
        //                     icon: Image.asset(
        //                       'assets/images/PDFFile.png',
        //                       fit: BoxFit.cover,
        //                     ),
        //                     onPressed: () {
        //                       showPDF(filterednotes[index].ServiceRenderNumber);
        //                     },
        //                   ),
        //                 ],
        //               )
        //             ]),
        //           )),
        //     ),
//           onTap: () {
//
//    },
        //   );
        // },

        //) // This trailing comma makes auto-formatting nicer for build methods.
        );

  }


  Future<String> data(serviceRendrNumber) async {
    print("downlod");
    File file;
    String url = "http://43.252.88.147/RNSMobAppAPI/Report/mapp_ViewAttachment";
    http.Response response = await http.post(url, body: {
      "serviceRenderNumber": "$serviceRendrNumber",
      "type": "REPORT",
    }
    );
    var extractdata = jsonDecode(response.body)["Attachment"];
    if (extractdata != null && extractdata[0] != null) {
      var bytes = base64Decode(extractdata[0]['FileContent']);

      var dir =  await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
      // file = File("${dir}/${extractdata[0]['FileName']}.pdf");
//      file = File("${dir}/${getRandomString(10)}.pdf");
      file = File("${dir}/${globals.personName}_${extractdata[0]['FileName']}.pdf");
//       await file.writeAsBytes(bytes);
      File f1=await file.writeAsBytes(bytes);
      if(f1 != null){
        print('downlod successfully..!');
//                 Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text('Download Successfully..!'),
//                      duration: Duration(seconds: 3),
//                    ));
        Fluttertoast.showToast(
            msg: "Downloaded Successfully..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

      print('${dir}');
    }
  }
  int i =1;
  Future<String> download(attachment) async {
    print("downlod");
    File file;

      var bytes = base64Decode(attachment);
      var dir =  await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

      file = File("${dir}/${globals.personName}_$i.pdf");
      i++;

      File f1=await file.writeAsBytes(bytes);
      if(f1 != null){
        print('downlod successfully..!');
        Fluttertoast.showToast(
            msg: "Downloaded Successfully..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
  }

  showPDF(serviceRendrNumber) async {
    File file;
    String url = "http://43.252.88.147/RNSMobAppAPI/Report/mapp_ViewAttachment";
    try {
      //var data = await http.get(url);
      var response = await http.post(url, body: {
        "serviceRenderNumber": "$serviceRendrNumber",
        "type": "REPORT",
      });
//      String url = "http://43.252.88.147/RNSMobAppAPI/Report/mapp_ViewAttachment";
//      try {
//        //var data = await http.get(url);
//        var response = await http.post(url, body: {
//          "serviceRenderNumber": "$serviceRendrNumber",
//          "type":"",
//          "serviceRqstNumber":"",
//        });

      var extractdata = jsonDecode(response.body)['Attachment'];
      if (extractdata != null && extractdata[0] != null) {
        var bytes = base64Decode(extractdata[0]['FileContent']);
        var dir = await getApplicationDocumentsDirectory();
//        var dir = await getDownloadsDirectory();
//        file = File("${dir.path}/${extractdata[0]['FileName']}");
        file = File("${dir.path}/${globals.personName}_${extractdata[0]['FileName']}.pdf");
        // maildirectory = file;
        await file.writeAsBytes(bytes);

      }
    } catch (e) {
      //throw Exception("Error opening url file");
    }
    if (file != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(path: file.path,pdf:file ),
        ),
      );
    }
  }

  showPDFnew(attachment) async{
    File file;
    var bytes = base64Decode(attachment);
    var dir = await getApplicationDocumentsDirectory();
    file = File("${dir.path}/${globals.personName}_1.pdf");
    i++;
    // maildirectory = file;
    await file.writeAsBytes(bytes);
    if (file != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(path: file.path,pdf:file ),
        ),
      );
    }
  }

  onTapped(int position) {
    var a = _notes[position].ServiceName;
    print("Name:" + a);

    var b = _notes[position].ServiceRenderDate;
    var c = filterednotes[position].ServiceRenderNumber;
    print("Name:" + c);

    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
//      onPressed: () {
//        Navigator.pop(context); Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text('Download Successful'),
//                      duration: Duration(seconds: 3),
//                    ));
//      },
    );

    var alertDialog = Theme(
        data: Theme.of(context)
            .copyWith(dialogBackgroundColor: Colors.orangeAccent),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Report Details!",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          contentPadding: EdgeInsets.all(30.0),
          content: Text(
            'Name:$a, \REnder Date:$b  '

            //"Name:"+a
            ,
            maxLines: 100,
            style: TextStyle(fontSize: 22.0, color: Colors.white),
          ),
          actions: [
            okButton,
          ],
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
    print('Card $position tapped');
  }
}

class PDFScreen extends StatefulWidget {
  final String path;
  final File pdf;
  PDFScreen({Key key, this.path, this.pdf}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
 
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
//   mail() async {
//  // https://support.google.com/accounts/answer/6010255?p=lsa_blocked&hl=en&visit_id=637166894705530050-3789727984&rd=1
  
//   String username = 'rnsmobileapp@gmail.com'; //Your Email;
//   String password = 'rns@Admin123'; //Your Email's password;
//   // ignore: deprecated_member_use
//   final smtpServer = gmail(username, password); 
 
  
 
//   final message = Message()
//     ..from = Address(username)
//     ..recipients.add('ambpab96@gmail.com') //recipent email
//     //..ccRecipients.addAll(['anjalihali9@gmail.com', 'anjalihali9@gmail.com']) //cc Recipents emails
//     //..bccRecipients.add(Address('anjalihali9@gmail.com')) //bcc Recipents emails
//     ..subject = 'Your Appointment Details ${DateTime.now()}'
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

  List<PatientReportServices> _notes = List<PatientReportServices>();
//  final imgUrl="/data/user/0/com.myapp.ciPatientApp/app_flutter/OS16000106 - ABCRR200000016.pdf";
//  final  imgUrl="${"widget.path"}";
//  final imgUrl="http://africau.edu/images/default/sample.pdf";

//  var dio=Dio();

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: globals.appMainColor,
        title: Text("${widget.path.split("/").last} - Document"),
        actions: <Widget>[
           IconButton(
                              constraints: BoxConstraints.tight(Size.fromWidth(50)),
                              icon: Icon(Icons.mail),
                              tooltip: "mail",
                              color: Colors.white,
                              onPressed: () async{
                    //           mail();
                    //            Scaffold.of(context).showSnackBar(SnackBar(
                    //   content: Text('Mail Sent '),
                    //   duration: Duration(seconds: 3),
                    // ));
                     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendEmail(pdf: widget.pdf,),
        ),
      );
                              },
                            ),
//            IconButton(
// //             icon: Icon(Icons.file_download),
// //             onPressed: () async{
// ////               shareFile();
// //               String path2=
// //               await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
// //               String fullPath="$path2/mytask.pdf";
// //               download2(dio,widget.path.split("/").last, fullPath);
// //               print("a");
// //               print(widget.path);
// //               print("b");
// //               print(widget.path.split("/").last);
// //             },
//              icon: Icon(Icons.file_download),
//             onPressed: () async{
// //              _printDocument();
// //             mail();
// //              data(_notes[index].ServiceRenderNumber);
//             data();
//             }
//            ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Page $currentPage of $pages)"),
              onPressed: () async {
                await snapshot.data.setPage(pages ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
//  void _printDocument(serviceRendrNumber) async{
////    Printing.layoutPdf(
////      onLayout: (pageFormat) {
////        final doc = pw.Document();
////
////        doc.addPage(
////          pw.Page(
////            build: (pw.Context context) => pw.Center(
////              child: pw.Text('Hello World!'),
////            ),
////          ),
////        );
////
////        return doc.save();
////      },
////    );
//    String url = "http://www.21ci.com/MobileAppEx/Report/mapp_ViewAttachment";
//      //var data = await http.get(url);
////      var response = await http.post(url, body: {
////        "serviceRenderNumber": "$serviceRendrNumber",
////        "type": "REPORT",
////      }
////      );
////    http.Response response = await http.get();
//////    print(widget.path);
////    var pdfData = response.bodyBytes;
////    await Printing.layoutPdf(onLayout: (PdfPageFormat ) async => pdfData);
////  }
//    http.Response response = await  http.post(url, body: {
//      "serviceRenderNumber": "$serviceRendrNumber",
//      "type": "REPORT",
//    }
//    );
////    print(widget.path);
//    var pdfData = response.bodyBytes;
//    await Printing.layoutPdf(onLayout: (PdfPageFormat ) async => pdfData);
//  }

 
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   getPermission();
  // }
  // void getPermission() async{
  //   print("getPermission");
  //   await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  // }
//   Future<String> data() async {
//     print("downlod");
//     File file;
//     String url = "http://43.252.88.147/RNSMobAppAPI/Report/mapp_ViewAttachment";
//     http.Response response = await http.post(url, body: {
//       "serviceRenderNumber": "RNCOP200024080",
//       "type": "REPORT",
//     }
//     );
//     var extractdata = jsonDecode(response.body)["Attachment"];
//     if (extractdata != null && extractdata[0] != null) {
//       var bytes = base64Decode(extractdata[0]['FileContent']);
// //      var dir = await getApplicationDocumentsDirectory();
//       var dir =  await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
//       file = File("${dir}/${extractdata[0]['FileName']}.pdf");
//       await file.writeAsBytes(bytes);
//       print('${dir}');
//     }
//   }
  // Future<List<PatientReportServices>> apiData() async {
  //   String url =
  //       "http://43.252.88.147/RNSMobAppAPI/PatientReport/mapp_PatientReports";
  //   print("PersonCode : ${globals.personCode}");
  //   var response = await http.post(url, body: {
  //     "PatientCode": globals.personCode,
  //     "DateType": "ALL",
  //   });
  //   var notes = List<PatientReportServices>();
  //   if (response.statusCode == 200) {
  //     var notesJson = json.decode(response.body)['patientReports'];
  //     for (var notejson in notesJson) {
  //       notes.add(PatientReportServices.fromJson(notejson));
  //     }
  //   }
  //   return notes;
  // }
//  Future download2(Dio dio,String url,String savePath) async{
//    try {
//      Response response = await dio.get(
//        url,
//        onReceiveProgress: showDownloadProgress,
//        options: Options(
//            responseType: ResponseType.bytes,
//            followRedirects: false,
//            validateStatus: (status) {
//              return status < 500;
//            }),
//      );
//      File file = File(savePath);
//      var raf = file.openSync(mode: FileMode.write);
//      raf.writeFromSync(response.data);
//      await raf.close();
//    }catch(e){
//      print("error is");
//      print(e);
//    }
//  }
//
//  void showDownloadProgress(received,total){
//    if(total != -1){
//      print((received / total * 100).toStringAsFixed(0) + "%");
//    }
//  }
//  shareFile() async {
//    await FlutterShare.shareFile(
//      title: 'Example share',
//      text: 'Example share text',
//      filePath: widget.path,
//    );
//  }
}
