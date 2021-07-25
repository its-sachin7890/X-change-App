import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:xchange_app/structures/call.dart';
import 'package:xchange_app/structures/trader.dart';
import 'package:xchange_app/structures/user.dart';

class DatabaseService {
  CollectionReference usersReference = Firestore.instance.collection('users');
  CollectionReference tradersReference =
      Firestore.instance.collection('traders');
  CollectionReference callsReference = Firestore.instance.collection('calls');

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  DocumentSnapshot lastTrade;

  DocumentSnapshot lastMessage;

  CollectionReference getMessageCollectionRef(String email) {
    return usersReference.document(email).collection('messages');
  }

  Future<void> setToken(String userEmail) async {
    var token = await _firebaseMessaging.getToken();
    await usersReference.document(userEmail).updateData(
        {'token': token}).catchError((e) => print('Error from setToken: ' + e));
    print('IN SET TOKEN');
  }

  Future<bool> validateUsername(String username) async {
    bool isValid = false;
    await tradersReference
        .where('username', isEqualTo: username)
        .getDocuments()
        .then((snapshot) => snapshot.documents.isEmpty ? isValid = true : null);
    print("Is Valid: " + isValid.toString());
    return isValid;
  }

  Future<void> registerUser(
      String firstName, String lastName, String email, String phone) async {
    await usersReference
        .document('$email')
        .setData(User(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
        ).toMap())
        .catchError((e) {
      print(e);
    });
  }

  Future<User> getUser(String email) async {
    var snapshot = await usersReference.document(email).get().catchError((e) {
      print('Error from getUser: ' + e.toString());
    });

    print('USER SNP: ' + snapshot.toString());
    print('USER: ' + snapshot?.data.toString());
    return (snapshot == null || snapshot.data == null)
        ? null
        : User.fromJson(snapshot.data);
  }

  Future<Trader> getTrader(String email) async {
    var snapshot = await tradersReference.document(email).get().catchError((e) {
      print('Error from getTrader: ' + e.toString());
    });

    print('TRADER SNP: ' + snapshot.toString());
    print('TRADER: ' + snapshot.data.toString());
    return snapshot.data == null ? null : Trader.fromJson(snapshot.data);
  }

  Future<List<Trader>> getTraders() async {
    List<Trader> traders;
    var snapshot = await tradersReference.getDocuments().catchError((e) {
      print(e);
    });

    print('TRADER: ' + snapshot.documents.toString());
    snapshot.documents.forEach((docs) {
      traders == null
          ? traders = [Trader.fromJson(docs.data)]
          : traders.add(Trader.fromJson(docs.data));
    });

    return traders;
  }

