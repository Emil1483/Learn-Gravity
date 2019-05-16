import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/question.dart';

enum Animation {
  Wrong,
  Correct,
  Nothing,
}

class Quiz extends StatefulWidget {
  final List<Question> questions;
  final Function onCompleted;

  Quiz({@required this.questions, @required this.onCompleted, Key key})
      : assert(questions != null),
        assert(onCompleted != null),
        super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  List<int> _chosen;
  List<bool> _correct;
  List<bool> _checked;
  AnimationController _controller;

  bool _allCorrect = false;

  @override
  initState() {
    super.initState();
    _chosen = widget.questions.map((Question q) => -1).toList();
    _correct = widget.questions.map((Question q) => false).toList();
    _checked = widget.questions.map((Question q) => false).toList();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 100),
      value: 0.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _animationPlay() {
    AnimationStatus status = _controller.status;
    bool atEnd = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _controller.fling(velocity: atEnd ? -1.0 : 1.0);
  }

  double _getOffsetWrong(double t) {
    return (10 * math.sin(t * math.pi) * math.sin(t * math.pi * 3));
  }

  double _getOffsetCorrect(double t) {
    return 0.1 * math.sin(t * math.pi) + 1;
  }

  void _handleUpdatedChoise(int newChoise, int qId) {
    setState(() {
      _chosen[qId] = newChoise;
      _checked[qId] = false;
    });
  }

  Matrix4 _getMatrix(Animation animation) {
    Matrix4 matrix = Matrix4.identity();
    if (animation == Animation.Nothing) return matrix;
    if (animation == Animation.Wrong) {
      double off = _getOffsetWrong(_controller.value);
      matrix.translate(off);
      return matrix;
    } else {
      double scale = _getOffsetCorrect(_controller.value);
      matrix.scale(scale);
      return matrix;
    }
  }

  Widget _animatedFeedback(
      {@required Widget child, @required Animation animation}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget c) {
        return Transform(
          alignment: Alignment.center,
          transform: _getMatrix(animation),
          child: child,
        );
      },
    );
  }

  Widget _buildChoise(String choise, int id, int qId) {
    bool chosen = _chosen[qId] == id;
    bool wrong = !_correct[qId];
    Animation animation;
    if (!chosen)
      animation = Animation.Nothing;
    else
      animation = wrong ? Animation.Wrong : Animation.Correct;
    return _animatedFeedback(
      animation: animation,
      child: ListTile(
        title: Text(choise),
        onTap: () => _handleUpdatedChoise(id, qId),
        leading: Radio(
          activeColor: !_checked[qId]
              ? Theme.of(context).accentColor
              : _correct[qId]
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).errorColor,
          groupValue: _chosen[qId],
          onChanged: (int newChoise) => _handleUpdatedChoise(newChoise, qId),
          value: id,
        ),
      ),
    );
  }

  bool _isCorrect() {
    for (bool isCorrect in _correct) if (!isCorrect) return false;
    return true;
  }

  Widget _buildQuestion(Question q) {
    final int qId = widget.questions.indexOf((q));

    List<Widget> children = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          q.question,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle,
        ),
      ),
    ];

    for (int i = 0; i < q.choises.length; i++) {
      children.add(Divider(
        color: Colors.white70,
      ));

      children.add(_buildChoise(q.choises[i], i, qId));

      if (i >= q.choises.length - 1)
        children.add(Divider(
          color: Colors.white70,
        ));
    }
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(top: 16.0),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 22.0),
      child: Column(
        children: widget.questions.map(_buildQuestion).toList()
          ..add(
            _animatedFeedback(
              animation: _allCorrect ? Animation.Correct : Animation.Wrong,
              child: Padding(
                padding: EdgeInsets.only(top: 22.0),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    "Check Results",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    for (int i = 0; i < widget.questions.length; i++) {
                      setState(() {
                        _checked[i] = _chosen[i] != -1;
                        _correct[i] = _chosen[i] == widget.questions[i].correct;
                      });
                    }

                    _animationPlay();

                    setState(() => _allCorrect = _isCorrect());

                    if (_allCorrect) widget.onCompleted();
                  },
                ),
              ),
            ),
          ),
      ),
    );
  }
}
