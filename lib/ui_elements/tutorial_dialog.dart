import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './transitioner.dart';

class TutorialDialog extends StatefulWidget {
  @override
  _TutorialDialogState createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog>
    with TickerProviderStateMixin {
  final double _circleSize = 8;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<Widget> tabs = <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 42.0),
        child: Text(
          "Congratulations! You unlocked the rest of the App!",
          style: textTheme.title,
          textAlign: TextAlign.center,
        ),
      ),
      Center(
        child: Text("2"),
      ),
      Center(
        child: Text("3"),
      ),
    ];

    TabController controller = TabController(
      vsync: this,
      length: tabs.length,
    );

    List<Widget> circles = [];
    for (int i = 0; i < tabs.length; i++) {
      circles.add(
        AnimatedBuilder(
          animation: controller.animation,
          builder: (BuildContext context, Widget child) {
            double dist = (controller.offset + controller.index - i).abs();
            dist = math.min(dist, 1);
            final double transition = Curves.easeInOutCubic.transform(dist);
            final int alpha = (255 - transition * 255).round();

            return Container(
              width: _circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(100)),
                color: Colors.white.withAlpha(alpha),
              ),
            );
          },
        ),
      );
      if (i >= tabs.length - 1) continue;
      circles.add(
        SizedBox(width: _circleSize * 1.5),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Center(
        child: Container(
          height: 250,
          width: size.width - 100,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: Stack(
            children: <Widget>[
              TabBarView(
                controller: controller,
                children: tabs,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (controller.animation.value + 1 < controller.length) {
                        int newIndex = math.min(
                            (controller.animation.value + 1).round(),
                            controller.length - 1);
                        controller.animateTo(newIndex);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Transitioner(
                      animation: controller.animation,
                      fromMin: (tabs.length - 2).toDouble(),
                      fromMax: (tabs.length - 1).toDouble(),
                      toMin: 0,
                      toMax: 1,
                      child1: Icon(Icons.navigate_next),
                      child2: Icon(Icons.done),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: _circleSize,
                  margin: EdgeInsets.only(bottom: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: circles,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
