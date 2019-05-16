import 'package:flutter/material.dart';

class QuizData {
  final List<int> chosen;
  final List<bool> correct;
  final List<bool> checked;

  QuizData({
    @required this.chosen,
    @required this.correct,
    @required this.checked,
  });

  bool hasData() {
    return chosen != null && correct != null && checked != null;
  }
}
