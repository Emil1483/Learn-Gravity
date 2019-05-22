import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './transitioner.dart';

class Popup extends StatefulWidget {
  final Widget tab;

  Popup({this.tab});

  @override
  _Popuptate createState() => _Popuptate();
}

class _Popuptate extends State<Popup> with TickerProviderStateMixin {
  final double _circleSize = 8;

  List<Widget> _buildTabs(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return <Widget>[
      Center(
        child: ListView(
          padding: EdgeInsets.all(22.0),
          shrinkWrap: true,
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
      Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "Use your finger to add planets",
              style: textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.0),
            Container(
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset("assets/gifs/tutorial_1.gif"),
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Text("3"),
      ),
    ];
  }

  List<Widget> _buildCircles(int n, TabController controller) {
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
      if (i >= n - 1) continue;
      circles.add(
        SizedBox(width: _circleSize * 1.5),
      );
    }
    return circles;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> tabs = widget.tab == null ? _buildTabs(context) : null;

    TabController controller = widget.tab == null
        ? TabController(
            vsync: this,
            length: tabs.length,
          )
        : null;

    return Center(
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
            widget.tab == null
                ? DefaultTabController(
                    length: tabs.length,
                    child: TabBarView(
                      controller: controller,
                      children: tabs,
                    ),
                  )
                : widget.tab,
            widget.tab == null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: _circleSize,
                      margin: EdgeInsets.only(bottom: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildCircles(tabs.length, controller),
                      ),
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (widget.tab != null) {
                      Navigator.of(context).pop();
                      return;
                    }
                    if (controller.animation.value + 1 < controller.length) {
                      int newIndex = math.min(
                          (controller.animation.value + 1).round(),
                          controller.length - 1);
                      controller.animateTo(newIndex);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: widget.tab == null
                      ? Transitioner(
                          animation: controller.animation,
                          fromMin: (tabs.length - 2).toDouble(),
                          fromMax: (tabs.length - 1).toDouble(),
                          toMin: 0,
                          toMax: 1,
                          child1: Icon(Icons.navigate_next),
                          child2: Icon(Icons.done),
                        )
                      : Icon(Icons.done),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
