import 'package:flutter/material.dart';

import '../enums/modes.dart';

class ModeFab extends StatefulWidget {
  ModeFab({Key key}) : super(key: key);

  @override
  ModeFabState createState() => ModeFabState();
}

class ModeFabState extends State<ModeFab> {
  final List<List<dynamic>> _modes = <List>[
    [
      Padding(
        padding: EdgeInsets.all(12.0),
        child: Image.asset("assets/gravity_in.png"),
      ),
      Modes.Gravity
    ],
    [
      Padding(
        padding: EdgeInsets.all(12.0),
        child: Image.asset("assets/gravity_out.png"),
      ),
      Modes.Repel
    ],
    [Icon(Icons.bubble_chart), Modes.Add],
  ];

  Modes _currentMode = Modes.Add;

  Modes get mode => _currentMode;

  @override
  Widget build(BuildContext context) {
    Color selected = Theme.of(context).primaryColor;
    Color notSelected = Theme.of(context).disabledColor;

    return Column(
      children: _modes.map((List<dynamic> item) {
        return Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: FloatingActionButton(
            backgroundColor: item[1] == _currentMode ? selected : notSelected,
            onPressed: () => setState(() {
                  if (_currentMode != item[1])
                    _currentMode = item[1];
                  else
                    _currentMode = Modes.Nothing;
                }),
            child: item[0],
          ),
        );
      }).toList(),
    );
  }
}
