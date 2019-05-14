import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ui_elements/quiz.dart';
import '../models/question.dart';

class LearningRoute extends StatefulWidget {
  final Function onQuizCompleted;

  LearningRoute({@required this.onQuizCompleted, Key key})
      : assert(onQuizCompleted != null),
        super(key: key);

  @override
  _LearningRouteState createState() => _LearningRouteState();
}

class _LearningRouteState extends State<LearningRoute> {
  String _intro;
  String _introForce;
  String _forceExplained;
  String _gravity1;
  String _gravity2;
  String _falling;
  String _question;

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
    _falling = texts[5];
    _question = texts[6];
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

    double width = MediaQuery.of(context).size.width;
    double maxWidth = 500;
    return ListView(
      padding: width <= maxWidth
          ? EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0)
          : EdgeInsets.symmetric(
              horizontal: 40.0 + (width - maxWidth) / 2, vertical: 48.0),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            "How Does Gravity Work?",
            style: textTheme.title,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          _intro,
          style: textTheme.body1,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.0),
        Text(
          _introForce,
          style: textTheme.body1,
          textAlign: TextAlign.center,
        ),
        Image.asset(
          "assets/gifs/force_learning.gif",
        ),
        Text(
          _forceExplained,
          style: textTheme.body1,
          textAlign: TextAlign.center,
        ),
        Image.asset(
          "assets/gifs/binary_system.gif",
        ),
        Text(
          _gravity2,
          style: textTheme.body1,
          textAlign: TextAlign.center,
        ),
        Column(
          children: <Widget>[
            Image.asset(
              "assets/gifs/binary_system_2.gif",
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
              child: Image.asset(
                "assets/formula.png",
              ),
            ),
          ],
        ),
        Text(
          _gravity1,
          style: textTheme.body1,
          textAlign: TextAlign.center,
        ),
        Image.asset(
          "assets/gifs/gravity_demo.gif",
        ),
        Text(
          _falling,
          style: textTheme.body1,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Image.asset(
            "assets/gifs/elliptical_orbit.gif",
          ),
        ),
        Text(
          _question,
          style: textTheme.body1,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 22.0),
          child: Quiz(
            questions: <Question>[
              Question(
                question: "Stupid question where the answear is obvios",
                choises: <String>[
                  "not correct",
                  "wrong",
                  "this is the correct answear",
                  "bad",
                ],
                correct: 2,
              ),
            ],
            onCompleted: widget.onQuizCompleted,
          ),
        ),
        SizedBox(height: 100.0),
      ],
    );
  }
}
