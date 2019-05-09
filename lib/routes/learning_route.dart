import 'package:flutter/material.dart';

class LearningRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget title = Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "How Does Gravity Work?",
        style: Theme.of(context).textTheme.title,
        textAlign: TextAlign.center,
      ),
    );

    Widget gravityGif = Image.asset(
      "assets/elliptical_orbit.gif",
    );

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      children: <Widget>[
        title,
        gravityGif,
      ],
    );
  }
}
