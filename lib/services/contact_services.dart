import 'package:chat_app/model/contact/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactService{
  static final contactData =
  FirebaseFirestore.instance.collection('users').withConverter<Contact>(
    fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()!),
    toFirestore: (contact, _) => contact.toJson(),
  );

  Future<void> addUser(String? uid, String? username) async {
    return contactData.add(
      Contact(uid: uid ?? '', username: username ?? ''),
    ).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

}
