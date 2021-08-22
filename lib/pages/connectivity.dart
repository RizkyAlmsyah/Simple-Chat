import 'package:chat_app/pages/offline/offline_screen.dart';
import 'package:chat_app/pages/wrapper.dart';
import 'package:chat_app/utils/Connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class Connectivity extends StatefulWidget {
  const Connectivity({Key? key}) : super(key: key);

  @override
  _ConnectivityState createState() => _ConnectivityState();
}

class _ConnectivityState extends State<Connectivity> {
  Map _source = {ConnectivityResult.none: false};
  final Connection _connection = Connection.instance;

  @override
  void initState() {
    super.initState();
    _connection.initialise();
    _connection.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        string = 'Mobile: Online';
        break;
      case ConnectivityResult.wifi:
        string = 'WiFi: Online';
        break;
      case ConnectivityResult.none:
      default:
        string = 'Offline';
    }
    return string == 'Offline' ? OfflineScreen() : Wrapper();
  }

  @override
  void dispose() {
    _connection.disposeStream();
    super.dispose();
  }

}
