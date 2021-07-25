import 'package:flutter/material.dart';
import 'package:xchange_app/screens/givecallpage.dart';
import 'package:xchange_app/screens/mytradespage.dart';
import 'package:xchange_app/services/authentication.dart';
import 'package:xchange_app/services/database.dart';
import 'package:xchange_app/structures/trader.dart';

import 'loginpage.dart';

class TraderHomePage extends StatefulWidget {
  final Trader trader;
  TraderHomePage(this.trader);
  @override
  _TraderHomePageState createState() => _TraderHomePageState();
}

class _TraderHomePageState extends State<TraderHomePage> {
  AuthService _auth;
  DatabaseService _databaseService;

  bool currencyFutures = false;
  bool currencyOptions = false;
  bool commodityFutures = false;
  bool commodityOptions = false;
  bool equityCash = false;
  bool equityFutures = false;
  bool equityOptions = false;
  String avatar;
  List<String> equityTypes = [];
  List<String> currencyTypes = [];
  List<String> commodityTypes = [];

  Future<void> _changeAvatar(String newAvatar, BuildContext context,
      BuildContext scaffoldContext) async {
    avatar = newAvatar;
    widget.trader.avatar = 'assets/avatars/' + newAvatar + '.png';
    setState(() {});
    Navigator.of(context).pop();
    final pleaseWaitSnackBar = SnackBar(
      content: Text(
        'Please wait...',
      ),
      backgroundColor: Colors.greenAccent,
    );
    Scaffold.of(scaffoldContext).showSnackBar(pleaseWaitSnackBar);
    await _databaseService.changeAvatar(avatar, widget.trader.email);
    final savedChangesSnackBar = SnackBar(
      content: Text(
        'Avatar Changed Successfully',
      ),
      backgroundColor: Colors.greenAccent,
    );
    Scaffold.of(scaffoldContext).showSnackBar(savedChangesSnackBar);
  }

  Widget _selectAvatar(context, scaffoldContext) {
    return Center(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height / 1.25,
        width: MediaQuery.of(context).size.height / 3,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (builderContext, index) {
            var avatar = 'assets/avatars/a' + (index + 1).toString() + '.png';
            return GestureDetector(
              onTap: () async => await _changeAvatar(
                  'a' + (index + 1).toString(), context, scaffoldContext),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0, right: 50.0, top: 20.0, bottom: 15.0),
                    child: Image.asset(
                      avatar,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Divider(
                    thickness: 2.0,
                    height: 0,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _avatarAndCardSetup(
      BuildContext context, BuildContext scaffoldContext) {
    return Container(
      child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.2,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Stack(
                      children: <Widget>[
                        Center(
                            child: GestureDetector(
                                onTap: () => showDialog(
                                    context: context,
                                    child: _selectAvatar(
                                        context, scaffoldContext)),
                                child: Image.asset(widget.trader.avatar))),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 22.9,
                        spreadRadius: 0.0,
                        offset: Offset(
                          0.0,
                          -5.0,
                        ),
                      )
                    ],
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 22, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text('REWARD:RISK',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(widget.trader.rewardRisk,
                                    style: TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text('SUCCESS RATE',
                                    style: TextStyle(
                                      fontSize: 13,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(widget.trader.successRate,
                                    style: TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text('FOLLOWERS',
                                    style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w400,
                                        height: 1)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(widget.trader.followers.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w700,
                                        height: 1)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ])),
    );
  }

  Widget _tradesAndCallSetup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 35,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MyTradesPage(widget.trader.email);
                },
              ),
            ),
            child: Container(
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF2D7DD2),
                        const Color(0xFF02A388),
                      ]),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 11, bottom: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'My Trades',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 30,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return GiveCallPage(
                      widget.trader.email, widget.trader.username);
                },
              ),
            ),
            child: Container(
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF2D7DD2),
                        const Color(0xFF02A388),
                      ]),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 11, bottom: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Give Call',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 35,
        ),
      ],
    );
  }

  Widget _assetClassSetup(String title, subTiles) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
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
          title: Text(
            title,
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          children: <Widget>[
            ...subTiles.map((subTile) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.only(left: 16.0, bottom: 6.0, right: 16.0),
                onTap: () {},
                leading: Icon(Icons.arrow_right),
                title: Text(subTile),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _signoutButtonSetup(BuildContext scaffoldContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: GestureDetector(
            onTap: () => {
              _auth.signOut(),
              Navigator.of(context).pop(),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LoginPage();
                  },
                ),
              ),
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.exit_to_app,
                  color: Colors.black54,
                  size: 19,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 19.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _setAssetClassType() {
    if (widget.trader.equityCash == true) {
      equityCash = true;
      equityTypes.add('Cash');
    }
    if (widget.trader.equityFutures == true) {
      equityFutures = true;
      equityTypes.add('Futures');
    }
    if (widget.trader.equityOptions == true) {
      equityOptions = true;
      equityTypes.add('Options');
    }
    if (widget.trader.currencyFutures == true) {
      currencyFutures = true;
      currencyTypes.add('Futures');
    }
    if (widget.trader.currencyOptions == true) {
      currencyOptions = true;
      currencyTypes.add('Options');
    }
    if (widget.trader.commodityFutures == true) {
      commodityFutures = true;
      commodityTypes.add('Futures');
    }
    if (widget.trader.commodityOptions == true) {
      commodityOptions = true;
      commodityTypes.add('Options');
    }
  }

  _feeExpansionTileSetup() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
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
          title: Text(
            'Fees',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          children: <Widget>[
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 16.0, bottom: 6.0, right: 16.0),
              title: Text(
                'Rs. ' + widget.trader.fee + ' p.m',
              ),
              leading: Icon(Icons.arrow_right),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _databaseService = DatabaseService();
    var tempavatar = widget.trader.avatar;
    avatar = tempavatar.substring(
        tempavatar.lastIndexOf('/') + 1, tempavatar.indexOf('.'));
    print('AVATAR    :' + avatar);
    _setAssetClassType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            widget.trader.username,
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 0,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
      body: Builder(
        builder: (scaffoldContext) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      AppBar().preferredSize.height),
              child: Column(
                children: <Widget>[
                  _avatarAndCardSetup(context, scaffoldContext),
                  SizedBox(
                    height: 25,
                  ),
                  _tradesAndCallSetup(),
                  SizedBox(
                    height: 25,
                  ),
                  equityTypes.isNotEmpty
                      ? _assetClassSetup('Equity', equityTypes)
                      : Container(),
                  equityTypes.isNotEmpty
                      ? SizedBox(
                          height: 20.0,
                        )
                      : Container(),
                  currencyTypes.isNotEmpty
                      ? _assetClassSetup('Currency', currencyTypes)
                      : Container(),
                  currencyTypes.isNotEmpty
                      ? SizedBox(
                          height: 20.0,
                        )
                      : Container(),
                  commodityTypes.isNotEmpty
                      ? _assetClassSetup('Commodity', commodityTypes)
                      : Container(),
                  commodityTypes.isNotEmpty
                      ? SizedBox(
                          height: 20.0,
                        )
                      : Container(),
                  _feeExpansionTileSetup(),
                  SizedBox(height: 30),
                  _signoutButtonSetup(scaffoldContext),
                  SizedBox(height: 30)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
