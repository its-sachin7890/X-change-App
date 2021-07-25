import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xchange_app/screens/signupscreens/detailspage.dart';

import 'package:xchange_app/services/authentication.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final AuthService _auth = AuthService();

  String phone = '', verificationId = '', smsCode = '';

  bool autoVerified = false;

  final verifiedSnackBar = SnackBar(
    duration: Duration(seconds: 2),
    content: Text(
      'Phone Number Verified',
    ),
    backgroundColor: Colors.greenAccent,
  );

  final otpSentSnackBar = SnackBar(
    duration: Duration(seconds: 2),
    content: Text(
      'OTP Sent',
    ),
    backgroundColor: Colors.greenAccent,
  );

  final invalidNumberSnackBar = SnackBar(
    content: Text(
      'Invalid Phone Number',
    ),
    backgroundColor: Colors.red[600],
  );

  final invalidOTPSnackBar = SnackBar(
    content: Text(
      'Invalid OTP',
    ),
    backgroundColor: Colors.red[600],
  );

  final enterOTPSnackBar = SnackBar(
    content: Text(
      'Enter OTP manually',
    ),
    backgroundColor: Colors.red[600],
  );

  Widget _phoneSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          phone = text;
        },
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.phone,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: '(+91)  Phone Number',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Widget _otpSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          smsCode = text;
        },
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Enter OTP',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.phone,
      ),
    );
  }

  void _navigateToDetailsPage(BuildContext context) {
    autoVerified = false;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return DetailsPage(phone.trim());
        },
      ),
    );
  }

  Future<void> verifyPhone(context, phone, scaffoldContext) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      print("PHONE NUMBER VERIFIED");
      autoVerified = true;
      Scaffold.of(scaffoldContext).showSnackBar(verifiedSnackBar);
      Timer(Duration(seconds: 3), () => _navigateToDetailsPage(context));
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print("SEND OTP ERROR: " + '${authException.message}');
      Scaffold.of(scaffoldContext).showSnackBar(invalidNumberSnackBar);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      Scaffold.of(scaffoldContext).showSnackBar(otpSentSnackBar);
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      Scaffold.of(scaffoldContext).showSnackBar(enterOTPSnackBar);
    };

    await _auth.getFirebaseAuthInstance().verifyPhoneNumber(
          phoneNumber: "+91" + phone,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout,
        );
  }

  Future<void> checkOTP(
      BuildContext context, BuildContext scaffoldContext) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (autoVerified) {
      return;
    }

    AuthCredential authResult = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode.trim());
    print("AUTH RESULT: " + authResult.toString());

    try {
      AuthResult result = await _auth
          .getFirebaseAuthInstance()
          .signInWithCredential(authResult);
      print("LOGGED IN");
      print(result);
      Scaffold.of(scaffoldContext).showSnackBar(verifiedSnackBar);
      Timer(Duration(seconds: 3), () => _navigateToDetailsPage(context));
      await result.user.delete();
    } catch (e) {
      print("CHECK: " + e.toString());
      Scaffold.of(scaffoldContext).showSnackBar(invalidOTPSnackBar);
    }
  }

  Widget _buttons(BuildContext context, BuildContext scaffoldContext) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 44.0,
              child: RaisedButton(
                elevation: 4.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () =>
                    verifyPhone(context, phone.trim(), scaffoldContext),
                child: Text(
                  'Send OTP',
                  style: TextStyle(
                    color: Color(0xFF2D7DD2),
                    letterSpacing: 1.5,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 44.0,
              child: RaisedButton(
                elevation: 4.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () => checkOTP(context, scaffoldContext),
                child: Text(
                  'NEXT',
                  style: TextStyle(
                    color: Color(0xFF2D7DD2),
                    letterSpacing: 1.5,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  //const Color(0xFF02A388),
                  //const Color(0xFF3BB78F),
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
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  _phoneSetup(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _otpSetup(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buttons(context, scaffoldContext),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
