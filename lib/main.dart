import 'package:flutter/material.dart';
import 'package:screengrabtext/home_drawer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ScreenGrab',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeDrawer(),
    );
  }
}