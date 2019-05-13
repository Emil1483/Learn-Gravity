import 'package:flutter/foundation.dart';

class Question {
  final String question;
  final List<String> choises;
  final int correct;

  const Question({
    @required this.question,
    @required this.choises,
    @required this.correct,
  })  : assert(question != null),
        assert(choises != null),
        assert(correct != null);
}
