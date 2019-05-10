import 'package:flutter/material.dart';

class LearningRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    //TODO: Put all body text in a text tiles

    Widget title = Text(
      "How Does Gravity Work?",
      style: textTheme.title,
      textAlign: TextAlign.center,
    );

    Widget gravityGif = Image.asset(
      "assets/elliptical_orbit.gif",
    );

    Widget intro = Text(
      "Gravity is a universal force that affects all parts of the Universe. It is the force that causes you to stay on earth. It is the force that causes apples to fall. And it is the force that causes the moon to fall. But what do I mean with the moon falling? And what IS gravity and how does it work?",
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    Widget introForce = Text(
      "But before we can understand how the force of gravity works, we must first understand what a force is.",
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    Widget forceGif = Image.asset(
      "assets/force_learning.gif",
    );

    Widget forceExplained = Text(
      "Forces cause objects to accelerate, and when an object is accelerating, its velocity changes. Furthermore, a force contains a magnitude and a direction. Above, the yellow arrow’s length represents the force’s magnitude. And its direction represents the force’s direction.",
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    double width = MediaQuery.of(context).size.width;
    double maxWidth = 600;
    return ListView(
      padding: width <= maxWidth
          ? EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0)
          : EdgeInsets.symmetric(
              horizontal: 40.0 + (width - maxWidth), vertical: 48.0),
      children: <Widget>[
        title,
        gravityGif,
        intro,
        SizedBox(height: 16.0),
        introForce,
        forceGif,
        forceExplained,
        SizedBox(height: 100.0),
      ],
    );
  }
}
