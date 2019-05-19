import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomFab extends StatefulWidget {
  final Widget child;
  final Widget mainIconFront;
  final Widget mainIconBack;
  final Color mainColor;
  final Object heroTag;
  final bool shrinkChildren;

  CustomFab({
    @required this.child,
    this.mainIconFront = const Icon(Icons.more_vert),
    this.mainIconBack = const Icon(Icons.close),
    this.shrinkChildren = true,
    this.mainColor,
    this.heroTag,
    Key key,
  })  : assert(child != null),
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
      duration: Duration(milliseconds: 300),
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

  Widget _buildSmallButtons() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        double val = 1 -
            CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOutCubic,
            ).value;

        return Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..translate(0.0, 45.0 * val)
            ..rotateX((val * math.pi / 2)),
          child: SingleChildScrollView(
            child: widget.child,
          ),
        );
      },
    );
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: _buildSmallButtons(),
            ),
          ),
        ),
        _buildMainButton(),
      ],
    );
  }
}
