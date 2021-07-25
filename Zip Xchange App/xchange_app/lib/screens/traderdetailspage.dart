import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//import 'package:xchange_app/constants.dart';
import 'package:xchange_app/services/database.dart';
import 'package:xchange_app/structures/trader.dart';
import 'package:xchange_app/structures/user.dart';

class TraderDetailsPage extends StatefulWidget {
  final Trader trader;
  final User user;
  TraderDetailsPage(this.trader, this.user);
  @override
  _TraderProfilePageState createState() => _TraderProfilePageState();
}

class _TraderProfilePageState extends State<TraderDetailsPage> {
  DatabaseService _databaseService;
  bool isFollowing;
  //Razorpay razorpay;

  Widget avatarAndCardSetup() {
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
                    child: Image.asset(widget.trader.avatar),
                  ),
                ),
                SizedBox(
                  height: 7,
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
                                      fontWeight: FontWeight.w600,
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
                                      fontWeight: FontWeight.w600,
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
                                        fontWeight: FontWeight.w600,
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

  Future<void> _followTrader(String traderEmail, String userEmail) async {
    setState(() {
      isFollowing = null;
    });
    await _databaseService.followTrader(traderEmail, userEmail);
    widget.trader.followers += 1;
    setState(() {
      isFollowing = true;
    });
  }

  Widget followFollowingButton() {
    return isFollowing == null
        ? Padding(
            padding: const EdgeInsets.only(top: 13, bottom: 25),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          )
        : isFollowing == true
            ? Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ' Following',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () async {
                  //openCheckOut();
                  await _followTrader(widget.trader.email, widget.user.email);
                },
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Follow',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Fees - Rs. ' + widget.trader.fee + ' p.m',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
              );
  }

  Widget assetClassTypeSetup() {
    List<String> equityTypes = [], currencyTypes = [], commodityTypes = [];
    if (widget.trader.equityCash == null &&
        widget.trader.equityFutures == null &&
        widget.trader.equityOptions == null) {
      equityTypes.add('---');
    } else {
      if (widget.trader.equityCash != null) equityTypes.add('Cash');
      if (widget.trader.equityFutures != null) equityTypes.add('Futures');
      if (widget.trader.equityOptions != null) equityTypes.add('Options');
    }

    if (widget.trader.currencyFutures == null &&
        widget.trader.currencyOptions == null) {
      currencyTypes.add('---');
    } else {
      if (widget.trader.currencyFutures != null) currencyTypes.add('Futures');
      if (widget.trader.currencyOptions != null) currencyTypes.add('Options');
    }

    if (widget.trader.commodityFutures == null &&
        widget.trader.commodityOptions == null) {
      commodityTypes.add('---');
    } else {
      if (widget.trader.commodityFutures != null) commodityTypes.add('Futures');
      if (widget.trader.commodityOptions != null) commodityTypes.add('Options');
    }

    return DataTable(
      dataRowHeight: 80,
      horizontalMargin: MediaQuery.of(context).size.width / 11,
      dividerThickness: 2.0,
      columnSpacing: MediaQuery.of(context).size.width / 4,
      columns: [
        DataColumn(
          label: Text(
            'Asset Class',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Type',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
      rows: [
        DataRow(cells: [
          DataCell(
            Center(
              child: Text(
                'Equity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),
          DataCell(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ...equityTypes.map((type) {
                    return Text(
                      type,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    );
                  })
                ],
              ),
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(
            Center(
              child: Text(
                'Currency',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          DataCell(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ...currencyTypes.map((type) {
                    return Text(
                      type,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    );
                  })
                ],
              ),
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(
            Center(
              child: Text(
                'Commodity',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          DataCell(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ...commodityTypes.map((type) {
                    return Text(
                      type,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    );
                  })
                ],
              ),
            ),
          ),
        ])
      ],
    );
  }

  _setIsFollowing(String traderEmail, String userEmail) async {
    var temp = await _databaseService.isFollowing(traderEmail, userEmail);
    if (!mounted) return;
    setState(() {
      isFollowing = temp;
    });
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print('SUCCESS');
    _followTrader(widget.trader.email, widget.user.email);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print('FAILURE');
  }

  /*void openCheckOut() async {
    num fee = num.parse(widget.trader.fee);
    var options = {
      'key': Constants.key,
      'amount': fee * 100,
      'name': widget.trader.username,
      'description': 'Xchange Payment',
      'prefill': {'contact': widget.user.phone, 'email': widget.user.email},
    };
    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('DEBUG: ' + e);
    }
  }*/

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _setIsFollowing(widget.trader.email, widget.user.email);
    //razorpay = Razorpay();
    //razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    //razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
  }

  @override
  void dispose() {
    super.dispose();
    //razorpay.clear();
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
        title: Text(
          widget.trader.username,
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
              fontWeight: FontWeight.normal),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  AppBar().preferredSize.height),
          child: Column(
            children: <Widget>[
              avatarAndCardSetup(),
              SizedBox(
                height: 30.0,
              ),
              followFollowingButton(),
              SizedBox(
                height: 30,
              ),
              assetClassTypeSetup(),
            ],
          ),
        ),
      ),
    );
  }
}
