import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class CustomFab extends StatefulWidget {
  final List<Widget> buttons;
  final Widget mainIconFront;
  final Widget mainIconBack;
  final Color mainColor;
  final Object heroTag;

  CustomFab({
    @required this.buttons,
    this.mainIconFront = const Icon(Icons.more_vert),
    this.mainIconBack = const Icon(Icons.close),
    this.mainColor,
    this.heroTag,
  }) {
    assert(buttons != null);
  }

  @override
  _CustomFabState createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab> with TickerProviderStateMixin {
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
  void didUpdateWidget(CustomFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.reverse();
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

    return widget.buttons.map((Widget button) {
      return Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()..scale(0.7),
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
      );
    }).toList();
  }

  Widget _buildMainButton() {
    //TODO: Fix animation from flare
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
