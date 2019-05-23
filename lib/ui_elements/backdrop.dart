import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './custom_fab.dart';
import './mode_fab.dart';
import './grav_slider.dart';
import './popup.dart';
import './transitioner.dart';
import './circles.dart';
import './popup_tab.dart';
import '../nodes/rootNode.dart';
import '../routes/info_route.dart';
import '../routes/spritewidget_content.dart';
import '../inheritedWidgets/inheritedRootNode.dart';

class BackdropPage extends StatefulWidget {
  @override
  _BackdropPageState createState() => _BackdropPageState();
}

class _BackdropPageState extends State<BackdropPage>
    with TickerProviderStateMixin {
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
    _unlocked = false; //TODO: Remove this when done!
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
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Widget> tabs = <Widget>[
      Padding(
        padding: EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Congratulations!",
              style: textTheme.title,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.0),
            Text(
              "You have now unlocked the sandbox",
              style: textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      PopupTab(
        text: "Use the slider to change the gravitational constant",
        imgUrl: "assets/gifs/gravity_slider.gif",
      ),
      PopupTab(
        text: "You can at any time get back to the previous page",
        imgUrl: "assets/gifs/info.gif",
      ),
      PopupTab(
        text: "You can at any time reset the sandbox",
        imgUrl: "assets/gifs/reset.gif",
      ),
      PopupTab(
        text: "Try the different modes!",
        imgUrl: "assets/gifs/modes.gif",
      ),
    ];

    TabController tabController = TabController(
      vsync: this,
      length: tabs.length,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => Popup(
            fabPressed: (BuildContext context) {
              if (tabController.animation.value + 1 < tabController.length) {
                int newIndex = math.min(
                    (tabController.animation.value + 1).round(),
                    tabController.length - 1);
                tabController.animateTo(newIndex);
              } else {
                Navigator.of(context).pop();
              }
            },
            fabChild: Transitioner(
              animation: tabController.animation,
              fromMin: (tabs.length - 2).toDouble(),
              fromMax: (tabs.length - 1).toDouble(),
              toMin: 0,
              toMax: 1,
              child1: Icon(Icons.navigate_next),
              child2: Icon(Icons.done),
            ),
            child: DefaultTabController(
              length: tabs.length,
              child: Circles(
                controller: tabController,
                child: TabBarView(
                  controller: tabController,
                  children: tabs,
                ),
              ),
            ),
          ),
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
