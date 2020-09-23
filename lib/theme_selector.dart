import 'package:flutter/material.dart';
import 'package:ciPatientApp/theme.dart';
import 'package:ciPatientApp/custom_theme.dart';

class ThemeSelector extends StatefulWidget {
  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Theme Selector"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _changeTheme(context, MyThemeKeys.LIGHT1);
                },
                child: Text("Green"),
              ),
              RaisedButton(
                onPressed: () {
                  _changeTheme(context, MyThemeKeys.LIGHT2);
                },
                child: Text("Purple"),
              ),
              RaisedButton(
                onPressed: () {
                  _changeTheme(context, MyThemeKeys.DARK);
                },
                child: Text("Dark"),
              ),
              RaisedButton(
                onPressed: () {
                  _changeTheme(context, MyThemeKeys.DARKER);
                },
                child: Text("Darker"),
              ),
              Divider(
                height: 100,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                color: Theme.of(context).primaryColor,
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
