import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import '../nodes/rootNode.dart';
import '../ui_elements/custom_fab.dart';
import '../ui_elements/mode_fab.dart';
import '../ui_elements/grav_slider.dart';
import '../ui_elements/backdrop.dart';

class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  RootNode rootNode;

  void _initRootNode(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    rootNode = RootNode(size: size);
  }

  @override
  Widget build(BuildContext context) {
    _initRootNode(context);

    Widget spriteWidgetContent = Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (BuildContext context) {
          rootNode.setContext(context);
          return SpriteWidget(rootNode);
        },
      ),
      floatingActionButton: CustomFab(
        mainColor: Theme.of(context).primaryColor,
        buttons: <Widget>[
          GravitySlider(rootNode: rootNode),
          ModeFab(rootNode: rootNode),
          FloatingActionButton(
            heroTag: "resetButton",
            backgroundColor: Theme.of(context).accentColor,
            onPressed: rootNode.reset,
          ),
          FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            heroTag: "infoButton",
            onPressed: () => Navigator.pushNamed(context, '/info'),
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
    );

    return BackdropPage(
      base: spriteWidgetContent,
      content: Center(child: Text("Hello")),
    );
  }
}
