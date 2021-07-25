import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xchange_app/screens/callspage.dart';
import 'package:xchange_app/services/database.dart';
import 'package:xchange_app/structures/call.dart';

_MyMessagesPageState stateVariable;

class MyMessagesPage extends StatefulWidget {
  final String email;
  MyMessagesPage(this.email);

  static _MyMessagesPageState getStateClass() {
    return stateVariable;
  }

  @override
  _MyMessagesPageState createState() => _MyMessagesPageState();
}

class _MyMessagesPageState extends State<MyMessagesPage> {
  DatabaseService _databaseService;
  List<Call> messages = [];
  bool isLoading = false;
  bool isExhausted = false;
  int first;
  bool empty;

  _fetchFromDatabase(String email) async {
    var tempMessages = await _databaseService.getMessages(email);
    if (tempMessages.isEmpty) {
      print('IN _GETMSG');
      if (!mounted) return;
      setState(() {
        messages = null;
      });
      return;
    }
    if (!mounted) return;
    setState(() {
      messages.addAll(tempMessages);
    });
    first = 0;
    print('First: ' + first.toString());
  }

  _getMessages(String email) async {
    print('First: ' + first.toString());

    _databaseService
        .getMessageCollectionRef(email)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((querySnapshot) async {
      print('LISTEN');
      print('Query Snapshot: ' + querySnapshot.documents.toString());
      if (querySnapshot.documents.isEmpty) {
        empty = true;
        print('EMPTY: ' + empty.toString());
      }
      for (var change in querySnapshot.documentChanges) {
        if (change.type == DocumentChangeType.added) {
          print('DocumentChangeType: ' + change.document.data.toString());
          if (empty == true) {
            first = 1;
            empty = false;
            print('EMPTY: ' + empty.toString());
            messages = [];
            _fetchFromDatabase(widget.email);
            return;
          }
          DocumentReference documentReference =
              change.document.data['reference'];
          print(documentReference.path);
          var snapshot = await documentReference.get();
          print('DocumentChangeType DOC: ' + snapshot.data.toString());
          if (first == 0) {
            print('EXECUTED');
            setState(() {
              messages == null
                  ? messages = [Call.fromJson(snapshot.data)]
                  : messages.insert(0, Call.fromJson(snapshot.data));
            });
          }
        }
      }
    });
    _fetchFromDatabase(email);
  }

  getMoreMessages() async {
    setState(() {
      isLoading = true;
    });
    var tempMessages = await _databaseService.getMoreMessages(widget.email);
    if (tempMessages.isEmpty) {
      setState(() {
        isExhausted = true;
      });
      isLoading = false;
      return;
    }
    setState(() {
      messages.addAll(tempMessages);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    stateVariable = this;
    first = 1;
    empty = false;
    _databaseService = DatabaseService();
    _getMessages(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Messages'),
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
      body: messages == null
          ? Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'No Messages',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20.0,
                  ),
                ),
              ),
            )
          : messages.isEmpty
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  ),
                )
              : CallsPage(messages, isLoading, isExhausted, isUser: true)
                  .callsPage(),
    );
  }
}
