import 'package:flutter/material.dart';
import 'package:xchange_app/screens/callspage.dart';
import 'package:xchange_app/services/database.dart';
import 'package:xchange_app/structures/call.dart';

_MyTradesPageState stateVariable;

class MyTradesPage extends StatefulWidget {
  final String email;
  MyTradesPage(this.email);

  static _MyTradesPageState getStateClass() {
    return stateVariable;
  }

  @override
  _MyTradesPageState createState() => _MyTradesPageState();
}

class _MyTradesPageState extends State<MyTradesPage> {
  DatabaseService _databaseService;
  List<Call> trades = [];
  bool isLoading = false;
  bool isExhausted = false;

  _getTrades(String email) async {
    var tempTrades = await _databaseService.getTrades(email);
    if (tempTrades.isEmpty) {
      if (!mounted) return;
      setState(() {
        trades = null;
      });
      return;
    }
    if (!mounted) return;
    setState(() {
      trades.addAll(tempTrades);
    });
  }

  getMoreTrades() async {
    setState(() {
      isLoading = true;
    });
    var tempTrades = await _databaseService.getMoreTrades(widget.email);
    if (tempTrades.isEmpty) {
      setState(() {
        isExhausted = true;
      });
      isLoading = false;
      return;
    }
    setState(() {
      trades.addAll(tempTrades);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    stateVariable = this;
    _databaseService = DatabaseService();
    _getTrades(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trades'),
        flexibleSpace: Container(
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
        ),
      ),
      body: trades == null
          ? Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'No Trades',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20.0,
                  ),
                ),
              ),
            )
          : trades.isEmpty
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  ),
                )
              : CallsPage(trades, isLoading, isExhausted, isUser: false)
                  .callsPage(),
    );
  }
}
