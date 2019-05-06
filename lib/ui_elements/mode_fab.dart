import 'package:flutter/material.dart';

import '../enums/modes.dart';
import './custom_fab.dart';

class ModeFab extends StatefulWidget {
  ModeFab({Key key}) : super(key: key);

  @override
  ModeFabState createState() => ModeFabState();
}

class ModeFabState extends State<ModeFab> {
  final List<List<dynamic>> _modes = <List>[
    [Icon(Icons.border_outer), Modes.Nothing],
    [Icon(Icons.brightness_5), Modes.Gravity],
    [Icon(Icons.brightness_7), Modes.Repel],
    [Icon(Icons.bubble_chart), Modes.Add],
  ];

  Modes _currentMode = Modes.Nothing;

  Modes get mode => _currentMode;

  @override
  Widget build(BuildContext context) {
    Color selected = Theme.of(context).primaryColor;
    Color notSelected = Theme.of(context).disabledColor;

    return CustomFab(
      shrinkChildren: false,
      buttons: _modes.map((List<dynamic> item) {
        return FloatingActionButton(
          backgroundColor: item[1] == _currentMode ? selected : notSelected,
          onPressed: () => setState(() => _currentMode = item[1]),
          child: item[0],
        );
      }).toList(),
    );
  }
}
