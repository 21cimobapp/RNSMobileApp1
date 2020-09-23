import 'dart:convert';
import 'package:ciPatientApp/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}
/* public static string getLastNameCommaFirstName(String fullName) {
    List<string> names = fullName.split(' ').toList();
    String firstName = names.First();
     names.removeAt(0);

    return String.Join(" ", names.ToArray()) + ", " + firstName;            
} */

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<String> _statecodes = <String>['', '+91', '+1', '+246', '+55', '+61'];
  String _statecode = '';

  Contact newContact = new Contact();

  final TextEditingController controller = TextEditingController();

  final TextEditingController mobileNumController = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  // string[] names = newContact.Name.split(' ');

  // String fullName = "Adrian Rules";
  // var names='';
  /*  String Name='';
  var names = Name.split(' ');
string firstName = names[0];
string lastName = names[1]; 
  */
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _controller = new TextEditingController();
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  String _selectionSalutation;
  List data2 = List();
  saluationData() async {
    String url = "http://www.21ci.com/MobileAppEx/Master/GetMaster";
    var response = await http.post(url, body: {
      "masterDataType": "SALUTATION",
      "saluation": "$_selectionSalutation",
    });
    var extractdata = jsonDecode(response.body)['Salutation'];
    setState(() {
      data2 = extractdata;
    });
    print(extractdata);
  }

  @override
  void initState() {
    super.initState();
    // this.getSWData();
    saluationData();
  }

  List gender = ["Female", "Male"];
  String select;
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              // print(value);

              newContact.GenderCode = value;
              //  _statecode = newValue;
              select = value;
              // state.didChange(newValue);
            });
          },
        ),
        Text(title)
      ],
    );
  }

  ////validation
  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
    return regex.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  ///submit form

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('identity: ${newContact.SalutationCode}');
      print('Name: ${newContact.FirstName.split(" ")}');
      print('Gender: ${newContact.GenderCode}');
      print('Dob: ${newContact.DateOfBirth}');
      print('Phone: ${newContact.MobileNumber}');
      print('Email: ${newContact.EmailID}');

      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      var contactService = new ContactService();

      contactService.createContact(newContact).then((value) =>
          // showMessage('New contact created for ${value.extractdata}!', Colors.blue)
          //showMessage('New contact created for', Colors.blue)

          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                    title: "Success",
                    description:
                        "You are registred successfully. Please login with your Mobile Number",
                    buttonText: "Okay",
                  )));

      Navigator.pop(context);
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: new Text("New Patient Registration"),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
            key: _formKey,
            //autovalidate: true,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                /*  Text(
              '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ), */
                new FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        //icon: const Icon(Icons.location_city),
                        //  icon: const Icon(Icons.domain),
                        icon: const Icon(Icons.person_outline),
                        hintText: 'Title',

                        errorText: state.hasError ? state.errorText : null,
                      ),
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          items: data2.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['Salutation_Name']),
                              value: item['Salutation_Code'].toString(),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              newContact.SalutationCode = newVal;
                              _selectionSalutation = newVal;
                              state.didChange(newVal);
                            });
                          },
                          value: _selectionSalutation,
                        ),
                      ),
                    );
                  },
                  validator: (val) {
                    return val != '' ? null : 'Please select a salutation';
                  },
                ),
                SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your name',
                    labelText: 'Full Name',
                  ),
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  validator: (val) => val.isEmpty ? 'Name is required' : null,
                  onSaved: (val) => newContact.FirstName = val,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Text("Gender"),
                    SizedBox(
                      width: 10,
                    ),
                    addRadioButton(0, 'Female'),
                    addRadioButton(1, 'Male'),
                    //addRadioButton(2, 'Others'),
                  ],
                ),
                SizedBox(height: 20.0),
                new Row(children: <Widget>[
                  new Expanded(
                      child: new TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Enter your date of birth',
                      labelText: 'Date of Birth',
                    ),
                    controller: _controller,
                    keyboardType: TextInputType.datetime,
                    validator: (val) =>
                        isValidDob(val) ? null : 'Not a valid date',
                    onSaved: (val) =>
                        newContact.DateOfBirth = convertToDate(val),
                  )),
                  new IconButton(
                    icon: new Icon(Icons.more_horiz),
                    tooltip: 'Choose date',
                    onPressed: (() {
                      _chooseDate(context, _controller.text);
                    }),
                  )
                ]),
                SizedBox(height: 20.0),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    newContact.MobileNumber = number.phoneNumber;
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  ignoreBlank: false,
                  autoValidate: false,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: mobileNumController,
                  inputBorder: OutlineInputBorder(),
                ),
                SizedBox(height: 20.0),
                //       new Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: <Widget>[
                //           //new Expanded(
                //           Container(
                //             width: 120.0,
                //             child: new FormField<String>(
                //               builder: (FormFieldState<String> state) {
                //                 return InputDecorator(
                //                   decoration: InputDecoration(
                //                     //icon: const Icon(Icons.location_city),
                //                     //  icon: const Icon(Icons.domain),
                //                     icon: const Icon(Icons.phone),
                //                     hintText: 'Country',

                //                     errorText:
                //                         state.hasError ? state.errorText : null,
                //                   ),
                //                   isEmpty: _statecode == '',
                //                   child: new DropdownButtonHideUnderline(
                //                     child: new DropdownButton<String>(
                //                       value: _statecode,
                //                       isDense: true,
                //                       onChanged: (String newValue) {
                //                         setState(() {
                //                           newContact.scode = newValue;
                //                           _statecode = newValue;
                //                           state.didChange(newValue);
                //                         });
                //                       },
                //                       items: _statecodes.map((String value) {
                //                         return new DropdownMenuItem<String>(
                //                           value: value,
                //                           child: new Text(value),
                //                         );
                //                       }).toList(),
                //                     ),
                //                   ),
                //                 );
                //               },
                //               /*  validator: (val) {
                //   return val != '' ? null : 'state';
                // }, */
                //             ),
                //           ),

                //           Container(
                //             width: 200.0,
                //             child: new TextFormField(
                //               decoration: const InputDecoration(
                //                 //icon: const Icon(Icons.phone),
                //                 hintText: 'Mobile number',
                //                 //labelText: 'Mobile Number',
                //               ),
                //               keyboardType: TextInputType.phone,
                //               inputFormatters: [
                //                 new WhitelistingTextInputFormatter(
                //                     new RegExp(r'^[()\d -]{1,15}$')),
                //               ],
                //               validator: (value) => isValidPhoneNumber(value)
                //                   ? null
                //                   : 'must be 10 digit',
                //               // : 'Phone number must be 10 digit entered as(##)####-#### ',
                //               onSaved: (val) => newContact.MobileNumber = val,
                //             ),
                //           ),
                //         ],
                //       ),
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: 'Enter a email address',
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => isValidEmail(value)
                      ? null
                      : 'Please enter a valid email address',
                  onSaved: (val) => newContact.EmailID = val,
                ),
                SizedBox(height: 20.0),
                new Container(
                    //padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                    child: new RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: const Text('Register'),
                  onPressed: _submitForm,
                )),
              ],
            )),
      ),
    );
  }
}

