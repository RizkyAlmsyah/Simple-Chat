import 'package:chat_app/pages/authenticate/login/login_screen.dart';
import 'package:chat_app/pages/authenticate/register/register_screen.dart';
import 'package:chat_app/pages/authenticate/toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  Widget build(BuildContext context) {
    //jancok 2 jam mahami provider
    Toggle _toggle = Provider.of<Toggle>(context);
    return _toggle.isSignIn ? LoginScreen() : RegisterScreen();
  }
}
