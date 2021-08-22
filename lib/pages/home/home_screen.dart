import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Chat",
          style: TextStyle(color: Colors.deepPurpleAccent),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await _auth.logout();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.deepPurpleAccent,
              ), iconSize: 25,)
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed('/contact');
        },
        child: Icon(Icons.message),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
