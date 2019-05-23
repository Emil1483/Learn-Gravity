import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Circles extends StatelessWidget {
  final TabController controller;
  final Widget child;
  final double circleSize;
  final double bottomSpace;

  Circles({
    @required this.controller,
    @required this.child,
    this.circleSize = 8.0,
    this.bottomSpace = 16.0,
  })  : assert(controller != null),
        assert(child != null);

  List<Widget> _buildCircles(TabController controller) {
    int n = controller.length;

    List<Widget> circles = [];
    for (int i = 0; i < n; i++) {
      circles.add(
        AnimatedBuilder(
          animation: controller.animation,
          builder: (BuildContext context, Widget child) {
            double dist = (controller.offset + controller.index - i).abs();
            dist = math.min(dist, 1);
            final double transition = Curves.easeInOutCubic.transform(dist);
            final int alpha = (255 - transition * 255).round();

            return Container(
              width: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(100)),
                color: Colors.white.withAlpha(alpha),
              ),
            );
          },
        ),
      );
      if (i >= n - 1) continue;
      circles.add(
        SizedBox(width: circleSize * 1.5),
      );
    }
    return circles;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        child,
        Transform.translate(
          offset: Offset(0, -bottomSpace),
          child: Container(
            height: circleSize,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildCircles(controller),
            ),
          ),
        ),
      ],
    );
  }
}