class ContactService {
  static const _serviceUrl =
      'http://www.21ci.com/MobileAppEx/Patient/RegisterPatient';
  static final _headers = {'Content-Type': 'application/json'};

  // Future<Contact> createContact(Contact contact) async {
  createContact(Contact contact) async {
    //  createContact() async {
    //  Contact contact;
    try {
      String json = _toJson(contact);
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);
      // var c1 = (response.body);
      //print(c1);
      //Future<var> _calculation =response.body;
      //return c;
      // var c = _fromJson(response.body);
      // print(c);
      //  return c;
      var extractdata = jsonDecode(response.body)['msg'];
      print(extractdata);
      return extractdata;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  Contact _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json); //JSON.decode(json);
    var contact = new Contact();
    contact.TokenKey = map['TokenKey'];
    contact.SalutationCode = map['SalutationCode'];

    /// copy same name as excl sheet insted of e.d ident
    contact.FirstName = map['FirstName'];
    contact.OtherName = map['OtherName'];
    contact.LastName = map['LastName'];
    contact.DateOfBirth = map['DateOfBirth'];
    contact.DateOfBirth =
        new DateFormat('dd-MM-yyyy').parseStrict(map['DateOfBirth']);
    // contact.DateOfBirth = new DateFormat.yMd().parseStrict(map['DateOfBirth']);
    contact.MobileNumber = map['MobileNumber'];
    contact.EmailID = map['EmailID'];
    contact.GenderCode = map['GenderCode'];
    contact.Address1 = map['Address1'];
    contact.Address2 = map['Address2'];
    contact.CityCode = map['CityCode'];
    contact.StateCode = map['StateCode'];
    contact.PinCode = map['PinCode'];
    contact.ProfileImage = map['ProfileImage'];
    contact.RelationCode = map['RelationCode'];
    return contact;
  }

  String _toJson(Contact contact) {
    var mapData = new Map();
    mapData["TokenKey"] = contact.TokenKey;
    mapData["SalutationCode"] = contact.SalutationCode;
    mapData["FirstName"] = contact.FirstName;
    mapData["OtherName"] = contact.OtherName;
    mapData["LastName"] = contact.LastName;
    mapData["DateOfBirth"] = contact.DateOfBirth;
    mapData["DateOfBirth"] =
        new DateFormat('dd-MMM-yyyy').format(contact.DateOfBirth);
    //mapData["DateOfBirth"] = new DateFormat.yMd().format(contact.DateOfBirth);
    mapData["MobileNumber"] = contact.MobileNumber;
    mapData["EmailID"] = contact.EmailID;
    mapData["GenderCode"] = contact.GenderCode;
    mapData["Address1"] = contact.Address1;
    mapData["Address2"] = contact.Address2;
    mapData["CityCode"] = contact.CityCode;
    mapData["StateCode"] = contact.StateCode;
    mapData["PinCode"] = contact.PinCode;
    mapData["ProfileImage"] = contact.ProfileImage;
    mapData["RelationCode"] = contact.RelationCode;
    String json = jsonEncode(mapData); //JSON.encode(mapData);
    return json;
  }
}

class Contact {
  String TokenKey = '';
  String SalutationCode;
  String FirstName;
  String OtherName;
  String LastName;
  DateTime DateOfBirth;
  String MobileNumber;
  String EmailID;
  String GenderCode = '';
  String Address1 = '';
  String Address2 = '';
  String CityCode = '';
  String StateCode = '';
  String PinCode = '';
  String ProfileImage = '';
  String scode = '';
  String age = '';
  String RelationCode = '';
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
