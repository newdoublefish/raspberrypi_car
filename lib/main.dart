import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

import 'MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MainPage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class DirectionButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback callback;
  DirectionButton({this.icon, this.callback});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
        child: CircleAvatar(
          child: this.icon,
          radius: 60,
        ),
        onPressed: this.callback);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
//    gyroscopeEvents.listen((GyroscopeEvent event) {
//      print(event);
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("robot"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: DirectionButton(
              icon: Icon(Icons.arrow_upward),
              callback: (){

              },
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DirectionButton(
                  icon: Icon(Icons.arrow_upward),
                ),
                DirectionButton(
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),
          Expanded(
            child: DirectionButton(
              icon: Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),
    );
  }
}
