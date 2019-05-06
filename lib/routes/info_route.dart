import 'package:flutter/material.dart';

import './about_route.dart';
import './learning_route.dart';

class InfoRoute extends StatefulWidget {
  final Function onBackPressed;

  InfoRoute({@required this.onBackPressed}) : assert(onBackPressed != null);

  @override
  _InfoRouteState createState() => _InfoRouteState();
}

class _InfoRouteState extends State<InfoRoute> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: widget.onBackPressed,
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.arrow_downward),
        ),
        body: TabBarView(
          controller: TabController(length: 2, initialIndex: 1, vsync: this),
          children: <Widget>[
            AboutRoute(),
            LearningRoute(),
          ],
        ),
      ),
    );
  }
}
