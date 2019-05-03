import 'package:flutter/material.dart';

import './about_route.dart';
import './learning_route.dart';

class InfoRoute extends StatelessWidget {
  final Function onBackPressed;

  InfoRoute({@required this.onBackPressed}) : assert(onBackPressed != null);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                AboutRoute(),
                LearningRoute(),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: onBackPressed,
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
