import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xchange_app/services/authentication.dart';

import '../constants.dart';

class ResetPassPage extends StatefulWidget {
  @override
  _ResetPassPageState createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  String _email = "";

  Widget _emailSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          setState(() {
            _email = text;
          });
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.account_box,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Email address',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _reset(BuildContext context, BuildContext scaffoldContext) {
    final invalidEmailSnackBar = SnackBar(
      content: Text(
        'Invalid email',
      ),
      backgroundColor: Colors.red[600],
    );

    final resetSnackBar = SnackBar(
      content: Text(
        'Reset link sent to your email',
      ),
      backgroundColor: Colors.greenAccent,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      width: double.infinity,
      child: SizedBox(
        height: 44.0,
        child: RaisedButton(
          elevation: 5.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () async {
            try {
              await AuthService()
                  .getFirebaseAuthInstance()
                  .sendPasswordResetEmail(email: _email.trim());
              Scaffold.of(scaffoldContext).showSnackBar(resetSnackBar);
            } catch (e) {
              print(e);
              Scaffold.of(scaffoldContext).showSnackBar(invalidEmailSnackBar);
            }
          },
          child: Text(
            'RESET',
            style: TextStyle(
              color: Color(0xFF2D7DD2),
              letterSpacing: 1.5,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (scaffoldContext) => GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2D7DD2),
                  const Color(0xFF02A388),
                ],
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 27.0, left: 25.0, right: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Reset Password',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  _emailSetup(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _reset(context, scaffoldContext),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
