import 'package:flutter/material.dart';

import '../enums/modes.dart';
import './popup.dart';
import './popup_tab.dart';

class ModeFab extends StatefulWidget {
  ModeFab({Key key}) : super(key: key);

  @override
  ModeFabState createState() => ModeFabState();
}

class ModeFabState extends State<ModeFab> {
  static Widget _buildIcon(String path) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Image.asset(path),
    );
  }

  final List<List<dynamic>> _allModes = <List>[
    [_buildIcon("assets/gravity_in.png"), Modes.Gravity],
    [_buildIcon("assets/gravity_out.png"), Modes.Repel],
    [Icon(Icons.bubble_chart), Modes.Add],
    [_buildIcon("assets/add_negative.png"), Modes.Negative],
    [_buildIcon("assets/move.png"), Modes.Move],
    [_buildIcon("assets/black_hole.png"), Modes.AddWithVel],
  ];

  List<List<dynamic>> _modes;

  @override
  initState() {
    _modes = <List>[];
    _modes.add(_allModes[0]);
    _modes.add(_allModes[1]);
    super.initState();
  }

  Modes _currentMode = Modes.Gravity;

  Modes get mode => _currentMode;

  int get currentLength => _modes.length;

  void _addMode() {
    if (_modes.length >= _allModes.length) return;
    int index = _modes.length;
    setState(() {
      _modes.add(_allModes[index]);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopup(
            context: context,
            mode: _modes[index][1],
          ),
    );
  }

  void addDelayedMode() async {
    await Future.delayed(
      Duration(seconds: 1),
    ).then(
      (_) => _addMode(),
    );
  }

  Widget _buildPopup({@required BuildContext context, @required Modes mode}) {
    return Popup(
      child: PopupTab(
        padding: EdgeInsets.symmetric(horizontal: 52.0, vertical: 22.0),
        text: _getTextFrom(mode),
        imgUrl: _getImgFrom(mode),
      ),
    );
  }

  String _getImgFrom(Modes mode) {
    switch (mode) {
      case Modes.Add:
        return "assets/gifs/modes_add.gif";
      case Modes.AddWithVel:
        return "assets/gifs/modes_black_hole.gif";
      case Modes.Move:
        return "assets/gifs/modes_move.gif";
      case Modes.Negative:
        return "assets/gifs/modes_negative.gif";
      default:
        return "assets/gifs/modes_add.gif";
    }
  }

  String _getTextFrom(Modes mode) {
    switch (mode) {
      case Modes.Negative:
        return "You've just unlocked a new mode! You can now add points with negative mass!";
      default:
        return "You've just unlocked a new mode!";
    }
  }

  @override
  Widget build(BuildContext context) {
    Color selected = Theme.of(context).primaryColor;
    Color notSelected = Theme.of(context).disabledColor;

    return Column(
      children: _modes.map((List<dynamic> item) {
        return Transform.scale(
          alignment: Alignment.topCenter,
          scale: 0.7,
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
