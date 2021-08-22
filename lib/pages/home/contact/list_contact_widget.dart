import 'package:chat_app/model/contact/contact.dart';
import 'package:chat_app/model/theuser/theuser.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/contact_services.dart';
import 'package:chat_app/services/message_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class list_contact_widget extends StatefulWidget {
  const list_contact_widget({
    Key? key,
  }) : super(key: key);

  @override
  _list_contact_widgetState createState() => _list_contact_widgetState();
}

class _list_contact_widgetState extends State<list_contact_widget> {

  @override
  Widget build(BuildContext context) {
    final theuser = Provider.of<TheUser?>(context);
    return StreamBuilder<QuerySnapshot<Contact>>(
        stream: ContactService.contactData
            .where("uid", isNotEqualTo: theuser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 60,
                    child: Center(
                      child: ListTile(
                        onTap: () async{
                          AuthService auth = new AuthService();
                          User user = await auth.currentUser();
                          String chatRoomId = createChatroomAndStartConverstion(data.docs[index], user);
                          Navigator.of(context).pushReplacementNamed('/message',
                              arguments: {
                                'uid': data.docs[index].data().uid,
                                'username': data.docs[index].data().username,
                                'chatroomid': chatRoomId,
                              });
                        },
                        title: Text(
                          data.docs[index].data().username,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}

String createChatroomAndStartConverstion(DocumentSnapshot document,User? user){
  MessageServices messageServices = new MessageServices();

  String chatRoomId = getChatRoomId(document['uid'], user!.uid);
  List<String> users = [document['username'], user.displayName ?? ''];
  print(user.displayName);
  Map<String, dynamic> chatRoomMap = {
    "users" : users,
    "chatroomid" : chatRoomId
  };
  messageServices.createChatRoom(chatRoomId, chatRoomMap);
  return chatRoomId;
}

getChatRoomId(String a, String b) {
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
    return "$b\_$a";
  }else {
    return "$a\_$b";
  }
}