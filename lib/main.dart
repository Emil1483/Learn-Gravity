import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './routes/home_route.dart';
import './inheritedWidgets/inheritedRootNode.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InheritedRootNode(
      child: MaterialApp(
        title: "How Gravity Works",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.orange.shade800,
          highlightColor: Colors.lightBlueAccent,
          cardColor: Color(0xff424242),
          backgroundColor: Color(0xff303030),
          disabledColor: Colors.grey.shade800,
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            headline: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            subtitle: TextStyle(
                fontSize: 16.0,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400),
            subhead: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            body1: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        home: HomeRoute(),
      ),
    );
  }
}
