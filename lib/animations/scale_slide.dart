import 'package:flutter/material.dart';

class ScaleSlide extends StatelessWidget {
  final Widget child;
  final AnimationController controller;

  ScaleSlide({@required this.child, @required this.controller})
      : assert(child != null),
        assert(controller != null);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(controller),
      child: ScaleTransition(
        scale: controller,
        child: child,
      ),
    );
  }
}
