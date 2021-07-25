import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xchange_app/screens/homepage.dart';
import 'package:xchange_app/screens/loginpage.dart';
import 'package:xchange_app/services/authentication.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().user,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
            );
          }
          if (snapshot.data is FirebaseUser &&
              snapshot.data != null &&
              snapshot.data.isEmailVerified) {
            return HomePage(snapshot.data, 0);
          } else
            return LoginPage();
        });
  }
}
