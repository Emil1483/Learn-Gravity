import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './routes/home_route.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gravity",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.orange[800],
        highlightColor: Colors.lightBlueAccent,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => HomeRoute(),
      },
    );
  }
}
