import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../enums/modes.dart';
import './popup.dart';
import './popup_tab.dart';

class ModeFab extends StatefulWidget {
  ModeFab({Key key}) : super(key: key);

  @override
  ModeFabState createState() => ModeFabState();
}

class ModeFabState extends State<ModeFab> with WidgetsBindingObserver {
  int _numStartingModes = 2;
  FlutterLocalNotificationsPlugin _notifications;
  bool _isOpen = true;

  @override
  initState() {
    super.initState();

    _getStartingModes();

    _initNotification();

    WidgetsBinding.instance.addObserver(this);
  }

  void _getStartingModes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int numModes = prefs.getInt("startingModes");
    if (numModes != null) {
      _numStartingModes = numModes;
      print("_numStartingModes: $_numStartingModes");
    } else {
      prefs.setInt("startingModes", _numStartingModes);
    }
    setState(() {
      _modes = <List>[];
      for (int i = 0; i < _numStartingModes; i++) {
        _modes.add(_allModes[i]);
      }
    });
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        _isOpen = false;
        break;
      case AppLifecycleState.resumed:
        _isOpen = true;
        break;
      default:
        break;
    }
  }

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

  final List<Duration> _delays = [
    Duration(seconds: 10),
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 5),
  ];

  List<List<dynamic>> _modes;

  void _initNotification() {
    _notifications = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);
    _notifications.initialize(
      initSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<dynamic> _onSelectNotification(String payload) {
    _showPopup();
    return Future.delayed(Duration());
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopup(
            context: context,
            mode: _modes[_modes.length - 1][1],
          ),
    );
  }

  void _showNotification() async {
    final android = AndroidNotificationDetails(
        "channel id", "channel NAME", "CHANNEL DESCRIPTION");
    final iOS = IOSNotificationDetails();
    final platfrom = NotificationDetails(android, iOS);
    await _notifications.show(
      0,
      "Congratulations!",
      _getTextFrom(_modes[_modes.length - 1][1]),
      platfrom,
    );
  }

  Modes _currentMode = Modes.Gravity;

  Modes get mode => _currentMode;

  int get currentLength => _modes.length;

  void _addMode() async {
    if (_modes.length >= _allModes.length) return;

    int index = _modes.length;
    setState(() {
      _modes.add(_allModes[index]);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("startingModes", _modes.length);

    if (_isOpen)
      _showPopup();
    else
      _showNotification();
  }

  void addDelayedMode() async {
    int delayIndex = _modes.length - _numStartingModes;
    if (delayIndex >= _delays.length) return;
    await Future.delayed(
      _delays[delayIndex],
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

    if (_modes == null) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      );
    }

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
