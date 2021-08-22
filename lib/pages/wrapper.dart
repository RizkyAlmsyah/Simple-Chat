import 'package:chat_app/model/theuser/theuser.dart';
import 'package:chat_app/pages/authenticate/authenticate.dart';
import 'package:chat_app/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    return user == null ? Authenticate() : HomeScreen();
  }
}
