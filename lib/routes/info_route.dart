import 'package:flutter/material.dart';

import './about_route.dart';
import './learning_route.dart';

class InfoRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget appbar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        "About",
        style: TextStyle(color: Colors.white),
      ),
      bottom: TabBar(
        indicatorColor: Theme.of(context).highlightColor,
        tabs: <Widget>[
          Tab(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appbar,
        body: TabBarView(
          children: <Widget>[
            AboutRoute(),
            LearningRoute(),
          ],
        ),
      ),
    );
  }
}
