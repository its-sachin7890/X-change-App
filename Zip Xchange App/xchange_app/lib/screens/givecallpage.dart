import 'package:flutter/material.dart';
import 'package:xchange_app/services/database.dart';

import '../constants.dart';

class GiveCallPage extends StatefulWidget {
  final String email;
  final String username;
  GiveCallPage(this.email, this.username);
  @override
  _GiveCallPageState createState() => _GiveCallPageState();
}

class _GiveCallPageState extends State<GiveCallPage> {
  String _entryPrice = '';
  String _stopLoss = '';
  String _targetPrice = '';
  String _credentials = '';
  bool _intraday = false;
  bool _swing = false;
  bool _positional = false;
  DatabaseService _databaseService;

  final credentialsController = TextEditingController();
  final entryPriceController = TextEditingController();
  final targetPriceController = TextEditingController();
  final stopLossController = TextEditingController();

  _validation(context, scaffoldContext) async {
    final fieldsEmpty = SnackBar(
      content: Text(
        'Please fill all fields',
      ),
      backgroundColor: Colors.red[600],
    );

    if (_entryPrice.isEmpty ||
        _stopLoss.isEmpty ||
        _targetPrice.isEmpty ||
        _credentials.isEmpty ||
        (_intraday == false && _swing == false && _positional == false)) {
      Scaffold.of(scaffoldContext).showSnackBar(fieldsEmpty);
      return;
    }
    final pleaseWaitSnackBar = SnackBar(
      content: Text(
        'Please wait...',
      ),
      backgroundColor: Colors.greenAccent,
    );
    Scaffold.of(scaffoldContext).showSnackBar(pleaseWaitSnackBar);

    final successSnackbar = SnackBar(
      content: Text(
        'Call Sent Successfully',
      ),
      backgroundColor: Colors.greenAccent,
    );

    _entryPrice = _entryPrice.trim();
    _stopLoss = _stopLoss.trim();
    _targetPrice = _targetPrice.trim();
    _credentials = _credentials.trim();
    String duration =
        (_intraday) ? 'Intraday' : (_swing) ? 'Swing' : 'Positional';

    await _databaseService.sendCall(widget.email, widget.username, _entryPrice,
        _stopLoss, _targetPrice, _credentials, duration);

    setState(() {
      _entryPrice = '';
      _stopLoss = '';
      _targetPrice = '';
      _credentials = '';
      _intraday = false;
      _positional = false;
      _swing = false;
    });
    credentialsController.clear();
    entryPriceController.clear();
    targetPriceController.clear();
    stopLossController.clear();
    Scaffold.of(scaffoldContext).showSnackBar(successSnackbar);
  }

  Widget _credentialsSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        controller: credentialsController,
        onChanged: (text) {
          setState(() {
            _credentials = text;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.create,
            color: Colors.lightBlue[700],
            size: 25.0,
          ),
          contentPadding:
              const EdgeInsets.only(top: 14.0, bottom: 14.0, right: 14.0),
          hintText: 'Enter Share Credentials',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }

  Widget _entryPriceSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        controller: entryPriceController,
        onChanged: (text) {
          setState(() {
            _entryPrice = text;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.check_circle_outline,
            color: Colors.teal,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Entry Price',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _targetPriceSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        controller: targetPriceController,
        onChanged: (text) {
          setState(() {
            _targetPrice = text;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Target Price',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _stopLossSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        controller: stopLossController,
        onChanged: (text) {
          setState(() {
            _stopLoss = text;
          });
        },
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.cancel,
            color: Colors.red,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Stop Loss',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  void _updateValues(String subTile) {
    setState(() {
      if (subTile == 'Intraday') {
        _intraday = !_intraday;
        if (_intraday) {
          _swing = false;
          _positional = false;
        }
      } else if (subTile == 'Swing') {
        _swing = !_swing;
        if (_swing) {
          _intraday = false;
          _positional = false;
        }
      } else {
        _positional = !_positional;
        if (_positional) {
          _intraday = false;
          _swing = false;
        }
      }
    });
  }

  bool _currentValue(subTile) {
    if (subTile == 'Intraday')
      return _intraday;
    else if (subTile == 'Swing')
      return _swing;
    else
      return _positional;
  }

  Widget _durationSetup(String title, subTiles) {
    return Container(
      decoration: Constants.boxDecoration,
      child: ExpansionTile(
        title: Text(
          title,
          style: Constants.hintStyle,
        ),
        backgroundColor: Color(0xFFECEBEB),
        children: <Widget>[
          ...subTiles.map((subTile) {
            return ListTile(
              dense: false,
              onTap: () {
                setState(() {
                  _updateValues(subTile);
                });
              },
              leading: Icon(Icons.arrow_right),
              title: Text(
                subTile,
              ),
              trailing: _currentValue(subTile)
                  ? Icon(
                      Icons.check,
                      color: Colors.blue,
                    )
                  : null,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _sendButton(BuildContext context, BuildContext scaffoldContext) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      width: 125,
      child: SizedBox(
        height: 44.0,
        child: RaisedButton(
          color: Color(0xFF02A388),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () => _validation(context, scaffoldContext),
          child: Text(
            'SEND',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F3F4),
      appBar: AppBar(
        title: Text('Trade Details'),
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
      body: Builder(
        builder: (scaffoldContext) => GestureDetector(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: 25.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _credentialsSetup(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _entryPriceSetup(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _targetPriceSetup(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _stopLossSetup(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _durationSetup(
                        'Duration', ['Intraday', 'Swing', 'Positional']),
                    SizedBox(
                      height: 15.0,
                    ),
                    _sendButton(context, scaffoldContext),
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
