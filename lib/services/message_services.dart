import 'package:cloud_firestore/cloud_firestore.dart';

class MessageServices {
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<String> sendConversationMessage(String chatRoomId, messageMap) async {
    String code = "";
    try{
      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(chatRoomId)
          .collection("messages")
          .add(messageMap);
      return code = "Success";
    }catch(e){
      return code = e.toString();
    }
  }
}
