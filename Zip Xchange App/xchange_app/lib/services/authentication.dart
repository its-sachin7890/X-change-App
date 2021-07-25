import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String log = "AuthServcie -->";

  FirebaseAuth getFirebaseAuthInstance() {
    return _auth;
  }

  Future<dynamic> signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      print("User: " + log + " " + user.toString());
      return user;
    } catch (e) {
      print("Error: " + log + e.toString());
      return null;
    }
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Error: " + log + e.toString());
      return null;
    }
  }

  Future signupWithEmail(String email, String password,
      SnackBar pleaseWaitSnackBar, BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).showSnackBar(pleaseWaitSnackBar);
    print('IN SIGNUPWITHEMAIL & EMAIL: ' + email);
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await user.sendEmailVerification();
      print("User: " + log + " " + user.toString());
      return user;
    } catch (e) {
      print("Error: " + log + e.toString());
      return null;
    }
  }
}
