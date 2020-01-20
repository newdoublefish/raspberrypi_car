import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DirectionButton extends StatefulWidget {
  final Icon icon;
  final String cmd;
  final BluetoothConnection connection;
  DirectionButton({Key key,this.icon, this.cmd,this.connection}):super(key:key);
  @override
  _DirectionButtonState createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<DirectionButton> {
  Color _backgroundColor;

  @override
  void initState() {
    _backgroundColor = Theme.of(context).accentColor;
    super.initState();
  }

  void _sendCmd(String text) async {
    text = text.trim();

    if (text.length > 0)  {
      try {
        print(text);
        widget.connection.output.add(utf8.encode(text + "\r\n"));
        await widget.connection.output.allSent;
      }
      catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: _backgroundColor,
        child: widget.icon,
        radius: 60,
      ),
      onTapDown: (detail){
        setState(() {
          _backgroundColor = Colors.grey;
        });

        _sendCmd(widget.cmd);
      },
      onTapUp: (detail){
        setState(() {
          _backgroundColor = Theme.of(context).accentColor;
        });
        _sendCmd("stop");
      },
    );
  }
}


class DirectionButton1 extends StatelessWidget {
  final Icon icon;
  final String cmd;
  final BluetoothConnection connection;
  DirectionButton1({this.icon, this.cmd,this.connection});

  void _sendCmd(String text) async {
    text = text.trim();

    if (text.length > 0)  {
      try {
        print(text);
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      }
      catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        child: this.icon,
        radius: 60,
      ),
      onTapDown: (detail){
        _sendCmd(this.cmd);
      },
      onTapUp: (detail){
        _sendCmd("stop");
      },
    );
  }
}

enum CarConnectStatus{
  DISCONNECTED,
  CONNECTING,
  CONNECTED,
}

class CarPage extends StatefulWidget {
  final BluetoothDevice server;
  CarPage({Key key, this.server}):super(key:key);
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  CarConnectStatus _carStatus = CarConnectStatus.CONNECTING;
  static final clientID = 0;
  static final maxMessageLength = 4096 - 3;
  BluetoothConnection connection;

  @override
  void dispose() {
    if(connection!=null){
      connection.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        _carStatus = CarConnectStatus.CONNECTED;
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      setState(() {
        _carStatus = CarConnectStatus.DISCONNECTED;
      });
    });
    super.initState();
  }


  String _getTitleName(CarConnectStatus status){
    if(status == CarConnectStatus.DISCONNECTED){
      return "${widget.server.name} 连接失败";
    }else if(status == CarConnectStatus.CONNECTING){
      return "${widget.server.name} 连接中....";
    }else if(status == CarConnectStatus.CONNECTED){
      return "${widget.server.name} 已经连接";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleName(_carStatus)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: DirectionButton(
              connection: connection,
              icon: Icon(Icons.keyboard_arrow_up),
              cmd:"up"
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DirectionButton(
                    connection: connection,
                  icon: Icon(Icons.keyboard_arrow_left),
                    cmd:"left"
                ),
                DirectionButton(
                    connection: connection,
                  icon: Icon(Icons.keyboard_arrow_right),
                    cmd:"right"
                ),
              ],
            ),
          ),
          Expanded(
            child: DirectionButton(
                connection: connection,
              icon: Icon(Icons.keyboard_arrow_down),
                cmd:"down"
            ),
          ),
        ],
      ),
    );
  }
}
