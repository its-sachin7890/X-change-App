import 'package:flutter/material.dart';
import 'package:xchange_app/screens/mymessagespage.dart';
import 'package:xchange_app/screens/mytradespage.dart';
import 'package:xchange_app/structures/call.dart';

class CallsPage {
  List<Call> calls;
  bool isLoading;
  bool isExhausted;
  bool isUser;
  CallsPage(this.calls, this.isLoading, this.isExhausted, {this.isUser});

  Widget callsPage() {
    return ListView.builder(
      itemCount: calls.length,
      reverse: true,
      physics: BouncingScrollPhysics(),
      padding:
          const EdgeInsets.only(left: 20, right: 35.0, bottom: 35, top: 20),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            (calls.length > 1 &&
                    index == calls.length - 1 &&
                    isExhausted == false)
                ? SizedBox(
                    width: 110.0,
                    height: 39,
                    child: RaisedButton(
                      onPressed: () {
                        isUser
                            ? MyMessagesPage.getStateClass().getMoreMessages()
                            : MyTradesPage.getStateClass().getMoreTrades();
                      },
                      elevation: 5.0,
                      color: Colors.white,
                      textColor: Color(0xFF02A388),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: isLoading == true
                          ? SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              ),
                            )
                          : Text('+ Show More',
                              style: TextStyle(fontSize: 13.0)),
                    ),
                  )
                : Container(),
            Padding(
              padding: (index == calls.length - 1)
                  ? EdgeInsets.only(top: 15)
                  : EdgeInsets.only(top: 35),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.12999999523162842),
                      offset: Offset(2, 2),
                      blurRadius: 15)
                ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(30),
                              ),
                              color: Color.fromRGBO(1, 163, 136, 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 12, bottom: 12),
                              child: Text(
                                calls[index].givenBy['username'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15, right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Credentials : ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          calls[index].shareAttributes,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                          maxLines: 10,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Entry Price : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  calls[index].entryPrice,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Target Price : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  calls[index].targetPrice,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Stop Loss : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  calls[index].stopLoss,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Duration : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  calls[index].duration,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: Text(
                                  calls[index].timestamp.toString(),
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
            ),
          ],
        );
      },
    );
  }
}
