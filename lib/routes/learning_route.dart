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
    String string = await rootBundle.loadString("assets/learning.txt");
    List<String> strings = string.split("\n");
    List<String> texts = [];
    int index = 0;
    for (String s in strings) {
      if (index % 2 == 0) texts.add(s);
      index++;
    }
    _intro = texts[0];
    _introForce = texts[1];
    _forceExplained = texts[2];
    _gravity1 = texts[3];
    _gravity2 = texts[4];
    setState(() => _waiting = false);
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
