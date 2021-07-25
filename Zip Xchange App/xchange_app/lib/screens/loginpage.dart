import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xchange_app/screens/homepage.dart';
import 'package:xchange_app/screens/resetpasspage.dart';
import 'package:xchange_app/screens/signupscreens/signuppage.dart';
import 'package:xchange_app/services/authentication.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService _auth;

  String _email = "";
  String _password = "";

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
            Icons.lock,
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

  Widget _forgotPassword(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ResetPassPage();
            },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            'Forgot Password?',
            style: Constants.labelStyle,
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context, BuildContext scaffoldContext) {
    final wrongCredSnackBar = SnackBar(
      content: Text(
        'Wrong Credentials',
      ),
      backgroundColor: Colors.red[600],
    );

    final verifyEmailSnackBar = SnackBar(
      content: Text(
        'Please verify your email',
      ),
      backgroundColor: Colors.red[600],
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
            var user =
                await _auth.signInWithEmail(_email.trim(), _password.trim());

            if (user == null) {
              Scaffold.of(scaffoldContext).showSnackBar(wrongCredSnackBar);
            } else if (user != null && user.isEmailVerified) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomePage(user, 1);
                  },
                ),
              );
            } else if (!user.isEmailVerified) {
              Scaffold.of(scaffoldContext).showSnackBar(verifyEmailSnackBar);
              _auth.signOut();
            }
          },
          child: Text(
            'LOGIN',
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

  Widget _signup(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SignupPage();
            },
          ),
        ),
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
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
              padding: const EdgeInsets.only(
                top: 28.0,
              ),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                ),
                child: Stack(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 28.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign In',
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
                            height: 20.0,
                          ),
                          _passwordSetup(),
                          _forgotPassword(context),
                          _loginButton(context, scaffoldContext),
                        ],
                      ),
                    ),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _signup(context))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
