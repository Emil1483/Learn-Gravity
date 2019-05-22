import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../nodes/rootNode.dart';
import '../ui_elements/custom_fab.dart';
import '../ui_elements/mode_fab.dart';
import '../ui_elements/grav_slider.dart';
import '../routes/info_route.dart';
import '../routes/spritewidget_content.dart';
import '../inheritedWidgets/inheritedRootNode.dart';
import '../ui_elements/popup.dart';

class BackdropPage extends StatefulWidget {
  @override
  _BackdropPageState createState() => _BackdropPageState();
}

class _BackdropPageState extends State<BackdropPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool _unlocked = false;

  static const _PANEL_HEADER_HEIGHT = 64.0;
  static const _PANEL_HEADER_PEAKING = 0.0;

  CustomFab customFab;
  final _customFabKey = GlobalKey<CustomFabState>();
  final _modeFabKey = GlobalKey<ModeFabState>();

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 100),
      value: 1.0,
      vsync: this,
    );
    _controller.addListener(() {
      if (_controller.value == 0) _seeSprite();
    });

    _getUnlocked();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _getUnlocked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool unlocked = prefs.getBool("unlocked");
    if (unlocked != null) {
      setState(() {
        _unlocked = unlocked;
      });
    }
  }

  void unlock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("unlocked", true);
    setState(() {
      _unlocked = true;
    });
  }

  bool get isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _panelUp() {
    if (!isPanelVisible) {
      _controller.fling(velocity: 1.0);
      _customFabKey.currentState.down();
    }
  }

  bool _panelDown() {
    if (!_unlocked) return false;
    if (isPanelVisible) {
      _controller.fling(velocity: -1.0);
      _customFabKey.currentState.down();
    }
    return true;
  }

  void _seeSprite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenSprite = prefs.getBool("seenSprite");
    if (seenSprite == null || !seenSprite) {
      prefs.setBool("seenSprite", true);
    }
    _startTutorial(); //TODO: Move this into the if block when done implementing the tutorial!
  }

  void _startTutorial() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Popup(),
    );
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double top = constraints.biggest.height - _PANEL_HEADER_PEAKING;
    final double bottom = 0;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: RelativeRect.fromLTRB(0.0, _PANEL_HEADER_HEIGHT, 0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    RootNode rootNode = InheritedRootNode.of(context).rootNode;
    ModeFab modeFab = ModeFab(key: _modeFabKey);

    customFab = CustomFab(
      key: _customFabKey,
      mainColor: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          modeFab,
          Transform.scale(
            alignment: Alignment.topCenter,
            scale: 0.7,
            child: FloatingActionButton(
              heroTag: "resetButton",
              backgroundColor: Theme.of(context).accentColor,
              onPressed: rootNode.reset,
              child: Icon(Icons.replay),
            ),
          ),
          Transform.scale(
            alignment: Alignment.topCenter,
            scale: 0.7,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              heroTag: "infoButton",
              onPressed: _panelUp,
              child: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
    );

    final ThemeData theme = Theme.of(context);
    rootNode.setModeFabKey(_modeFabKey);
    return Stack(
      children: <Widget>[
        SpritewidgetContent(
          customFab: customFab,
          gravitySlider: GravitySlider(),
        ),
        PositionedTransition(
          rect: _getPanelAnimation(constraints),
          child: Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            color: theme.backgroundColor,
            child: Container(
              margin: EdgeInsets.only(top: 16),
              color: theme.backgroundColor,
              child: InfoRoute(
                  onBackPressed: _panelDown,
                  animation: _controller,
                  onQuizCompleted: unlock,
                  isUnlocked: _unlocked),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    InheritedRootNode.of(context).rootNode.setOnTappedFunction(_panelDown);
    return LayoutBuilder(
      builder: _buildStack,
    );
  }
}
