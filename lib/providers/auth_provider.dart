import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_mon/model/my_user.dart';

class AuthProvider extends ChangeNotifier {
  MyUser? currentUser;

  void updateUser(MyUser newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
