import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xchange_app/services/database.dart';
import 'package:xchange_app/structures/user.dart';

import '../../constants.dart';

class TradersSignUpPage extends StatefulWidget {
  final User user;
  TradersSignUpPage(this.user);

  @override
  State<TradersSignUpPage> createState() => _TradersSignupPagePageState();
}

class _TradersSignupPagePageState extends State<TradersSignUpPage> {
  DatabaseService _databaseService;
  String _username = '';
  String _sebi = '';
  double _fees;
  String _aboutYou = '';
  String _mailTo = 'xchangeadvisors@gmail.com';
  String _subject = 'Trader\'s Request For Verification';
  String _body = '';

  bool currencyFutures = false;
  bool currencyOptions = false;
  bool commodityFutures = false;
  bool commodityOptions = false;
  bool equityCash = false;
  bool equityFutures = false;
  bool equityOptions = false;

  void _createBody() {
    _body = '''First Name: ${widget.user.firstName}<br>
    Last Name: ${widget.user.lastName}<br>
    Email: ${widget.user.email}<br>
    Phone Number: ${widget.user.phone}<br><br>
    Username: $_username<br>
    SEBI: $_sebi<br>
    Fees: $_fees<br><br>''';

    if (equityCash) _body += 'Equity: Cash<br>';
    if (equityFutures) _body += 'Equity: Futures<br>';
    if (equityOptions) _body += 'Equity: Options<br>';
    if (currencyFutures) _body += 'Currency: Futures<br>';
    if (currencyOptions) _body += 'Currency: Options<br>';
    if (commodityFutures) _body += 'Commodity: Futures<br>';
    if (commodityOptions) _body += 'Commodity: Options<br>';

    _body += '<br>Trading Experience: $_aboutYou<br>';
  }

  _validation(scaffoldContext) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final takenUsernameSnackBar = SnackBar(
      content: Text(
        'Username not available',
      ),
      backgroundColor: Colors.red[600],
    );

    final invalidUsernameSnackBar = SnackBar(
      content: Text(
        'Username should be Alphanumeric and atmost 9 characters long',
      ),
      backgroundColor: Colors.red[600],
    );

    final fieldsEmpty = SnackBar(
      content: Text(
        'Please fill all fields',
      ),
      backgroundColor: Colors.red[600],
    );

    _username = _username.trim();
    _sebi = _sebi.trim();
    _aboutYou = _aboutYou.trim();

    if (!(RegExp(r'.*[a-zA-Z].*').hasMatch(_username) &&
            RegExp(r'.*[0-9].*').hasMatch(_username) &&
            RegExp(r'[A-Za-z0-9]*').hasMatch(_username)) ||
        _username.length > 9) {
      Scaffold.of(scaffoldContext).showSnackBar(invalidUsernameSnackBar);
      return;
    }

    if (_username.isEmpty ||
        _sebi.isEmpty ||
        _fees == null ||
        _aboutYou.isEmpty ||
        (currencyFutures == false &&
            currencyOptions == false &&
            commodityFutures == false &&
            commodityOptions == false &&
            equityCash == false &&
            equityFutures == false &&
            equityOptions == false)) {
      Scaffold.of(scaffoldContext).showSnackBar(fieldsEmpty);
      return;
    }

    if (!(await _databaseService.validateUsername(_username))) {
      Scaffold.of(scaffoldContext).showSnackBar(takenUsernameSnackBar);
      return;
    } else {
      _createBody();

      var url = 'mailto:$_mailTo?subject=$_subject&body=$_body';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Widget _usernameSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          setState(() {
            _username = text;
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
          hintText: 'Choose Username',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _sebiSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          setState(() {
            _sebi = text;
          });
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'SEBI Number',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _feesSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          setState(() {
            if (text.isEmpty)
              _fees = null;
            else
              _fees = double.parse(text);
          });
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding: const EdgeInsets.only(top: 14.0),
          hintText: 'Fees per month',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _aboutYouSetup() {
    return Container(
      decoration: Constants.boxDecoration,
      child: TextField(
        onChanged: (text) {
          setState(() {
            _aboutYou = text;
          });
        },
        maxLines: null,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.description,
            color: Colors.white,
            size: 25.0,
          ),
          contentPadding:
              const EdgeInsets.only(top: 14.0, bottom: 14.0, right: 14.0),
          hintText: 'Tell us about your trading',
          hintStyle: Constants.hintStyle,
        ),
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  bool _currentValue(title, subTile) {
    if (title == 'Currency') {
      if (subTile == 'Futures')
        return currencyFutures;
      else
        return currencyOptions;
    } else if (title == 'Commodity') {
      if (subTile == 'Futures')
        return commodityFutures;
      else
        return commodityOptions;
    } else {
      if (subTile == 'Cash')
        return equityCash;
      else if (subTile == 'Futures')
        return equityFutures;
      else
        return equityOptions;
    }
  }

  void _updateValues(title, subTile) {
    if (title == 'Currency') {
      if (subTile == 'Futures')
        currencyFutures = !currencyFutures;
      else
        currencyOptions = !currencyOptions;
    } else if (title == 'Commodity') {
      if (subTile == 'Futures')
        commodityFutures = !commodityFutures;
      else
        commodityOptions = !commodityOptions;
    } else {
      if (subTile == 'Cash')
        equityCash = !equityCash;
      else if (subTile == 'Futures')
        equityFutures = !equityFutures;
      else
        equityOptions = !equityOptions;
    }
  }

  Widget _assetClassSetup(String title, subTiles) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF2F3F4),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        subtitle: title == 'Equity'
            ? Text(
                'Choose Asset Class and Type',
                style: TextStyle(color: Colors.black87),
              )
            : null,
        title: Text(
          title,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        children: <Widget>[
          ...subTiles.map((subTile) {
            return ListTile(
              dense: true,
              onTap: () {
                setState(() {
                  _updateValues(title, subTile);
                });
              },
              leading: Icon(Icons.arrow_right),
              title: Text(subTile),
              trailing: _currentValue(title, subTile)
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

  Widget _sendEmailButton(BuildContext context, BuildContext scaffoldContext) {
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
            'SEND',
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
    _databaseService = DatabaseService();
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
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          'Trader\'s Form',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      _usernameSetup(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _sebiSetup(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _feesSetup(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _assetClassSetup(
                          'Equity', ['Cash', 'Futures', 'Options']),
                      SizedBox(
                        height: 20.0,
                      ),
                      _assetClassSetup('Currency', ['Futures', 'Options']),
                      SizedBox(
                        height: 20.0,
                      ),
                      _assetClassSetup('Commodity', ['Futures', 'Options']),
                      SizedBox(
                        height: 20.0,
                      ),
                      _aboutYouSetup(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _sendEmailButton(context, scaffoldContext),
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
