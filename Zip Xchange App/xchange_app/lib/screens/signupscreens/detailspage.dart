import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xchange_app/services/authentication.dart';
import 'package:xchange_app/services/database.dart';

import '../../constants.dart';

class DetailsPage extends StatefulWidget {
  final String phone;
  DetailsPage(this.phone);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String phone = '';

  AuthService _auth;
  DatabaseService _databaseService;

  _validation(scaffoldContext) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _firstName = _firstName.trim();
    _lastName = _lastName.trim();
    _email = _email.trim();
    _password = _password.trim();
    _confirmPassword = _confirmPassword.trim();
    print("Email: " + _email);

    final lengthSnackBar = SnackBar(
      content: Text(
        'Password must be at least 6 characters',
      ),
      backgroundColor: Colors.red[600],
    );

    final mismatchSnackBar = SnackBar(
      content: Text(
        'Password does not match',
      ),
      backgroundColor: Colors.red[600],
    );

    final emailSnackBar = SnackBar(
      content: Text(
        'Invalid email or email already in use',
      ),
      backgroundColor: Colors.red[600],
    );

    final nameSnackBar = SnackBar(
      content: Text(
        'Please enter first name and last name',
      ),
      backgroundColor: Colors.red[600],
    );
    final successSnackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(
        'Sign up successful. Please verify your email to login.',
      ),
      backgroundColor: Colors.greenAccent,
    );
    final pleaseWaitSnackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(
        'Please wait... ',
      ),
      backgroundColor: Colors.greenAccent,
    );

    if (_password.length < 6)
      Scaffold.of(scaffoldContext).showSnackBar(lengthSnackBar);
    else if (_password != _confirmPassword)
      Scaffold.of(scaffoldContext).showSnackBar(mismatchSnackBar);
    else if (_firstName.isEmpty || _lastName.isEmpty) {
      Scaffold.of(scaffoldContext).showSnackBar(nameSnackBar);
    } else if (await _auth.signupWithEmail(
            _email, _password, pleaseWaitSnackBar, scaffoldContext) !=
        null) {
      await _auth.signOut();
      await _databaseService.registerUser(_firstName, _lastName, _email, phone);
      print("EXECUTED");
      Scaffold.of(scaffoldContext).showSnackBar(successSnackBar);
      Timer(Duration(seconds: 3), () {
        _firstName = '';
        _lastName = '';
        _email = '';
        _password = '';
        _confirmPassword = '';
        phone = '';
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    } else {
      Scaffold.of(scaffoldContext).showSnackBar(emailSnackBar);
    }
  }

  Widget _firstNameSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          setState(() {
            _firstName = text;
          });
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'First Name',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _lastNameSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          setState(() {
            _lastName = text;
          });
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Last Name',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

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
            Icons.email,
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

  Widget _passwordSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        obscureText: true,
        onChanged: (text) {
          setState(() {
            _password = text;
          });
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.lock_open,
            color: Colors.white,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Password',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _passwordConfirmationSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        obscureText: true,
        onChanged: (text) {
          setState(() {
            _confirmPassword = text;
          });
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Confirm Password',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _signupButton(BuildContext context, BuildContext scaffoldContext) {
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
          onPressed: () => _validation(scaffoldContext),
          child: Text(
            'SIGN UP',
            style: TextStyle(
              color: Color(0xFF2D7DD2),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _databaseService = DatabaseService();
    phone = widget.phone;
    print('PHONE: ' + phone);
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
              padding: const EdgeInsets.only(top: 27.0),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Subtracting 27 from it so as to fix the Padding of 24.0 from the top
                    minHeight: MediaQuery.of(context).size.height - 27.0,
                  ),
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
                      _firstNameSetup(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _lastNameSetup(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _emailSetup(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _passwordSetup(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _passwordConfirmationSetup(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _signupButton(context, scaffoldContext),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
