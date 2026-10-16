import 'package:flutter/material.dart';
import 'package:projec1/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     title: 'Aplikasi',
     theme: ThemeData(
      primarySwatch: Colors.deepPurple,
     ),
     home: SplashScreen(),
    );
  }
}

