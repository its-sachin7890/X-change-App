import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xchange_app/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Xchange App',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}
