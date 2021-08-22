import 'package:chat_app/model/theuser/theuser.dart';
import 'package:chat_app/services/contact_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //create singleton user for listening
  TheUser? _userFromFirebase(User? user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  //creating a stream for listening obj user
  Stream<TheUser?> get onAuthStateChanged =>
      auth.authStateChanges().map(_userFromFirebase);

  //
  Future<User?> reloadUser() async{
    User? user = await auth.currentUser;
    return user;
  }

  //register email & password
  Future<String> registrationEmail(String email, String password, String name) async {
    String code = "";
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user!.updateDisplayName(name);
      await ContactService().addUser(user.uid, name);
      return code = "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return code = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return code = 'The account already exists for that email.';
      }
    }
    return code;
  }

  Future<User> currentUser() async{
    User? user = await auth.currentUser;
    user!.reload();
    return user;
  }

  //login email & password
  Future<String> loginEmail(String email, String password) async {
    String code = "";
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return code = "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return code = 'User not found';
      } else if (e.code == 'wrong-password') {
        return code = 'Wrong password';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return code;
  }

  //login anonymous
  Future<void> loginAnoymous() async {
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      User? user = userCredential.user;
      _userFromFirebase(user);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future logout() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print("Error {$e}");
      return null;
    }
  }
}
