import 'package:flutter/foundation.dart';

class Toggle extends ChangeNotifier{
  bool _isSignIn = true;

  bool get isSignIn => _isSignIn;

  void changeStatus(){
    _isSignIn = !_isSignIn;
    notifyListeners();
  }
}