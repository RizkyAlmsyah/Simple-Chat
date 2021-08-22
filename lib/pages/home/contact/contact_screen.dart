import 'package:chat_app/pages/home/contact/list_contact_widget.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Choose Contact'),
            backgroundColor: Colors.deepPurple,
          ),
          body: Container(
            child: list_contact_widget(),
          ),
        );
      }
  }

