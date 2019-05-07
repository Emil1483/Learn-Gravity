import 'package:flutter/material.dart';

import './about_route.dart';
import './learning_route.dart';

class InfoRoute extends StatefulWidget {
  final Function onBackPressed;

  InfoRoute({@required this.onBackPressed}) : assert(onBackPressed != null);

  @override
  _InfoRouteState createState() => _InfoRouteState();
}

class _InfoRouteState extends State<InfoRoute> with TickerProviderStateMixin {
  TabController _tabController;
  final List<Widget> _tabs = [LearningRoute(), AboutRoute()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double circleSize = 8;
    final Color transparrent = Colors.white.withAlpha(100);

    List<Widget> circles = [];
    for (int i = 0; i < _tabs.length; i++) {
      circles.add(
        Container(
          width: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: i == _tabController.index ? Colors.white: transparrent),
            color: i == _tabController.index ? Colors.white : Colors.transparent,
          ),
        ),
      );
      if (i >= _tabs.length - 1) continue;
      circles.add(
        SizedBox(width: circleSize * 1.5),
      );
    }

    return DefaultTabController(
      length: _tabs.length,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: widget.onBackPressed,
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.arrow_downward),
            ),
            body: TabBarView(
              controller: _tabController,
              children: _tabs,
            ),
          ),
          Container(
            height: circleSize,
            margin: EdgeInsets.only(bottom: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: circles,
            ),
          ),
        ],
      ),
    );
  }
}
