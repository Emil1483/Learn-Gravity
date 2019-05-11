import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LearningRoute extends StatefulWidget {
  @override
  _LearningRouteState createState() => _LearningRouteState();
}

class _LearningRouteState extends State<LearningRoute> {
  String _intro;
  String _introForce;
  String _forceExplained;
  String _gravity1;
  String _gravity2;

  bool _waiting = true;

  @override
  initState() {
    _getTexts();
    super.initState();
  }

  void _getTexts() async {
    _intro = await getText("assets/learning/intro.txt");
    _introForce = await getText("assets/learning/introForce.txt");
    _forceExplained = await getText("assets/learning/forceExplained.txt");
    _gravity1 = await getText("assets/learning/gravity1.txt");
    _gravity2 = await getText("assets/learning/gravity2.txt");
    setState(() => _waiting = false);
  }

  Future<String> getText(String path) async {
    String string = await rootBundle.loadString(path);
    return string.replaceAll("\n", " ");
  }

  @override
  Widget build(BuildContext context) {
    if (_waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    TextTheme textTheme = Theme.of(context).textTheme;

    Widget title = Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Text(
        "How Does Gravity Work?",
        style: textTheme.title,
        textAlign: TextAlign.center,
      ),
    );

    Widget gravityGif = Image.asset(
      "assets/elliptical_orbit.gif",
    );

    Widget intro = Text(
      _intro,
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    Widget introForce = Text(
      _introForce,
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    Widget forceGif = Image.asset(
      "assets/force_learning.gif",
    );

    Widget forceExplained = Text(
      _forceExplained,
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    Widget binaryGif = Image.asset(
      "assets/binary_system.gif",
    );

    Widget formula = Text(
      _gravity1,
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    Widget binaryGif2 = Column(
      children: <Widget>[
        Image.asset(
          "assets/binary_system_2.gif",
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
          child: Image.asset(
            "assets/formula.png",
          ),
        ),
      ],
    );

    Widget gravity2 = Text(
      _gravity2,
      style: textTheme.body1,
      textAlign: TextAlign.center,
    );

    double width = MediaQuery.of(context).size.width;
    double maxWidth = 500;
    return ListView(
      padding: width <= maxWidth
          ? EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0)
          : EdgeInsets.symmetric(
              horizontal: 40.0 + (width - maxWidth) / 2, vertical: 48.0),
      children: <Widget>[
        title,
        intro,
        SizedBox(height: 16.0),
        introForce,
        forceGif,
        forceExplained,
        binaryGif,
        formula,
        binaryGif2,
        gravity2,
        SizedBox(height: 100.0),
      ],
    );
  }
}
