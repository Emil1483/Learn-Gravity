import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomFab extends StatefulWidget {
  final List<Widget> buttons;
  final Widget mainIconFront;
  final Widget mainIconBack;
  final Color mainColor;
  final Object heroTag;
  final bool shrinkChildren;

  CustomFab({
    @required this.buttons,
    this.mainIconFront = const Icon(Icons.more_vert),
    this.mainIconBack = const Icon(Icons.close),
    this.shrinkChildren = true,
    this.mainColor,
    this.heroTag,
    Key key,
  })  : assert(buttons != null),
        super(key: key);

  @override
  CustomFabState createState() => CustomFabState();
}

class CustomFabState extends State<CustomFab> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    if (_controller.isDismissed)
      _controller.forward();
    else
      _controller.reverse();
  }

  void up() {
    _controller.forward();
  }

  void down() {
    _controller.reverse();
  }

  double _getSize(double t) {
    double newT = Curves.linear.transform(t);
    return (math.cos(newT * 2 * math.pi) + 1) / 2;
  }

  double _getRotation(double t) {
    double newT = Curves.linear.transform(t);
    return newT * math.pi / 2;
  }

  List<Widget> _buildSmallButtons() {
    Animation<Offset> position = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    int index = 0;
    return widget.buttons.map((Widget button) {
      bool last = index >= widget.buttons.length - 1;
      bool addPadding = last || !widget.shrinkChildren;
      index += 1;
      return Padding(
        padding: EdgeInsets.only(bottom: addPadding ? 24.0 : 0),
        child: Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..scale(widget.shrinkChildren ? 0.7 : 1.0),
          child: SlideTransition(
            position: position,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ),
              child: button,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildMainButton() {
    return FloatingActionButton(
      heroTag: widget.heroTag != null ? widget.heroTag : this,
      backgroundColor: widget.mainColor,
      onPressed: _animate,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(_getSize(_controller.value))
              ..rotateZ(_getRotation(_controller.value)),
            child: _controller.value <= 0.5
                ? widget.mainIconFront
                : widget.mainIconBack,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (Widget button in _buildSmallButtons()) children.add(button);
    children.add(_buildMainButton());

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }
}
