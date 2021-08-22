import 'package:bubble/bubble.dart';
import 'package:chat_app/model/theuser/theuser.dart';
import 'package:chat_app/services/message_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageServices messageServices = new MessageServices();

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    final user = Provider.of<TheUser?>(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(args['username']),
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 46),
                child: buildMessages(args['chatroomid'], args['uid'])),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) => value!.isNotEmpty ? null: "Cannot send blank message",
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                        controller: messageController,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        if(messageController.text.isNotEmpty){
                          Map<String, dynamic> messageMap = {
                            'message': messageController.text,
                            'sendBy': user!.uid,
                            'sendTo': args['uid'],
                            'timestamp': DateTime.now().millisecondsSinceEpoch
                          };
                          String code =
                          await messageServices.sendConversationMessage(
                              args['chatroomid'], messageMap);
                          if (code == "Success") {
                            messageController.clear();
                          }
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildMessages(String chatroomid, uid) {
  return Container(
    child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chatroom")
            .doc(chatroomid)
            .collection("messages")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              reverse: true,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (snapshot.data!.docs[index]['sendBy'] == uid
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (snapshot.data!.docs[index]['sendBy'] == uid
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        snapshot.data!.docs[index]['message'],
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
                ;
              },
            );
          } else {
            return Container();
          }
        }),
  );
}

