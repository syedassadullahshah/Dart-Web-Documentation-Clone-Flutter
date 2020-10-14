import 'package:flutter/material.dart';

import './pages/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Technical Documentation',
      home: HomePage(),
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Color(0xff4A4A4A),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
