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
        title: "Gravity",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.orange[800],
          highlightColor: Colors.lightBlueAccent,
          backgroundColor: Color(0xff303030),
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
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
          ),
        ),
        home: HomeRoute(),
      ),
    );
  }
}
