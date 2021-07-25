import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xchange_app/screens/loginpage.dart';
import 'package:xchange_app/screens/mymessagespage.dart';
import 'package:xchange_app/screens/signupscreens/tradersignuppage.dart';
import 'package:xchange_app/screens/traderdetailspage.dart';
import 'package:xchange_app/services/authentication.dart';
import 'package:xchange_app/services/database.dart';
import 'package:xchange_app/structures/trader.dart';
import 'package:xchange_app/structures/user.dart';

class UserHomePage extends StatefulWidget {
  final User user;
  UserHomePage(this.user);
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  AuthService _auth;
  DatabaseService _databaseService;
  FirebaseMessaging _firebaseMessaging;
  List<Trader> traders;

  bool currencyFutures = false;
  bool currencyOptions = false;
  bool commodityFutures = false;
  bool commodityOptions = false;
  bool equityCash = false;
  bool equityFutures = false;
  bool equityOptions = false;

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
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white70,
        children: <Widget>[
          ...subTiles.map((subTile) {
            return ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 16.0, bottom: 6.0, right: 16.0),
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

  Widget _categoriesSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _assetClassSetup('Equity', ['Cash', 'Futures', 'Options']),
        SizedBox(
          height: 25.0,
        ),
        _assetClassSetup('Currency', ['Futures', 'Options']),
        SizedBox(
          height: 25.0,
        ),
        _assetClassSetup('Commodity', ['Futures', 'Options']),
        SizedBox(
          height: 25.0,
        ),
        RaisedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            setState(() {
              traders = null;
            });
            if ((equityCash &&
                    equityFutures &&
                    equityOptions &&
                    currencyFutures &&
                    currencyOptions &&
                    commodityFutures &&
                    commodityOptions) ||
                (!equityCash &&
                    !equityFutures &&
                    !equityOptions &&
                    !currencyFutures &&
                    !currencyOptions &&
                    !commodityFutures &&
                    !commodityOptions)) {
              _getTraders();
              return;
            }

            var dirtyTradersList = await _databaseService.filterTraders(
                equityCash,
                equityFutures,
                equityOptions,
                currencyFutures,
                currencyOptions,
                commodityFutures,
                commodityOptions);
            if (dirtyTradersList.isEmpty) {
              setState(() {
                traders = [];
              });
              return;
            }
            Map<String, Trader> uniqueTradersMap;
            dirtyTradersList.forEach((trader) {
              uniqueTradersMap == null
                  ? uniqueTradersMap = {trader.email: trader}
                  : uniqueTradersMap.putIfAbsent(trader.email, () => trader);
            });
            print('uniqueTradersMap: ' + uniqueTradersMap.toString());
            List<Trader> cleanTradersList;
            uniqueTradersMap.forEach((key, value) {
              cleanTradersList == null
                  ? cleanTradersList = [value]
                  : cleanTradersList.add(value);
            });
            setState(() {
              traders = cleanTradersList;
            });
          },
          elevation: 5.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'SEE TRADERS',
            style: TextStyle(
                color: Color(0xFF02A388),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _userDetails() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
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
        width: double.maxFinite,
        padding: const EdgeInsets.only(
            left: 12.0, top: 45.0, right: 12.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 70.0,
              height: 70.0,
              child: Center(
                child: Text(
                  widget.user == null
                      ? ''
                      : (widget.user.firstName[0] + widget.user.lastName[0]),
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 2.0),
              child: Text(
                widget.user == null
                    ? ''
                    : (widget.user.firstName + ' ' + widget.user.lastName),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              widget.user == null ? '' : widget.user.email,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () => {
                _auth.signOut(),
                Navigator.of(context).pop(),
                Navigator.of(context).pop(),
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LoginPage();
                    },
                  ),
                ),
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'Sign out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawer() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                _userDetails(),
                _categoriesSelection(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      String _mailTo = 'xchangeadvisors@gmail.com';
                      String _subject = 'Feedback Response';
                      String _body = '';
                      var url = 'mailto:$_mailTo?subject=$_subject&body=$_body';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                          color: Color(0xFF02A388),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 3.0,
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return TradersSignUpPage(widget.user);
                          },
                        ),
                      )
                    },
                    child: Text(
                      'Join the platform',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getTraders() async {
    var tempTraders = await _databaseService.getTraders();
    if (!mounted) return;
    setState(() {
      traders = tempTraders;
    });
  }

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _databaseService = DatabaseService();
    _getTraders();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.subscribeToTopic('calls');
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("ON MESSAGE");

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MyMessagesPage(widget.user.email);
          },
        ),
      );
    }, onResume: (Map<String, dynamic> message) async {
      print("ON RESUME");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MyMessagesPage(widget.user.email);
          },
        ),
      );
    }, onLaunch: (Map<String, dynamic> message) async {
      print("ON LAUNCH");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MyMessagesPage(widget.user.email);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F3F4),
      drawer: Drawer(
        child: SafeArea(child: _drawer()),
      ),
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MyMessagesPage(widget.user.email);
                },
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 20.0),
              child: Icon(
                Icons.chat,
              ),
            ),
          ),
        ],
        title: Text(
          'Xchange',
          style: TextStyle(fontSize: 23.0),
        ),
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
      body: traders == null
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 3.0,
            ))
          : traders.isEmpty
              ? Center(
                  child: Text(
                    'No Traders Found',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                  ),
                )
              : GridView.builder(
                  itemCount: traders?.length,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                      top: 30, left: 18, right: 18.0, bottom: 30),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 1.9,
                      mainAxisSpacing: 27.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return TraderDetailsPage(
                                  traders[index], widget.user);
                            },
                          ),
                        );
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(2, 163, 136, 1),
                                Color.fromRGBO(16, 149, 161, 1),
                                Color.fromRGBO(44, 125, 210, 1),
                              ],
                            ),
                          ),
                          child: Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 20, right: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        traders[index].username,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                            height: 1),
                                      ),
                                      Text(
                                        'REWARD : RISK',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w300,
                                            height: 1),
                                      ),
                                      Text(
                                        traders[index].rewardRisk,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      ),
                                      Text(
                                        'SUCCESS RATE',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w300,
                                            height: 1),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: Text(
                                          traders[index].successRate,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26,
                                              letterSpacing: 0.3,
                                              fontWeight: FontWeight.bold,
                                              height: 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5, top: 15),
                                          child: Image.asset(
                                            traders[index].avatar,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                ),
    );
  }
}
