import 'package:flutter/material.dart';

import '../enums/modes.dart';
import './popup.dart';

class ModeFab extends StatefulWidget {
  ModeFab({Key key}) : super(key: key);

  @override
  ModeFabState createState() => ModeFabState();
}

class ModeFabState extends State<ModeFab> {
  final List<List<dynamic>> _allModes = <List>[
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
    [Icon(Icons.add_circle_outline), Modes.Negative],
    [Icon(Icons.compare_arrows), Modes.Move],
    [Icon(Icons.arrow_upward), Modes.AddWithVel],
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

  void addMode() {
    if (_modes.length >= _allModes.length) return;
    setState(() {
      int index = _modes.length;
      _modes.add(_allModes[index]);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => Popup(child: _buildPopupTab(context)),
    );
  }

  Widget _buildPopupTab(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "You've just unlocked a new mode!",
                style: textTheme.subtitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.0),
              Container(
                height: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset("assets/gifs/tutorial_1.gif"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Move the addMode logic from the rootNode to here

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
