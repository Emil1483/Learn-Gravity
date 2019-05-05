import 'package:flutter/material.dart';

import '../enums/modes.dart';

class ModeFab extends StatefulWidget {
  ModeFab({Key key}) : super(key: key);

  @override
  ModeFabState createState() => ModeFabState();
}

class ModeFabState extends State<ModeFab> {
  final List<List<dynamic>> modes = <List>[
    [Icon(Icons.border_outer), Modes.Nothing],
    [Icon(Icons.brightness_5), Modes.Gravity],
    [Icon(Icons.brightness_7), Modes.Repel],
    [Icon(Icons.bubble_chart), Modes.Add],
  ];

  int _currenMode = 0;

  void _increment() {
    if (_currenMode + 1 > modes.length - 1)
      _currenMode = 0;
    else
      _currenMode += 1;
  }

  Modes get mode => modes[_currenMode][1];

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).accentColor,
      heroTag: this,
      onPressed: () => setState(_increment),
      child: modes[_currenMode][0],
    );
  }
}
