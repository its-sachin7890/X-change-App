import 'package:flutter/material.dart';

class Trader {
  final String username;
  final String rewardRisk;
  final String successRate;
  final String fee;
  int followers;
  final String email;
  final bool currencyFutures;
  final bool currencyOptions;
  final bool commodityFutures;
  final bool commodityOptions;
  final bool equityCash;
  final bool equityFutures;
  final bool equityOptions;
  String avatar;

  Trader({
    @required this.username,
    @required this.rewardRisk,
    @required this.successRate,
    @required this.fee,
    @required this.email,
    @required this.followers,
    this.currencyFutures,
    this.currencyOptions,
    this.commodityFutures,
    this.commodityOptions,
    this.equityCash,
    this.equityFutures,
    this.equityOptions,
    @required this.avatar,
  });

  Trader.fromJson(Map jsonMap)
      : username = jsonMap['username'],
        rewardRisk = jsonMap['rewardRisk'],
        successRate = jsonMap['successRate'],
        fee = jsonMap['fee'],
        followers = jsonMap['followers'],
        email = jsonMap['email'],
        currencyFutures = jsonMap.containsKey('currencyFutures')
            ? jsonMap['currencyFutures']
            : null,
        currencyOptions = jsonMap.containsKey('currencyOptions')
            ? jsonMap['currencyOptions']
            : null,
        commodityFutures = jsonMap.containsKey('commodityFutures')
            ? jsonMap['commodityFutures']
            : null,
        commodityOptions = jsonMap.containsKey('commodityOptions')
            ? jsonMap['commodityOptions']
            : null,
        equityCash =
            jsonMap.containsKey('equityCash') ? jsonMap['equityCash'] : null,
        equityFutures = jsonMap.containsKey('equityFutures')
            ? jsonMap['equityFutures']
            : null,
        equityOptions = jsonMap.containsKey('equityOptions')
            ? jsonMap['equityOptions']
            : null,
        avatar = 'assets/avatars/' + jsonMap['avatar'] + '.png';

}
