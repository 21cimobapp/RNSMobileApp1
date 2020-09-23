import 'package:ciPatientApp/startscreen.dart';
import 'package:flutter/material.dart';
import 'package:ciPatientApp/providers/countries.dart';
import 'package:ciPatientApp/providers/phone_auth.dart';
//import 'package:intro_slider/intro_slider.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:ciPatientApp/startscreen.dart';
//import 'package:ciPatientApp/intro_slider.dart';
import 'package:ciPatientApp/theme.dart';
import 'package:ciPatientApp/custom_theme.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ciPatientApp/globals.dart' as globals;
import 'package:ciPatientApp/src/utils/settings.dart';

//void main() => runApp(MyApp());

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();

  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT1,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CountryProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PhoneAuthDataProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Video Connect App',
          theme: CustomTheme.of(context),
          home: StartScreen(),
        )
        //home :HomePageNew(),

        );
  }
}