  Future<List<Trader>> filterTraders(
      equityCash,
      equityFutures,
      equityOptions,
      currencyFutures,
      currencyOptions,
      commodityFutures,
      commodityOptions) async {
    List<Trader> equityCashTraders = [],
        equityFuturesTraders = [],
        equityOptionsTraders = [],
        currencyFuturesTraders = [],
        currencyOptionsTraders = [],
        commodityFuturesTraders = [],
        commodityOptionsTraders = [];

    if (equityCash) {
      await tradersReference
          .where('equityCash', isEqualTo: equityCash)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((docs) {
          equityCashTraders.isEmpty
              ? equityCashTraders = [Trader.fromJson(docs.data)]
              : equityCashTraders.add(Trader.fromJson(docs.data));
        });
      });
    }
    if (equityFutures) {
      await tradersReference
          .where('equityFutures', isEqualTo: equityFutures)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((docs) {
          equityFuturesTraders.isEmpty
              ? equityFuturesTraders = [Trader.fromJson(docs.data)]
              : equityFuturesTraders.add(Trader.fromJson(docs.data));
        });
      });
    }
    if (equityOptions) {
      await tradersReference
          .where('equityOptions', isEqualTo: equityOptions)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((docs) {
          equityOptionsTraders.isEmpty
              ? equityOptionsTraders = [Trader.fromJson(docs.data)]
              : equityOptionsTraders.add(Trader.fromJson(docs.data));
        });
      });
    }
    if (currencyFutures) {
      await tradersReference
          .where('currencyFutures', isEqualTo: currencyFutures)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((docs) {
          currencyFuturesTraders.isEmpty
              ? currencyFuturesTraders = [Trader.fromJson(docs.data)]
              : currencyFuturesTraders.add(Trader.fromJson(docs.data));
        });
      });
    }
    if (currencyOptions) {
      await tradersReference
          .where('currencyOptions', isEqualTo: currencyOptions)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((docs) {
          currencyOptionsTraders.isEmpty
              ? currencyOptionsTraders = [Trader.fromJson(docs.data)]
              : currencyOptionsTraders.add(Trader.fromJson(docs.data));
        });
      });
    }
    if (commodityFutures) {
      await tradersReference
          .where('commodityFutures', isEqualTo: commodityFutures)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((docs) {
          commodityFuturesTraders.isEmpty
              ? commodityFuturesTraders = [Trader.fromJson(docs.data)]
              : commodityFuturesTraders.add(Trader.fromJson(docs.data));
        });
      });
    }
    if (commodityOptions) {
      await tradersReference
          .where('commodityOptions', isEqualTo: commodityOptions)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((docs) {
          commodityOptionsTraders.isEmpty
              ? commodityOptionsTraders = [Trader.fromJson(docs.data)]
              : commodityOptionsTraders.add(Trader.fromJson(docs.data));
        });
      });
    }

    var dirtyTradersList = (equityCashTraders +
        equityFuturesTraders +
        equityOptionsTraders +
        currencyFuturesTraders +
        currencyOptionsTraders +
        commodityFuturesTraders +
        commodityOptionsTraders);

    return dirtyTradersList;
  }

  Future<bool> isFollowing(String traderEmail, String userEmail) async {
    bool isFollowing = false;
    await tradersReference
        .document(traderEmail)
        .collection('followers')
        .document(userEmail)
        .get()
        .then((snapshot) => snapshot.exists ? isFollowing = true : null)
        .catchError((e) => print('Error in isFollowing: ' + e.toString()));
    print("isFollowing: " + isFollowing.toString());
    return isFollowing;
  }

  Future<void> followTrader(String traderEmail, String userEmail) async {
    var start = DateTime.now();
    await tradersReference
        .document(traderEmail)
        .collection('followers')
        .document(userEmail)
        .setData({
      'start': start,
      'end': start.add(Duration(days: 30)),
    }).catchError((e) =>
            print('Error in followTrader followers update: ' + e.toString()));

    await tradersReference.document(traderEmail).updateData({
      'followers': FieldValue.increment(1)
    }).catchError((e) =>
        print('Error in followTrader follower\'s no. update: ' + e.toString()));
  }

  Future<void> changeAvatar(String avatar, String email) async {
    print('CHANGE AVATAR');
    var data = {
      'avatar': avatar,
    };
    await tradersReference
        .document(email)
        .updateData(data)
        .catchError((e) => print('Error in saveChanges: ' + e.toString()));
  }

  Future<List<Call>> getMessages(String email) async {
    List<Call> calls = [];

    var snapshot = await usersReference
        .document(email)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(2)
        .getDocuments()
        .catchError((e) => print('Error from getMessages: ' + e.toString()));
    print('SNAP: ' + snapshot.documents.toString());
    if (snapshot.documents.isEmpty) {
      return calls;
    }

    lastMessage = snapshot.documents[snapshot.documents.length - 1];
    print(snapshot);
    for (var doc in snapshot.documents) {
      print('DOC: ' + doc.data.toString());
      DocumentReference documentReference = doc.data['reference'];
      print(documentReference.path);
      print('HERE');
      var snapshot = await documentReference.get();
      print('CALL DOC: ' + snapshot.data.toString());
      calls.add(Call.fromJson(snapshot.data));
    }

    return calls;
  }

  setLastMessage(DocumentSnapshot documentSnapshot) {
    lastMessage = documentSnapshot;
  }

  Future<List<Call>> getMoreMessages(String email) async {
    List<Call> calls = [];
    var snapshot = await usersReference
        .document(email)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastMessage)
        .limit(2)
        .getDocuments()
        .catchError((e) => print('Error from getTrades: ' + e.toString()));

    if (snapshot.documents.isEmpty) {
      return calls;
    }

    print('SNAPSHOT: ' + snapshot.documents.toString());

    lastMessage = snapshot.documents[snapshot.documents.length - 1];

    for (var doc in snapshot.documents) {
      print('DOC: ' + doc.data.toString());
      DocumentReference documentReference = doc.data['reference'];
      print(documentReference.path);
      print('HERE');
      var snapshot = await documentReference.get();
      print('CALL DOC: ' + snapshot.data.toString());
      calls.add(Call.fromJson(snapshot.data));
    }

    return calls;
  }

  Future<List<Call>> getTrades(String email) async {
    List<Call> calls = [];

    var snapshot = await tradersReference
        .document(email)
        .collection('trades')
        .orderBy('timestamp', descending: true)
        .limit(2)
        .getDocuments()
        .catchError((e) => print('Error from getTrades: ' + e.toString()));
    if (snapshot.documents.isEmpty) {
      return calls;
    }

    lastTrade = snapshot.documents[snapshot.documents.length - 1];
    print(snapshot);
    for (var doc in snapshot.documents) {
      print('DOC: ' + doc.data.toString());
      DocumentReference documentReference = doc.data['reference'];
      print(documentReference.path);
      print('HERE');
      var snapshot = await documentReference.get();
      print('CALL DOC: ' + snapshot.data.toString());
      calls.add(Call.fromJson(snapshot.data));
    }
    return calls;
  }

  Future<List<Call>> getMoreTrades(String email) async {
    List<Call> calls = [];
    var snapshot = await tradersReference
        .document(email)
        .collection('trades')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastTrade)
        .limit(2)
        .getDocuments()
        .catchError((e) => print('Error from getTrades: ' + e.toString()));

    if (snapshot.documents.isEmpty) {
      return calls;
    }

    print('SNAPSHOT: ' + snapshot.documents.toString());

    lastTrade = snapshot.documents[snapshot.documents.length - 1];

    for (var doc in snapshot.documents) {
      print('DOC: ' + doc.data.toString());
      DocumentReference documentReference = doc.data['reference'];
      print(documentReference.path);
      print('HERE');
      var snapshot = await documentReference.get();
      print('CALL DOC: ' + snapshot.data.toString());
      calls.add(Call.fromJson(snapshot.data));
    }

    return calls;
  }

  Future<void> sendCall(
      String email,
      String username,
      String entryPrice,
      String stopLoss,
      String targetPrice,
      String credentials,
      String duration) async {
    var timestamp = DateTime.now();
    var data = Call(
      givenBy: {
        'email': email,
        'username': username,
      },
      entryPrice: entryPrice,
      shareAttributes: credentials,
      stopLoss: stopLoss,
      targetPrice: targetPrice,
      duration: duration,
      timestamp: timestamp,
    ).toMap();
    var docRef = callsReference.document();
    data.putIfAbsent('reference', () => docRef);
    await docRef.setData(data);
    await tradersReference
        .document(email)
        .updateData({'totalCalls': FieldValue.increment(1)}).catchError(
            (e) => print('Error in saveChanges: ' + e.toString()));
  }
}
