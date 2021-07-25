import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Call {
  final Map<String, dynamic> givenBy;
  final String shareAttributes;
  final String entryPrice;
  final String targetPrice;
  final String stopLoss;
  final DateTime timestamp;
  final String duration;

  Call(
      {@required this.givenBy,
      @required this.shareAttributes,
      @required this.entryPrice,
      @required this.targetPrice,
      @required this.stopLoss,
      @required this.timestamp,
      @required this.duration});

  Call.fromJson(Map jsonMap)
      : givenBy = jsonMap['givenBy'],
        duration = jsonMap['duration'],
        shareAttributes = jsonMap['shareAttributes'],
        entryPrice = jsonMap['entryPrice'],
        targetPrice = jsonMap['targetPrice'],
        stopLoss = jsonMap['stopLoss'],
        timestamp = (jsonMap['timestamp'] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      'givenBy': givenBy,
      'shareAttributes': shareAttributes,
      'entryPrice': entryPrice,
      'targetPrice': targetPrice,
      'stopLoss': stopLoss,
      'duration': duration,
      'timestamp': timestamp,
    };
  }
}
