import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_mon/auth/register/register_navigator.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  /// hold data - handle logic
  late RegisterNavigator navigator;

  void register(String email, String password) async {
    //todo: register with firebase auth
    // todo: show loading
    navigator.showMyLoading();
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // todo: hide loading
      navigator.hideMyLoading();
      // todo : show message
      navigator.showMyMessage('Register Successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // todo: hide loading
        navigator.hideMyLoading();
        // todo : show message
        navigator.showMyMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // todo: hide loading
        navigator.hideMyLoading();
        // todo : show message
        navigator.showMyMessage('The account already exists for that email.');
      }
    } catch (e) {
      // todo: hide loading
      navigator.hideMyLoading();
      // todo : show message
      navigator.showMyMessage(e.toString());
    }
  }
}
