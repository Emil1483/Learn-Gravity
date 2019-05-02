import 'package:flutter/material.dart';

import '../nodes/rootNode.dart';
import '../enums/modes.dart';

class ModeFab extends StatefulWidget {
  final RootNode rootNode;

  ModeFab({@required this.rootNode}) : assert(rootNode != null);

  @override
  _ModeFabState createState() => _ModeFabState();
}

class _ModeFabState extends State<ModeFab> {
  final List<List<dynamic>> modes = <List>[
    [Icon(Icons.border_outer), Modes.Nothing],
    [Icon(Icons.brightness_5), Modes.Gravity],
    [Icon(Icons.brightness_7), Modes.Repel],
    [Icon(Icons.bubble_chart), Modes.Add],
  ];

  int _currenMode = 0;

  void _increment() {
    if (_currenMode + 1 > modes.length - 1) {
      _currenMode = 0;
    } else {
      _currenMode += 1;
    }
    widget.rootNode.setMode(modes[_currenMode][1]);
  }

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
