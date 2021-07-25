import 'package:flutter/material.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User({
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phone,
  });

  User.fromJson(Map json)
      : firstName = json['first name'],
        lastName = json['last name'],
        email = json['email'],
        phone = json['phone'];

  Map<String, dynamic> toMap() {
    return {
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'phone': phone,
      'timestamp': DateTime.now(),
    };
  }
}
