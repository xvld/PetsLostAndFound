import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'widgets/PetList.widget.dart';
import 'package:location/location.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Varela',
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: MyHomePage(title: 'לוח אבידות ומציאות בעלי חיים'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> {
  final String title;
  Map<String, double> _currentLocation;
  Location _location = new Location();
  String error;

  _MyHomePageState(this.title);

  doNothing() => null;

  initPlatformState() async {
    Map<String, double> location;

    try {
      await _location.hasPermission();
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    setState(() {
      _currentLocation = location;
    });
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
                child: Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Text(this.title,
                        style:
                            TextStyle(fontSize: 25.0, color: Colors.green)))),
            Text(this._currentLocation.toString()),
            Expanded(child: PetList())
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: doNothing(),
        child: Icon(Icons.add),
      ),
    );
  }
}
