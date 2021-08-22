import 'package:chat_app/model/theuser/theuser.dart';
import 'package:chat_app/pages/authenticate/login/login_screen.dart';
import 'package:chat_app/pages/authenticate/register/register_screen.dart';
import 'package:chat_app/pages/authenticate/toggle.dart';
import 'package:chat_app/pages/connectivity.dart';
import 'package:chat_app/pages/home/contact/contact_screen.dart';
import 'package:chat_app/pages/home/home_screen.dart';
import 'package:chat_app/pages/home/message/message_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Toggle>.value(value: Toggle()),
      StreamProvider<TheUser?>.value(
        value: AuthService().onAuthStateChanged,
        initialData: null,
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Connectivity(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginScreen(),
        '/home': (BuildContext context) => new HomeScreen(),
        '/register': (BuildContext context) => new RegisterScreen(),
        '/contact': (BuildContext context) => new ContactScreen(),
        '/message': (BuildContext context) => new MessageScreen(),
      },
    );
  }
}
