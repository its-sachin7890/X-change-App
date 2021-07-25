import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xchange_app/screens/traderhomepage.dart';
import 'package:xchange_app/screens/userhomepage.dart';
import 'package:xchange_app/services/database.dart';
import 'package:xchange_app/structures/trader.dart';
import 'package:xchange_app/structures/user.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final int fromLogin;
  HomePage(this.firebaseUser, this.fromLogin);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService _databaseService;
  User user;
  Trader trader;

  Future<void> _getTrader(String email) async {
    var tempTrader = await _databaseService.getTrader(email);
    if (!mounted) return;
    setState(() {
      trader = tempTrader;
    });
  }

  Future<void> _getUser(String email) async {
    final tempUser = await _databaseService.getUser(email);
    if (tempUser != null) {
      if (widget.fromLogin == 1) {
        await _databaseService.setToken(email);
      }
      if (!mounted) return;
      setState(() {
        user = tempUser;
      });
    } else {
      _getTrader(email);
    }
  }

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _getUser(widget.firebaseUser.email);
  }

  @override
  Widget build(BuildContext context) {
    return (user == null && trader == null)
        ? Container(
            color: Colors.white,
          )
        : (user != null) ? UserHomePage(user) : TraderHomePage(trader);
  }
}
