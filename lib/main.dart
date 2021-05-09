import 'package:flutter/material.dart';
import 'package:url_shortener_app/pages/Landing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AShortL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Landing()
    );
  }
}

